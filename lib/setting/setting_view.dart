import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import 'package:workoutdiary/common/colo_extension.dart';
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
  Future<PackageInfo> _getPackageInfo() {
    return PackageInfo.fromPlatform();
  }

  Future<bool> _onBackPressed(BuildContext context) async {
    Navigator.pop(context, false);
    return true;
  }

  String appversion = '';
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: (() => _onBackPressed(context)),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          automaticallyImplyLeading: false,
          foregroundColor: TColor.black,
          elevation: 0,
          toolbarHeight: 48,
          backgroundColor: TColor.white,
          title: Text(
            LocaleData.setting.getString((context)),
            style: TextStyle(color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Text(
                  LocaleData.usersetting.getString((context)),
                  style: TextStyle(
                      fontSize: 14,
                      // fontWeight: FontWeight.w700,
                      color: TColor.primarygray),
                ),
              ),
              Card(
                shape: Border(right: BorderSide(color: TColor.secondaryColor1, width: 5)),
                shadowColor: TColor.secondaryColor1,
                elevation: 0.5,
                child: Column(
                  children: [
                    SizedBox(
                      // height: 72,
                      child: ListTile(
                        // contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        // visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                        leading: CircleAvatar(
                          backgroundColor: TColor.white,
                          foregroundColor: TColor.black,
                          child: const Icon(Icons.language_rounded),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LocaleData.language.getString((context)),
                            ),
                            Text(
                              LocaleData.selectedLanguage.getString((context)),
                              style: TextStyle(color: TColor.primarygray),
                            ),
                          ],
                        ),

                        // trailing: Icon(Icons.keyboard_arrow_down_rounded),
                        // onTap: () {
                        //   //
                        // },
                      ),
                    ),
                    Divider(height: 1, color: TColor.primarygray),
                    SizedBox(
                      // height: 72,
                      child: ListTile(
                        // contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        // visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                        leading: CircleAvatar(
                          backgroundColor: TColor.white,
                          foregroundColor: TColor.black,
                          child: const Icon(Icons.monitor_weight_outlined),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LocaleData.units.getString((context)),
                            ),
                            Text(
                              widget.weightUnits,
                              style: TextStyle(color: TColor.primarygray),
                            ),
                          ],
                        ),
                        // trailing: Icon(Icons.keyboard_arrow_down_rounded),
                        // onTap: () {
                        //   //
                        // },
                      ),
                    ),
                    // ListTile(
                    //   leading: Icon(Icons.home_work_outlined),
                    //   title: Text("인스타그램 방문하기"),
                    //   onTap: (() {
                    //     //
                    //   }),
                    // ),
                    // ListTile(
                    //   leading: Icon(Icons.star),
                    //   title: Text("별점주기"),
                    //   onTap: (() {
                    //     //
                    //   }),
                    // ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Text(
                  LocaleData.more.getString((context)),
                  style: TextStyle(
                      fontSize: 14,
                      // fontWeight: FontWeight.w700,
                      color: TColor.primarygray),
                ),
              ),
              Card(
                shape: Border(right: BorderSide(color: TColor.primaryColor1, width: 5)),
                shadowColor: TColor.primaryColor1,
                elevation: 0.5,
                child: Column(
                  children: [
                    SizedBox(
                      // height: 72,
                      child: Center(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: TColor.white,
                            foregroundColor: TColor.black,
                            child: const Icon(Icons.restore_rounded),
                          ),
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
                                                  style: TextStyle(color: TColor.primarygray),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop(); // Dismisses the dialog
                                                },
                                              ),
                                              CupertinoDialogAction(
                                                  child: Text(
                                                    LocaleData.deleteButtonText.getString((context)),
                                                    style: TextStyle(color: TColor.primarygray),
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
                    Divider(height: 1, color: TColor.primarygray),
                    SizedBox(
                      // height: 72,
                      child: Center(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: TColor.white,
                            foregroundColor: TColor.black,
                            child: const Icon(
                              Icons.handshake_outlined,
                            ),
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
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Text(
                  LocaleData.toDevelopers.getString((context)),
                  style: TextStyle(
                      fontSize: 14,
                      // fontWeight: FontWeight.w700,
                      color: TColor.primarygray),
                ),
              ),
              Card(
                shape: Border(right: BorderSide(color: TColor.primaryColor1, width: 5)),
                shadowColor: Theme.of(context).canvasColor, //TColor.primaryColor1,
                elevation: 0.5,
                child: Column(
                  children: [
                    SizedBox(
                      // height: 72,
                      child: Center(
                        child: ListTile(
                          leading: CircleAvatar(backgroundColor: TColor.white, foregroundColor: TColor.black, child: const Icon(Icons.mail_outline_rounded)),
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
                                      style: TextStyle(color: TColor.primarygray),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Dismisses the dialog
                                    },
                                  ),
                                  CupertinoDialogAction(
                                    child: Text(
                                      LocaleData.sendEmailButtonText.getString((context)),
                                      style: TextStyle(color: TColor.secondaryColor1),
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
                    // ListTile(
                    //   leading: Icon(Icons.home_work_outlined),
                    //   title: Text("인스타그램 방문하기"),
                    //   onTap: (() {
                    //     //
                    //   }),
                    // ),
                    // ListTile(
                    //   leading: Icon(Icons.star),
                    //   title: Text("별점주기"),
                    //   onTap: (() {
                    //     //
                    //   }),
                    // ),
                  ],
                ),
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
                          Text(
                            data.appName, //App Name:
                            style: TextStyle(
                                fontSize: 14,
                                // fontWeight: FontWeight.w700,
                                color: TColor.primarygray),
                          ),
                          // Text('Package Name: ${data.packageName}'),
                          Text(
                            '${LocaleData.version.getString((context))} ${data.version}',
                            style: TextStyle(
                                fontSize: 14,
                                // fontWeight: FontWeight.w700,
                                color: TColor.primarygray),
                          ),
                          // Text('Build Number: ${data.buildNumber}'),
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
