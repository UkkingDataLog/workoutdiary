import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workoutdiary/common/hive_helper.dart';
import 'package:workoutdiary/hivedata/xlog.dart';
import 'package:workoutdiary/exercise_log/xlog_create_view.dart';

import 'package:provider/provider.dart';
import 'package:workoutdiary/onboard/onboard_view.dart';
import 'package:workoutdiary/localization/locales.dart';
import 'package:workoutdiary/operating_doc/term_of_use_view.dart';
import 'package:workoutdiary/providers/app_image_provider.dart';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';

int? isviewed;

@override
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  isviewed = prefs.getInt('onBoard');
  // 세로모드로 고정
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Show tracking authorization dialog and ask for permission

  // ignore: unused_local_variable
  final status = await AppTrackingTransparency.requestTrackingAuthorization();
  sleep(const Duration(seconds: 1));

  // 스플래시 확인시
  // await Future.delayed(const Duration(seconds: 5));
  // FlutterNativeSplash.remove();

  // 나중에 실행해도 되는 코드
  await Hive.initFlutter();
  Hive.registerAdapter(XlogAdapter());
  Hive.registerAdapter(XimgAdapter());
  Hive.registerAdapter(UserSettingAdapter());
  await HiveHelper().openBox();

  // googld admob
  MobileAds.instance.initialize();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AppImageProvider())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalization localization = FlutterLocalization.instance;

  @override
  void initState() {
    configureLocalization();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 상태바 색상 변환
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle());
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // 테마
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF5C6BC0),
            brightness: Brightness.light,
          ),
          useMaterial3: true),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5C6BC0),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,

      supportedLocales: localization.supportedLocales,
      localizationsDelegates: localization.localizationsDelegates,
      //스크린 위치 설정
      routes: <String, WidgetBuilder>{
        '/': (_) => const XlogCreateView(),
        '/landing': (context) => OnBoard(),
        '/TermsOfUse': (context) => const TermOfUseView(),
      },
      initialRoute:
          // '/landing',
          isviewed != 0 ? '/landing' : '/',
    );
  }

  void configureLocalization() {
    localization.init(mapLocales: LOCALES, initLanguageCode: "en");
    localization.onTranslatedLanguage = onTranslatedLanguage;
  }

  void onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }
}
