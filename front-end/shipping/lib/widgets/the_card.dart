import 'package:flutter/material.dart';
import '../constant/constants.dart';

class TheCard extends StatelessWidget {
  TheCard({super.key, required this.image, required this.title, required this.width, required this.height});
  final String image, title;
  double width, height;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 5,
          child: Container(
            width: width * 0.45,
            height: width * 0.55,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(color: thirdColor, spreadRadius: 1, blurRadius: 8)
                ],
                border: Border.all(color: Colors.white),
                color: thirdColor,
                borderRadius: BorderRadius.circular(15)),
            child: Align(
                alignment: Alignment(0, 0.8),
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Text(
                    title,
                  ),
                )),
          ),
        ),
        Positioned(
            top: 0,
            left: 8,
            child: Image(image: AssetImage("assets/images/$image.png"), width: width * 0.40, height: width * 0.40,)
            // Container(
            //   width: width * 0.39,
            //   height: width * 0.36,
            //   decoration: BoxDecoration(
            //       boxShadow: [
            //         BoxShadow(color: thirdColor, spreadRadius: 1, blurRadius: 8)
            //       ],
            //       border: Border.all(color: thirdColor),
            //       gradient: const LinearGradient(
            //         colors: [Color.fromARGB(255, 255, 255, 255), secondColor],
            //         begin: Alignment.topLeft,
            //         end: Alignment.bottomRight,
            //       ),
            //       image: DecorationImage(image: AssetImage(image)),
            //       borderRadius: BorderRadius.circular(20)),
            // )
            ),
      ],
    );
  }
}
