import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomPrefixIcon extends StatelessWidget {
  final String svgIconPath;
  const CustomPrefixIcon({Key? key, required this.svgIconPath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.fromLTRB(
          0, 0, 0.053 * width,0.053 * width),
      child: SvgPicture.asset(
        svgIconPath,
        height: 0.021 * width,
      ),
    );
  }
}
