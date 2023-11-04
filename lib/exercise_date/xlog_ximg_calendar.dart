// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:workoutdiary/common/colo_extension.dart';
import 'package:workoutdiary/exercise_date/utils.dart';
import 'package:workoutdiary/exercise_date/ximg_saved_tile.dart';
import 'package:workoutdiary/exercise_date/xlog_ximg_date_calendar_view.dart';
import 'package:workoutdiary/exercise_log/xlog_create_tile.dart';

class TableComplexExample extends StatefulWidget {
  const TableComplexExample({
    super.key,
    required this.kEvents,
    required this.kFirstDay,
    required this.kLastDay,
  });

  final LinkedHashMap<DateTime, List<Event>> kEvents;
  final DateTime kFirstDay;
  final DateTime kLastDay;

  @override
  _TableComplexExampleState createState() => _TableComplexExampleState();
}

class _TableComplexExampleState extends State<TableComplexExample> {
  //
  bool isSelectedkg = true;
  String selectedWeighUnint = 'kg';
  //
  bool isCalenderopen = true;
  //
  int selectdaycount = 0;
  late final ValueNotifier<List<Event>> _selectedEvents;
  final ValueNotifier<DateTime> _focusedDay = ValueNotifier(DateTime.now());
  final Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  late PageController _pageController;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();

    _selectedDays.add(_focusedDay.value);
    _selectedEvents = ValueNotifier(_getEventsForDay(_focusedDay.value));
  }

  @override
  void dispose() {
    _focusedDay.dispose();
    _selectedEvents.dispose();
    super.dispose();
  }

  bool get canClearSelection => _selectedDays.isNotEmpty || _rangeStart != null || _rangeEnd != null;

  List<Event> _getEventsForDay(DateTime day) {
    return widget.kEvents[day] ?? [];
  }

  List<Event> _getEventsForDays(Iterable<DateTime> days) {
    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);
    return _getEventsForDays(days);
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      if (_selectedDays.contains(selectedDay)) {
        _selectedDays.remove(selectedDay);
      } else {
        _selectedDays.add(selectedDay);
      }

      _focusedDay.value = focusedDay;
      _rangeStart = null;
      _rangeEnd = null;
      _rangeSelectionMode = RangeSelectionMode.toggledOff;
    });

    _selectedEvents.value = _getEventsForDays(_selectedDays);
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _focusedDay.value = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _selectedDays.clear();
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    XlogXimgDateCalendarViewState? parent = context.findAncestorStateOfType<XlogXimgDateCalendarViewState>();

    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
            color: Colors.black,
            child: Center(
              child: Text(
                'Habit make me',
                style: TextStyle(color: TColor.white),
              ),
            ),
          ),
          (isCalenderopen == true)
              ? ValueListenableBuilder<DateTime>(
                  valueListenable: _focusedDay,
                  builder: (context, value, _) {
                    return SizedBox(
                      child: _CalendarHeader(
                        focusedDay: value,
                        clearButtonVisible: canClearSelection,
                        onTodayButtonTap: () {
                          setState(() => _focusedDay.value = DateTime.now());
                        },
                        onClearButtonTap: () {
                          setState(() {
                            _rangeStart = null;
                            _rangeEnd = null;
                            _selectedDays.clear();
                            _selectedEvents.value = [];
                          });
                        },
                        onLeftArrowTap: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        },
                        onRightArrowTap: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        },
                      ),
                    );
                  },
                )
              : Container(),

          Column(
            children: [
              (isCalenderopen == true)
                  ? TableCalendar<Event>(
                      rowHeight: 48,
                      locale: 'ko_KR',

                      firstDay: widget.kFirstDay,
                      lastDay: widget.kLastDay,
                      focusedDay: _focusedDay.value,
                      headerVisible: false,
                      selectedDayPredicate: (day) => _selectedDays.contains(day),
                      rangeStartDay: _rangeStart,
                      rangeEndDay: _rangeEnd,
                      calendarFormat: _calendarFormat,

                      rangeSelectionMode: _rangeSelectionMode,
                      eventLoader: _getEventsForDay,
                      // holidayPredicate: (day) {
                      //   // Every 20th day of the month will be treated as a holiday 휴무일
                      //   return day.day == 20;
                      // },

                      onDaySelected: _onDaySelected,
                      onRangeSelected: _onRangeSelected,
                      onCalendarCreated: (controller) => _pageController = controller,
                      onPageChanged: (focusedDay) => _focusedDay.value = focusedDay,
                      onFormatChanged: (format) {
                        if (_calendarFormat != format) {
                          setState(() => _calendarFormat = format);
                        }
                      },
                    )
                  : Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 40,
                    child: IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        setState(() {
                          if (isSelectedkg == true) {
                            isSelectedkg = false;
                            selectedWeighUnint = 'lb';
                          } else {
                            isSelectedkg = true;
                            selectedWeighUnint = 'kg';
                          }
                        });
                      },
                      icon: Image.asset(
                        (isSelectedkg == true) ? 'assets/img/weight_kg.png' : 'assets/img/weight_lb.png',
                        scale: 24,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Container(
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        // gradient:
                        //     LinearGradient(colors: TColor.secondaryG),
                        borderRadius: BorderRadius.only(
                          // topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        children: [
                          // 위젯이미지 캡처 및 공유
                          // IconButton(
                          //     onPressed: () {},
                          //     icon: Icon(
                          //       Icons.share,
                          //       // size: iconsize - 4,
                          //       color: TColor.white,
                          //     )),
                          IconButton(
                              onPressed: () {
                                if (isCalenderopen == true) {
                                  setState(() {
                                    isCalenderopen = false;
                                  });
                                } else {
                                  setState(() {
                                    isCalenderopen = true;
                                  });
                                }
                              },
                              icon: Icon(
                                Icons.date_range,
                                color: TColor.white,
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),

          // const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  // physics: ClampingScrollPhysics(),
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          // horizontal: 12.0,
                          // vertical: 16.0,
                          ),
                      decoration: const BoxDecoration(
                          // border: Border.all(),
                          // borderRadius: BorderRadius.circular(12.0),

                          ),
                      //수정필요 카드형태로 제작
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        // onTap: () => print('${value[index]}'), //버튼 클릭시 이벤트 발생
                        title: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Container(
                                //   color: TColor.black,
                                //   child: Container(
                                //     height: media.width * 0.06,
                                //     width: media.width * 0.28, //* 0.28,
                                //     decoration: BoxDecoration(
                                //       color: Theme.of(context).canvasColor,
                                //       borderRadius: const BorderRadius.only(
                                //         bottomRight: Radius.circular(10),
                                //       ),
                                //     ),
                                //     child: const Text(''),
                                //   ),
                                // ),
                                Container(
                                  height: media.width * 0.06,
                                  width: media.width * 0.28,
                                  decoration: BoxDecoration(
                                    color: TColor.black,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      '${value[index].datetime.month}월 ${value[index].datetime.day}일',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: TColor.white, fontSize: 16, fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                                // Container(
                                //   color: TColor.black,
                                //   child: Container(
                                //     height: media.width * 0.06,
                                //     width: media.width * 0.28, //* 0.28,
                                //     decoration: BoxDecoration(
                                //       color: Theme.of(context).canvasColor,
                                //       borderRadius: const BorderRadius.only(
                                //         bottomLeft: Radius.circular(10),
                                //       ),
                                //     ),
                                //     child: const Text(''),
                                //   ),
                                // ),
                              ],
                            ),
                            // Container(
                            //   height: 1,
                            //   decoration: BoxDecoration(
                            //     color: TColor.black,
                            //     // borderRadius: const BorderRadius.only(
                            //     //   topLeft: Radius.circular(10),
                            //     //   topRight: Radius.circular(10),
                            //     // ),
                            //   ),
                            // ),
                            for (int ximgsindex = 0; ximgsindex < value[index].ximgs.length; ximgsindex += 1)
                              if (value[index].ximgs[ximgsindex].date.year == value[index].datetime.year //년 비교
                                      &&
                                      value[index].ximgs[ximgsindex].date.month == value[index].datetime.month //월 비교
                                      &&
                                      value[index].ximgs[ximgsindex].date.day == value[index].datetime.day //일 비교
                                  )
                                XimgSavedTile(
                                  ximg: value[index].ximgs[ximgsindex],
                                  height: 1.25,
                                  onDeleted: () {
                                    setState(() {
                                      value[index].ximgs.removeAt(ximgsindex);
                                      parent?.setState(() {});
                                    });
                                  },
                                ),
                            //
                            for (int xlogsindex = 0; xlogsindex < value[index].xlogs.length; xlogsindex += 1)
                              if (

                                  ////둘다 dateTime 형식이므로 해당년, 월, 일 비교가 필요함
                                  value[index].xlogs[xlogsindex].lxdate.year == value[index].datetime.year //년 비교
                                      &&
                                      value[index].xlogs[xlogsindex].lxdate.month == value[index].datetime.month //월 비교
                                      &&
                                      value[index].xlogs[xlogsindex].lxdate.day == value[index].datetime.day //일 비교

                                  )
                                Container(
                                  color: Colors.black,
                                  child: XlogCreateTile(
                                    xlog: value[index].xlogs[xlogsindex],
                                    onDeleted: () {
                                      setState(() {
                                        value[index].xlogs.removeAt(xlogsindex);
                                        parent?.setState(() {});
                                      });
                                    },
                                    selectedweightUnit: selectedWeighUnint,
                                  ),
                                ),
                            // Container(
                            //   height: 8,
                            //   decoration: BoxDecoration(
                            //     color: TColor.black,
                            //     borderRadius: const BorderRadius.only(
                            //       bottomLeft: Radius.circular(10),
                            //       bottomRight: Radius.circular(10),
                            //     ),
                            //   ),
                            // ),
                            // Stack(
                            //   alignment: Alignment.center,
                            //   children: [
                            //     Container(
                            //       height: media.width * 0.06,
                            //       width: media.width,
                            //       color: TColor.black,
                            //     ),
                            //     Row(
                            //       mainAxisAlignment: MainAxisAlignment.center,
                            //       children: [
                            //         Container(
                            //           color: TColor.white,
                            //           child: Container(
                            //             height: media.width * 0.06,
                            //             width: media.width * 0.28, //* 0.28,
                            //             decoration: BoxDecoration(
                            //               color: TColor.black,
                            //               borderRadius: const BorderRadius.only(
                            //                 bottomRight: Radius.circular(10),
                            //               ),
                            //             ),
                            //             child: const Text(''),
                            //           ),
                            //         ),
                            //         Container(
                            //           height: media.width * 0.06,
                            //           width: media.width * 0.28, //* 0.28,
                            //           decoration: BoxDecoration(
                            //             color: Theme.of(context).canvasColor,
                            //             borderRadius: const BorderRadius.only(
                            //               topLeft: Radius.circular(10),
                            //               topRight: Radius.circular(10),
                            //             ),
                            //           ),
                            //           child: const Text(''),
                            //         ),
                            //         Container(
                            //           color: TColor.white,
                            //           child: Container(
                            //             height: media.width * 0.06,
                            //             width: media.width * 0.28, //* 0.28,
                            //             decoration: BoxDecoration(
                            //               color: TColor.black,
                            //               borderRadius: const BorderRadius.only(
                            //                 bottomLeft: Radius.circular(10),
                            //               ),
                            //             ),
                            //             child: const Text(''),
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ],
                            // ),
                            const SizedBox(height: 16)
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  final DateTime focusedDay;
  final VoidCallback onLeftArrowTap;
  final VoidCallback onRightArrowTap;
  final VoidCallback onTodayButtonTap;
  final VoidCallback onClearButtonTap;
  final bool clearButtonVisible;

  const _CalendarHeader({
    Key? key,
    required this.focusedDay,
    required this.onLeftArrowTap,
    required this.onRightArrowTap,
    required this.onTodayButtonTap,
    required this.onClearButtonTap,
    required this.clearButtonVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final headerText = DateFormat.yMMM().format(focusedDay);
    final headerText = DateFormat('yyyy M월').format(focusedDay);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Row(
        children: [
          const SizedBox(width: 16.0),
          SizedBox(
            width: 110.0,
            child: Text(
              headerText,
              style: const TextStyle(fontSize: 22.0),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today, size: 20.0),
            visualDensity: VisualDensity.compact,
            onPressed: onTodayButtonTap,
          ),
          if (clearButtonVisible)
            IconButton(
              icon: const Icon(Icons.clear, size: 20.0),
              visualDensity: VisualDensity.compact,
              onPressed: onClearButtonTap,
            ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: onLeftArrowTap,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: onRightArrowTap,
          ),
        ],
      ),
    );
  }
}
