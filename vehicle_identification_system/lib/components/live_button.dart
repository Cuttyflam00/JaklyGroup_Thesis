import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget liveButton() {
  return Container(
    padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      color: Colors.red,
    ),
    child: Row(
      children: const [
        FaIcon(
          FontAwesomeIcons.circleDot,
          size: 18,
          color: Colors.white,
        ),
        SizedBox(width: 5),
        Text(
          "LIVE",
          style: TextStyle(color: Colors.white),
        ),
      ],
    ),
  );
}
