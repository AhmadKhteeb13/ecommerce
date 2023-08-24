import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../constant/constants.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_page_transition.dart';
import '../../home/home_screen.dart';
import '../../sign_in/login_screen.dart';

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
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 255, 255, 249),
              Color.fromARGB(255, 255, 255, 255)
            ],
          )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Flexible(
                flex: 2,
                child: Text("Welcom To UBC",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: Colors.pink,
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
                  if (emailcont != null || passco != null) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                  } else {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  }
                },
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
