import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../constant/constants.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_page_transition.dart';
import '../../home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../login_screen.dart';

class SplashScreenBody extends StatefulWidget {
  const SplashScreenBody({Key? key}) : super(key: key);

  @override
  State<SplashScreenBody> createState() => _SplashScreenBodyState();
}

class _SplashScreenBodyState extends State<SplashScreenBody>
    with TickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(duration: const Duration(seconds: 2), vsync: this)
        ..repeat(reverse: true);
  late final Animation<double> _animation =
      CurvedAnimation(parent: _controller, curve: Curves.ease);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(gradient: primaryGradientColor),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Flexible(
                flex: 2,
                child: Text("Welcom To UBC",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: secondColor,
                    )),
              ),
              Flexible(
                flex: 5,
                child: FadeTransition(
                  opacity: _animation,
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height *
                            0.5, // 50 percent of screen's height
                        child: Image.asset("assets/images/splash.png"),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        decoration: const BoxDecoration(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
              CustomButton(
                backgroundColor: secondColor,
                forgroundColor: Colors.white,
                onPressed: () async {
                  final storage = FlutterSecureStorage();
                  var email = storage.read(key: 'email');
                  String? emailcont, passco;
                  final password = storage.read(key: 'password');
                  email.then((String? result) {
                    setState(() {
                      emailcont = result;
                    });
                  });
                  password.then((String? result) {
                    setState(() {
                      passco = result;
                    });
                  });
                  // print("1111111111111111111111${emailcont} 333333333333333333333333 ${passco}");
                  if (emailcont != null || passco != null) {
                    Navigator.push(
                        context,
                        CustomScaleTransition(
                            nextPageUrl: HomeScreen.routeName,
                            nextPage: const HomeScreen()));
                  } else {
                    Navigator.push(
                        context,
                        CustomScaleTransition(
                            nextPageUrl: LoginScreen.routeName,
                            nextPage: LoginScreen()));
                  }
                },
                // (
                //     context,
                //     CustomScaleTransition(
                //         nextPageUrl: .routeName,
                //         nextPage: const ())),
                title: "Get Started",
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }

  // override dispose method to release the memory of controller object after leaving the screen
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
