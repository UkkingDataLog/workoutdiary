import 'dart:collection';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:workoutdiary/common_widget/round_button.dart';
import 'package:workoutdiary/exercise_date/utils.dart';
import 'package:workoutdiary/exercise_date/xlog_ximg_calendar.dart';
import 'package:workoutdiary/exercise_log/xlog_create_view.dart';
import 'package:workoutdiary/hivedata/xlog.dart';
import 'package:workoutdiary/localization/locales.dart';

class XlogXimgDateCalendarView extends StatefulWidget {
  XlogXimgDateCalendarView({
    Key? key,
    required this.xlogs,
    required this.ximgs,
    required this.weightUnits,
  }) : super(key: key);
  final List<Xlog> xlogs;
  final List<Ximg> ximgs;
  final String weightUnits;

  @override
  State<XlogXimgDateCalendarView> createState() => XlogXimgDateCalendarViewState();
}

class XlogXimgDateCalendarViewState extends State<XlogXimgDateCalendarView> {
  @override
  void initState() {
    super.initState();

    _createRewardedInterstitialAd();
  }

  @override
  void dispose() {
    super.dispose();
    _rewardedInterstitialAd?.dispose();
  }

  late bool selectedAnalysis = false;
  int value = 0;
  int selectedbodypart = 0;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    List<int> xlogximgDateTimeList = [];
    List<int> xlogximgDateTimeListdeduplicated = [];
    List<int> listforxlogximgDateOrder = [];
    List<int> xlogximgDateOrder = [];

    //리스트 타입 xlogximgDateTimeList에 ximgs의 datetime을 hashcode로 변환하여 추가
    if (xlogximgDateTimeListdeduplicated.isEmpty) {
      for (int imgindex = 0; imgindex < widget.ximgs.length; imgindex++) {
        int ximgdatetimeHashCode = getHashCode(widget.ximgs[imgindex].date);
        xlogximgDateTimeList.add(ximgdatetimeHashCode);
        //
        int ximgdatetimeinverseHashCode = getHashCodeInverse(widget.ximgs[imgindex].date);
        listforxlogximgDateOrder.add(ximgdatetimeinverseHashCode);
      }
      // print(xlogximgDateTimeList);
      for (int xlogindex = 0; xlogindex < widget.xlogs.length; xlogindex++) {
        int xlogdatetimeHashCode = getHashCode(widget.xlogs[xlogindex].lxdate);
        xlogximgDateTimeList.add(xlogdatetimeHashCode);
        //
        int xlogdatetimeHashInverseCode = getHashCodeInverse(widget.xlogs[xlogindex].lxdate);
        listforxlogximgDateOrder.add(xlogdatetimeHashInverseCode);
      }
      // print(xlogximgDateTimeList);
    }

    // //리스트 타입 xlogximgDateTimeList에 xlogs의 datetime을 hashcode로 변환하여 추가
    // if (xlogximgDateTimeListdeduplicated.isEmpty) {

    // }

    //중복값 제거
    xlogximgDateTimeListdeduplicated = xlogximgDateTimeList.toSet().toList();
    listforxlogximgDateOrder.sort();
    xlogximgDateOrder = listforxlogximgDateOrder.toSet().toList();

    if (xlogximgDateOrder.isNotEmpty) {
      listforxlogximgDateOrder.clear();
    }

    final kToday = DateTime.now();
    DateTime kFirstDay; //출력되는 달력의 시작 날
    DateTime kLastDay; //출력되는 달력의 마지막 날

    if (xlogximgDateOrder.isNotEmpty) {
      final xlongximglistforkFirstDay = changeHashCodeToInverseDateTime(xlogximgDateOrder.first);

      kFirstDay = DateTime(xlongximglistforkFirstDay.year, xlongximglistforkFirstDay.month, xlongximglistforkFirstDay.day);

      kLastDay = DateTime(kToday.year, kToday.month, kToday.day);
    } else {
      kFirstDay = DateTime(kToday.year, kToday.month - 1, kToday.day);
      kLastDay = DateTime(kToday.year, kToday.month + 1, kToday.day);
    }
    //달력에 들어가는 개수 조절
    final _kEventSource = Map.fromIterable(
      //xlogximgDateTimeList.length개수 만큼 만들기
      List.generate(xlogximgDateTimeListdeduplicated.length, (index) => xlogximgDateTimeListdeduplicated[index]),
      //item은 xlogximgDateTimeList.length개수로 구성

      key: (item) {
        DateTime itemDatetime = changeHashCodeToDateTime(item);
        return DateTime.utc(itemDatetime.year, itemDatetime.month, itemDatetime.day);
      },
      value: (item) {
        return List.generate(
          1, //날짜별로 생성하는 아이템 개수
          (index) {
            DateTime changeHashCodeToDateTimeItem = changeHashCodeToDateTime(item);

            return Event(changeHashCodeToDateTimeItem, widget.ximgs, widget.xlogs);
          },
        );
      },
    );

    final kEvents = LinkedHashMap<DateTime, List<Event>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(_kEventSource);
    // ..addAll({
    //     kToday: [
    //       Event('Today\'s Event 1'),
    //       Event('Today\'s Event 2'),
    //     ],
    //   });
    return WillPopScope(
      onWillPop: (() => _onBackPressed(context)),
      child: Scaffold(
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              forceElevated: true,
              floating: true,
              snap: true,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              automaticallyImplyLeading: false,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              elevation: 0,
              toolbarHeight: 48,
              backgroundColor: Theme.of(context).colorScheme.primary,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onBackground,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 8),
                              // 페이지 제목
                              Text(
                                (selectedAnalysis == false) ? LocaleData.viewtitle_calendar.getString((context)) : LocaleData.workout_analysis.getString((context)),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.background,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                        ),

                        // 운동 분석 버튼
                        InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
                            if (selectedAnalysis == false) {
                              showCupertinoModalPopup(
                                context: context,
                                builder: (context) {
                                  return Column(
                                    children: [
                                      Container(height: media.height * 0.125),
                                      SizedBox(
                                        height: 48,
                                        width: double.infinity,
                                        child: RoundButton(
                                          type: RoundButtonType.textGradient,
                                          onPressed: () {
                                            showRewardedInterstitialAd();
                                            setState(() {});
                                          },
                                          title: LocaleData.seeAds.getString((context)),
                                        ),
                                      ),
                                      Container(height: 8),
                                      SizedBox(
                                        height: 48,
                                        width: double.infinity,
                                        child: RoundButton(
                                          type: RoundButtonType.textGradient,
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          title: LocaleData.back_button_text.getString((context)),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                              // selectedAnalysis = true;
                              setState(() {});
                            } else {
                              selectedAnalysis = false;
                              setState(() {});
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.only(left: 12.0, right: 16.0),
                            height: 48,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surfaceVariant,
                              borderRadius: const BorderRadius.only(
                                // topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                            ),
                            child: Center(
                                child: Icon(
                              (selectedAnalysis == false) ? Icons.analytics : Icons.checklist,
                              color: Theme.of(context).colorScheme.outline,
                            )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          body: TableComplexExample(
            kFirstDay: kFirstDay,
            kLastDay: kLastDay,
            kEvents: kEvents,
            weightUnits: widget.weightUnits,
            selectedAnalysis: selectedAnalysis,
            value: value,
            selectedbodypart: selectedbodypart,
            xlogs: widget.xlogs,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
        floatingActionButton: (selectedAnalysis == false)
            ? Container()
            : SizedBox(
                height: 96,
                width: media.width * 0.90,
                child: FloatingActionButton(
                    elevation: 2,
                    backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                    child: Column(
                      children: [
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8,
                          children: [
                            FittedBox(
                              child: IconButton.outlined(
                                  // 아이콘컬러
                                  color: Colors.redAccent,
                                  //

                                  isSelected: (selectedbodypart == 0 || selectedbodypart == 1) ? true : false,
                                  onPressed: () {
                                    selectedbodypart = 1;
                                    setState(() {});
                                  },
                                  icon: Row(
                                    children: [
                                      Icon(Icons.circle),
                                      Text(
                                        LocaleData.legs.getString((context)),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.redAccent,
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                            FittedBox(
                              child: IconButton.outlined(
                                  color: Colors.orangeAccent,
                                  isSelected: (selectedbodypart == 0 || selectedbodypart == 2) ? true : false,
                                  onPressed: () {
                                    selectedbodypart = 2;
                                    setState(() {});
                                  },
                                  icon: Row(
                                    children: [
                                      Icon(Icons.circle),
                                      Text(
                                        LocaleData.shoulders.getString((context)),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.orangeAccent,
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                            FittedBox(
                              child: IconButton.outlined(
                                  color: Colors.yellow[600],
                                  isSelected: (selectedbodypart == 0 || selectedbodypart == 3) ? true : false,
                                  onPressed: () {
                                    selectedbodypart = 3;
                                    setState(() {});
                                  },
                                  icon: Row(
                                    children: [
                                      Icon(Icons.circle),
                                      Text(
                                        LocaleData.chest.getString((context)),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.yellow[600],
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                            FittedBox(
                              child: IconButton.outlined(
                                  color: Colors.greenAccent,
                                  isSelected: (selectedbodypart == 0 || selectedbodypart == 4) ? true : false,
                                  onPressed: () {
                                    selectedbodypart = 4;
                                    setState(() {});
                                  },
                                  icon: Row(
                                    children: [
                                      Icon(Icons.circle),
                                      Text(
                                        LocaleData.arms.getString((context)),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.greenAccent,
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                            FittedBox(
                              child: IconButton.outlined(
                                  color: Colors.blueAccent,
                                  isSelected: (selectedbodypart == 0 || selectedbodypart == 5) ? true : false,
                                  onPressed: () {
                                    selectedbodypart = 5;
                                    setState(() {});
                                  },
                                  icon: Row(
                                    children: [
                                      Icon(Icons.circle),
                                      Text(
                                        LocaleData.back.getString((context)),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.blueAccent,
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                            FittedBox(
                              child: IconButton.outlined(
                                  color: Colors.purpleAccent,
                                  isSelected: (selectedbodypart == 0 || selectedbodypart == 6) ? true : false,
                                  onPressed: () {
                                    selectedbodypart = 6;
                                    setState(() {});
                                  },
                                  icon: Row(
                                    children: [
                                      Icon(Icons.circle),
                                      Text(
                                        LocaleData.abs.getString((context)),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.purpleAccent,
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                          ],
                        )
                      ],
                    ),
                    onPressed: () {
                      selectedbodypart = 0;
                      setState(() {});
                    }),
              ),
      ),
    );
  }

  Future<bool> _onBackPressed(BuildContext context) async {
    Navigator.pop(context, false);
    return true;
  }

  static final AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );
  RewardedInterstitialAd? _rewardedInterstitialAd;
  int _numRewardedInterstitialLoadAttempts = 0;
  void _createRewardedInterstitialAd() {
    RewardedInterstitialAd.load(
        adUnitId: Platform.isIOS
            ?
            // // 배포용
            'ca-app-pub-9398946924743018/3910679056' //my ios key
            : 'ca-app-pub-9398946924743018/5926506292', //my android key

        //테스트용
        // 'ca-app-pub-3940256099942544/6978759866'
        // : 'ca-app-pub-3940256099942544/6978759866',
        // 테스트 데모 https://developers.google.com/admob/ios/test-ads?hl=ko#demo_ad_units

        request: request,
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (RewardedInterstitialAd ad) {
            debugPrint('$ad loaded.');
            _rewardedInterstitialAd = ad;
            _numRewardedInterstitialLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('RewardedInterstitialAd failed to load: $error');
            _rewardedInterstitialAd = null;
            _numRewardedInterstitialLoadAttempts += 1;
            if (_numRewardedInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createRewardedInterstitialAd();
            }
          },
        ));
  }

  void showRewardedInterstitialAd() {
    if (_rewardedInterstitialAd == null) {
      debugPrint('Warning: attempt to show rewarded interstitial before loaded.');
      return;
    }
    _rewardedInterstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedInterstitialAd ad) {
        debugPrint('$ad onAdShowedFullScreenContent.');

        setState(() {
          Navigator.pop(context);
        });
      },
      onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
        debugPrint('$ad onAdDismissedFullScreenContent.');

        ad.dispose();
        _createRewardedInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedInterstitialAd ad, AdError error) {
        debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createRewardedInterstitialAd();
      },
    );

    _rewardedInterstitialAd!.setImmersiveMode(true);
    _rewardedInterstitialAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      debugPrint('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
      selectedAnalysis = true;
      setState(() {});
    });
    _rewardedInterstitialAd = null;
  }
}
