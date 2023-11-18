import 'package:flutter/material.dart';

enum RoundButtonType { selected, unselected, textGradient }

class RoundButton extends StatelessWidget {
  final String title;
  final RoundButtonType type;
  final VoidCallback onPressed;
  final double elevation;
  final FontWeight fontWeight;

  const RoundButton({
    super.key,
    required this.title,
    this.type = RoundButtonType.selected,
    this.elevation = 1,
    this.fontWeight = FontWeight.w700,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 1,
        backgroundColor: type == RoundButtonType.selected || type == RoundButtonType.unselected ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: type == RoundButtonType.selected || type == RoundButtonType.unselected
          ? FittedBox(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.surface,
                  fontWeight: fontWeight,
                ),
              ),
            )
          : FittedBox(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: fontWeight,
                ),
              ),
            ),
    );
  }
}
