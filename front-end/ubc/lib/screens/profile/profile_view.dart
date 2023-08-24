import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:ubc/screens/order/orders_screen.dart';
import '../../constant/constants.dart';
import 'package:http/http.dart' as http;

import '../../widgets/YouDoNotHavePermission.dart';
import '../../widgets/no_internet_connection.dart';
import '../sign_in/login_screen.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  int isUserActive = 0;
  int userstatus = 0;
  String username = "";
  String useremail = "";
  @override
  void initState() {
    super.initState();
    checkConnectivity();
    getstatus();
  }

  late StreamSubscription subscription;
  late bool isDeviceConnected = true;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;

    return Scaffold(
      body: (isDeviceConnected)
          ? Stack(
              children: [
                Container(
                  height: size.height,
                  width: width / 4,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color.fromARGB(255, 255, 255, 255), secondColor],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                  ),
                ),
                (userstatus == 1 && isUserActive == 1)
                    ? ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          Container(
                            // color: Colors.amber,
                            height: width * 0.8,
                            width: width,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 40,
                                  top: 40,
                                  child: Container(
                                    height: width * 0.5,
                                    width: width * 0.8,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(30),
                                      color: thirdColor,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 110,
                                    top: 120,
                                  child: Column(
                                    children: [
Text(
                                      username,
                                      style: TextStyle(
                                          fontSize: height / 30,
                                          fontWeight: FontWeight.w100,
                                          color: darkGrey),
                                    ),
                                FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      useremail,
                                      style: TextStyle(
                                          fontSize: height / 50,
                                          fontWeight: FontWeight.w100,
                                          color: darkGrey),
                                    ),
                                  ),
                                  // Container(
                                  //   width: width * 0.34,
                                  //   height: width * 0.34,
                                  //   decoration: const BoxDecoration(
                                  //     borderRadius:
                                  //         BorderRadius.all(Radius.circular(20)),
                                  //     image: DecorationImage(
                                  //       image: AssetImage(
                                  //           'assets/images/menavatar.png'),
                                  //       // fit: BoxFit.cover,
                                  //     ),
                                  //   ),
                                  // ),
                                
                                
                                    ],)),
                                // Positioned(
                                //     left: 110,
                                //     top: 120,
                                //     child: Text(
                                //       username,
                                //       style: TextStyle(
                                //           fontSize: height / 30,
                                //           fontWeight: FontWeight.w100,
                                //           color: darkGrey),
                                //     )),
                                
                                // Positioned(
                                //   left: 60,
                                //   top: 160,
                                //   child: FittedBox(
                                //     fit: BoxFit.fitWidth,
                                //     child: Text(
                                //       useremail,
                                //       style: TextStyle(
                                //           fontSize: height / 50,
                                //           fontWeight: FontWeight.w100,
                                //           color: darkGrey),
                                //     ),
                                //   ),
                                
                                // ),
                                Positioned(
                                  top: 0,
                                  left: width * 0.37,
                                  child: Container(
                                    width: width * 0.34,
                                    height: width * 0.34,
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/menavatar.png'),
                                        // fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: width * 0.5,
                            width: width,
                            // color: Colors.amber,
                            child: Stack(
                              children: [
                                Positioned(
                                    left: 40,
                                    top: 20,
                                    child: Container(
                                      height: width * 0.4,
                                      width: width * 0.8,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white),
                                        borderRadius: BorderRadius.circular(30),
                                        color: thirdColor,
                                      ),
                                    )),
                                // Positioned(
                                //   left: 40,
                                //   top: 40,
                                //   child: TextButton(
                                //     onPressed: () async {},
                                //     style: ButtonStyle(
                                //         backgroundColor:
                                //             MaterialStateProperty.all(
                                //                 thirdColor),
                                //         foregroundColor:
                                //             MaterialStateProperty.all(
                                //                 Colors.black),
                                //         shape: MaterialStateProperty.all<
                                //                 RoundedRectangleBorder>(
                                //             RoundedRectangleBorder(
                                //                 borderRadius:
                                //                     BorderRadius.circular(10),
                                //                 side: BorderSide(
                                //                     color: thirdColor)))),
                                //     child: Text(
                                //       "                Edit Profile                ",
                                //       style: TextStyle(
                                //           color: Colors.black,
                                //           fontSize: width * 0.05),
                                //     ),
                                //   ),
                                // ),
                                Positioned(
                                  left: 40,
                                  top: 40,
                                  child: TextButton(
                                    onPressed: () async {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                OrderScreen()),
                                      );
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                thirdColor),
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                                Colors.black),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                side: BorderSide(
                                                    color: thirdColor)))),
                                    child: Text(
                                      "              Order History             ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: width * 0.05),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 40,
                                  top: 100,
                                  child: TextButton(
                                    onPressed: () async {
                                      const storage = FlutterSecureStorage();
                                      await storage.write(
                                          key: 'email', value: null);
                                      await storage.write(
                                          key: 'password', value: null);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginScreen()));
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                thirdColor),
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                                Colors.black),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                side: BorderSide(
                                                    color: thirdColor)))),
                                    child: Text(
                                      "                  Log Out                   ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: width * 0.05),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          // const SizedBox(
                          //   height: 20,
                          // ),
                        ],
                      )
                    : YouDoNotHavePermission()
              ],
            )
          : const NoInternet(),
    );
  }
//  Future <void> getprofile () async
//  {
//   const storage = FlutterSecureStorage();
//     String? token = await storage.read(key: 'jwt_token');
//     try{var response = await http.get(
//       Uri.parse('${url}customer/show'),
//       headers: <String, String>{
//         'Authorization': 'Bearer $token',
//       },
//     );

//     if (response.statusCode == 200) {
//       var result = response.body;
//       final list = json.decode(result) as Map<String, dynamic>;
//       var tot = list["status"];
//       setState(() {
//         isUserActive = tot;
//       });
//       userstatus = tot;
//     } else {
//       throw Exception('Failed to load data.');
//     }}catch(e){
//       userstatus = 0;
//     }

//  }
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

  Future<void> getstatus() async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'jwt_token');
    try {
      var response = await http.get(
        Uri.parse('${url}customer/show'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var result = response.body;
        final list = json.decode(result) as Map<String, dynamic>;
        // var tot = list["status"];
        username = list["firstName"]+" "+list["lastName"];
        useremail = list["email"];
        var tot = list["status"];
        var tot1 = list["accountStatus"];
        print("$tot1  _____________________________$tot");
        print("${list["status"]}  _____________________________$tot");
        setState(() {
          isUserActive = tot1;
          userstatus = tot;
        });
      } else {
        throw Exception('Failed to load data.');
      }
    } catch (e) {
      userstatus = 0;
    }
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}

class CustomListTile extends StatelessWidget {
  final String iconName;
  final String title;
  final VoidCallback onTapFn;

  const CustomListTile({
    super.key,
    required this.iconName,
    required this.title,
    required this.onTapFn,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTapFn,
          leading: Image.asset(
            'assets/icons/$iconName.png',
            height: 40,
            width: 40,
          ),
          title: Container(
            alignment: Alignment.topLeft,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ),
          trailing: title == 'Log Out'
              ? null
              : const Icon(
                  Icons.navigate_next,
                  color: Colors.black,
                ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
