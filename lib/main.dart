import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';
//
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workoutdiary/common/colo_extension.dart';
import 'package:workoutdiary/common/hive_helper.dart';
import 'package:workoutdiary/hivedata/xlog.dart';
import 'package:workoutdiary/exercise_log/xlog_create_view.dart';
//
import 'package:provider/provider.dart';
import 'package:workoutdiary/operating_doc/term_of_use_view.dart';
import 'package:workoutdiary/providers/app_image_provider.dart';

import 'package:workoutdiary/ui/ui_group.dart';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';

@override
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 세로모드로 고정
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Show tracking authorization dialog and ask for permission
  final status = await AppTrackingTransparency.requestTrackingAuthorization();

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
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Container(
      color: TColor.white,
      child: SafeArea(
        maintainBottomViewPadding: true,
        top: true,
        bottom: true,
        child: MaterialApp(
          title: maintitle,

          debugShowCheckedModeBanner: false,

          theme: ThemeData(
            primaryColor: TColor.primaryColor1,
            fontFamily: fontFamily,
          ),
          // darkTheme: ThemeData.dark(),
          //스크린 위치 설정
          routes: <String, WidgetBuilder>{
            '/': (_) => const XlogCreateView(),
            // '/splish': (context) => const SplashView(),
            '/TermsOfUse': (context) => const TermOfUseView(),
          },
          initialRoute: '/',
        ),
      ),
    );
  }
}
