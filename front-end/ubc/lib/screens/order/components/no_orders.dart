import 'package:flutter/material.dart';
import '../../../constant/constants.dart';

class NoOrder extends StatelessWidget {
  const NoOrder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    return SingleChildScrollView(
      child: SizedBox(
        height: height,
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () {},
              child: const Image(
                  image: AssetImage("assets/images/default_img.png"),
                  width: 300.0,
                  height: 300.0),
            ),
            Text(
              "You don't have orders yet!.",
              textAlign: TextAlign.center,
              style: TextStyle(
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(10.0, 10.0),
                    blurRadius: 3.0,
                    color: Colors.black12,
                  ),
                ],
                color: Colors.black,
                fontSize: width * 0.06,
                fontFamily: "Raleway",
                fontWeight: FontWeight.w100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/**Column(
      children: [
        SizedBox(
          height: height * 0.05,
        ),
        SizedBox(
          child: Image.asset(
            "assets/images/no_order.png",
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          "No history yet",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontFamily: "Raleway",
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Opacity(
          opacity: 0.57,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 80),
            child: Text(
              "Hit the button down below to Create an order",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: SizedBox(
                width: width * 0.8,
                height: height * 0.1,
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    foregroundColor: Colors.white,
                    backgroundColor: secondColor,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      "/home",
                    );
                  },
                  child: Text(
                    "Start ordering",
                    style: TextStyle(
                      fontSize: 0.042 * width,
                      color: Colors.white,
                    ),
                  ),
                )))
      ],
    );
  */