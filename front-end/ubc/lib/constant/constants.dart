import 'package:flutter/material.dart';
final  SECRET_KEY = "sk_test_51NcngkBfwNmt5PSiIVU37Wr2yPw0DRPEXJ9zRapq9hCDZOnOivIPh81KRqRiXG9q1v8gcAaXbvvG7iz1OFvNOnPP00R8OSgepk";
// String url = 'http://ubcfood.000webhostapp.com/api/';
String url = 'http://192.168.43.25:8080/api/';
// String url = 'http://192.168.43.10:8080/api/';
const Color secondColor = Color(0xFFED1A3B);
const Color thirdColor = Color.fromARGB(255, 244, 209, 215);
// const Color thirdColor = Color.fromARGB(255, 213, 222, 249);
const Color darkGrey = Color(0xFF000C35);
const Color circleColor = Colors.red;
const Color socialCardBgColor = Color(0xFFF5F6F9);
const Color inActiveIconColor = Color(0xFFB6B6B6);
const Color searchFieldTextColor = Color(0xff858585);
const primaryGradientColor = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color.fromARGB(255, 76, 118, 238),
    Color.fromARGB(255, 76, 118, 244)
  ],
);
const circleGradientColor = LinearGradient(
  begin: Alignment.center,
  end: Alignment.bottomCenter,
  colors: [ Colors.red, Colors.white, Colors.white],
);
const Color textColor = Color(0xFF757575);

const primaryShadow = BoxShadow(
  color: Color(0x19393939),
  blurRadius: 60,
  offset: Offset(0, 30),
);

const drawerShadow = BoxShadow(
  color: thirdColor,
  offset: Offset(-28, 35),
  spreadRadius: 5,
  blurRadius: 7,
);