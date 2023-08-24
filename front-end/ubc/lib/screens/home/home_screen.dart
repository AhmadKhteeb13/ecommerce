import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/no_internet_connection.dart';
import 'home_content.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static String routeName = "/home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StreamSubscription subscription;
  late bool isDeviceConnected = true;
  
  @override
  void initState() {
    super.initState();
    checkConnectivity();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: (isDeviceConnected)
              ? const Stack(children: [
                  CustomDrawer(),
                  HomeContent(),
                ])
              : const NoInternet()),
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
