import 'package:flutter/material.dart';

import '../constant/constants.dart';
class CardForCarousel extends StatelessWidget {
  const CardForCarousel({super.key, required this.image, required this.width});
  final String image;
  final double width;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width / (1.2),
      decoration: BoxDecoration(
        boxShadow: [
                    BoxShadow(
                      color: thirdColor,
                      spreadRadius: 1,
                      blurRadius: 8
                    )
                  ],
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          image: DecorationImage(image: AssetImage("assets/images/$image"), fit: BoxFit.fill)),
    );
  }
}