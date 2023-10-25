import 'package:flutter/material.dart';
import 'package:workoutdiary/common/colo_extension.dart';
import 'package:workoutdiary/hivedata/xlog.dart';
import 'package:workoutdiary/ui/ui_group.dart';

class XlogDateTile extends StatefulWidget {
  const XlogDateTile({
    Key? key,
    required this.xlog,
    required this.onDeleted,
  }) : super(key: key);

  final Xlog xlog;
  final Function onDeleted;

  @override
  State<XlogDateTile> createState() => _XlogDateTileState();
}

class _XlogDateTileState extends State<XlogDateTile> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Material(
      color: TColor.black,
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
                        style: TextStyle(
                            color: TColor.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
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
                        style: TextStyle(
                            color: TColor.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: media.width * xlogtileweightwidth * 0.7,
                    child: FittedBox(
                      alignment: Alignment.centerRight,
                      fit: BoxFit.contain,
                      child: Text(
                        "${widget.xlog.lxweight * 0.5}",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            color: TColor.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: media.width * xlogtileweightwidth * 0.3,
                    child: FittedBox(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.contain,
                      child: Text(
                        widget.xlog.lxweightUnit,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: TColor.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
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
                        style: TextStyle(
                            color: TColor.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
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
                        style: TextStyle(
                            color: TColor.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
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
