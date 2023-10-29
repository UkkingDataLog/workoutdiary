import 'package:flutter/material.dart';
import 'package:workoutdiary/common/colo_extension.dart';
import 'package:workoutdiary/hivedata/xlog.dart';
import 'package:workoutdiary/ui/ui_group.dart';

class XlogCreateTile extends StatefulWidget {
  const XlogCreateTile({
    Key? key,
    required this.xlog,
    required this.onDeleted,
    required this.selectedweightUnit,
  }) : super(key: key);

  final Xlog xlog;
  final Function onDeleted;
  final String selectedweightUnit;

  @override
  State<XlogCreateTile> createState() => _XlogCreateTileState();
}

class _XlogCreateTileState extends State<XlogCreateTile> {
  @override
  Widget build(BuildContext context) {
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
        : Material(
            color: TColor.black.withOpacity(0.25),
            child: AnimatedContainer(
              constraints: const BoxConstraints(maxHeight: 22),
              alignment: Alignment.center,
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn,
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        SizedBox(
                          height: media.width * xlogcheckboxwidth * 0.5,
                          width: media.width * xlogcheckboxwidth,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Image.asset(
                              "assets/img/checkboxok.png",
                              color: TColor.white,
                              fit: BoxFit.contain,
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
                              "${widget.xlog.xbodypart} |",
                              style: TextStyle(color: TColor.white, fontSize: 14, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: media.width * xlogtilextypewidth,
                          child: FittedBox(
                            alignment: Alignment.centerLeft,
                            fit: BoxFit.contain,
                            child: Text(
                              " ${widget.xlog.xType}",
                              textAlign: TextAlign.start,
                              style: TextStyle(color: TColor.white, fontSize: 14, fontWeight: FontWeight.w700),
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
                              style: TextStyle(color: TColor.white, fontSize: 14, fontWeight: FontWeight.w700),
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
                              style: TextStyle(color: TColor.white, fontSize: 14, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: media.width * xlogtileweightnumber,
                          child: FittedBox(
                            alignment: Alignment.centerRight,
                            fit: BoxFit.contain,
                            child: Text(
                              " ${widget.xlog.lxnumber}회 ×",
                              textAlign: TextAlign.end,
                              style: TextStyle(color: TColor.white, fontSize: 14, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: media.width * xlogtileweightset,
                          child: FittedBox(
                            alignment: Alignment.centerRight,
                            fit: BoxFit.contain,
                            child: Text(
                              "${widget.xlog.lxset}세트",
                              textAlign: TextAlign.end,
                              style: TextStyle(color: TColor.white, fontSize: 14, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
