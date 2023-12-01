// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:workoutdiary/anlysis/chart.dart';
import 'package:workoutdiary/exercise_date/utils.dart';
import 'package:workoutdiary/exercise_date/ximg_saved_tile.dart';
import 'package:workoutdiary/exercise_date/xlog_ximg_date_calendar_view.dart';
import 'package:workoutdiary/exercise_log/xlog_create_tile.dart';
import 'package:workoutdiary/hivedata/xlog.dart';

import 'package:workoutdiary/localization/locales.dart';

// ignore: must_be_immutable
class TableComplexExample extends StatefulWidget {
  TableComplexExample({
    super.key,
    required this.kEvents,
    required this.kFirstDay,
    required this.kLastDay,
    required this.weightUnits,
    required this.selectedAnalysis,
    //
    required this.value, // 0: day, 1: week, 2: month
    required this.selectedbodypart, // 0: all, 1: leg, 2: shoulders, 3: chest, 4: arms, 5: back, 6: abs
    //
    required this.xlogs,
  });

  final LinkedHashMap<DateTime, List<Event>> kEvents;
  final DateTime kFirstDay;
  final DateTime kLastDay;
  String weightUnits;
  bool selectedAnalysis;
  //
  int value;
  int selectedbodypart;
  //
  final List<Xlog> xlogs;
  //
  String startTitle = '';
  String endTitle = '';

  @override
  _TableComplexExampleState createState() => _TableComplexExampleState();
}

class _TableComplexExampleState extends State<TableComplexExample> {
  bool isSelectedkg = true;
  bool isCalenderopen = true;

  //
  double todayLegsSum = 0;

  late final ValueNotifier<List<Event>> _selectedEvents;
  final ValueNotifier<DateTime> _focusedDay = ValueNotifier(DateTime.now());
  final Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  late PageController _pageController;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;
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

  var allBodypartStatisticsinput = Map<int, List<double>>();

  @override
  Widget build(BuildContext context) {
    //

    // selectedbodypart 0,1,2,3,4,5,6
    switch (widget.selectedbodypart) {
      case 0:
        // int allBodypartStatisticsIndex;
        Map<int, List<double>> allBodypartStatistics = {};
        allBodypartStatisticsinput = allBodypartStatistics;
        break;
      case 1:
        break;
      default:
        break;
    }

    XlogXimgDateCalendarViewState? parent = context.findAncestorStateOfType<XlogXimgDateCalendarViewState>();

    if (widget.weightUnits == 'kg') {
      isSelectedkg = true;
    } else {
      isSelectedkg = false;
    }
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 42,
            padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
            color: Theme.of(context).colorScheme.onBackground,
            child: Center(
              child: Text(
                LocaleData.slogan.getString((context)),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.background,
                ),
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
                      daysOfWeekHeight: 22,
                      locale: LocaleData.locale.getString((context)),
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

                      // 단일 기간을 선택하여 다중선택
                      // onDaySelected: _onDaySelected,
                      onRangeSelected: _onRangeSelected,
                      onCalendarCreated: (controller) => _pageController = controller,
                      onPageChanged: (focusedDay) => _focusedDay.value = focusedDay,
                      onFormatChanged: (format) {
                        if (_calendarFormat != format) {
                          setState(() => _calendarFormat = format);
                        }
                      },

                      //custom
                      calendarStyle: CalendarStyle(
                        rangeHighlightColor: Theme.of(context).colorScheme.primaryContainer,
                        withinRangeTextStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),

                        rangeStartDecoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        rangeEndDecoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),

                        // marker 모양 조정
                        markerDecoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onBackground,
                          shape: BoxShape.circle,
                        ),
                        // startDay, endDay 사이의 글자 조정
                      ),
                    )
                  : Container(),
              Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        child: IconButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () {
                            setState(() {
                              if (isSelectedkg == true) {
                                isSelectedkg = false;

                                widget.weightUnits = 'lb';
                              } else {
                                isSelectedkg = true;

                                widget.weightUnits = 'kg';
                              }
                            });
                          },
                          icon: Image.asset(
                            (isSelectedkg == true) ? 'assets/img/weight_kg.png' : 'assets/img/weight_lb.png',
                            scale: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onBackground,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                  color: Theme.of(context).colorScheme.background,
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
                                  icon: const Icon(Icons.date_range)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  (isCalenderopen == true)
                      ? Container()
                      : Text(
                          (_rangeStart == _rangeEnd)
                              ? (_rangeStart == null && _rangeEnd == null)
                                  ? "${_selectedDays.first.month}/${_selectedDays.first.day}"
                                  : "${_rangeStart?.month}/${_rangeStart?.day}"
                              : (_rangeEnd == null)
                                  ? "${_rangeStart?.month}/${_rangeStart?.day}"
                                  : "${_rangeStart?.month}/${_rangeStart?.day}~${_rangeEnd?.month}/${_rangeEnd?.day}",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ],
              )
            ],
          ),
          (widget.selectedAnalysis == false)
              ? Expanded(
                  child: ValueListenableBuilder<List<Event>>(
                    valueListenable: _selectedEvents,
                    builder: (context, value, _) {
                      return ListView.builder(
                        // physics: ClampingScrollPhysics(),
                        itemCount: value.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            // onTap: () => print('${value[index]}'), //버튼 클릭시 이벤트 발생
                            title: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: media.width * 0.06,
                                      width: media.width * 0.28,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.onBackground,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.fitHeight,
                                        child: Text(
                                          '${value[index].datetime.month} / ${value[index].datetime.day}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Theme.of(context).colorScheme.background,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                for (int ximgsindex = 0; ximgsindex < value[index].ximgs.length; ximgsindex += 1)
                                  if (getHashCodeInverse(value[index].ximgs[ximgsindex].date) == getHashCodeInverse(value[index].datetime))
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
                                  if (getHashCodeInverse(value[index].xlogs[xlogsindex].lxdate) == getHashCodeInverse(value[index].datetime))
                                    Container(
                                      color: Theme.of(context).colorScheme.onBackground,
                                      child: XlogCreateTile(
                                        xlog: value[index].xlogs[xlogsindex],
                                        onDeleted: () {
                                          setState(() {
                                            value[index].xlogs.removeAt(xlogsindex);
                                            parent?.setState(() {});
                                          });
                                        },
                                        selectedweightUnit: widget.weightUnits,
                                      ),
                                    ),

                                const SizedBox(height: 16)
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                )
              : Expanded(
                  child: ValueListenableBuilder<List<Event>>(
                    valueListenable: _selectedEvents,
                    builder: (context, value, _) {
                      return ListView.builder(
                        // physics: ClampingScrollPhysics(),

                        itemCount: value.length,
                        itemBuilder: (context, index) {
                          return (value.isEmpty)
                              ? Container()
                              : Column(
                                  children: [
                                    // Text("$_rangeStart,$_rangeEnd,${value.last.datetime}"),
                                    // 1회만 만들기
                                    if (index == value.length - 1)
                                      Column(
                                        children: [
                                          Builder(builder: (context) {
                                            return ChartCustom(
                                              value: widget.value,
                                              selectedbodypart: widget.selectedbodypart,
                                              //
                                              rangeStart: (_rangeStart == null && _rangeEnd == null) ? value.last.datetime : _rangeStart!,
                                              rangeEnd: (_rangeEnd == null) ? value.last.datetime : _rangeEnd!,
                                              //
                                              xlogs: widget.xlogs,
                                              weightUnits: widget.weightUnits,
                                            );
                                          }),
                                          SizedBox(height: media.height * 0.20),
                                        ],
                                      ),
                                  ],
                                );
                        },
                      );
                    },
                  ),
                )
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
    final headerText = DateFormat('yyyy. MM').format(focusedDay);

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
