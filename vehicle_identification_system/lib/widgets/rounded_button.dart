import 'package:flutter/material.dart';

import '../constants/colors.dart';

class RoundedButton extends StatelessWidget {
  final Function press;
  final Widget child;
  final Color color;
  const RoundedButton({
    Key? key,
    required this.child,
    required this.press,
    this.color = primaryBlue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.6,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: TextButton(
          style: ButtonStyle(
            padding: const MaterialStatePropertyAll(
                EdgeInsets.symmetric(vertical: 15, horizontal: 30)),
            backgroundColor: MaterialStatePropertyAll(color),
          ),
          onPressed: (() => press),
          child: child,
        ),
      ),
    );
  }
}
