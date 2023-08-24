import 'package:flutter/material.dart';
import '../constant/constants.dart';// import 'categories.dart';

class TitleWithBtn extends StatelessWidget {
  TitleWithBtn(
      {super.key,
      required this.title,
      required this.press,
      required this.titleofbutton});
  final String title, titleofbutton;
  String press;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: height / 33),
      child: Row(
        children: <Widget>[
          Container(
              height: height / 22,
              child: Stack(
                children: [
                  Positioned(
                    child: Text(
                      title,
                      style: TextStyle(
                          fontSize: height / 30,
                          fontWeight: FontWeight.w100,
                          color: darkGrey),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 20,
                      color: secondColor.withOpacity(0.2),
                    ),
                  )
                ],
              )),
          const Spacer(),
          Container(
              width: width / 4,
              height: width / 10,
              decoration: BoxDecoration(
                  color: secondColor.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20)),
              child: InkWell(
                child: Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                      border: Border.all(color: secondColor),
                      color: secondColor,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: Text(
                      titleofbutton,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                onTap: () {
              Navigator.pushNamed(
                context,
                press,
              );
                },
              ),
            ),
        ],
      ),
    );
  }
}
