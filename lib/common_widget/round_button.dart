import 'package:flutter/material.dart';

import '../common/colo_extension.dart';

enum RoundButtonType { bgGradient, bgSGradient, textGradient }

class RoundButton extends StatelessWidget {
  final String title;
  final RoundButtonType type;
  final VoidCallback onPressed;
  final double fontSize;
  final double elevation;
  final FontWeight fontWeight;

  const RoundButton(
      {super.key, required this.title, this.type = RoundButtonType.bgGradient, this.fontSize = 16, this.elevation = 1, this.fontWeight = FontWeight.w700, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 1,
        backgroundColor: type == RoundButtonType.bgGradient || type == RoundButtonType.bgSGradient ? TColor.black : TColor.white, //텍스트버튼 수정 필요
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: type == RoundButtonType.bgGradient || type == RoundButtonType.bgSGradient
          ? Text(title, style: TextStyle(color: TColor.white, fontSize: fontSize, fontWeight: fontWeight))
          : Text(
              title,
              style: TextStyle(
                color: TColor.black,
                fontSize: fontSize,
                fontWeight: fontWeight,
              ),
            ),
    );
  }
}
