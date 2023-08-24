import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:ubc/constant/constants.dart';
import 'constant/routes.dart';
import 'screens/splash/splash_screen.dart';

void main() {
  Stripe.publishableKey = "pk_test_51NcngkBfwNmt5PSi6yLG99j5X2yUj48qVEIEMrRdIXuxd52amLyB2KNJVCEQnHWKdZDC7PEbR8xg7KN1aHsyXcta00tcKqGk9K";
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // color: secondColor,
        debugShowCheckedModeBanner: false,
        title: 'Your Store',
        theme: ThemeData(
          fontFamily: 'Raleway',
          primarySwatch: Colors.grey
        ),
        initialRoute: SplashScreen.routeName,
        routes: routes);
  }
}
