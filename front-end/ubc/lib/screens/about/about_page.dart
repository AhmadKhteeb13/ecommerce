import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../constant/constants.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/no_internet_connection.dart';
import '../sign_in/login_screen.dart';

class AboutPage extends StatefulWidget {
  static const String routeName = "/about";
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  late double xOffset, yOffset, scaleFactor;
  late bool isDrawerOpen;
  @override
  void initState() {
    super.initState();
    checkConnectivity();
    xOffset = yOffset = 0.0;
    scaleFactor = 1.0;
    isDrawerOpen = false;
  }

  var subscription;
  bool isDeviceConnected = true;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: (isDeviceConnected)
            ? Stack(
                children: [
                  const CustomDrawer(),
                  AnimatedContainer(
                      transform:
                          Matrix4.translationValues(xOffset, yOffset, 0.0)
                            ..scale(scaleFactor),
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                          borderRadius: (isDrawerOpen)
                              ? BorderRadius.circular(40)
                              : BorderRadius.circular(0),
                          color: Colors.white,
                          boxShadow: [if (isDrawerOpen) drawerShadow]),
                      child: Scaffold(
                          appBar: PreferredSize(
                            preferredSize: Size(width, width * 0.2),
                            child: Row(
                              children: [
                                Container(
                                  width: width * 0.25,
                                  height: width * 0.25,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        secondColor,
                                        secondColor
                                      ],
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 0, top: width * 0.036),
                                    child: isDrawerOpen
                                        ? IconButton(
                                            icon: const Icon(
                                                Icons.arrow_back_ios),
                                            onPressed: () {
                                              setState(() {
                                                xOffset = 0.0;
                                                yOffset = 0.0;
                                                scaleFactor = 1;
                                                isDrawerOpen = false;
                                              });
                                            },
                                          )
                                        : IconButton(
                                            icon: SvgPicture.asset(
                                                "assets/icons/hamburger.svg"),
                                            onPressed: () {
                                              setState(() {
                                                xOffset = width * 0.55;
                                                yOffset = height * 0.2;
                                                scaleFactor = 0.6;
                                                isDrawerOpen = true;
                                              });
                                            },
                                          ),
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.75,
                                  height: width * 0.25,
                                  child: Row(
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(
                                              top: 0, left: width * 0.1),
                                          child: SizedBox(
                                            // color: Colors.pink,
                                            width: width * 0.26,
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                    child: SizedBox(
                                                  // color: Colors.pink,
                                                  height: width * 0.1,
                                                  width: width * 0.4,
                                                  child: Text(
                                                    "ABOUT",
                                                    style: TextStyle(
                                                      fontSize: width * 0.06,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: darkGrey,
                                                    ),
                                                  ),
                                                )),
                                                Positioned(
                                                  bottom: 0,
                                                  left: 0,
                                                  right: 0,
                                                  child: Container(
                                                    height: 20,
                                                    color: secondColor
                                                        .withOpacity(0.2),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          body: Stack(
                            children: [
                              Container(
                                height: height,
                                width: width / 4,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(255, 255, 255, 255),
                                      secondColor
                                    ],
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width * 0.05),
                                child: Container(
                                  width: width * 0.9,
                                  height: height * 0.7,
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      color: thirdColor),
                                  padding: EdgeInsets.only(
                                      left: width * 0.0576,
                                      top: 0,
                                      right: width * 0.0576),
                                  child: ListView(
                                    physics: const BouncingScrollPhysics(),
                                    children: [
                                      SizedBox(
                                        height: width * 0.06,
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/icons/general.png',
                                            color: secondColor,
                                            width: width * 0.07,
                                            height: width * 0.07,
                                          ),
                                          SizedBox(
                                            width: width * 0.028,
                                          ),
                                          Text(
                                            "General",
                                            style: TextStyle(
                                                fontSize: width * 0.05,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        height: width * 0.054,
                                        thickness: 2,
                                      ),
                                      SizedBox(
                                        height: width * 0.036,
                                      ),
                                      Container(
                                          height: height * 0.3,
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: ListView(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                children: [
                                                  Text(
                                                    "koooo",
                                                    style: TextStyle(
                                                        color: darkGrey
                                                            .withOpacity(0.8),
                                                        fontSize: width * 0.05),
                                                  )
                                                ]),
                                          )),
                                      SizedBox(
                                        height: width * 0.08,
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.security,
                                            color: secondColor,
                                          ),
                                          SizedBox(
                                            width: width * 0.028,
                                          ),
                                          Text(
                                            "Privacy and security",
                                            style: TextStyle(
                                                color: darkGrey,
                                                fontSize: width * 0.05,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        height: width * 0.054,
                                        thickness: 2,
                                      ),
                                      SizedBox(
                                        height: width * 0.036,
                                      ),
                                      Container(
                                          height: height * 0.3,
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: ListView(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                children: [Text(
                                                  "koooo",
                                                  style: TextStyle(
                                                      color: darkGrey,
                                                      fontSize: width * 0.05),
                                                )]),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: width * 0.3,
                                top: width * 1.4,
                                child: Container(
                                  width: width * 0.4,
                                  height: width * 0.15,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: secondColor,
                                      width: 2.0,
                                    ),
                                  ),
                                  child: FloatingActionButton(
                                    elevation: 0,
                                    heroTag: null,
                                    backgroundColor:
                                        Colors.white.withOpacity(0),
                                    onPressed: () {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  const LoginScreen()));
                                    },
                                    child: Text("SIGN OUT",
                                        style: TextStyle(
                                            fontSize: width * 0.05,
                                            letterSpacing: 2.2,
                                            color: darkGrey)),
                                  ),
                                ),
                              ),
                            ],
                          )))
                ],
              )
            : const NoInternet(),
      ),
    );
  }

  Future<void> checkConnectivity() async {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;
      setState(() {
        isDeviceConnected = isDeviceConnected;
      });
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}
