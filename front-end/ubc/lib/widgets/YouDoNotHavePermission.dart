import 'package:flutter/material.dart';

class YouDoNotHavePermission extends StatelessWidget {
  const YouDoNotHavePermission({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      // color: Colors.amber,
      height: height * 0.73,
      width: width,
      child: Column
      (
        children: [
          Container(
            height: height * 0.4,
            
              child: Image.asset(
                "assets/images/NoPermission.png",
                scale: 0.5,
                // fit: BoxFit.contain,
              ),
            ),
            const Text(
              "You do not have permission to enter this page",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10,),
            const Opacity(
              opacity: 0.57,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 60),
                child: Text(
                  "Please check your login or see the application administrators.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}


/**Container(
            child: Image.asset(
              "assets/images/NoPermission.png",
              fit: BoxFit.contain,
            ),
          ),
          const Text(
            "You do not have permission to enter this page",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10,),
          const Opacity(
            opacity: 0.57,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 60),
              child: Text(
                "Please check your login or see the application administrators.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
          ),
 */