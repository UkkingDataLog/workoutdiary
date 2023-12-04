import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:workoutdiary/common/hive_helper.dart';
import 'package:workoutdiary/hivedata/xlog.dart';
import 'package:workoutdiary/common_widget/show_toast_message.dart';
import 'package:workoutdiary/localization/locales.dart';

class SettingView extends StatefulWidget {
  const SettingView({
    super.key,
    required this.weightUnits,
  });
  final String weightUnits;

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  //
  late FlutterLocalization _flutterLocalization;
  // ignore: unused_field
  late String _currentLocale;
  //
  void _setLocale(String? value) {
    if (value == null) return;
    if (value == 'en') {
      _flutterLocalization.translate(('en'));
    } else if (value == 'ko') {
      _flutterLocalization.translate(('ko'));
    } else if (value == 'zh') {
      _flutterLocalization.translate(('zh'));
    } else if (value == 'ja') {
      _flutterLocalization.translate(('ja'));
    } else if (value == 'de') {
      _flutterLocalization.translate(('de'));
    } else if (value == 'es') {
      _flutterLocalization.translate(('es'));
    } else if (value == 'pt') {
      _flutterLocalization.translate(('pt'));
    } else if (value == 'ar') {
      _flutterLocalization.translate(('ar'));
    } else if (value == 'hi') {
      _flutterLocalization.translate(('hi'));
    } else {
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    _flutterLocalization = FlutterLocalization.instance;
    _currentLocale = _flutterLocalization.currentLocale!.languageCode;
  }

  Future<PackageInfo> _getPackageInfo() {
    return PackageInfo.fromPlatform();
  }

  String appversion = '';
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        elevation: 0,
        toolbarHeight: 48,
        title: Text(
          LocaleData.setting.getString((context)),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    child: Text(
                      LocaleData.usersetting.getString((context)),
                    ),
                  ),
                  Card(
                    elevation: 0,
                    child: Column(
                      children: [
                        Card(
                          margin: EdgeInsets.zero,
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            underline: Container(),
                            customButton: ListTile(
                              leading: const Icon(Icons.language_outlined),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(LocaleData.language.getString((context))),
                                  Text(
                                    LocaleData.selectedLanguage.getString((context)),
                                  ),
                                ],
                              ),
                            ),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: 500,
                              width: 160,
                              offset: Offset(media.width - 160 - 24, -2),
                              scrollbarTheme: ScrollbarThemeData(
                                radius: const Radius.circular(40),
                                thickness: MaterialStateProperty.all<double>(6),
                                thumbVisibility: MaterialStateProperty.all<bool>(true),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 40,
                              padding: EdgeInsets.only(left: 14, right: 14),
                            ),
                            items: [
                              DropdownMenuItem(
                                value: 'en',
                                child: (LocaleData.locale.getString(context) == 'en') ? Text('🇺🇸 English ✔') : Text('🇺🇸 English'),
                              ),
                              DropdownMenuItem(
                                value: 'ko',
                                child: (LocaleData.locale.getString(context) == 'ko') ? Text("🇰🇷 한국어 ✔") : Text("🇰🇷 한국어"),
                              ),
                              DropdownMenuItem(
                                value: 'zh',
                                child: (LocaleData.locale.getString(context) == 'zh') ? Text("🇨🇳 中国 ✔") : Text("🇨🇳 中国"),
                              ),
                              DropdownMenuItem(
                                value: 'ja',
                                child: (LocaleData.locale.getString(context) == 'ja') ? Text("🇯🇵 日本語 ✔") : Text("🇯🇵 日本語"),
                              ),
                              DropdownMenuItem(
                                value: 'de',
                                child: (LocaleData.locale.getString(context) == 'de') ? Text('🇩🇪 Deutsch ✔') : Text('🇩🇪 Deutsch'),
                              ),
                              DropdownMenuItem(
                                value: 'es',
                                child: (LocaleData.locale.getString(context) == 'es') ? Text("🇪🇸 Español ✔") : Text("🇪🇸 Español"),
                              ),
                              DropdownMenuItem(
                                value: 'pt',
                                child: (LocaleData.locale.getString(context) == 'pt') ? Text("🇵🇹 Português ✔") : Text("🇵🇹 Português"),
                              ),
                              DropdownMenuItem(
                                value: 'ar',
                                child: (LocaleData.locale.getString(context) == 'ar') ? Text("🇸🇦 عربي ✔") : Text("🇸🇦 عربي"),
                              ),
                              DropdownMenuItem(
                                value: 'hi',
                                child: (LocaleData.locale.getString(context) == 'hi') ? Text("🇮🇳 हिंदी ✔") : Text("🇮🇳 हिंदी"),
                              ),
                            ],
                            onChanged: (value) {
                              _setLocale(value);
                            },
                          ),
                        ),
                        SizedBox(
                          // height: 72,
                          child: ListTile(
                            // contentPadding: EdgeInsets.symmetric(horizontal: 16),
                            // visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                            leading: const Icon(Icons.monitor_weight_outlined),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  LocaleData.units.getString((context)),
                                ),
                                Text(
                                  widget.weightUnits,
                                ),
                              ],
                            ),
                            // trailing: Icon(Icons.keyboard_arrow_down_rounded),
                            // onTap: () {
                            //   //
                            // },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    child: Text(
                      LocaleData.more.getString((context)),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  Card(
                    child: Column(
                      children: [
                        SizedBox(
                          // height: 72,
                          child: Center(
                            child: ListTile(
                              leading: const Icon(Icons.restore_rounded),
                              title: Text(
                                LocaleData.dataInitialization.getString((context)),
                              ),
                              onTap: (() {
                                //
                                showCupertinoDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return FutureBuilder<List<Ximg>>(
                                        future: HiveHelper().readXimg(),
                                        builder: (context, snapshot) {
                                          List<Ximg> ximgs = snapshot.data ?? [];
                                          return FutureBuilder<List<Xlog>>(
                                            future: HiveHelper().readXlog(),
                                            builder: (context, snapshot) {
                                              List<Xlog> xlogs = snapshot.data ?? [];
                                              return CupertinoAlertDialog(
                                                title: Text(
                                                  LocaleData.dataInitialization.getString((context)),
                                                ),
                                                content: Column(
                                                  children: [
                                                    Text(
                                                      LocaleData.dataInitializationBody.getString((context)),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ],
                                                ),
                                                actions: <Widget>[
                                                  // Button to continue with formatted text
                                                  CupertinoDialogAction(
                                                    child: Text(
                                                      LocaleData.back_button_text.getString((context)),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context).pop(); // Dismisses the dialog
                                                    },
                                                  ),
                                                  CupertinoDialogAction(
                                                      child: Text(
                                                        LocaleData.deleteButtonText.getString((context)),
                                                      ),
                                                      onPressed: () {
                                                        if (xlogs.isEmpty && ximgs.isEmpty) {
                                                          showToastMessage(
                                                            LocaleData.dataInitializationNotToastmessage.getString((context)),
                                                          );
                                                          Navigator.of(context).pop();
                                                        } else {
                                                          for (int index = 0; index < xlogs.length; index++) {
                                                            xlogs[index].delete();
                                                          }
                                                          {
                                                            for (int index = 0; index < ximgs.length; index++) {
                                                              ximgs[index].delete();
                                                            }
                                                          }
                                                          showToastMessage(
                                                            LocaleData.dataInitializationToastmessage.getString((context)),
                                                          );
                                                          setState(() {});
                                                          Navigator.of(context).pop();
                                                        }

                                                        //
                                                      }),
                                                ],
                                              );
                                            }, //
                                          );
                                        });
                                  },
                                );
                              }),
                            ),
                          ),
                        ),
                        SizedBox(
                          // height: 72,
                          child: Center(
                            child: ListTile(
                              leading: const Icon(
                                Icons.handshake_outlined,
                              ),
                              title: Text(
                                LocaleData.termsOfUse.getString((context)),
                              ),
                              onTap: (() {
                                Navigator.of(context).pushNamed('/TermsOfUse');
                              }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    child: Text(
                      LocaleData.toDevelopers.getString((context)),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  Card(
                    child: Column(
                      children: [
                        SizedBox(
                          // height: 72,
                          child: Center(
                            child: ListTile(
                              leading: const Icon(Icons.mail_outline_rounded),
                              title: Text(
                                LocaleData.feedback.getString((context)),
                              ),
                              onTap: (() {
                                //
                                showCupertinoDialog(
                                  context: context,
                                  builder: (BuildContext context) => CupertinoAlertDialog(
                                    title: Text(
                                      LocaleData.feedback.getString((context)),
                                    ),
                                    content: Column(
                                      children: [
                                        Text(
                                          LocaleData.feedbackEmailBody.getString((context)),
                                          textAlign: TextAlign.left,
                                        ),
                                        const Text('00:00~24:00'),
                                        const Text('ukkingdatalog@gmail.com'),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      // Button to continue with formatted text
                                      CupertinoDialogAction(
                                        child: Text(
                                          LocaleData.back_button_text.getString((context)),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop(); // Dismisses the dialog
                                        },
                                      ),
                                      CupertinoDialogAction(
                                        child: Text(
                                          LocaleData.sendEmailButtonText.getString((context)),
                                        ),
                                        onPressed: () async {
                                          Map<String, dynamic> deviceInfo = await _getDeviceInfo();

                                          String? encodeQueryParameters(Map<String, String> params) {
                                            return params.entries.map((MapEntry<String, String> e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');
                                          }

                                          final Uri emailLaunchUri = Uri(
                                            scheme: 'mailto',
                                            path: 'ukkingdatalog@gmail.com',
                                            query: encodeQueryParameters(
                                              <String, String>{
                                                'subject': '[Workout Diary][${LocaleData.Inquiry.getString((context))}]',
                                                'body':
                                                    '${LocaleData.InquiryEmailBody.getString((context))}\n$deviceInfo \n ${LocaleData.screenRatio.getString((context))} : ${media.width.ceil()} × ${media.height.ceil()}\n\nWorkout Diary $appversion '
                                              },
                                            ),
                                          );

                                          if (await canLaunchUrl(emailLaunchUri)) {
                                            launchUrl(emailLaunchUri);
                                          } else {
                                            throw Exception('Could not launch $emailLaunchUri');
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Center(
                child: FutureBuilder<PackageInfo>(
                  future: _getPackageInfo(),
                  builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('ERROR');
                    } else if (!snapshot.hasData) {
                      return const Text('Loading...');
                    }
                    final data = snapshot.data!;
                    appversion = snapshot.data!.version;
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(data.appName),
                          Text('${LocaleData.version.getString((context))} ${data.version}'),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<Map<String, dynamic>> _getDeviceInfo() async {
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> deviceData = <String, dynamic>{};

  try {
    if (Platform.isAndroid) {
      deviceData = _readAndroidDeviceInfo(await deviceInfoPlugin.androidInfo);
    } else if (Platform.isIOS) {
      deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
    }
  } catch (error) {
    deviceData = {"Error": "Failed to get platform version."};
  }

  return deviceData;
}

Map<String, dynamic> _readAndroidDeviceInfo(AndroidDeviceInfo info) {
  var release = info.version.release;
  var sdkInt = info.version.sdkInt;
  var manufacturer = info.manufacturer;
  var model = info.model;

  return {"OS version": "Android $release (SDK $sdkInt)", "device": "$manufacturer $model"};
}

Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo info) {
  var systemName = info.systemName;
  var version = info.systemVersion;
  var machine = info.utsname.machine;

  return {"OS version": "$systemName $version", "device": machine};
}
