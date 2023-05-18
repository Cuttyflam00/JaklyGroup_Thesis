import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final double elevation;
  final Color bgColor;
  final double borderRadius;
  final Widget icon;
  final Color fontColor;
  final String text;
  const CustomIconButton({
    super.key,
    this.elevation = 10,
    required this.bgColor,
    required this.icon,
    required this.text,
    this.borderRadius = 15,
    this.fontColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          borderRadius: BorderRadius.circular(borderRadius),
          elevation: elevation,
          child: Container(
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              padding: const EdgeInsets.all(20),
              child: icon),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          text,
          style: TextStyle(color: fontColor, fontSize: 16),
        )
      ],
    );
  }
}
