import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:workoutdiary/anlysis/indicator.dart';
import 'package:workoutdiary/data/weightUnitConversion.dart';
import 'package:workoutdiary/exercise_date/utils.dart';
import 'package:workoutdiary/hivedata/xlog.dart';
import 'package:workoutdiary/localization/locales.dart';

class ChartCustom extends StatefulWidget {
  const ChartCustom({
    super.key,
    required this.value, // 0: day, 1: week, 2: month
    required this.selectedbodypart, // 0: all, 1: legs, 2: shoulders, 3: chest, 4: arms, 5: back, 6: abs
    required this.rangeStart,
    required this.rangeEnd,
    //
    required this.weightUnits,
    required this.xlogs,
  });
  //
  final int value;
  final int selectedbodypart;
  final DateTime rangeStart;
  final DateTime rangeEnd;
  //
  final String weightUnits;
  final List<Xlog> xlogs;
  //

  @override
  State<ChartCustom> createState() => _BarChartSample6State();
}

class _BarChartSample6State extends State<ChartCustom> {
  //
  final legsColor = Colors.redAccent;
  final shouldersColor = Colors.orangeAccent;
  final chestColor = Colors.yellow[600]!;
  final armsColor = Colors.greenAccent;
  final backColor = Colors.blueAccent;
  final absColor = Colors.purpleAccent;
  //
  Color colorRank1 = Colors.grey[800]!;
  Color colorRank2 = Colors.grey[700]!;
  Color colorRank3 = Colors.grey[600]!;
  Color colorRank4 = Colors.grey;
  Color colorRank5 = Colors.grey[400]!;
  Color colorRank6 = Colors.grey[300]!;
  //
  Color legsColorRank1 = Colors.red[800]!;
  Color legsColorRank2 = Colors.red[700]!;
  Color legsColorRank3 = Colors.red[600]!;
  Color legsColorRank4 = Colors.red;
  Color legsColorRank5 = Colors.red[400]!;
  Color legsColorRank6 = Colors.red[300]!;
  //
  Color shouldersColorRank1 = Colors.orange[800]!;
  Color shouldersColorRank2 = Colors.orange[700]!;
  Color shouldersColorRank3 = Colors.orange[600]!;
  Color shouldersColorRank4 = Colors.orange;
  Color shouldersColorRank5 = Colors.orange[400]!;
  Color shouldersColorRank6 = Colors.orange[300]!;
  //
  Color chestColorRank1 = Colors.yellow[600]!;
  Color chestColorRank2 = Colors.yellow;
  Color chestColorRank3 = Colors.yellow[400]!;
  Color chestColorRank4 = Colors.yellow[300]!;
  Color chestColorRank5 = Colors.yellow[200]!;
  Color chestColorRank6 = Colors.yellow[100]!;
  //
  Color armsColorRank1 = Colors.green[800]!;
  Color armsColorRank2 = Colors.green[700]!;
  Color armsColorRank3 = Colors.green[600]!;
  Color armsColorRank4 = Colors.green;
  Color armsColorRank5 = Colors.green[400]!;
  Color armsColorRank6 = Colors.green[300]!;
  //
  Color backColorRank1 = Colors.blue[800]!;
  Color backColorRank2 = Colors.blue[700]!;
  Color backColorRank3 = Colors.blue[600]!;
  Color backColorRank4 = Colors.blue;
  Color backColorRank5 = Colors.blue[400]!;
  Color backColorRank6 = Colors.blue[300]!;
  //
  Color absColorRank1 = Colors.purple[800]!;
  Color absColorRank2 = Colors.purple[700]!;
  Color absColorRank3 = Colors.purple[600]!;
  Color absColorRank4 = Colors.purple;
  Color absColorRank5 = Colors.purple[400]!;
  Color absColorRank6 = Colors.purple[300]!;

  late List<double> rank = [0, 0, 0, 0, 0, 0];
  late List<String> rankName = [" ", " ", " ", " ", " ", " "];
  late double rankTotal = 1;

  final betweenSpace = 0.0;
  int touchedIndex = -1;

  BarChartGroupData generateGroupData(
    int x,
    double legs,
    double shoulders,
    double chest,
    double arms,
    double back,
    double abs,
  ) {
    return BarChartGroupData(
      x: x,
      groupVertically: true,
      showingTooltipIndicators: (widget.selectedbodypart == 0 && (legs > 0 || shoulders > 0 || chest > 0 || arms > 0 || back > 0 || abs > 0))
          ? [6]
          : (widget.selectedbodypart == 1 && legs > 0)
              ? [0]
              : (widget.selectedbodypart == 2 && shoulders > 0)
                  ? [1]
                  : (widget.selectedbodypart == 3 && chest > 0)
                      ? [2]
                      : (widget.selectedbodypart == 4 && arms > 0)
                          ? [3]
                          : (widget.selectedbodypart == 5 && back > 0)
                              ? [4]
                              : (abs > 0)
                                  ? [5]
                                  : [],
      barRods: [
        BarChartRodData(
          fromY: 0,
          toY: legs,
          color: legsColor,
          width: (MediaQuery.sizeOf(context).width - 48 * 3) / (widget.rangeEnd.difference(widget.rangeStart).inDays + 1),
          borderRadius: const BorderRadius.all(Radius.circular(0)),
        ),
        BarChartRodData(
          fromY: legs + betweenSpace,
          toY: legs + betweenSpace + shoulders,
          color: shouldersColor,
          width: (MediaQuery.sizeOf(context).width - 48 * 3) / (widget.rangeEnd.difference(widget.rangeStart).inDays + 1),
          borderRadius: const BorderRadius.all(Radius.circular(0)),
        ),
        BarChartRodData(
          fromY: legs + betweenSpace + shoulders + betweenSpace,
          toY: legs + betweenSpace + shoulders + betweenSpace + chest,
          color: chestColor,
          width: (MediaQuery.sizeOf(context).width - 48 * 3) / (widget.rangeEnd.difference(widget.rangeStart).inDays + 1),
          borderRadius: const BorderRadius.all(Radius.circular(0)),
        ),
        BarChartRodData(
          fromY: legs + betweenSpace + shoulders + betweenSpace + chest + betweenSpace,
          toY: legs + betweenSpace + shoulders + betweenSpace + chest + betweenSpace + arms,
          color: armsColor,
          width: (MediaQuery.sizeOf(context).width - 48 * 3) / (widget.rangeEnd.difference(widget.rangeStart).inDays + 1),
          borderRadius: const BorderRadius.all(Radius.circular(0)),
        ),
        BarChartRodData(
          fromY: legs + betweenSpace + shoulders + betweenSpace + chest + betweenSpace + arms + betweenSpace,
          toY: legs + betweenSpace + shoulders + betweenSpace + chest + betweenSpace + arms + betweenSpace + back,
          color: backColor,
          width: (MediaQuery.sizeOf(context).width - 48 * 3) / (widget.rangeEnd.difference(widget.rangeStart).inDays + 1),
          borderRadius: const BorderRadius.all(Radius.circular(0)),
        ),
        BarChartRodData(
          fromY: legs + betweenSpace + shoulders + betweenSpace + chest + betweenSpace + arms + betweenSpace + back + betweenSpace,
          toY: legs + betweenSpace + shoulders + betweenSpace + chest + betweenSpace + arms + betweenSpace + back + betweenSpace + abs,
          color: absColor,
          width: (MediaQuery.sizeOf(context).width - 48 * 3) / (widget.rangeEnd.difference(widget.rangeStart).inDays + 1),
          borderRadius: const BorderRadius.all(Radius.circular(0)),
        ),
        BarChartRodData(
          fromY: legs + betweenSpace + shoulders + betweenSpace + chest + betweenSpace + arms + betweenSpace + back + betweenSpace + abs,
          toY: legs + betweenSpace + shoulders + betweenSpace + chest + betweenSpace + arms + betweenSpace + back + betweenSpace + abs,
          color: Theme.of(context).colorScheme.onBackground,
          width: (MediaQuery.sizeOf(context).width - 48 * 3) / (widget.rangeEnd.difference(widget.rangeStart).inDays + 1),
          borderRadius: const BorderRadius.all(Radius.circular(0)),
        ),
      ],
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 14);
    String text = "";
    // x축 항목 날짜
    for (int index = 0; index < widget.rangeEnd.difference(widget.rangeStart).inDays + 1; index++) {
      if (value.toInt() == index) {
        text = (widget.rangeEnd.difference(widget.rangeStart).inDays + 1 > 8)
            ? (index == 0 || (index + widget.rangeStart.day) % 7 == widget.rangeStart.day % 7 && widget.rangeEnd.difference(widget.rangeStart).inDays + 1 < 33)
                ? "${(widget.rangeStart.subtract(Duration(days: -index))).day}"
                : (index == (widget.rangeEnd.difference(widget.rangeStart).inDays + 1) - 1)
                    ? "${(widget.rangeStart.subtract(Duration(days: -index))).day}"
                    : " "
            : "${(widget.rangeStart.subtract(Duration(days: -index))).day}";
      }
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  Map<DateTime, List<double>> sumBodypartbyDateTime = {};

  List<double> sum0 = []; // todayStandard

  //
  List<BarChartGroupData> Xvalue = [];
  //
  Map<String, double> sumLeg = {};
  Map<String, double> sumSho = {};
  Map<String, double> sumChe = {};
  Map<String, double> sumArm = {};
  Map<String, double> sumBac = {};
  Map<String, double> sumAbs = {};

  @override
  Widget build(BuildContext context) {
    sumBodypartbyDateTime.clear();
    sum0.clear();

    for (int index = 0; index < widget.rangeEnd.difference(widget.rangeStart).inDays + 1; index++) {
      sumBodypartbyDateTime[widget.rangeStart.subtract(Duration(days: -index))] = [0, 0, 0, 0, 0, 0];
    }
    // print("${sumBodypartbyDateTime}");
    sum0 = [0, 0, 0, 0, 0, 0];

    //
    sumLeg.clear();
    sumSho.clear();
    sumChe.clear();
    sumArm.clear();
    sumLeg.clear();
    sumBac.clear();
    sumLeg = {};
    sumSho = {};
    sumChe = {};
    sumArm = {};
    sumBac = {};
    sumAbs = {};
    // sumBodypartbyDateTime[widget.rangeStart.subtract(Duration(days: 0))]?[0] = 1;
    // print(sumBodypartbyDateTime[widget.rangeStart.subtract(Duration(days: 0))]?[0]);
    // print(sumBodypartbyDateTime);

    //두날짜사이의 차이 개수구하기
    // print(widget.rangeEnd.difference(widget.rangeStart).inDays + 1);

    for (int index = 0; index < widget.xlogs.length; index++) {
      if (widget.xlogs[index].finished == true) {
        for (int datetimeindex = 0; datetimeindex < widget.rangeEnd.difference(widget.rangeStart).inDays + 1; datetimeindex++) {
          if (getHashCodeInverse(widget.xlogs[index].lxdate) == getHashCodeInverse(widget.rangeStart.subtract(Duration(days: -datetimeindex)))) {
            switch (widget.xlogs[index].xbodypart) {
              case '하체':
                sumBodypartbyDateTime[widget.rangeStart.subtract(Duration(days: -datetimeindex))]![0] += widget.xlogs[index].lxweight *
                    0.5 *
                    unitConversion(widget.xlogs[index].lxweightUnit, widget.weightUnits) *
                    widget.xlogs[index].lxnumber *
                    widget.xlogs[index].lxset;
                // 운동부위의 운동종류별 운동강도
                if (sumLeg.containsKey(widget.xlogs[index].xType)) {
                  sumLeg[widget.xlogs[index].xType] = sumLeg[widget.xlogs[index].xType]! +
                      widget.xlogs[index].lxweight *
                          0.5 *
                          unitConversion(widget.xlogs[index].lxweightUnit, widget.weightUnits) *
                          widget.xlogs[index].lxnumber *
                          widget.xlogs[index].lxset;
                } else {
                  sumLeg[widget.xlogs[index].xType] = widget.xlogs[index].lxweight *
                      0.5 *
                      unitConversion(widget.xlogs[index].lxweightUnit, widget.weightUnits) *
                      widget.xlogs[index].lxnumber *
                      widget.xlogs[index].lxset;
                }

                break;
              case '어깨':
                sumBodypartbyDateTime[widget.rangeStart.subtract(Duration(days: -datetimeindex))]![1] += widget.xlogs[index].lxweight *
                    0.5 *
                    unitConversion(widget.xlogs[index].lxweightUnit, widget.weightUnits) *
                    widget.xlogs[index].lxnumber *
                    widget.xlogs[index].lxset;
                // 운동부위의 운동종류별 운동강도
                if (sumSho.containsKey(widget.xlogs[index].xType)) {
                  sumSho[widget.xlogs[index].xType] = sumSho[widget.xlogs[index].xType]! +
                      widget.xlogs[index].lxweight *
                          0.5 *
                          unitConversion(widget.xlogs[index].lxweightUnit, widget.weightUnits) *
                          widget.xlogs[index].lxnumber *
                          widget.xlogs[index].lxset;
                } else {
                  sumSho[widget.xlogs[index].xType] = widget.xlogs[index].lxweight *
                      0.5 *
                      unitConversion(widget.xlogs[index].lxweightUnit, widget.weightUnits) *
                      widget.xlogs[index].lxnumber *
                      widget.xlogs[index].lxset;
                }
                break;
              case '가슴':
                sumBodypartbyDateTime[widget.rangeStart.subtract(Duration(days: -datetimeindex))]![2] += widget.xlogs[index].lxweight *
                    0.5 *
                    unitConversion(widget.xlogs[index].lxweightUnit, widget.weightUnits) *
                    widget.xlogs[index].lxnumber *
                    widget.xlogs[index].lxset;
                // 운동부위의 운동종류별 운동강도
                if (sumChe.containsKey(widget.xlogs[index].xType)) {
                  sumChe[widget.xlogs[index].xType] = sumChe[widget.xlogs[index].xType]! +
                      widget.xlogs[index].lxweight *
                          0.5 *
                          unitConversion(widget.xlogs[index].lxweightUnit, widget.weightUnits) *
                          widget.xlogs[index].lxnumber *
                          widget.xlogs[index].lxset;
                } else {
                  sumChe[widget.xlogs[index].xType] = widget.xlogs[index].lxweight *
                      0.5 *
                      unitConversion(widget.xlogs[index].lxweightUnit, widget.weightUnits) *
                      widget.xlogs[index].lxnumber *
                      widget.xlogs[index].lxset;
                }
                break;
              case '팔':
                sumBodypartbyDateTime[widget.rangeStart.subtract(Duration(days: -datetimeindex))]![3] += widget.xlogs[index].lxweight *
                    0.5 *
                    unitConversion(widget.xlogs[index].lxweightUnit, widget.weightUnits) *
                    widget.xlogs[index].lxnumber *
                    widget.xlogs[index].lxset;
                // 운동부위의 운동종류별 운동강도
                if (sumArm.containsKey(widget.xlogs[index].xType)) {
                  sumArm[widget.xlogs[index].xType] = sumArm[widget.xlogs[index].xType]! +
                      widget.xlogs[index].lxweight *
                          0.5 *
                          unitConversion(widget.xlogs[index].lxweightUnit, widget.weightUnits) *
                          widget.xlogs[index].lxnumber *
                          widget.xlogs[index].lxset;
                } else {
                  sumArm[widget.xlogs[index].xType] = widget.xlogs[index].lxweight *
                      0.5 *
                      unitConversion(widget.xlogs[index].lxweightUnit, widget.weightUnits) *
                      widget.xlogs[index].lxnumber *
                      widget.xlogs[index].lxset;
                }
                break;
              case '등':
                sumBodypartbyDateTime[widget.rangeStart.subtract(Duration(days: -datetimeindex))]![4] += widget.xlogs[index].lxweight *
                    0.5 *
                    unitConversion(widget.xlogs[index].lxweightUnit, widget.weightUnits) *
                    widget.xlogs[index].lxnumber *
                    widget.xlogs[index].lxset;
                // 운동부위의 운동종류별 운동강도
                if (sumBac.containsKey(widget.xlogs[index].xType)) {
                  sumBac[widget.xlogs[index].xType] = sumBac[widget.xlogs[index].xType]! +
                      widget.xlogs[index].lxweight *
                          0.5 *
                          unitConversion(widget.xlogs[index].lxweightUnit, widget.weightUnits) *
                          widget.xlogs[index].lxnumber *
                          widget.xlogs[index].lxset;
                } else {
                  sumBac[widget.xlogs[index].xType] = widget.xlogs[index].lxweight *
                      0.5 *
                      unitConversion(widget.xlogs[index].lxweightUnit, widget.weightUnits) *
                      widget.xlogs[index].lxnumber *
                      widget.xlogs[index].lxset;
                }
                break;
              case '복근':
                sumBodypartbyDateTime[widget.rangeStart.subtract(Duration(days: -datetimeindex))]![5] += widget.xlogs[index].lxweight *
                    0.5 *
                    unitConversion(widget.xlogs[index].lxweightUnit, widget.weightUnits) *
                    widget.xlogs[index].lxnumber *
                    widget.xlogs[index].lxset;
                // 운동부위의 운동종류별 운동강도
                if (sumAbs.containsKey(widget.xlogs[index].xType)) {
                  sumAbs[widget.xlogs[index].xType] = sumAbs[widget.xlogs[index].xType]! +
                      widget.xlogs[index].lxweight *
                          0.5 *
                          unitConversion(widget.xlogs[index].lxweightUnit, widget.weightUnits) *
                          widget.xlogs[index].lxnumber *
                          widget.xlogs[index].lxset;
                } else {
                  sumAbs[widget.xlogs[index].xType] = widget.xlogs[index].lxweight *
                      0.5 *
                      unitConversion(widget.xlogs[index].lxweightUnit, widget.weightUnits) *
                      widget.xlogs[index].lxnumber *
                      widget.xlogs[index].lxset;
                }
                break;
            }
          }
        }
      }
    }

    for (int datetimeindex = 0; datetimeindex < widget.rangeEnd.difference(widget.rangeStart).inDays + 1; datetimeindex++) {
      sum0[0] += sumBodypartbyDateTime[widget.rangeStart.subtract(Duration(days: -datetimeindex))]![0];
      sum0[1] += sumBodypartbyDateTime[widget.rangeStart.subtract(Duration(days: -datetimeindex))]![1];
      sum0[2] += sumBodypartbyDateTime[widget.rangeStart.subtract(Duration(days: -datetimeindex))]![2];
      sum0[3] += sumBodypartbyDateTime[widget.rangeStart.subtract(Duration(days: -datetimeindex))]![3];
      sum0[4] += sumBodypartbyDateTime[widget.rangeStart.subtract(Duration(days: -datetimeindex))]![4];
      sum0[5] += sumBodypartbyDateTime[widget.rangeStart.subtract(Duration(days: -datetimeindex))]![5];
    }

    // 오늘날짜에 따라 내림차순 정렬
    Map<String, double> todayBodypratRaito = {'하체': sum0[0], '어깨': sum0[1], '가슴': sum0[2], '팔': sum0[3], '등': sum0[4], '복근': sum0[5]};
    Map<String, double> sortedMap = Map.fromEntries(todayBodypratRaito.entries.toList()..sort((e1, e2) => e2.value.compareTo(e1.value)));
    todayBodypratRaito.clear;
    // print(sortedMap.entries);
    // print(sortedMap.keys.elementAt(0));
    // print(sortedMap[sortedMap.keys.elementAt(0)]);

    // 운동별 value값에 따라서 내림차순 정렬
    Map<String, double> legsortedMap = Map.fromEntries(sumLeg.entries.toList()..sort((e1, e2) => e2.value.compareTo(e1.value)));
    Map<String, double> shosortedMap = Map.fromEntries(sumSho.entries.toList()..sort((e1, e2) => e2.value.compareTo(e1.value)));
    Map<String, double> chesortedMap = Map.fromEntries(sumChe.entries.toList()..sort((e1, e2) => e2.value.compareTo(e1.value)));
    Map<String, double> armsortedMap = Map.fromEntries(sumArm.entries.toList()..sort((e1, e2) => e2.value.compareTo(e1.value)));
    Map<String, double> bacsortedMap = Map.fromEntries(sumBac.entries.toList()..sort((e1, e2) => e2.value.compareTo(e1.value)));
    Map<String, double> abssortedMap = Map.fromEntries(sumAbs.entries.toList()..sort((e1, e2) => e2.value.compareTo(e1.value)));
    // print(legsortedMap.entries);
    // print(sumSho.entries);
    // print(sumChe.entries);
    // print(sumArm.entries);
    // print(sumBac.entries);
    // print(sumAbs.entries);
    // 부위에 맞게 그래프 x값 조정
    // selectedbodypart, // 0: all, 1: legs, 2: shoulders, 3: chest, 4: arms, 5: back, 6: abs

    switch (widget.selectedbodypart) {
      case 0:
        rank = [0, 0, 0, 0, 0, 0];
        rankTotal = 1;
        rank[0] = sortedMap[sortedMap.keys.elementAt(0)]!.toDouble();
        rank[1] = sortedMap[sortedMap.keys.elementAt(1)]!.toDouble();
        rank[2] = sortedMap[sortedMap.keys.elementAt(2)]!.toDouble();
        rank[3] = sortedMap[sortedMap.keys.elementAt(3)]!.toDouble();
        rank[4] = sortedMap[sortedMap.keys.elementAt(4)]!.toDouble();
        rank[5] = sortedMap[sortedMap.keys.elementAt(5)]!.toDouble();
        rankTotal = rank[0] + rank[1] + rank[2] + rank[3] + rank[4] + rank[5];
        //
        rankName = [" ", " ", " ", " ", " ", " "];
        switch (sortedMap.keys.elementAt(0)) {
          case '하체':
            colorRank1 = legsColor;
            rankName[0] = LocaleData.legs.getString((context));
            break;
          case '어깨':
            colorRank1 = shouldersColor;
            rankName[0] = LocaleData.shoulders.getString((context));
            break;
          case '가슴':
            colorRank1 = chestColor;
            rankName[0] = LocaleData.chest.getString((context));
            break;
          case '팔':
            colorRank1 = armsColor;
            rankName[0] = LocaleData.arms.getString((context));
            break;
          case '등':
            colorRank1 = backColor;
            rankName[0] = LocaleData.back.getString((context));
            break;
          case '복근':
            colorRank1 = absColor;
            rankName[0] = LocaleData.abs.getString((context));
            break;
        }
        switch (sortedMap.keys.elementAt(1)) {
          case '하체':
            colorRank2 = legsColor;
            rankName[1] = LocaleData.legs.getString((context));
            break;
          case '어깨':
            colorRank2 = shouldersColor;
            rankName[1] = LocaleData.shoulders.getString((context));
            break;
          case '가슴':
            colorRank2 = chestColor;
            rankName[1] = LocaleData.chest.getString((context));
            break;
          case '팔':
            colorRank2 = armsColor;
            rankName[1] = LocaleData.arms.getString((context));
            break;
          case '등':
            colorRank2 = backColor;
            rankName[1] = LocaleData.back.getString((context));
            break;
          case '복근':
            colorRank2 = absColor;
            rankName[1] = LocaleData.abs.getString((context));
            break;
        }
        switch (sortedMap.keys.elementAt(2)) {
          case '하체':
            colorRank3 = legsColor;
            rankName[2] = LocaleData.legs.getString((context));
            break;
          case '어깨':
            colorRank3 = shouldersColor;
            rankName[2] = LocaleData.shoulders.getString((context));
            break;
          case '가슴':
            colorRank3 = chestColor;
            rankName[2] = LocaleData.chest.getString((context));
            break;
          case '팔':
            colorRank3 = armsColor;
            rankName[2] = LocaleData.arms.getString((context));
            break;
          case '등':
            colorRank3 = backColor;
            rankName[2] = LocaleData.back.getString((context));
            break;
          case '복근':
            colorRank3 = absColor;
            rankName[2] = LocaleData.abs.getString((context));
            break;
        }
        switch (sortedMap.keys.elementAt(3)) {
          case '하체':
            colorRank4 = legsColor;
            rankName[3] = LocaleData.legs.getString((context));
            break;
          case '어깨':
            colorRank4 = shouldersColor;
            rankName[3] = LocaleData.shoulders.getString((context));
            break;
          case '가슴':
            colorRank4 = chestColor;
            rankName[3] = LocaleData.chest.getString((context));
            break;
          case '팔':
            colorRank4 = armsColor;
            rankName[3] = LocaleData.arms.getString((context));
            break;
          case '등':
            colorRank4 = backColor;
            rankName[3] = LocaleData.back.getString((context));
            break;
          case '복근':
            colorRank4 = absColor;
            rankName[3] = LocaleData.abs.getString((context));
            break;
        }
        switch (sortedMap.keys.elementAt(4)) {
          case '하체':
            colorRank5 = legsColor;
            rankName[4] = LocaleData.legs.getString((context));
            break;
          case '어깨':
            colorRank5 = shouldersColor;
            rankName[4] = LocaleData.shoulders.getString((context));
            break;
          case '가슴':
            colorRank5 = chestColor;
            rankName[4] = LocaleData.chest.getString((context));
            break;
          case '팔':
            colorRank5 = armsColor;
            rankName[4] = LocaleData.arms.getString((context));
            break;
          case '등':
            colorRank5 = backColor;
            rankName[4] = LocaleData.back.getString((context));
            break;
          case '복근':
            colorRank5 = absColor;
            rankName[4] = LocaleData.abs.getString((context));
            break;
        }
        switch (sortedMap.keys.elementAt(5)) {
          case '하체':
            colorRank6 = legsColor;
            rankName[5] = LocaleData.legs.getString((context));
            break;
          case '어깨':
            colorRank6 = shouldersColor;
            rankName[5] = LocaleData.shoulders.getString((context));
            break;
          case '가슴':
            colorRank6 = chestColor;
            rankName[5] = LocaleData.chest.getString((context));
            break;
          case '팔':
            colorRank6 = armsColor;
            rankName[5] = LocaleData.arms.getString((context));
            break;
          case '등':
            colorRank6 = backColor;
            rankName[5] = LocaleData.back.getString((context));
            break;
          case '복근':
            colorRank6 = absColor;
            rankName[5] = LocaleData.abs.getString((context));
            break;
        }
        break;
      case 1:
        //초기화
        rankTotal = 1;
        rank = [0, 0, 0, 0, 0, 0];
        if (legsortedMap.isNotEmpty) {
          if (legsortedMap.length < 6) {
            for (int index = 0; index < legsortedMap.length; index++) {
              rank[index] = legsortedMap[legsortedMap.keys.elementAt(index)]!.toDouble();
              rankName[index] = legsortedMap.keys.elementAt(index).getString(context);

              rankTotal += legsortedMap[legsortedMap.keys.elementAt(index)]!.toDouble();
            }
          } else {
            // 항목이 6개인 경우는 5개만 돌리고 나머지는 ...으로 처리
            for (int index = 0; index < legsortedMap.length; index++) {
              if (index < 5) {
                rank[index] = legsortedMap[legsortedMap.keys.elementAt(index)]!.toDouble();
                rankName[index] = legsortedMap.keys.elementAt(index).getString(context);
              } else {
                rank[5] += legsortedMap[legsortedMap.keys.elementAt(index)]!.toDouble();
                rankName[5] = '···';
              }
              rankTotal += legsortedMap[legsortedMap.keys.elementAt(index)]!.toDouble();
            }
          }
        }
        //
        colorRank1 = legsColorRank1;
        colorRank2 = legsColorRank2;
        colorRank3 = legsColorRank3;
        colorRank4 = legsColorRank4;
        colorRank5 = legsColorRank5;
        colorRank6 = legsColorRank6;
        break;
      case 2:
        //초기화
        rankTotal = 1;
        rank = [0, 0, 0, 0, 0, 0];
        if (shosortedMap.isNotEmpty) {
          if (shosortedMap.length < 6) {
            for (int index = 0; index < shosortedMap.length; index++) {
              rank[index] = shosortedMap[shosortedMap.keys.elementAt(index)]!.toDouble();
              rankName[index] = shosortedMap.keys.elementAt(index).getString(context);

              rankTotal += shosortedMap[shosortedMap.keys.elementAt(index)]!.toDouble();
            }
          } else {
            // 항목이 6개인 경우는 5개만 돌리고 나머지는 ...으로 처리
            for (int index = 0; index < shosortedMap.length; index++) {
              if (index < 5) {
                rank[index] = shosortedMap[shosortedMap.keys.elementAt(index)]!.toDouble();
                rankName[index] = shosortedMap.keys.elementAt(index).getString(context);
              } else {
                rank[5] += shosortedMap[shosortedMap.keys.elementAt(index)]!.toDouble();
                rankName[5] = '···';
              }
              rankTotal += shosortedMap[shosortedMap.keys.elementAt(index)]!.toDouble();
            }
          }
        }
        //
        colorRank1 = shouldersColorRank1;
        colorRank2 = shouldersColorRank2;
        colorRank3 = shouldersColorRank3;
        colorRank4 = shouldersColorRank4;
        colorRank5 = shouldersColorRank5;
        colorRank6 = shouldersColorRank6;
        break;
      case 3:
        //초기화
        rankTotal = 1;
        rank = [0, 0, 0, 0, 0, 0];
        if (chesortedMap.isNotEmpty) {
          if (chesortedMap.length < 6) {
            for (int index = 0; index < chesortedMap.length; index++) {
              rank[index] = chesortedMap[chesortedMap.keys.elementAt(index)]!.toDouble();
              rankName[index] = chesortedMap.keys.elementAt(index).getString(context);

              rankTotal += chesortedMap[chesortedMap.keys.elementAt(index)]!.toDouble();
            }
          } else {
            // 항목이 6개인 경우는 5개만 돌리고 나머지는 ...으로 처리
            for (int index = 0; index < chesortedMap.length; index++) {
              if (index < 5) {
                rank[index] = chesortedMap[chesortedMap.keys.elementAt(index)]!.toDouble();
                rankName[index] = chesortedMap.keys.elementAt(index).getString(context);
              } else {
                rank[5] += chesortedMap[chesortedMap.keys.elementAt(index)]!.toDouble();
                rankName[5] = '···';
              }
              rankTotal += chesortedMap[chesortedMap.keys.elementAt(index)]!.toDouble();
            }
          }
        }
        //
        colorRank1 = chestColorRank1;
        colorRank2 = chestColorRank2;
        colorRank3 = chestColorRank3;
        colorRank4 = chestColorRank4;
        colorRank5 = chestColorRank5;
        colorRank6 = chestColorRank6;
        break;
      case 4:
        //초기화
        rankTotal = 1;
        rank = [0, 0, 0, 0, 0, 0];
        if (armsortedMap.isNotEmpty) {
          if (armsortedMap.length < 6) {
            for (int index = 0; index < armsortedMap.length; index++) {
              rank[index] = armsortedMap[armsortedMap.keys.elementAt(index)]!.toDouble();
              rankName[index] = armsortedMap.keys.elementAt(index).getString(context);

              rankTotal += armsortedMap[armsortedMap.keys.elementAt(index)]!.toDouble();
            }
          } else {
            // 항목이 6개인 경우는 5개만 돌리고 나머지는 ...으로 처리
            for (int index = 0; index < armsortedMap.length; index++) {
              if (index < 5) {
                rank[index] = armsortedMap[armsortedMap.keys.elementAt(index)]!.toDouble();
                rankName[index] = armsortedMap.keys.elementAt(index).getString(context);
              } else {
                rank[5] += armsortedMap[armsortedMap.keys.elementAt(index)]!.toDouble();
                rankName[5] = '···';
              }
              rankTotal += armsortedMap[armsortedMap.keys.elementAt(index)]!.toDouble();
            }
          }
        }
        //
        colorRank1 = armsColorRank1;
        colorRank2 = armsColorRank2;
        colorRank3 = armsColorRank3;
        colorRank4 = armsColorRank4;
        colorRank5 = armsColorRank5;
        colorRank6 = armsColorRank6;
        break;
      case 5:
        //초기화
        rankTotal = 1;
        rank = [0, 0, 0, 0, 0, 0];
        if (bacsortedMap.isNotEmpty) {
          if (bacsortedMap.length < 6) {
            for (int index = 0; index < bacsortedMap.length; index++) {
              rank[index] = bacsortedMap[bacsortedMap.keys.elementAt(index)]!.toDouble();
              rankName[index] = bacsortedMap.keys.elementAt(index).getString(context);

              rankTotal += bacsortedMap[bacsortedMap.keys.elementAt(index)]!.toDouble();
            }
          } else {
            // 항목이 6개인 경우는 5개만 돌리고 나머지는 ...으로 처리
            for (int index = 0; index < bacsortedMap.length; index++) {
              if (index < 5) {
                rank[index] = bacsortedMap[bacsortedMap.keys.elementAt(index)]!.toDouble();
                rankName[index] = bacsortedMap.keys.elementAt(index).getString(context);
              } else {
                rank[5] += bacsortedMap[bacsortedMap.keys.elementAt(index)]!.toDouble();
                rankName[5] = '···';
              }
              rankTotal += bacsortedMap[bacsortedMap.keys.elementAt(index)]!.toDouble();
            }
          }
        }
        //
        colorRank1 = backColorRank1;
        colorRank2 = backColorRank2;
        colorRank3 = backColorRank3;
        colorRank4 = backColorRank4;
        colorRank5 = backColorRank5;
        colorRank6 = backColorRank6;
        break;
      case 6:
        //초기화
        rankTotal = 1;
        rank = [0, 0, 0, 0, 0, 0];
        if (abssortedMap.isNotEmpty) {
          if (abssortedMap.length < 6) {
            for (int index = 0; index < abssortedMap.length; index++) {
              rank[index] = abssortedMap[abssortedMap.keys.elementAt(index)]!.toDouble();
              rankName[index] = abssortedMap.keys.elementAt(index).getString(context);

              rankTotal += abssortedMap[abssortedMap.keys.elementAt(index)]!.toDouble();
            }
          } else {
            // 항목이 6개인 경우는 5개만 돌리고 나머지는 ...으로 처리
            for (int index = 0; index < abssortedMap.length; index++) {
              if (index < 5) {
                rank[index] = abssortedMap[abssortedMap.keys.elementAt(index)]!.toDouble();
                rankName[index] = abssortedMap.keys.elementAt(index).getString(context);
              } else {
                rank[5] += abssortedMap[abssortedMap.keys.elementAt(index)]!.toDouble();
                rankName[5] = '···';
              }
              rankTotal += abssortedMap[abssortedMap.keys.elementAt(index)]!.toDouble();
            }
          }
        }
        //
        colorRank1 = absColorRank1;
        colorRank2 = absColorRank2;
        colorRank3 = absColorRank3;
        colorRank4 = absColorRank4;
        colorRank5 = absColorRank5;
        colorRank6 = absColorRank6;
        break;
    }
    List<double> maxYScalelist = [];
    double maxYScale = 0;
    switch (widget.selectedbodypart) {
      case 0:
        for (int datetimeindex = 0; datetimeindex < widget.rangeEnd.difference(widget.rangeStart).inDays + 1; datetimeindex++) {
          maxYScalelist.add(
            sumBodypartbyDateTime[widget.rangeStart.subtract(Duration(days: -datetimeindex))]![0] +
                sumBodypartbyDateTime[widget.rangeStart.subtract(Duration(days: -datetimeindex))]![1] +
                sumBodypartbyDateTime[widget.rangeStart.subtract(Duration(days: -datetimeindex))]![2] +
                sumBodypartbyDateTime[widget.rangeStart.subtract(Duration(days: -datetimeindex))]![3] +
                sumBodypartbyDateTime[widget.rangeStart.subtract(Duration(days: -datetimeindex))]![4] +
                sumBodypartbyDateTime[widget.rangeStart.subtract(Duration(days: -datetimeindex))]![5],
          );
        }
        List<double> legsortedmaxYScale = maxYScalelist.toList()..sort((e1, e2) => e2.compareTo(e1));
        maxYScale = legsortedmaxYScale.first;
        break;
      case 1:
        for (int datetimeindex = 0; datetimeindex < widget.rangeEnd.difference(widget.rangeStart).inDays + 1; datetimeindex++) {
          maxYScalelist.add(sumBodypartbyDateTime[widget.rangeStart.subtract(Duration(days: -datetimeindex))]![0]);
        }
        List<double> legsortedmaxYScale = maxYScalelist.toList()..sort((e1, e2) => e2.compareTo(e1));
        maxYScale = legsortedmaxYScale.first;
        break;
      case 2:
        for (int datetimeindex = 0; datetimeindex < widget.rangeEnd.difference(widget.rangeStart).inDays + 1; datetimeindex++) {
          maxYScalelist.add(sumBodypartbyDateTime[widget.rangeStart.subtract(Duration(days: -datetimeindex))]![1]);
        }
        List<double> legsortedmaxYScale = maxYScalelist.toList()..sort((e1, e2) => e2.compareTo(e1));
        maxYScale = legsortedmaxYScale.first;
        break;
      case 3:
        for (int datetimeindex = 0; datetimeindex < widget.rangeEnd.difference(widget.rangeStart).inDays + 1; datetimeindex++) {
          maxYScalelist.add(sumBodypartbyDateTime[widget.rangeStart.subtract(Duration(days: -datetimeindex))]![2]);
        }
        List<double> legsortedmaxYScale = maxYScalelist.toList()..sort((e1, e2) => e2.compareTo(e1));
        maxYScale = legsortedmaxYScale.first;
        break;
      case 4:
        for (int datetimeindex = 0; datetimeindex < widget.rangeEnd.difference(widget.rangeStart).inDays + 1; datetimeindex++) {
          maxYScalelist.add(sumBodypartbyDateTime[widget.rangeStart.subtract(Duration(days: -datetimeindex))]![3]);
        }
        List<double> legsortedmaxYScale = maxYScalelist.toList()..sort((e1, e2) => e2.compareTo(e1));
        maxYScale = legsortedmaxYScale.first;
        break;
      case 5:
        for (int datetimeindex = 0; datetimeindex < widget.rangeEnd.difference(widget.rangeStart).inDays + 1; datetimeindex++) {
          maxYScalelist.add(sumBodypartbyDateTime[widget.rangeStart.subtract(Duration(days: -datetimeindex))]![4]);
        }
        List<double> legsortedmaxYScale = maxYScalelist.toList()..sort((e1, e2) => e2.compareTo(e1));
        maxYScale = legsortedmaxYScale.first;
        break;
      case 6:
        for (int datetimeindex = 0; datetimeindex < widget.rangeEnd.difference(widget.rangeStart).inDays + 1; datetimeindex++) {
          maxYScalelist.add(sumBodypartbyDateTime[widget.rangeStart.subtract(Duration(days: -datetimeindex))]![5]);
        }
        List<double> legsortedmaxYScale = maxYScalelist.toList()..sort((e1, e2) => e2.compareTo(e1));
        maxYScale = legsortedmaxYScale.first;
        break;
    }
    // ----------------------<< pie ChartCustom >>-----------------------

    return Column(
      children: [
        // pie ChartCustom
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Text(
                //   "${widget.rangeStart.month}/${widget.rangeStart.day}~${widget.rangeEnd.month}/${widget.rangeEnd.day}",
                //   style: TextStyle(
                //     color: Theme.of(context).colorScheme.onBackground,
                //     fontSize: 16,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: (rank[0] == 0)
                        ? Image.asset('./assets/img/emptyBox.png')
                        : Row(
                            children: <Widget>[
                              // const SizedBox(width: 18),
                              Expanded(
                                child: AspectRatio(
                                  aspectRatio: 1.2,
                                  child: PieChart(
                                    PieChartData(
                                      pieTouchData: PieTouchData(
                                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                          setState(() {
                                            if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                                              touchedIndex = -1;
                                              return;
                                            }
                                            touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                                          });
                                        },
                                      ),
                                      borderData: FlBorderData(
                                        show: false,
                                      ),
                                      sectionsSpace: 0,
                                      centerSpaceRadius: 40,
                                      sections: showingSections(),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.35,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      (rank[0] == 0)
                                          ? Container()
                                          : Row(
                                              children: [
                                                SizedBox(
                                                  height: 24,
                                                  width: 24,
                                                  child: Image.asset('./assets/img/medal_1.png'),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(2.0),
                                                  child: Indicator(
                                                    color: colorRank1,
                                                    text: rankName[0],
                                                    isSquare: true,
                                                  ),
                                                ),
                                              ],
                                            ),
                                      (rank[1] == 0)
                                          ? Container()
                                          : Row(
                                              children: [
                                                SizedBox(
                                                  height: 24,
                                                  width: 24,
                                                  child: Image.asset('./assets/img/medal_2.png'),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(2.0),
                                                  child: Indicator(
                                                    color: colorRank2,
                                                    text: rankName[1],
                                                    isSquare: true,
                                                  ),
                                                ),
                                              ],
                                            ),
                                      (rank[2] == 0)
                                          ? Container()
                                          : Row(
                                              children: [
                                                SizedBox(
                                                  height: 24,
                                                  width: 24,
                                                  child: Image.asset('./assets/img/medal_3.png'),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(2.0),
                                                  child: Indicator(
                                                    color: colorRank3,
                                                    text: rankName[2],
                                                    isSquare: true,
                                                  ),
                                                ),
                                              ],
                                            ),
                                      (rank[3] == 0)
                                          ? Container()
                                          : Row(
                                              children: [
                                                const SizedBox(height: 24, width: 24),
                                                Padding(
                                                  padding: const EdgeInsets.all(2.0),
                                                  child: Indicator(
                                                    color: colorRank4,
                                                    text: rankName[3],
                                                    isSquare: true,
                                                  ),
                                                ),
                                              ],
                                            ),
                                      (rank[4] == 0)
                                          ? Container()
                                          : Row(
                                              children: [
                                                const SizedBox(height: 24, width: 24),
                                                Padding(
                                                  padding: const EdgeInsets.all(2.0),
                                                  child: Indicator(
                                                    color: colorRank5,
                                                    text: rankName[4],
                                                    isSquare: true,
                                                  ),
                                                ),
                                              ],
                                            ),
                                      (rank[5] == 0)
                                          ? Container()
                                          : Row(
                                              children: [
                                                const SizedBox(height: 24, width: 24),
                                                Padding(
                                                  padding: const EdgeInsets.all(2.0),
                                                  child: Indicator(
                                                    color: colorRank6,
                                                    text: rankName[5],
                                                    isSquare: true,
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 8)
              ],
            ),
          ),
        ),

        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Text(
        //     (widget.rangeStart == widget.rangeEnd)
        //         ? "${widget.rangeStart.month}/${widget.rangeStart.day}"
        //         : "${widget.rangeStart.month}/${widget.rangeStart.day}~${widget.rangeEnd.month}/${widget.rangeEnd.day}",
        //     style: TextStyle(
        //       color: Theme.of(context).colorScheme.onBackground,
        //       fontSize: 16,
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        // ),
        // bar_chart
        // const SizedBox(height: 8),
        (rank[0] == 0)
            ? Container()
            : Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Text(
                      //   "${widget.rangeStart.month}/${widget.rangeStart.day}~${widget.rangeEnd.month}/${widget.rangeEnd.day}",
                      //   style: TextStyle(
                      //     color: Theme.of(context).colorScheme.onBackground,
                      //     fontSize: 16,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      // 범례
                      // const SizedBox(height: 8),
                      // LegendsListWidget(
                      //   legends: [
                      //     Legend(LocaleData.legs.getString((context)), legsColor),
                      //     Legend(LocaleData.shoulders.getString((context)), legsColor),
                      //     Legend(LocaleData.chest.getString((context)), legsColor),
                      //     Legend(LocaleData.arms.getString((context)), legsColor),
                      //     Legend(LocaleData.back.getString((context)), legsColor),
                      //     Legend(LocaleData.abs.getString((context)), legsColor),
                      //   ],
                      // ),

                      Padding(
                        padding: const EdgeInsets.only(top: 48, bottom: 8, left: 0, right: 20),
                        child: SizedBox(
                          width: double.infinity,
                          height: 200,
                          child: AspectRatio(
                            aspectRatio: 2,
                            child: BarChart(
                              BarChartData(
                                alignment: (widget.rangeEnd.difference(widget.rangeStart).inDays + 1 == 1) ? BarChartAlignment.center : BarChartAlignment.spaceBetween,
                                titlesData: FlTitlesData(
                                  leftTitles: const AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 50,
                                    ),
                                  ),
                                  rightTitles: const AxisTitles(),
                                  topTitles: const AxisTitles(),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: bottomTitles,
                                      reservedSize: 25,
                                    ),
                                  ),
                                ),
                                barTouchData: BarTouchData(
                                  enabled: false,
                                  touchTooltipData: BarTouchTooltipData(
                                    tooltipBgColor: Colors.transparent,
                                    tooltipRoundedRadius: 8,
                                  ),
                                ),
                                borderData: FlBorderData(show: false),
                                gridData: const FlGridData(show: true, drawVerticalLine: false),
                                barGroups: [
                                  for (int index = 0; index < widget.rangeEnd.difference(widget.rangeStart).inDays + 1; index++)
                                    (widget.selectedbodypart == 0)
                                        ? generateGroupData(
                                            index,
                                            sumBodypartbyDateTime[widget.rangeStart.subtract(Duration(days: -index))]![0],
                                            sumBodypartbyDateTime[widget.rangeStart.subtract(Duration(days: -index))]![1],
                                            sumBodypartbyDateTime[widget.rangeStart.subtract(Duration(days: -index))]![2],
                                            sumBodypartbyDateTime[widget.rangeStart.subtract(Duration(days: -index))]![3],
                                            sumBodypartbyDateTime[widget.rangeStart.subtract(Duration(days: -index))]![4],
                                            sumBodypartbyDateTime[widget.rangeStart.subtract(Duration(days: -index))]![5],
                                          )
                                        : (widget.selectedbodypart == 1)
                                            ? generateGroupData(index, sumBodypartbyDateTime[widget.rangeStart.subtract(Duration(days: -index))]![0], 0, 0, 0, 0, 0)
                                            : (widget.selectedbodypart == 2)
                                                ? generateGroupData(index, 0, sumBodypartbyDateTime[widget.rangeStart.subtract(Duration(days: -index))]![1], 0, 0, 0, 0)
                                                : (widget.selectedbodypart == 3)
                                                    ? generateGroupData(index, 0, 0, sumBodypartbyDateTime[widget.rangeStart.subtract(Duration(days: -index))]![2], 0, 0, 0)
                                                    : (widget.selectedbodypart == 4)
                                                        ? generateGroupData(index, 0, 0, 0, sumBodypartbyDateTime[widget.rangeStart.subtract(Duration(days: -index))]![3], 0, 0)
                                                        : (widget.selectedbodypart == 5)
                                                            ? generateGroupData(index, 0, 0, 0, 0, sumBodypartbyDateTime[widget.rangeStart.subtract(Duration(days: -index))]![4], 0)
                                                            : generateGroupData(index, 0, 0, 0, 0, 0, sumBodypartbyDateTime[widget.rangeStart.subtract(Duration(days: -index))]![5])
                                ],

                                // 그래프의 Y축 길이
                                maxY: maxYScale,

                                // extraLinesData: ExtraLinesData(
                                //   horizontalLines: [
                                //     HorizontalLine(
                                //       y: maxYScale,
                                //       color: legsColor,
                                //       strokeWidth: 1,
                                //       dashArray: [20, 4],
                                //     ),
                                //     HorizontalLine(
                                //       y: maxYScale,
                                //       color: shouldersColor,
                                //       strokeWidth: 1,
                                //       dashArray: [20, 4],
                                //     ),
                                //     HorizontalLine(
                                //       y: 6,
                                //       color: chestColor,
                                //       strokeWidth: 1,
                                //       dashArray: [20, 4],
                                //     ),
                                //     HorizontalLine(
                                //       y: 8,
                                //       color: armsColor,
                                //       strokeWidth: 1,
                                //       dashArray: [20, 4],
                                //     ),
                                //     HorizontalLine(
                                //       y: 10,
                                //       color: backColor,
                                //       strokeWidth: 1,
                                //       dashArray: [20, 4],
                                //     ),
                                //     HorizontalLine(
                                //       y: 12,
                                //       color: absColor,
                                //       strokeWidth: 1,
                                //       dashArray: [20, 4],
                                //     ),
                                //   ],
                                // ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(6, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: colorRank1,
            value: rank[0] / rankTotal * 100,
            title: ((rank[0] / rankTotal * 100).round() == 0) ? '' : '${(rank[0] / rankTotal * 100).round()}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: colorRank2,
            value: rank[1] / rankTotal * 100,
            title: ((rank[1] / rankTotal * 100).round() == 0) ? '' : '${(rank[1] / rankTotal * 100).round()}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: colorRank3,
            value: rank[2] / rankTotal * 100,
            title: ((rank[2] / rankTotal * 100).round() == 0) ? '' : '${(rank[2] / rankTotal * 100).round()}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: colorRank4,
            value: rank[3] / rankTotal * 100,
            title: ((rank[3] / rankTotal * 100).round() == 0) ? '' : '${(rank[3] / rankTotal * 100).round()}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 4:
          return PieChartSectionData(
            color: colorRank5,
            value: rank[4] / rankTotal * 100,
            title: ((rank[4] / rankTotal * 100).round() == 0) ? '' : '${(rank[4] / rankTotal * 100).round()}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 5:
          return PieChartSectionData(
            color: colorRank6,
            value: rank[5] / rankTotal * 100,
            title: ((rank[5] / rankTotal * 100).round() == 0)
                ? ''
                : '${100 - (rank[0] / rankTotal * 100).round() - (rank[1] / rankTotal * 100).round() - (rank[2] / rankTotal * 100).round() - (rank[3] / rankTotal * 100).round() - (rank[4] / rankTotal * 100).round()}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );

        default:
          throw Error();
      }
    });
  }
}
