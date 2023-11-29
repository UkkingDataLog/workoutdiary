import 'dart:collection';
import 'dart:math';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:workoutdiary/exercise_date/utils.dart';
import 'package:workoutdiary/exercise_date/xlog_ximg_calendar.dart';
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
  bool selectedAnalysis = false;
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
                              selectedAnalysis = true;
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
                        //// 기간 선택
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(vertical: 8.0),
                        //   child: AnimatedToggleSwitch<int>.size(
                        //     height: 36,
                        //     current: min(value, 2),
                        //     style: ToggleStyle(
                        //       backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                        //       indicatorColor: Theme.of(context).colorScheme.onSurface,
                        //       borderColor: Colors.transparent,
                        //       borderRadius: BorderRadius.circular(10.0),
                        //       indicatorBorderRadius: BorderRadius.zero,
                        //     ),
                        //     // 주, 달 까지 고도화
                        //     // values: const [0, 1, 2],
                        //     values: const [0],
                        //     iconOpacity: 1.0,
                        //     selectedIconScale: 1.0,
                        //     indicatorSize: const Size.fromWidth(100),
                        //     iconAnimationType: AnimationType.onHover,
                        //     styleAnimationType: AnimationType.onHover,
                        //     spacing: 2.0,
                        //     customSeparatorBuilder: (context, local, global) {
                        //       final opacity = ((global.position - local.position).abs() - 0.5).clamp(0.0, 1.0);
                        //       return VerticalDivider(
                        //         indent: 10.0,
                        //         endIndent: 10.0,
                        //         color: Theme.of(context).colorScheme.onSurfaceVariant,
                        //       );
                        //     },
                        //     customIconBuilder: (context, local, global) {
                        //       // 주, 달 까지 고도화
                        //       // final text = const ["day", "week", "month"][local.index];
                        //       final text = const ["day"][local.index];
                        //       return Center(
                        //         child: Text(
                        //           text,
                        //           style: TextStyle(
                        //             color: Color.lerp(
                        //               Theme.of(context).colorScheme.onBackground,
                        //               Theme.of(context).colorScheme.background,
                        //               local.animationValue,
                        //             ),
                        //           ),
                        //         ),
                        //       );
                        //     },
                        //     borderWidth: 0.0,
                        //     onChanged: (i) {
                        //       setState(() => value = i);
                        //       // print(i);
                        //     },
                        //   ),
                        // ),
                        //
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
}
