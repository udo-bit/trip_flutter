import 'package:flutter/material.dart';

SizedBox hiSpace({double height = 1, double width = 1}) {
  return SizedBox(height: height, width: width);
}

Widget shadowWrap({required Widget child, EdgeInsetsGeometry? padding}) {
  return Container(
    padding: padding,
    decoration: const BoxDecoration(
      gradient: LinearGradient(
          colors: [Color(0x66000000), Colors.transparent],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter),
    ),
    child: child,
  );
}
