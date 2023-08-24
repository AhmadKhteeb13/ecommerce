import 'package:flutter/cupertino.dart';
import '../screen/about/about_page.dart';
import '../screen/home/home_screen.dart';
import '../screen/login_screen.dart';
import '../screen/splash/splash_screen.dart';
var categoryname,categoryid;
final Map<String, WidgetBuilder> routes = {
  HomeScreen.routeName: (context) => const HomeScreen(),
  SplashScreen.routeName: (context) => const SplashScreen(),
  LoginScreen.routeName: (context) => const LoginScreen(),
  AboutPage.routeName:(context) => AboutPage()
};
