import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:workoutdiary/common/colo_extension.dart';
import 'package:workoutdiary/hivedata/xlog.dart';
import 'package:workoutdiary/localization/locales.dart';
import 'package:workoutdiary/ui/ui_group.dart';

class todayXlogTile extends StatefulWidget {
  const todayXlogTile({
    Key? key,
    required this.xlog,
    required this.onDeleted,
    required this.onFinished,
    required this.selectedweightUnit,
  }) : super(key: key);

  final Xlog xlog;
  final Function onDeleted;
  final Function onFinished;
  final String selectedweightUnit;

  @override
  State<todayXlogTile> createState() => _todayXlogTileState();
}

class _todayXlogTileState extends State<todayXlogTile> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    Color finishedColor = Theme.of(context).colorScheme.primaryContainer;
    Color unfinishedColor = Colors.white;

    Color finishedTextColor = Theme.of(context).colorScheme.onPrimaryContainer;
    Color unfinishedTextColor = Colors.black;
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
    return AnimatedContainer(
      height: media.height * 0.70 / 15.2,
      // constraints: const BoxConstraints(minHeight: 48),
      alignment: Alignment.center,

      decoration: BoxDecoration(
        color: (widget.xlog.finished == true) ? finishedColor : unfinishedColor,
        border: Border.all(
          color: (widget.xlog.finished == true) ? Theme.of(context).colorScheme.primary : TColor.primarygray.withOpacity(0.3),
          width: (widget.xlog.finished == true) ? 2.0 : 1.0,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
      child: Row(
        children: [
          Expanded(
            child: FittedBox(
              child: Row(
                children: [
                  const SizedBox(width: 4),
                  SizedBox(
                    height: media.width * xlogcheckboxwidth * 1.4,
                    width: media.width * xlogcheckboxwidth * 1.4,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: (widget.xlog.finished == true)
                          ? Icon(Icons.check_box, color: finishedTextColor)
                          // Image.asset(
                          //     "assets/img/checkboxok.png",
                          //     // color: TColor.white,
                          //     fit: BoxFit.contain,
                          //   )
                          : Icon(Icons.check_box_outline_blank_outlined, color: unfinishedTextColor),
                      //  Image.asset(
                      //     "assets/img/checkbox_empty.png",
                      //     // color: TColor.white,
                      //     fit: BoxFit.contain,
                      //   ),
                      onPressed: () {
                        // setState(() {
                        //   if (widget.xlog.finished == true) {
                        //     widget.xlog.finished = false;
                        //     widget.xlog.save();
                        //     widget.onFinished();
                        //   } else {
                        //     widget.xlog.finished = true;
                        //     widget.xlog.save();
                        //     widget.onFinished();
                        //   }
                        // });

                        widget.onFinished();
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: media.width * xlogtilebodypartwidth * 0.6,
                    child: FittedBox(
                      alignment: Alignment.centerRight,
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "${(widget.xlog.xbodypart == '하체') ? (LocaleData.legs.getString((context)).length > 2) ? LocaleData.legs.getString((context)).substring(0, 3) : LocaleData.legs.getString((context)) : (widget.xlog.xbodypart == '어깨') ? (LocaleData.shoulders.getString((context)).length > 2) ? LocaleData.shoulders.getString((context)).substring(0, 3) : LocaleData.shoulders.getString((context)) : (widget.xlog.xbodypart == '가슴') ? (LocaleData.chest.getString((context)).length > 2) ? LocaleData.chest.getString((context)).substring(0, 3) : LocaleData.chest.getString((context)) : (widget.xlog.xbodypart == '팔') ? (LocaleData.arms.getString((context)).length > 2) ? LocaleData.arms.getString((context)).substring(0, 3) : LocaleData.arms.getString((context)) : (widget.xlog.xbodypart == '등') ? (LocaleData.back.getString((context)).length > 2) ? LocaleData.back.getString((context)).substring(0, 3) : LocaleData.back.getString((context)) : (LocaleData.abs.getString((context)).length > 2) ? LocaleData.abs.getString((context)).substring(0, 3) : LocaleData.abs.getString((context))}",
                        style: TextStyle(
                          color: (widget.xlog.finished == true) ? finishedTextColor : unfinishedTextColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: media.width * xlogtilextypewidth * 0.97 - 10,
                    child: FittedBox(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.scaleDown,
                      child: Text(
                        " ${widget.xlog.xType.getString(context)}",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: (widget.xlog.finished == true) ? finishedTextColor : unfinishedTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          decoration: widget.xlog.finished ? TextDecoration.lineThrough : TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: media.width * xlogtileweightwidth * 0.6,
                    child: FittedBox(
                      alignment: Alignment.centerRight,
                      fit: BoxFit.scaleDown,
                      child: Text(
                        (widget.xlog.lxweight == 0) ? ' ' : (widget.xlog.lxweight * 0.5 * weightUnitConversion).toStringAsFixed(1), //소수2자리에서 반올림
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: (widget.xlog.finished == true) ? finishedTextColor : unfinishedTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: media.width * xlogtileweightwidth * 0.25,
                    child: FittedBox(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.scaleDown,
                      child: Text(
                        (widget.xlog.lxweight == 0) ? ' ' : widget.selectedweightUnit,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: (widget.xlog.finished == true) ? finishedTextColor : unfinishedTextColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: media.width * xlogtileweightnumber * 0.4,
                    child: FittedBox(
                      alignment: Alignment.centerRight,
                      fit: BoxFit.scaleDown,
                      child: Text(
                        " ${widget.xlog.lxnumber}",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: (widget.xlog.finished == true) ? finishedTextColor : unfinishedTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: media.width * xlogtileweightnumber * 0.36 + 10,
                    child: FittedBox(
                      alignment: Alignment.centerRight,
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "${(LocaleData.reps.getString((context)).length < 4) ? LocaleData.reps.getString((context)) : LocaleData.reps.getString((context)).substring(0, 3)} ×",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: (widget.xlog.finished == true) ? finishedTextColor : unfinishedTextColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: media.width * xlogtileweightset * 0.4,
                    child: FittedBox(
                      alignment: Alignment.centerRight,
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "${widget.xlog.lxset}",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: (widget.xlog.finished == true) ? finishedTextColor : unfinishedTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: media.width * xlogtileweightset * 0.4,
                    child: FittedBox(
                      alignment: Alignment.centerRight,
                      fit: BoxFit.scaleDown,
                      child: Text(
                        (LocaleData.sets.getString((context)).length < 4) ? LocaleData.sets.getString((context)) : LocaleData.sets.getString((context)).substring(0, 3),
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: (widget.xlog.finished == true) ? finishedTextColor : unfinishedTextColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.delete),
              color: (widget.xlog.finished == true) ? finishedTextColor : unfinishedTextColor,
              onPressed: () {
                widget.xlog.delete();
                widget.onDeleted();
              },
              // fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
