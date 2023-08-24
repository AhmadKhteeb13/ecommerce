import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
// import '../map/geolocation.dart';
import '../map/mapscreen.dart';
import '/constant/constants.dart';
import '../../model/order_model.dart';
import '../../model/product_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent>
    with TickerProviderStateMixin {
  late double xOffset, yOffset, scaleFactor;
  late bool isDrawerOpen;
  Position? _currentLocation;
  late Timer _timer;
  bool servicePermission = false;
  late LocationPermission permission;
  void onTap(int index) {
    setState(() {});
  }

  Future<Position> _sendCurrentLocation() async {
    servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {
      print("service disabled");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<List<dynamic>> getORDERSprocess() async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'jwt_token');
    final response = await http.get(
      Uri.parse('${url}shipping/shippingOrdersNotComplete'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var result = response.body;
      final list = json.decode(result) as Map<String, dynamic>;
      var tot = list["data"];
      return tot.map((e) => OrderModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load data.');
    }
  }

  Future<List<dynamic>> getORDERSDone() async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'jwt_token');
    final response = await http.get(
      Uri.parse('${url}shipping/shippingOrdersComplete'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );
    print("${response.body}999999999999999999999999");
    if (response.statusCode == 200) {
      var result = response.body;
      final list = json.decode(result) as Map<String, dynamic>;
      var tot = list["data"];
      return tot.map((e) => OrderModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load data.');
    }
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

  late final TabController _tabController;
  late StreamSubscription subscription;
  late bool isDeviceConnected = true;
  @override
  void initState() {
    super.initState();
    checkConnectivity();
    xOffset = yOffset = 0.0;
    scaleFactor = 1.0;
    isDrawerOpen = false;
    _tabController = TabController(length: 2, vsync: this);
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      _sendCurrentLocation(); // Call the method you want to execute
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    subscription.cancel();
    _timer.cancel();
    super.dispose();
  }

  List<String> tabs = ["Processing", "Done"];
  int current = 0;

  double changePositionedOfLine(width) {
    switch (current) {
      case 0:
        return 0;
      case 1:
        return width * 0.55;
      default:
        return 0;
    }
  }

  double changeContainerWidth() {
    switch (current) {
      case 0:
        return 50;
      case 1:
        return 80;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return AnimatedContainer(
        transform: Matrix4.translationValues(xOffset, yOffset, 0.0)
          ..scale(scaleFactor),
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
            borderRadius: (isDrawerOpen)
                ? BorderRadius.circular(40)
                : BorderRadius.circular(0),
            color: Colors.white.withOpacity(0),
            boxShadow: [if (isDrawerOpen) drawerShadow]),
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(width, width * 0.2),
            child: Row(
              children: [
                Container(
                  width: width * 0.25,
                  height: width * 0.25,
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Padding(
                    padding: EdgeInsets.only(left: 0, top: 10),
                    child: isDrawerOpen
                        ? IconButton(
                            icon: const Icon(Icons.arrow_back_ios),
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
                            icon:
                                SvgPicture.asset("assets/icons/hamburger.svg"),
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
                Container(
                  width: width * 0.75,
                  height: width * 0.25,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 0, left: width * 0.17),
                        child: Stack(
                          children: [
                            Positioned(
                                child: Container(
                              width: width * 0.2,
                              // color: Colors.pink,
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  "Shipper",
                                  style: TextStyle(
                                    fontSize: width * 0.2,
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
                                color: secondColor.withOpacity(0.2),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: width * 0.15, top: 10),
                        child: IconButton(
                          splashColor: Colors.white,
                          iconSize: 32,
                          onPressed: () {
                            // if (sideMenuKey.currentState!.isOpened) {
                            //   sideMenuKey.currentState!.closeSideMenu();
                            // } else {
                            //   sideMenuKey.currentState!.openSideMenu();
                            // }
                          },
                          icon: Image.asset(
                            'assets/icons/search.png',
                            width: 25,
                            height: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: SizedBox(
            width: width,
            height: height,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  width: size.width,
                  height: size.height * 0.05,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: SizedBox(
                          width: size.width,
                          height: size.height * 0.04,
                          child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: tabs.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      left: index == 0
                                          ? width * 0.1
                                          : width * 0.35,
                                      top: 7),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        current = index;
                                      });
                                    },
                                    child: Text(
                                      tabs[index],
                                      style: TextStyle(
                                        fontSize: current == index ? 16 : 14,
                                        fontWeight: current == index
                                            ? FontWeight.w400
                                            : FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                      AnimatedPositioned(
                        curve: Curves.fastLinearToSlowEaseIn,
                        bottom: 0,
                        left: changePositionedOfLine(width),
                        duration: const Duration(milliseconds: 500),
                        child: AnimatedContainer(
                          margin: EdgeInsets.only(left: width * 0.1),
                          width: changeContainerWidth(),
                          height: size.height * 0.008,
                          decoration: BoxDecoration(
                            color: secondColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.fastLinearToSlowEaseIn,
                        ),
                      )
                    ],
                  ),
                ),
                (current == 0)
                    ? Container(
                        width: width,
                        height: height * 0.78,
                        // color: Colors.red,
                        child: FutureBuilder(
                            future: getORDERSprocess(),
                            builder: (buildContext, snapshot) {
                              if (snapshot.hasError) {
                                return Center(child: Text("${snapshot.error}"));
                              }

                              if (!snapshot.hasData) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              var items = snapshot.data as List<dynamic>;
                              return ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: items.length,
                                itemBuilder: (buildContext, index) =>
                                    CardForOrder(
                                  width: width * 0.7,
                                  height: height * 0.7,
                                  percento: 50.0,
                                  orderId: items[index].id,
                                  customerId: items[index].customerId,
                                  pickedQuantity: items[index].pickedQuantity,
                                  totalAmount: items[index].totalAmount,
                                  approvedQuantity:
                                      items[index].approvedQuantity,
                                      targetLatitude: 33.524697,
                                      targetLongitude: 36.2859862,
                                ),
                              );
                            }),
                      )
                    : Container(
                        width: width,
                        height: height * 0.78,
                        // color: Colors.red,
                        child: FutureBuilder(
                            future: getORDERSDone(),
                            builder: (buildContext, snapshot) {
                              if (snapshot.hasError) {
                                return Center(child: Text("${snapshot.error}"));
                              }

                              if (!snapshot.hasData) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              var items = snapshot.data as List<dynamic>;
                              return ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: items.length,
                                itemBuilder: (buildContext, index) =>
                                    CardForDoneOrder(
                                  width: width * 0.7,
                                  height: height * 0.7,
                                  orderId: items[index].id,
                                  customerId: items[index].customerId,
                                  pickedQuantity: items[index].pickedQuantity,
                                  totalAmount: items[index].totalAmount,
                                  approvedQuantity:
                                      items[index].approvedQuantity,
                                ),
                              );
                            }),
                      )
              ],
            ),
          ),
        ));
  }
}

class CircleTabIndicater extends Decoration {
  final Color color;
  double radius;
  CircleTabIndicater({required this.color, required this.radius});
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CirclePainter(color: color, radius: radius);
  }
}

class _CirclePainter extends BoxPainter {
  final Color color;
  double radius;
  _CirclePainter({required this.color, required this.radius});
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    Paint _paint = Paint();
    _paint.color = color;
    _paint.isAntiAlias = true;
    final Offset circleOffset = Offset(
        configuration.size!.width / 4000 - radius / 2,
        configuration.size!.height - radius);
    canvas.drawCircle(offset + circleOffset, radius, _paint);
  }
}

class CardForDoneOrder extends StatefulWidget {
  CardForDoneOrder(
      {super.key,
      required this.width,
      required this.height,
      required this.orderId,
      required this.totalAmount,
      required this.customerId,
      required this.pickedQuantity,
      required this.approvedQuantity});
  double width;
  double height;
  num orderId, customerId, pickedQuantity, approvedQuantity, totalAmount;
  @override
  State<CardForDoneOrder> createState() => _CardForDoneOrderState(
      width: width,
      height: height,
      orderId: orderId,
      customerId: customerId,
      pickedQuantity: pickedQuantity,
      totalAmount: totalAmount,
      approvedQuantity: approvedQuantity);
}

class _CardForDoneOrderState extends State<CardForDoneOrder> {
  _CardForDoneOrderState(
      {required this.width,
      required this.height,
      required this.orderId,
      required this.totalAmount,
      required this.customerId,
      required this.pickedQuantity,
      required this.approvedQuantity});
  double width;
  double height;
  num orderId,
      customerId,
      pickedQuantity,
      approvedQuantity,
      totalAmount,
      startOrEnd = 1;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height * 0.3,
      // color: Colors.red,
      child: Stack(
        children: [
          Center(
            child: Container(
              width: width * 1.25,
              height: height * 0.23,
              decoration: BoxDecoration(
                  color: thirdColor,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Stack(
                children: [
                  Positioned(
                      left: width * 0.05,
                      top: width * 0.05,
                      child: Container(
                        width: width * 0.7,
                        height: height * 0.05,
                        // color: Colors.green,
                        child: Text(
                          "Order Id : $orderId",
                          style: TextStyle(fontSize: width * 0.05),
                        ),
                      )),
                  Positioned(
                      left: width * 0.05,
                      top: width * 0.13,
                      child: Container(
                        width: width * 0.7,
                        height: height * 0.05,
                        // color: Colors.green,
                        child: Text(
                          "Total Amount : $totalAmount",
                          style: TextStyle(fontSize: width * 0.04),
                        ),
                      )),
                  Positioned(
                      left: width * 0.05,
                      top: width * 0.2,
                      child: Container(
                        width: width * 0.7,
                        height: height * 0.05
                        ,
                        // color: Colors.green,
                        child: Text(
                          "Approved Quantity : $approvedQuantity",
                          style: TextStyle(fontSize: width * 0.04),
                        ),
                      )),
                ],
              ),
            ),
          ),
          // Positioned(
          //   top: width * 0.12,
          //   left: width * 0.9,
          //   child: CircularPercentIndicator(
          //     radius: 40,
          //     animation: true,
          //     lineWidth: 10.0,
          //     percent: percento / 100,
          //     center: new Text(
          //       "$percento%",
          //       style:
          //           new TextStyle(fontWeight: FontWeight.bold, fontSize: 11.0),
          //     ),
          //     reverse: false,
          //     arcType: ArcType.FULL,
          //     startAngle: 0.0,
          //     animateFromLastPercent: true,
          //     circularStrokeCap: CircularStrokeCap.round,
          //     linearGradient: LinearGradient(
          //       begin: Alignment.centerLeft,
          //       end: Alignment.centerRight,
          //       tileMode: TileMode.clamp,
          //       stops: [0.0, 1.0],
          //       colors: <Color>[Colors.blue, secondColor],
          //     ),
          //     arcBackgroundColor: Colors.grey,
          //   ),
          // )
        ],
      ),
    );
  }
}

class CardForOrder extends StatefulWidget {
  CardForOrder(
      {super.key,
      required this.width,
      required this.height,
      required this.percento,
      required this.orderId,
      required this.totalAmount,
      required this.customerId,
      required this.pickedQuantity,
      required this.approvedQuantity,
      required this.targetLatitude, required this.targetLongitude});
  double width;
  double height, percento;
  num orderId, customerId, pickedQuantity, approvedQuantity, totalAmount;
  double targetLatitude ;
  double targetLongitude ;
  // String date;
  @override
  State<CardForOrder> createState() => _CardForOrderState(
      width: width,
      height: height,
      percento: percento,
      orderId: orderId,
      customerId: customerId,
      pickedQuantity: pickedQuantity,
      totalAmount: totalAmount,
      approvedQuantity: approvedQuantity,
      targetLatitude: targetLatitude,
      targetLongitude: targetLongitude
      );
}

class _CardForOrderState extends State<CardForOrder> {
  _CardForOrderState(
      {required this.width,
      required this.height,
      required this.percento,
      required this.orderId,
      required this.totalAmount,
      required this.customerId,
      required this.pickedQuantity,
      required this.approvedQuantity,
      required this.targetLatitude, required this.targetLongitude});
  double width;
  double height, percento;
  num orderId,
      customerId,
      pickedQuantity,
      approvedQuantity,
      totalAmount,
      startOrEnd = 1;
      double targetLatitude ;
  double targetLongitude ;
  // String date;
  int count = 0;
  void _increment() {
    setState(() {
      this.count++;
    });
  }

  void _decrement() {
    if (this.count > 0) {
      setState(() {
        this.count--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (BuildContext context) => MapScreen(targetLatitude: targetLatitude,targetLongitude: targetLongitude,),
        //     ));

        // showModalBottomSheet<void>(
        //   shape: const RoundedRectangleBorder(
        //       borderRadius: BorderRadius.vertical(
        //     top: Radius.circular(30),
        //   )),
        //   isScrollControlled: true,
        //   context: context,
        //   builder: (BuildContext context) {
        //     return bottomSheet(context);
        //   },
        // );
      },
      child: Container(
        width: width,
        height: height * 0.3,
        // color: Colors.red,
        child: Stack(
          children: [
            Center(
              child: Container(
                width: width * 1.25,
                height: height * 0.23,
                decoration: BoxDecoration(
                    color: thirdColor,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Stack(
                  children: [
                    Positioned(
                        left: width * 0.05,
                        top: width * 0.05,
                        child: Container(
                          width: width * 0.7,
                          height: height * 0.05,
                          // color: Colors.green,
                          child: Text(
                            "Order Id : $orderId",
                            style: TextStyle(fontSize: width * 0.05),
                          ),
                        )),
                    Positioned(
                        left: width * 0.05,
                        top: width * 0.13,
                        child: Container(
                          width: width * 0.7,
                          height: height * 0.05,
                          // color: Colors.green,
                          child: Text(
                            "Total Amount : $totalAmount",
                            style: TextStyle(fontSize: width * 0.04),
                          ),
                        )),
                    Positioned(
                        left: width * 0.05,
                        top: width * 0.2,
                        child: Container(
                          width: width * 0.7,
                          height: height * 0.05,
                          // color: Colors.green,
                          child: Text(
                            "Approved Quantity : $approvedQuantity",
                            style: TextStyle(fontSize: width * 0.04),
                          ),
                        )),
                  ],
                ),
              ),
            ),
            Positioned(
              top: width * 0.38,
              left: width * 0.02,
              child: (startOrEnd == 1)
                  ? FloatingActionButton.small(
                      elevation: 0,
                      heroTag: null,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.keyboard_arrow_right_outlined,
                        color: darkGrey,
                      ),
                      onPressed: () {
                        startorder(orderId);
                        setState(() {
                          startOrEnd = 0;
                        });
                      })
                  : FloatingActionButton.small(
                      elevation: 0,
                      heroTag: null,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.stop_circle_outlined,
                        color: darkGrey,
                      ),
                      onPressed: () {
                        endorder(orderId);
                        setState(() {
                          startOrEnd = 1;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeContent()),
                        );
                      }),
            ),
            Positioned(
              top: width * 0.12,
              left: width * 0.9,
              child: CircularPercentIndicator(
                radius: 40,
                animation: true,
                // animationDuration: 1000,
                lineWidth: 10.0,
                percent: percento / 100,
                center: new Text(
                  "$percento%",
                  style: new TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 11.0),
                ),
                reverse: false,
                arcType: ArcType.FULL,
                startAngle: 0.0,
                animateFromLastPercent: true,
                circularStrokeCap: CircularStrokeCap.round,
                // backgroundColor: Colors.green,
                linearGradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  tileMode: TileMode.clamp,
                  stops: [0.0, 1.0],
                  colors: <Color>[secondColor, secondColor],
                ),

                // widgetIndicator: Center(
                //   child: Container(
                //     height: 20,
                //     width: 20,
                //     decoration: BoxDecoration(
                //       color: Colors.white,
                //       borderRadius: BorderRadius.circular(50),
                //     ),
                //     padding: const EdgeInsets.all(5),
                //     child: Container(
                //       decoration: BoxDecoration(
                //         color: Colors.white,
                //         borderRadius: BorderRadius.circular(50),
                //       ),
                //     ),
                //   ),
                // ),
                arcBackgroundColor: Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<List<dynamic>> getproductsforORDERSprocess(num ordertid) async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'jwt_token');
    final response = await http.get(
      Uri.parse('${url}order/view/$orderId'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      var result = response.body;
      final list = json.decode(result) as Map<String, dynamic>;
      var tot = list["data"];
      return tot.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load data.');
    }
  }

  Future<void> startorder(num orderid) async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'jwt_token');
    final response = await http.get(
      Uri.parse('${url}order/start/$orderId'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      // print(response.body);
    } else {
      throw Exception('Failed to load data.');
    }
  }

  Future<void> endorder(num orderid) async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'jwt_token');
    final response = await http.get(
      Uri.parse('${url}order/End/$orderId'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      // print(response.body);
    } else {
      throw Exception('Failed to load data.');
    }
  }

  //************************************************* */
  Future<void> putscan(int ordertid, int productid) async {
    try {
      final response =
          await http.put(Uri.parse(url + 'order/edit/$ordertid/$productid'));
      if (response.statusCode == 200) {
        var result = response.body;
        print("****************************$result");
      }
    } catch (e) {
      print(e);
    }
  }

  Widget bottomSheet(BuildContext context) {
    return StatefulBuilder(builder: (context, state) {
      return Container(
        height: height * 0.99,
        width: width,
        decoration: BoxDecoration(
            color: thirdColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: FutureBuilder(
            future: getproductsforORDERSprocess(orderId),
            builder: (buildContext, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text("${snapshot.error}"));
              }

              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              var items = snapshot.data as List<dynamic>;
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (buildContext, index) => CardForProductForOrder(
                  email: items[index].email,
                  productname: items[index].namperoduct,
                  pymentMethods: items[index].pymentMethods,
                  customername:
                      (items[index].namefirst + items[index].nameLast),
                  orderCreated: items[index].orderCreated,
                  warehouseName: items[index].warehouseName,
                  count: count,
                ),
              );
            }),
      );
    });
  }

  // Widget CardForProductForOrder() {
  //   return StatefulBuilder(builder: (context, state) {
  //     return Container(
  //       height: height * 0.5,
  //       width: width,
  //       decoration: BoxDecoration(
  //           color: thirdColor,
  //           borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(20), topRight: Radius.circular(20))),
  //       child: Column(
  //         children: [
  //           Container(
  //             width: width * 1.5,
  //             height: width * 0.8,
  //             child: Stack(
  //               children: <Widget>[
  //                 Positioned(
  //                   left: 30,
  //                   top: 48,
  //                   child: Container(
  //                     width: width * 1.2,
  //                     height: width * 0.6,
  //                     decoration: BoxDecoration(
  //                         boxShadow: [
  //                           BoxShadow(
  //                               color: Colors.white,
  //                               spreadRadius: 1,
  //                               blurRadius: 8)
  //                         ],
  //                         color: Colors.white,
  //                         borderRadius: BorderRadius.circular(15)),
  //                     child: Stack(
  //                       children: [
  //                         Positioned(
  //                             top: width * 0.04,
  //                             left: width * 0.35,
  //                             child: Column(
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               children: [
  //                                 Container(
  //                                   height: width * 0.08,
  //                                   width: width * 0.4,
  //                                   // color: Colors.amber,
  //                                   child: Text(
  //                                     "customerId: $customerId",
  //                                     style: TextStyle(
  //                                         color: darkGrey,
  //                                         fontSize: width * 0.05,
  //                                         fontWeight: FontWeight.w900),
  //                                   ),
  //                                 ),
  //                                 SizedBox(
  //                                   height: width * 0.03,
  //                                 ),
  //                                 Container(
  //                                   height: width * 0.1,
  //                                   width: width * 0.5,
  //                                   // color: Colors.red,
  //                                   child: Text(
  //                                     "pickedQuantity: $pickedQuantity",
  //                                     style: TextStyle(
  //                                         color: darkGrey,
  //                                         fontSize: width * 0.04,
  //                                         fontWeight: FontWeight.w300),
  //                                   ),
  //                                 ),
  //                                 SizedBox(
  //                                   height: width * 0.08,
  //                                 ),
  //                               ],
  //                             )),
  //                         Positioned(
  //                           left: width * 0.94,
  //                           top: width * 0.05,
  //                           child: Container(
  //                             width: width * 0.2,
  //                             height: width * 0.2,
  //                             decoration: BoxDecoration(
  //                                 border:
  //                                     Border.all(color: secondColor, width: 2),
  //                                 color: thirdColor,
  //                                 borderRadius:
  //                                     BorderRadius.all(Radius.circular(50))),
  //                             child: Center(
  //                               child: Text(
  //                                 "$_count",
  //                                 style: TextStyle(color: darkGrey),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         Positioned(
  //                           left: width * 0.94,
  //                           top: width * 0.3,
  //                           child: Container(
  //                             decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(50),
  //                               border: Border.all(
  //                                 color: secondColor,
  //                                 width: 2.0,
  //                               ),
  //                             ),
  //                             child: FloatingActionButton.small(
  //                               elevation: 0,
  //                               heroTag: null,
  //                               backgroundColor: thirdColor,
  //                               child: Icon(
  //                                 Icons.add,
  //                                 size: width * 0.1,
  //                                 color: darkGrey,
  //                               ),
  //                               onPressed: () {
  //                                 setState(() {
  //                                   updated(state);
  //                                 });
  //                               },
  //                             ),
  //                           ),
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //                 Positioned(
  //                     left: width * 0.05,
  //                     top: width * 0.13,
  //                     child: Container(
  //                       width: width * 0.35,
  //                       height: width * 0.25,
  //                       decoration: BoxDecoration(
  //                           boxShadow: [
  //                             BoxShadow(
  //                                 color: Colors.white,
  //                                 spreadRadius: 1,
  //                                 blurRadius: 8)
  //                           ],
  //                           gradient: const LinearGradient(
  //                             colors: [thirdColor, secondColor, secondColor],
  //                             begin: Alignment.topLeft,
  //                             end: Alignment.bottomRight,
  //                           ),
  //                           borderRadius: BorderRadius.circular(20)),
  //                     )),
  //                 Positioned(
  //                     top: 5,
  //                     left: width * 0.095,
  //                     child: Image(
  //                       image: AssetImage("assets/images/vvd.png"),
  //                       width: width * 0.26,
  //                       height: width * 0.26,
  //                     )),
  //               ],
  //             ),
  //           ),
  //           // Container(
  //           //     height: width * 0.2,
  //           //     width: width * 1.5,
  //           //     // color: Colors.orange,
  //           //     child: Padding(
  //           //       padding: EdgeInsets.only(
  //           //         left: width * 0.2,
  //           //       ),
  //           //       child: Row(
  //           //         children: [
  //           //           Text(
  //           //             "Total Weight :",
  //           //             style:
  //           //                 TextStyle(color: darkGrey, fontSize: width * 0.05),
  //           //           ),
  //           //           SizedBox(
  //           //             width: width * 0.2,
  //           //           ),
  //           //           Text(
  //           //             "{_count * weight}Kg",
  //           //             style: TextStyle(
  //           //                 color: darkGrey.withOpacity(0.5),
  //           //                 fontSize: width * 0.05),
  //           //           ),
  //           //         ],
  //           //       ),
  //           //     )),
  //           // Container(
  //           //     height: width * 0.2,
  //           //     width: width * 1.5,
  //           //     // color: Colors.blue,
  //           //     child: Padding(
  //           //       padding: EdgeInsets.only(
  //           //         left: width * 0.2,
  //           //       ),
  //           //       child: Row(
  //           //         children: [
  //           //           Text(
  //           //             "Total Amount :",
  //           //             style:
  //           //                 TextStyle(color: darkGrey, fontSize: width * 0.05),
  //           //           ),
  //           //           SizedBox(
  //           //             width: width * 0.2,
  //           //           ),
  //           //           Text(
  //           //             "${_count * price}",
  //           //             style: TextStyle(
  //           //                 color: darkGrey.withOpacity(0.5),
  //           //                 fontSize: width * 0.05),
  //           //           ),
  //           //         ],
  //           //       ),
  //           //     )),
  //         ],
  //       ),
  //     );
  //   });
  // }

  // Future<Null> updated(StateSetter updateState) async {
  //   updateState(() {
  //     _increment();
  //   });
  // }

  // Future<Null> dedated(StateSetter dedateState) async {
  //   dedateState(() {
  //     _decrement();
  //   });
  // }
}

class CardForProductForOrder extends StatefulWidget {
  CardForProductForOrder(
      {super.key,
      required this.email,
      required this.productname,
      required this.orderCreated,
      required this.pymentMethods,
      required this.warehouseName,
      required this.customername,
      required this.count});
  int count;
  String productname,
      customername,
      orderCreated,
      warehouseName,
      pymentMethods,
      email;
  @override
  State<CardForProductForOrder> createState() => _CardForProductForOrderState(
      email: email,
      productname: productname,
      orderCreated: orderCreated,
      pymentMethods: pymentMethods,
      warehouseName: warehouseName,
      customername: customername,
      count: count);
}

class _CardForProductForOrderState extends State<CardForProductForOrder> {
  _CardForProductForOrderState(
      {required this.email,
      required this.productname,
      required this.orderCreated,
      required this.pymentMethods,
      required this.warehouseName,
      required this.customername,
      required this.count});
  int count;
  String productname,
      customername,
      orderCreated,
      warehouseName,
      pymentMethods,
      email;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
      height: height * 0.4,
      width: width,
      decoration: BoxDecoration(
          color: thirdColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Container(
        width: width,
        // height: width * 0.3,
        // color: Colors.amber,
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 25,
              top: 48,
              child: Container(
                width: width * 0.88,
                height: width * 0.6,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.white, spreadRadius: 1, blurRadius: 8)
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
              ),
            ),
            Positioned(
                left: width * 0.03,
                top: width * 0.09,
                child: Container(
                  width: width * 0.3,
                  height: width * 0.25,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.white, spreadRadius: 1, blurRadius: 8)
                      ],
                      gradient: const LinearGradient(
                        colors: [thirdColor, secondColor, secondColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20)),
                )),
            Positioned(
                top: 5,
                left: width * 0.05,
                child: Image(
                  image: AssetImage("assets/images/vvd.png"),
                  width: width * 0.26,
                  height: width * 0.26,
                )),
            Positioned(
                top: width * 0.2,
                left: width * 0.38,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: width * 0.08,
                      width: width * 0.4,
                      // color: Colors.amber,
                      child: Text(
                        productname,
                        style: TextStyle(
                            color: darkGrey,
                            fontSize: width * 0.05,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                  ],
                )),
            Positioned(
              top: width * 0.37,
              left: width * 0.12,
              child: Container(
                height: width * 0.1,
                width: width * 0.7,
                // color: Colors.red,
                child: Text(
                  "Customer Name :",
                  style: TextStyle(
                      color: darkGrey,
                      fontSize: width * 0.04,
                      fontWeight: FontWeight.w900),
                ),
              ),
            ),
            Positioned(
              top: width * 0.43,
              left: width * 0.12,
              child: Container(
                height: width * 0.1,
                width: width * 0.8,
                // color: Colors.red,
                child: Text(
                  "$customername",
                  style: TextStyle(
                      color: darkGrey,
                      fontSize: width * 0.04,
                      fontWeight: FontWeight.w300),
                ),
              ),
            ),
            Positioned(
              left: width * 0.75,
              top: width * 0.35,
              child: Container(
                width: width * 0.18,
                height: width * 0.18,
                decoration: BoxDecoration(
                    border: Border.all(color: secondColor, width: 2),
                    color: thirdColor,
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                child: Center(
                  child: Text(
                    "$count",
                    style: TextStyle(color: darkGrey),
                  ),
                ),
              ),
            ),
            Positioned(
              left: width * 0.77,
              top: width * 0.55,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: secondColor,
                    width: 2.0,
                  ),
                ),
                child: FloatingActionButton.small(
                  elevation: 0,
                  heroTag: null,
                  backgroundColor: thirdColor,
                  child: Icon(
                    Icons.add,
                    size: width * 0.1,
                    color: darkGrey,
                  ),
                  onPressed: () {
                    setState(() {
                      count++;
                    });
                  },
                ),
              ),
            ),
            Positioned(
              top: width * 0.5,
              left: width * 0.12,
              child: Container(
                height: width * 0.1,
                width: width * 0.7,
                // color: Colors.red,
                child: Text(
                  "Order Created :",
                  style: TextStyle(
                      color: darkGrey,
                      fontSize: width * 0.04,
                      fontWeight: FontWeight.w900),
                ),
              ),
            ),
            Positioned(
              top: width * 0.55,
              left: width * 0.12,
              child: Container(
                height: width * 0.1,
                width: width * 0.8,
                // color: Colors.red,
                child: Text(
                  "$orderCreated",
                  style: TextStyle(
                      color: darkGrey,
                      fontSize: width * 0.04,
                      fontWeight: FontWeight.w300),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
