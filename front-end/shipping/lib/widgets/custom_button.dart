import 'package:flutter/material.dart';
import '../constant/constants.dart';

class CustomButton extends StatelessWidget {
  final Color? backgroundColor, forgroundColor;
  final String title;
  final double width, height;
  final VoidCallback? onPressed;

  const CustomButton(
      {Key? key,
      this.width = 300,
      this.height = 60,
      this.backgroundColor = Colors.white,
      this.forgroundColor = secondColor,
      required this.title,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: forgroundColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: onPressed,
        child:
            Text(title, style: TextStyle(fontSize: 20, color: forgroundColor)),
      ),
    );
  }
}
