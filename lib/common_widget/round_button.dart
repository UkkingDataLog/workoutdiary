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
    return Container(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: type == RoundButtonType.bgSGradient ? TColor.secondaryG : TColor.primaryG,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow:
              type == RoundButtonType.bgGradient || type == RoundButtonType.bgSGradient ? const [BoxShadow(color: Colors.black26, blurRadius: 0.5, offset: Offset(0, 0.5))] : null),
      child: MaterialButton(
        onPressed: onPressed,
        height: 50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        textColor: TColor.primaryColor1,
        minWidth: double.maxFinite,
        elevation: type == RoundButtonType.bgGradient || type == RoundButtonType.bgSGradient ? 0 : 0.5,
        color: type == RoundButtonType.bgGradient || type == RoundButtonType.bgSGradient ? Colors.transparent : TColor.white, //텍스트버튼 수정 필요
        child: type == RoundButtonType.bgGradient || type == RoundButtonType.bgSGradient
            ? FittedBox(
                fit: BoxFit.fitHeight,
                child: Text(title, style: TextStyle(color: TColor.white, fontSize: fontSize, fontWeight: fontWeight)),
              )
            : FittedBox(
                fit: BoxFit.fitHeight,
                child: Text(
                  title,
                  style: TextStyle(
                    color: TColor.black,
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                  ),
                ),
              ),
      ),
    );
  }
}
