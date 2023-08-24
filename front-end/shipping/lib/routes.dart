import 'package:flutter/material.dart';
import '/screen/about/about_page.dart';
import '/screen/home/home_screen.dart';
import '/screen/login_screen.dart';
import '/screen/splash/splash_screen.dart';

var categoryname, jdon_path;
final Map<String, WidgetBuilder> routes = {
  HomeScreen.routeName: (context) => const HomeScreen(),
  LoginScreen.routeName: (context) => LoginScreen(),
  SplashScreen.routeName: (context) => const SplashScreen(),
  AboutPage.routeName: (context) => AboutPage(),
};
