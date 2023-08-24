import 'package:flutter/material.dart';
import 'package:picker/screen/about/about_page.dart';
import 'package:picker/screen/home/home_screen.dart';
import 'package:picker/screen/login_screen.dart';
import 'package:picker/screen/splash/splash_screen.dart';
var categoryname,jdon_path;
final Map<String, WidgetBuilder> routes = {
  HomeScreen.routeName: (context) => const HomeScreen(),
  LoginScreen.routeName:(context) => LoginScreen(),
  SplashScreen.routeName: (context) => const SplashScreen(),
  AboutPage.routeName:(context) => AboutPage(),

};
