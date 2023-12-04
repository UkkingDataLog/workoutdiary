import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import 'package:lindi_sticker_widget/lindi_controller.dart';
import 'package:lindi_sticker_widget/lindi_sticker_widget.dart';
import 'package:provider/provider.dart';
import 'package:text_editor/text_editor.dart';
import 'package:workoutdiary/common/fonts.dart';
import 'package:workoutdiary/common/hive_helper.dart';
import 'package:workoutdiary/hivedata/xlog.dart';
import 'package:workoutdiary/localization/locales.dart';

import 'package:workoutdiary/providers/app_image_provider.dart';

class TextAddView extends StatefulWidget {
  TextAddView({
    Key? key,
    required this.image,
    required this.onSave,
    required this.tempximgindex,
    required this.tempximg,
  }) : super(key: key);
  Uint8List image;
  Function onSave;
  int tempximgindex;
  Ximg tempximg;

  @override
  State<TextAddView> createState() => _TextAddViewState();
}

class _TextAddViewState extends State<TextAddView> {
  late AppImageProvider imageProvider;
  LindiController controller = LindiController(
    borderColor: Colors.white,
    iconColor: Colors.black,
    showDone: true,
    showClose: true,
    showFlip: true,
    showStack: true,
    showLock: true,
    showAllBorders: true,
    shouldScale: true,
    shouldRotate: true,
    shouldMove: true,
    minScale: 0.5,
    maxScale: 4,
  );

  bool showEditor = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: CloseButton(
              color: (showEditor == true) ? Colors.black : Colors.white,
            ),
            title: Text(
              LocaleData.text.getString((context)),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: (showEditor == true) ? Colors.black : Colors.white,
              ),
            ),
            actions: [
              (showEditor == true)
                  ? Container()
                  : IconButton.outlined(
                      onPressed: () async {
                        Uint8List? changeimage = await controller.saveAsUint8List();
                        widget.tempximg.image = changeimage!;
                        HiveHelper().updateXimg(widget.tempximgindex, widget.tempximg);
                        if (!mounted) return;
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.done,
                        color: Colors.white,
                      ),
                    )
            ],
          ),
          body: Container(
            color: Colors.black,
            child: Center(
              child: Consumer<AppImageProvider>(builder: (BuildContext context, value, Widget? child) {
                return LindiStickerWidget(
                  controller: controller,
                  child: Image.memory(widget.image),
                );
              }),
            ),
          ),
          bottomNavigationBar: Container(
            width: double.infinity,
            height: 80,
            color: Colors.black,
            child: Center(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    showEditor = true;
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    Text(
                      LocaleData.add_Text.getString((context)),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (showEditor)
          Scaffold(
            backgroundColor: Colors.black.withOpacity(0.75),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextEditor(
                  fonts: Fonts().list(),
                  textStyle: const TextStyle(color: Colors.white, fontSize: 22),
                  minFontSize: 10,
                  maxFontSize: 86,
                  decoration: EditorDecoration(
                    doneButton: Text(
                      LocaleData.done.getString((context)),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                  onEditCompleted: (style, align, text) {
                    setState(() {
                      showEditor = false;
                      if (text.isNotEmpty) {
                        controller.addWidget(
                          Text(
                            text,
                            textAlign: align,
                            style: style,
                          ),
                        );
                      }
                    });
                  },
                ),
              ),
            ),
          )
      ],
    );
  }
}
