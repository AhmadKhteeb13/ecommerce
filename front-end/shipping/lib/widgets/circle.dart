import 'package:flutter/material.dart';

class Circle extends StatelessWidget {
  final double width;
  final double height;
  final double borderWidth;
  final Color color;
  final Color borderColor;
  const Circle(
      {Key? key,
      required this.width,
      required this.height,
      this.borderWidth = 0,
      this.color = Colors.transparent,
      this.borderColor = const Color.fromARGB(255, 101, 139, 253)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (width / 375) * width,
      height: (height / 812) * height,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: borderColor,
            width: borderWidth,
          ),
          color: color),
    );
  }
}
