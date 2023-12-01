import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:workoutdiary/common/colo_extension.dart';
import 'package:workoutdiary/hivedata/xlog.dart';
import 'package:workoutdiary/localization/locales.dart';
import 'package:workoutdiary/ui/ui_group.dart';

class XlogCreateTile extends StatefulWidget {
  const XlogCreateTile({
    Key? key,
    required this.xlog,
    required this.onDeleted,
    required this.selectedweightUnit,
    this.xlogformat = 0,
    this.styleformat = 0,
  }) : super(key: key);

  final Xlog xlog;
  final Function onDeleted;
  final String selectedweightUnit;
  final int xlogformat;
  final int styleformat;

  @override
  State<XlogCreateTile> createState() => _XlogCreateTileState();
}

class _XlogCreateTileState extends State<XlogCreateTile> {
  Color stylefontColor = Colors.white;
  Color stylebackgroundColor = Colors.black;
  @override
  Widget build(BuildContext context) {
    switch (widget.styleformat) {
      case 0:
        stylefontColor = Colors.white;
        stylebackgroundColor = Colors.black.withOpacity(0.25);
        break;
      case 1:
        stylefontColor = Colors.white;
        stylebackgroundColor = Colors.black.withOpacity(0);
        break;
      case 2:
        stylefontColor = Colors.black;
        stylebackgroundColor = Colors.white.withOpacity(0.25);
        break;
      case 3:
        stylefontColor = Colors.black;
        stylebackgroundColor = Colors.white.withOpacity(0);
        break;
    }
    var media = MediaQuery.of(context).size;

    double weightUnitConversion = 1;

    switch (widget.selectedweightUnit) {
      case 'lb':
        switch (widget.xlog.lxweightUnit) {
          case 'lb':
            // weightUnitConversion = 1; //변화없음
            setState(() {});

            break;
          case 'kg':
            weightUnitConversion = 2.20; //2.20462

            setState(() {});
            break;
        }
        break;
      //
      case 'kg':
        switch (widget.xlog.lxweightUnit) {
          case 'lb':
            weightUnitConversion = 0.45; //0.453592

            break;
          case 'kg':
            weightUnitConversion = 1; //변화없음

            break;
        }
    }
    return widget.xlog.finished == false
        ? Container()
        : (widget.xlogformat == 2)
            ? Container()
            : Material(
                color: stylebackgroundColor,
                child: AnimatedContainer(
                  constraints: const BoxConstraints(maxHeight: 22),
                  alignment: Alignment.center,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.fastOutSlowIn,
                  child: Row(
                    children: [
                      Expanded(
                        child: (widget.xlogformat == 0)
                            ? Row(
                                children: [
                                  SizedBox(
                                    height: media.width * xlogcheckboxwidth,
                                    width: media.width * xlogcheckboxwidth,
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: Image.asset(
                                        "assets/img/checkboxok.png",
                                        color: stylefontColor,
                                        fit: BoxFit.fitHeight,
                                      ),
                                      onPressed: () {
                                        widget.xlog.delete();
                                        widget.onDeleted();
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: media.width * xlogtilebodypartwidth,
                                    child: FittedBox(
                                      alignment: Alignment.centerRight,
                                      fit: BoxFit.contain,
                                      child: Text(
                                        " ${(widget.xlog.xbodypart == '하체') ? (LocaleData.legs.getString((context)).length > 2) ? LocaleData.legs.getString((context)).substring(0, 3) : LocaleData.legs.getString((context)) : (widget.xlog.xbodypart == '어깨') ? (LocaleData.shoulders.getString((context)).length > 2) ? LocaleData.shoulders.getString((context)).substring(0, 3) : LocaleData.shoulders.getString((context)) : (widget.xlog.xbodypart == '가슴') ? (LocaleData.chest.getString((context)).length > 2) ? LocaleData.chest.getString((context)).substring(0, 3) : LocaleData.chest.getString((context)) : (widget.xlog.xbodypart == '팔') ? (LocaleData.arms.getString((context)).length > 2) ? LocaleData.arms.getString((context)).substring(0, 3) : LocaleData.arms.getString((context)) : (widget.xlog.xbodypart == '등') ? (LocaleData.back.getString((context)).length > 2) ? LocaleData.back.getString((context)).substring(0, 3) : LocaleData.back.getString((context)) : (LocaleData.abs.getString((context)).length > 2) ? LocaleData.abs.getString((context)).substring(0, 3) : LocaleData.abs.getString((context))} |",
                                        style: TextStyle(color: stylefontColor, fontSize: 14, fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: media.width * xlogtilextypewidth - 10,
                                    child: FittedBox(
                                      alignment: Alignment.centerLeft,
                                      fit: BoxFit.contain,
                                      child: Text(
                                        " ${widget.xlog.xType.getString(context)}",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(color: stylefontColor, fontSize: 14, fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: media.width * xlogtileweightwidth * 0.7,
                                    child: FittedBox(
                                      alignment: Alignment.centerRight,
                                      fit: BoxFit.contain,
                                      child: Text(
                                        (widget.xlog.lxweight == 0) ? ' ' : (widget.xlog.lxweight * 0.5 * weightUnitConversion).toStringAsFixed(1), //소수2자리에서 반올림
                                        textAlign: TextAlign.end,
                                        style: TextStyle(color: stylefontColor, fontSize: 14, fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: media.width * xlogtileweightwidth * 0.3,
                                    child: FittedBox(
                                      alignment: Alignment.centerLeft,
                                      fit: BoxFit.contain,
                                      child: Text(
                                        (widget.xlog.lxweight == 0) ? ' ' : widget.selectedweightUnit,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(color: stylefontColor, fontSize: 14, fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: media.width * xlogtileweightnumber + 4,
                                    child: FittedBox(
                                      alignment: Alignment.centerRight,
                                      fit: BoxFit.contain,
                                      child: Text(
                                        " ${widget.xlog.lxnumber}${(LocaleData.reps.getString((context)).length < 4) ? LocaleData.reps.getString((context)) : LocaleData.reps.getString((context)).substring(0, 3)} ×",
                                        textAlign: TextAlign.end,
                                        style: TextStyle(color: stylefontColor, fontSize: 14, fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: media.width * xlogtileweightset,
                                    child: FittedBox(
                                      alignment: Alignment.centerRight,
                                      fit: BoxFit.contain,
                                      child: Text(
                                        "${widget.xlog.lxset}${(LocaleData.sets.getString((context)).length < 4) ? LocaleData.sets.getString((context)) : LocaleData.sets.getString((context)).substring(0, 3)}",
                                        textAlign: TextAlign.end,
                                        style: TextStyle(color: stylefontColor, fontSize: 14, fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : (widget.xlogformat == 1)
                                ? // 현재 0과 1만 있으므로 이번이 변수상 1 유저 화면에서는 0->1, 1->2
                                Row(
                                    children: [
                                      SizedBox(
                                        height: media.width * xlogcheckboxwidth,
                                        width: media.width * xlogcheckboxwidth,
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          icon: Image.asset(
                                            "assets/img/checkboxok.png",
                                            color: stylefontColor,
                                            fit: BoxFit.fitHeight,
                                          ),
                                          onPressed: () {
                                            widget.xlog.delete();
                                            widget.onDeleted();
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: media.width * (xlogtilextypewidth + xlogtilebodypartwidth) + 34,
                                        child: FittedBox(
                                          alignment: Alignment.centerLeft,
                                          fit: BoxFit.contain,
                                          child: Text(
                                            " ${widget.xlog.xType.getString(context)}",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(color: stylefontColor, fontSize: 14, fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: media.width * xlogtileweightwidth * 0.7,
                                        child: FittedBox(
                                          alignment: Alignment.centerRight,
                                          fit: BoxFit.contain,
                                          child: Text(
                                            (widget.xlog.lxweight == 0) ? ' ' : (widget.xlog.lxweight * 0.5 * weightUnitConversion).toStringAsFixed(1), //소수2자리에서 반올림
                                            textAlign: TextAlign.end,
                                            style: TextStyle(color: stylefontColor, fontSize: 14, fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: media.width * xlogtileweightwidth * 0.3,
                                        child: FittedBox(
                                          alignment: Alignment.centerLeft,
                                          fit: BoxFit.contain,
                                          child: Text(
                                            (widget.xlog.lxweight == 0) ? ' ' : widget.selectedweightUnit,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(color: stylefontColor, fontSize: 14, fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: media.width * xlogtileweightnumber - 14,
                                        child: FittedBox(
                                          alignment: Alignment.centerRight,
                                          fit: BoxFit.contain,
                                          child: Text(
                                            " ${widget.xlog.lxnumber} ×",
                                            textAlign: TextAlign.end,
                                            style: TextStyle(color: stylefontColor, fontSize: 14, fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: media.width * xlogtileweightset - 26,
                                        child: FittedBox(
                                          alignment: Alignment.centerRight,
                                          fit: BoxFit.contain,
                                          child: Text(
                                            "${widget.xlog.lxset}",
                                            textAlign: TextAlign.end,
                                            style: TextStyle(color: stylefontColor, fontSize: 14, fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                :
                                //(widget.xlogformat == 2)
                                Container(),
                      ),
                    ],
                  ),
                ),
              );
  }
}
