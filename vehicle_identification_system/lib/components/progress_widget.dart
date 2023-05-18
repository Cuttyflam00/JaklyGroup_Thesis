import 'package:flutter/material.dart';

circularprogress({Color color = Colors.white}) {
  return SizedBox(
    height: 30.0,
    width: 30.0,
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(color),
    ),
  );
}

linearprogress() {
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.only(top: 12.0),
    child: const LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.lightBlueAccent),
    ),
  );
}
