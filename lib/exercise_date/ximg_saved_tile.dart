import 'package:flutter/material.dart';

import 'package:workoutdiary/common/colo_extension.dart';
import 'package:workoutdiary/hivedata/xlog.dart';

import 'package:workoutdiary/ui/ui_group.dart';

class XimgSavedTile extends StatefulWidget {
  const XimgSavedTile({
    Key? key,
    required this.ximg,
    required this.onDeleted,
    this.height = 1,
  }) : super(key: key);

  final Ximg ximg;
  final Function onDeleted;
  final double height;

  @override
  State<XimgSavedTile> createState() => _XimgSavedTileState();
}

class _XimgSavedTileState extends State<XimgSavedTile> {
  // final Map<int, double> ratiosMultiply = {
  //   0: 1, //'1:1
  //   1: 1.25, //4:5
  //   2: 1.778, //9:16 반올림
  // };
  // //사진 크기 변경
  // int _ratio = 0;
  // final Map<int, String> ratios = {
  //   0: '1:1',
  //   1: '4:5',
  //   2: '9:16',
  // };
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Container(
          color: TColor.black,
          height: media.width * widget.height,
          width: media.width * 1.0,
          child: InteractiveViewer(
            constrained: false,
            child: Container(
              height: media.width * widget.height, //화면비에 맞게 조정!
              width: media.width * 1.00,
              decoration: BoxDecoration(
                color: TColor.black,
                image: DecorationImage(
                  image: MemoryImage(widget.ximg.image),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          // color: TColor.black.withOpacity(0.25),
          child: SizedBox(
            height: media.width * xlogcheckboxwidth * 0.5,
            width: media.width * xlogcheckboxwidth,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Image.asset(
                "assets/img/checkboxok.png",
                color: TColor.white,
                height: media.width * 1.00,
                width: media.width * 1.00,
                fit: BoxFit.contain,
              ),
              onPressed: () {
                widget.ximg.delete();
                widget.onDeleted();
              },
            ),
          ),
        ),
      ],
    );
  }
}
