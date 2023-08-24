import 'package:flutter/material.dart';
import '../constant/constants.dart';

class DefaultButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? forgroundColor;
  final double width, height;
  const DefaultButton(
      {Key? key,
      this.text,
      this.onPressed,
      this.backgroundColor = Colors.white,
      this.forgroundColor = secondColor,
      this.width = 300,
      this.height = 60})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: (width / 375) * width,
        height: (height / 812) * height,
        child: TextButton(
          style: TextButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            foregroundColor: Colors.white,
            backgroundColor: backgroundColor,
          ),
          onPressed: onPressed,
          child: Text(
            text!,
            style: TextStyle(
              fontSize: 0.042 * width,
              color: forgroundColor,
            ),
          ),
        ));
  }
}
