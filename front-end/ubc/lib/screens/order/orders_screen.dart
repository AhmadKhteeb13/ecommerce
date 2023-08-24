import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../constant/constants.dart';
import '../../widgets/YouDoNotHavePermission.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/no_internet_connection.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'components/no_orders.dart';
import '../../../model/order_model.dart';

class OrderScreen extends StatefulWidget {
  static const String routeName = "/order";
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int isUserActive = 0;
  int userstatus = 0;
  @override
  void initState() {
    checkConnectivity();
    xOffset = yOffset = 0.0;
    scaleFactor = 1.0;
    isDrawerOpen = false;
    getstatus();
    super.initState();
  }

  Future<List<dynamic>> getORDERSprocess() async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'jwt_token');
    final response = await http.get(
      Uri.parse('${url}customer/orderCustomersNotDone'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      var result = response.body;
      final list = json.decode(result) as Map<String, dynamic>;
      var tot = list["message"];
      return tot.map((e) => OrderModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load data.');
    }
  }

  late double xOffset, yOffset, scaleFactor;
  late bool isDrawerOpen;

  late StreamSubscription subscription;
  late bool isDeviceConnected = true;

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
                                      colors: [secondColor, secondColor],
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight,
                                    ),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(left: 0, top: 10),
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
                                        child: Stack(
                                          children: [
                                            Positioned(
                                                child: SizedBox(
                                              // color: Colors.pink,
                                              height: width * 0.1,
                                              width: width * 0.4,
                                              child: const FittedBox(
                                                fit: BoxFit.fitWidth,
                                                child: Text(
                                                  "Orders History",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600,
                                                    color: darkGrey,
                                                  ),
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
                                      ),
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
                              (userstatus == 1 && isUserActive == 1)
                                  ? SizedBox(
                                      width: width,
                                      height: height * 0.78,
                                      // color: Colors.red,
                                      child: FutureBuilder(
                                          future: getORDERSprocess(),
                                          builder: (buildContext, snapshot) {
                                            if (snapshot.hasError) {
                                              return Center(
                                                  child: Text(
                                                      "${snapshot.error}"));
                                            }

                                            if (!snapshot.hasData) {
                                              return _buildEmpty();
                                            }
                                            var items =
                                                snapshot.data as List<dynamic>;
                                            return ListView.builder(
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              itemCount: items.length,
                                              itemBuilder: (buildContext,
                                                      index) =>
                                                  CardForOrder(
                                                      width: width * 0.7,
                                                      height: height * 0.7,
                                                      totalAmount: items[index]
                                                          .totalAmount,
                                                      date: items[index].date,
                                                      currentStatus:
                                                          items[index]
                                                              .currentStatus,
                                                      pickedQuantity:
                                                          items[index]
                                                              .pickedQuantity,
                                                      approvedQuantity:
                                                          items[index]
                                                              .approvedQuantity,
                                                      id: items[index].id),
                                            );
                                          }),
                                    )
                                  : YouDoNotHavePermission()
                            ],
                          )))
                ],
              )
            : const NoInternet(),
      ),
    );
  }

  Widget _buildEmpty() {
    var mediaQueryData = MediaQueryData.fromView(View.of(context));
    var statusBar = mediaQueryData.padding.top;
    var bottomArea = mediaQueryData.padding.bottom;
    var height = MediaQuery.sizeOf(context).height -
        statusBar -
        bottomArea -
        kBottomNavigationBarHeight -
        kToolbarHeight;
    var width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: SizedBox(
        height: height,
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () {},
              child: const Image(
                  image: AssetImage("assets/images/default_img.png"),
                  width: 300.0,
                  height: 300.0),
            ),
            Text(
              "You don't have orders yet!.",
              textAlign: TextAlign.center,
              style: TextStyle(
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(10.0, 10.0),
                    blurRadius: 3.0,
                    color: Colors.black12,
                  ),
                ],
                color: Colors.black,
                fontSize: width * 0.06,
                fontFamily: "Raleway",
                fontWeight: FontWeight.w100,
              ),
            ),
          ],
        ),
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

class CardForOrder extends StatefulWidget {
  CardForOrder(
      {super.key,
      required this.width,
      required this.height,
      required this.currentStatus,
      required this.date,
      required this.totalAmount,
      required this.approvedQuantity,
      required this.pickedQuantity,
      required this.id});
  double width;
  num height, totalAmount;
  int id, pickedQuantity, approvedQuantity;
  String date, currentStatus;
  @override
  State<CardForOrder> createState() => _CardForOrderState(
      width: width,
      height: height,
      date: date,
      approvedQuantity: approvedQuantity,
      currentStatus: currentStatus,
      totalAmount: totalAmount,
      pickedQuantity: pickedQuantity,
      id: id);
}

class _CardForOrderState extends State<CardForOrder> {
  _CardForOrderState(
      {required this.width,
      required this.height,
      required this.currentStatus,
      required this.date,
      required this.totalAmount,
      required this.approvedQuantity,
      required this.pickedQuantity,
      required this.id});
  double width;
  num height, totalAmount;
  int id, pickedQuantity, approvedQuantity;
  String date, currentStatus;
  double culcpercent(curentstate) {
    if (curentstate == "credit") {
      return 0.0;
    } else if (curentstate == "salesManager") {
      return 16.0;
    } else if (curentstate == "warehouse1") {
      return 32.0;
    } else if (curentstate == "picked") {
      return 48.0;
    } else if (curentstate == "warehouse2") {
      return 64.0;
    } else if (curentstate == "shipping") {
      return 80.0;
    } else {
      return 100.0;
    }
  }

  var message = "Approve";
  Future<void> getmessage() async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'jwt_token');
    final response = await http.get(
      Uri.parse('${url}customer/orderMessage/$id'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      var result = response.body;
      final list = json.decode(result) as Map<String, dynamic>;
      var tot = list["data"]["pivot"]["message"];
      print(
          "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
      print("$tot");
      setState(() {
        message = tot;
      });
      print("${tot.toString()}");
      // return tot.toString();
    } else {
      throw Exception('Failed to load data.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        
        print("****************************************");
        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Order Note:'),
              content: Text(
                "${message}",
              ),
              actions: <Widget>[
                // TextButton(
                //   style: TextButton.styleFrom(
                //     textStyle: Theme.of(context).textTheme.labelLarge,
                //   ),
                //   child: const Text('Disable'),
                //   onPressed: () {
                //     Navigator.of(context).pop();
                //   },
                // ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      child: SizedBox(
        width: width,
        height: height * 0.4,
        // color: Colors.red,
        child: Stack(
          children: [
            Center(
              child: Container(
                width: width * 1.25,
                height: height * 0.27,
                decoration: const BoxDecoration(
                    color: thirdColor,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Stack(
                  children: [
                    Positioned(
                        left: width * 0.05,
                        top: width * 0.05,
                        child: SizedBox(
                          width: width * 0.7,
                          height: height * 0.05,
                          // color: Colors.green,
                          child: Text(
                            "totalAmount:  $totalAmount",
                            style: TextStyle(fontSize: width * 0.05),
                          ),
                        )),
                    // Positioned(
                    //     left: width * 0.05,
                    //     top: width * 0.15,
                    //     child: SizedBox(
                    //       width: width * 0.7,
                    //       height: height * 0.05,
                    //       // color: Colors.green,
                    //       child: Text(
                    //         "currentStatus:  $currentStatus",
                    //         style: TextStyle(fontSize: width * 0.04),
                    //       ),
                    //     )),
                    // Positioned(
                    //     left: width * 0.05,
                    //     top: width * 0.24,
                    //     child: SizedBox(
                    //       width: width * 0.7,
                    //       height: height * 0.05,
                    //       // color: Colors.green,
                    //       child: Text(
                    //         "pickedQuantity:  $pickedQuantity",
                    //         style: TextStyle(fontSize: width * 0.04),
                    //       ),
                    //     )),
                    Positioned(
                        left: width * 0.05,
                        top: width * 0.15,
                        child: SizedBox(
                          width: width * 0.7,
                          height: height * 0.06,
                          // color: Colors.green,
                          child: Text(
                            "Date:  $date",
                            style: TextStyle(fontSize: width * 0.04),
                          ),
                        )),
                    Positioned(
                        left: width * 0.05,
                        top: width * 0.26,
                        child: SizedBox(
                          width: width * 0.7,
                          height: height * 0.05,
                          // color: Colors.green,
                          child: Text(
                            "Approved Quantity:  $approvedQuantity",
                            style: TextStyle(fontSize: width * 0.04),
                          ),
                        )),
                  ],
                ),
              ),
            ),
            Positioned(
              top: width * 0.2,
              left: width * 0.9,
              child: CircularPercentIndicator(
                radius: 40,
                animation: true,
                // animationDuration: 1000,
                lineWidth: 10.0,
                percent: (culcpercent(currentStatus)) / 100,
                center: Text(
                  "${culcpercent(currentStatus)}%",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 11.0),
                ),
                reverse: false,
                arcType: ArcType.FULL,
                startAngle: 0.0,
                animateFromLastPercent: true,
                circularStrokeCap: CircularStrokeCap.round,
                linearGradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  tileMode: TileMode.clamp,
                  stops: [0.0, 1.0],
                  colors: <Color>[secondColor, Colors.amber],
                ),
                arcBackgroundColor: Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }
}
