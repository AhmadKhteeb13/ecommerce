import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSuffixIcon extends StatelessWidget {
  final String svgIconPath;
  const CustomSuffixIcon({Key? key, required this.svgIconPath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.fromLTRB(
          0.053 * width,
          0.053 * width,
          0,
          0.053 * width),
      child: SvgPicture.asset(
        svgIconPath,
        height: 0.048 * width,
      ),
    );
  }
}
