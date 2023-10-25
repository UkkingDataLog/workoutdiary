import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:workoutdiary/common/colo_extension.dart';
import 'package:workoutdiary/exercise_date/utils.dart';

import 'package:workoutdiary/exercise_date/xlog_ximg_calendar.dart';
import 'package:workoutdiary/hivedata/xlog.dart';

class XlogXimgDateCalendarView extends StatefulWidget {
  XlogXimgDateCalendarView({
    Key? key,
    required this.xlogs,
    required this.ximgs,
  }) : super(key: key);
  final List<Xlog> xlogs;
  final List<Ximg> ximgs;

  @override
  State<XlogXimgDateCalendarView> createState() => XlogXimgDateCalendarViewState();
}

class XlogXimgDateCalendarViewState extends State<XlogXimgDateCalendarView> {
  @override
  Widget build(BuildContext context) {
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
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                // iconSize: iconsize,
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
                "운동 달력",
                style: TextStyle(color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ],
          body: TableComplexExample(
            kFirstDay: kFirstDay,
            kLastDay: kLastDay,
            kEvents: kEvents,
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed(BuildContext context) async {
    Navigator.pop(context, false);
    return true;
  }
}
