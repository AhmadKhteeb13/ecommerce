import 'dart:async';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:ubc/model/mineorder.dart';
import 'package:ubc/model/mineproduct.dart';
import 'package:ubc/screens/home/home_screen.dart';
import '../../constant/constants.dart';
import '../../widgets/YouDoNotHavePermission.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/no_internet_connection.dart';
import '../categoryproducts/category_products.dart';
import 'package:http/http.dart' as http;

class ShoppingCartScreen extends StatefulWidget {
  static const String routeName = "/ShoppingCartScreen";
  const ShoppingCartScreen({super.key});

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  static Future<int> addorder(products, totalAmount) async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'jwt_token');
    mineorder myobject =
        mineorder(totalAmount: totalAmount, products: products);
    String data = jsonEncode(myobject.toJson());
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http.post(
      Uri.parse('${url}order/add'),
      headers: headers,
      body: data,
    );
    print(
        "*****************************************************************************************************");
    print('${url}order/add');
    // print(response.statusCode);
    print(response.body);
    if (response.statusCode == 201) {
      return 1;
    } else {
      return 0;
    }
  }

  List<mineproduct> confirmproducts() {
    List<mineproduct> truelistproducts = [];
    mineproduct trueproduct;
    int i = 0;
    while (i < products.length) {
      trueproduct = new mineproduct(
          productId: products[i].productId,
          orderedQuantity: products[i].orderedQuantity);
      truelistproducts.add(trueproduct);
      i++;
    }
    return truelistproducts;
  }

  Map<String, dynamic>? paymentIntentData;
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 0;
  late bool isDrawerOpen;
  int isUserActive = 0;
  double Total_Price = 0;
  int userstatus = 0;
  @override
  void initState() {
    super.initState();
    getstatus();
    print("${userstatus}00000000000000000000000000000000000");
    checkConnectivity();
    xOffset = yOffset = 0.0;
    scaleFactor = 1.0;
    isDrawerOpen = false;
    Total_Price = sumprice();
  }

  Map<String, dynamic>? paymentIntent;
  late StreamSubscription subscription;
  late bool isDeviceConnected = true;
  String paid = "faild";
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;

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
                                      SizedBox(
                                        // color: Colors.amber,
                                        height: width * 0.1,
                                        width: width * 0.47,
                                        child: Padding(
                                            padding: EdgeInsets.only(
                                                left: width * 0.03,
                                                top: width * 0.03),
                                            child: AutoSizeText(
                                              "Shopping Cart",
                                              style: TextStyle(
                                                  color: darkGrey,
                                                  fontSize: width * 0.07),
                                            )),
                                      ),
                                      // Padding(
                                      //   padding: const EdgeInsets.only(
                                      //       left: 30, top: 10, right: 0),
                                      //   child: IconButton(
                                      //     splashColor: Colors.white,
                                      //     iconSize: 32,
                                      //     onPressed: () {},
                                      //     icon: Image.asset(
                                      //       'assets/icons/search.png',
                                      //       width: 25,
                                      //       height: 25,
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          body: Stack(children: [
                            Container(
                              height: size.height,
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
                                ? products.isEmpty
                                    ? _buildEmpty()
                                    : Column(
                                        children: [
                                          Container(
                                            height: width * 1.2,
                                            width: width,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: thirdColor.withOpacity(0),
                                              // border: Border.all(
                                              //     color: Colors.white)
                                            ),
                                            child: ListView.builder(
                                              physics:
                                                  const AlwaysScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                return CardForOrder(
                                                  image: products[index].image,
                                                  title: products[index].name,
                                                  width: width * 0.7,
                                                  height: height * 0.7,
                                                  weight:
                                                      products[index].weight,
                                                  price: products[index].price,
                                                  categoryname: products[index]
                                                      .categoryname,
                                                  productid:
                                                      products[index].productId,
                                                  available:
                                                      products[index].available,
                                                  count: products[index]
                                                      .orderedQuantity,
                                                );
                                              },
                                              itemCount: products.length,
                                            ),
                                          ),
                                          SizedBox(
                                            height: width * 0.1,
                                          ),
                                          TextButton(
                                            onPressed: () async {},
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.white),
                                                foregroundColor:
                                                    MaterialStateProperty.all(
                                                        secondColor),
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                10),
                                                        side: BorderSide(
                                                            color:
                                                                secondColor)))),
                                            child: Text(
                                              "Total Price : $Total_Price\$",
                                              style: TextStyle(
                                                  color: secondColor,
                                                  fontSize: width * 0.05),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              // await makePayment();
                                              // print(
                                              //     "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ");
                                              {
                                                List<mineproduct> temp =
                                                    confirmproducts();
                                                int temo = await addorder(
                                                    temp, Total_Price);
                                                if (temo == 1) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content: Stack(
                                                      children: [
                                                        Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    16),
                                                            height: 90,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.green,
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          20)),
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 48,
                                                                ),
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                          "Amazing!"),
                                                                      Text(
                                                                        "Congratulations, your Order is being processed.",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              12,
                                                                        ),
                                                                        maxLines:
                                                                            2,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            )),
                                                      ],
                                                    ),
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    backgroundColor: Colors
                                                        .white
                                                        .withOpacity(0),
                                                    elevation: 0,
                                                  ));
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content: Stack(
                                                      children: [
                                                        Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    16),
                                                            height: 90,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  secondColor,
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          20)),
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 48,
                                                                ),
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                          "Oh snap!"),
                                                                      Text(
                                                                        "Do not worry, the error is not yours. Please try again later or contact the administrators.",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              12,
                                                                        ),
                                                                        maxLines:
                                                                            2,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            )),
                                                      ],
                                                    ),
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    backgroundColor: Colors
                                                        .white
                                                        .withOpacity(0),
                                                    elevation: 0,
                                                  ));
                                                }
                                                products = [];
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const ShoppingCartScreen()));
                                              }
                                              if (paid == "successfully") {
                                                // print(
                                                //     "11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111");
                                                // List<mineproduct> temp =
                                                //     confirmproducts();
                                                // int temo = await addorder(
                                                //     temp, Total_Price);
                                                // if (temo == 1) {
                                                //   ScaffoldMessenger.of(context)
                                                //       .showSnackBar(SnackBar(
                                                //     content: Stack(
                                                //       children: [
                                                //         Container(
                                                //             padding:
                                                //                 EdgeInsets.all(
                                                //                     16),
                                                //             height: 90,
                                                //             decoration:
                                                //                 BoxDecoration(
                                                //               color:
                                                //                   secondColor,
                                                //               borderRadius: BorderRadius
                                                //                   .all(Radius
                                                //                       .circular(
                                                //                           20)),
                                                //             ),
                                                //             child: Row(
                                                //               children: [
                                                //                 SizedBox(
                                                //                   width: 48,
                                                //                 ),
                                                //                 Expanded(
                                                //                   child: Column(
                                                //                     crossAxisAlignment:
                                                //                         CrossAxisAlignment
                                                //                             .start,
                                                //                     children: [
                                                //                       Text(
                                                //                           "Amazing!"),
                                                //                       Text(
                                                //                         "Congratulations, your application is being processed.",
                                                //                         style:
                                                //                             TextStyle(
                                                //                           color:
                                                //                               Colors.white,
                                                //                           fontSize:
                                                //                               12,
                                                //                         ),
                                                //                         maxLines:
                                                //                             2,
                                                //                         overflow:
                                                //                             TextOverflow.ellipsis,
                                                //                       ),
                                                //                     ],
                                                //                   ),
                                                //                 )
                                                //               ],
                                                //             )),
                                                //       ],
                                                //     ),
                                                //     behavior: SnackBarBehavior
                                                //         .floating,
                                                //     backgroundColor: Colors
                                                //         .white
                                                //         .withOpacity(0),
                                                //     elevation: 0,
                                                //   ));
                                                // } else {
                                                //   ScaffoldMessenger.of(context)
                                                //       .showSnackBar(SnackBar(
                                                //     content: Stack(
                                                //       children: [
                                                //         Container(
                                                //             padding:
                                                //                 EdgeInsets.all(
                                                //                     16),
                                                //             height: 90,
                                                //             decoration:
                                                //                 BoxDecoration(
                                                //               color:
                                                //                   secondColor,
                                                //               borderRadius: BorderRadius
                                                //                   .all(Radius
                                                //                       .circular(
                                                //                           20)),
                                                //             ),
                                                //             child: Row(
                                                //               children: [
                                                //                 SizedBox(
                                                //                   width: 48,
                                                //                 ),
                                                //                 Expanded(
                                                //                   child: Column(
                                                //                     crossAxisAlignment:
                                                //                         CrossAxisAlignment
                                                //                             .start,
                                                //                     children: [
                                                //                       Text(
                                                //                           "Oh snap!"),
                                                //                       Text(
                                                //                         "Do not worry, the error is not yours. Please try again later or contact the administrators.",
                                                //                         style:
                                                //                             TextStyle(
                                                //                           color:
                                                //                               Colors.white,
                                                //                           fontSize:
                                                //                               12,
                                                //                         ),
                                                //                         maxLines:
                                                //                             2,
                                                //                         overflow:
                                                //                             TextOverflow.ellipsis,
                                                //                       ),
                                                //                     ],
                                                //                   ),
                                                //                 )
                                                //               ],
                                                //             )),
                                                //       ],
                                                //     ),
                                                //     behavior: SnackBarBehavior
                                                //         .floating,
                                                //     backgroundColor: Colors
                                                //         .white
                                                //         .withOpacity(0),
                                                //     elevation: 0,
                                                //   ));
                                                // }
                                                // products = [];
                                                // Navigator.pushReplacement(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //         builder: (context) =>
                                                //             const ShoppingCartScreen()));
                                              }
                                            },
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        secondColor),
                                                foregroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.white),
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                10),
                                                        side: BorderSide(
                                                            color:
                                                                secondColor)))),
                                            child: Text(
                                              //  Total Price : $Total_Price\$
                                              "              Pay              ",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: width * 0.05),
                                            ),
                                          ),
                                        ],
                                      )
                                : YouDoNotHavePermission()
                          ])))
                ],
              )
            : const NoInternet(),
      ),
    );
  }

  Future<void> makePayment() async {
    try {
      paymentIntent =
          await createPaymentIntent('${Total_Price.toInt()}', 'USD');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  style: ThemeMode.dark,
                  merchantDisplayName: 'Ahmad'))
          .then((value) {});
      displayPaymentSheet();
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        // showNotification();
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                    Text("Payment Successful"),
                  ],
                ),
              ],
            ),
          ),
        );
        print(
            "HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH");
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("paid successfully")));
        {
          List<mineproduct> temp = confirmproducts();
          int temo = await addorder(temp, Total_Price);
          if (temo == 1) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Stack(
                children: [
                  Container(
                      padding: EdgeInsets.all(16),
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 48,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Amazing!"),
                                Text(
                                  "Congratulations, your Order is being processed.",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
                ],
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.white.withOpacity(0),
              elevation: 0,
            ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Stack(
                children: [
                  Container(
                      padding: EdgeInsets.all(16),
                      height: 90,
                      decoration: BoxDecoration(
                        color: secondColor,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 48,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Oh snap!"),
                                Text(
                                  "Do not worry, the error is not yours. Please try again later or contact the administrators.",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
                ],
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.white.withOpacity(0),
              elevation: 0,
            ));
          }
          products = [];
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const ShoppingCartScreen()));
        }
        paymentIntent = null;
      }).onError((error, stackTrace) {
        print('Error is:--->$error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('$e');
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $SECRET_KEY',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      // ignore: avoid_print
      print('Payment Intent Body->>> ${response.body.toString()}');

      return jsonDecode(response.body);
    } catch (err) {
      // ignore: avoid_print
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
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

  double sumprice() {
    int i = 0;
    double sum = 0;
    while (i < products.length) {
      sum += (products[i].orderedQuantity) * (products[i].price);
      i++;
    }
    return sum;
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
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
              "Your Cart IS Empty.\nPleas Add A Few Products.",
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
}

class CardForOrder extends StatefulWidget {
  const CardForOrder(
      {super.key,
      required this.productid,
      required this.image,
      required this.title,
      required this.width,
      required this.height,
      required this.weight,
      required this.price,
      required this.categoryname,
      required this.available,
      required this.count});

  final String image, title, categoryname;
  final double width, height;
  final num weight, price, available;
  final int productid, count;
  @override
  State<CardForOrder> createState() => _CardForOrderState(
      image: image,
      title: title,
      width: width,
      height: height,
      weight: weight,
      price: price,
      categoryname: categoryname,
      productid: productid,
      available: available,
      count: count);
}

class _CardForOrderState extends State<CardForOrder> {
  _CardForOrderState(
      {required this.image,
      required this.productid,
      required this.title,
      required this.width,
      required this.height,
      required this.weight,
      required this.price,
      required this.categoryname,
      required this.count,
      required this.available});
  bool lovSelected = false;
  int count = 0, productid;
  num available;
  final String image, title, categoryname;
  double width, height;
  @override
  void initState() {
    super.initState();
  }

  void _increment() {
    setState(() {
      count++;
    });
  }

  void _decrement() {
    if (count > 0) {
      setState(() {
        count--;
      });
    }
  }

  num weight, price;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet<void>(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          )),
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return bottomSheet(context);
          },
        );
      },
      child: SizedBox(
        width: width,
        height: width * 0.70,
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 30,
              top: 48,
              child: Container(
                width: width * 1.25,
                height: width * 0.45,
                decoration: BoxDecoration(boxShadow: const [
                  BoxShadow(color: Colors.white, spreadRadius: 1, blurRadius: 8)
                ], color: thirdColor, borderRadius: BorderRadius.circular(15)),
                child: Stack(
                  children: [
                    Positioned(
                        top: width * 0.04,
                        left: width * 0.38,
                        child: SizedBox(
                          height: width * 0.1,
                          width: width * 0.5,
                          child: Text(
                            title,
                            style: TextStyle(
                                color: darkGrey, fontSize: width * 0.06),
                          ),
                        )),
                    Positioned(
                        top: width * 0.04,
                        left: width,
                        child: SizedBox(
                          height: width * 0.1,
                          width: width * 0.2,
                          child: Text(
                            "\$$price",
                            style: TextStyle(
                                color: darkGrey, fontSize: width * 0.05),
                          ),
                        )),
                    Positioned(
                      top: width * 0.225,
                      left: width * 0.35,
                      child: Row(
                        children: [
                          FloatingActionButton.small(
                              heroTag: null,
                              backgroundColor: Colors.white,
                              onPressed: _increment,
                              child: Icon(
                                Icons.add,
                                size: width * 0.1,
                                color: darkGrey,
                              )),
                          Container(
                            width: width * 0.2,
                            height: width * 0.1,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                                color: Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
                            child: Center(
                              child: Text(
                                "$count",
                                style: const TextStyle(color: darkGrey),
                              ),
                            ),
                          ),
                          FloatingActionButton.small(
                              heroTag: null,
                              backgroundColor: Colors.white,
                              onPressed: _decrement,
                              child: Icon(
                                Icons.remove,
                                size: width * 0.1,
                                color: darkGrey,
                              )),
                        ],
                      ),
                    ),
                    Positioned(
                        top: width * 0.225,
                        left: width * 0.98,
                        child: SizedBox(
                          width: width * 0.2,
                          height: width * 0.2,
                          child: FloatingActionButton(
                              heroTag: null,
                              elevation: 0,
                              backgroundColor: thirdColor,
                              child: Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: width * 0.13,
                              ),
                              onPressed: () {
                                products.removeWhere((element) =>
                                    element.productId == productid);
                              }),
                        ))
                  ],
                ),
              ),
            ),
            Positioned(
                left: 15,
                top: 23,
                child: Container(
                  width: width * 0.39,
                  height: width * 0.30,
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.white, spreadRadius: 1, blurRadius: 8)
                      ],
                      gradient: const LinearGradient(
                        colors: [secondColor, thirdColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20)),
                )),
            Positioned(
                // top: 0,
                left: 25,
                child: Image(
                  image: AssetImage("assets/images/$image"),
                  width: width * 0.30,
                  height: width * 0.30,
                )),
          ],
        ),
      ),
    );
  }

  // String lovAsset = "assets/images/65.png";
  Widget bottomSheet(BuildContext context) {
    return StatefulBuilder(builder: (context, state) {
      return Container(
        height: height * 0.9,
        width: width,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Column(
          children: [
            SizedBox(
              width: width * 1.5,
              height: width * 0.6,
              // color: Colors.red,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 30,
                    top: 48,
                    child: Container(
                      width: width * 1.2,
                      height: width * 0.35,
                      decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.white,
                                spreadRadius: 1,
                                blurRadius: 8)
                          ],
                          color: thirdColor,
                          borderRadius: BorderRadius.circular(15)),
                      child: Stack(
                        children: [
                          Positioned(
                              top: width * 0.04,
                              left: width * 0.35,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: width * 0.08,
                                    width: width * 0.4,
                                    // color: Colors.amber,
                                    child: Text(
                                      title,
                                      style: TextStyle(
                                          color: darkGrey,
                                          fontSize: width * 0.05,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                  SizedBox(
                                    height: width * 0.03,
                                  ),
                                  SizedBox(
                                    height: width * 0.08,
                                    width: width * 0.3,
                                    // color: Colors.red,
                                    child: Text(
                                      categoryname,
                                      style: TextStyle(
                                          color: darkGrey,
                                          fontSize: width * 0.04,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: width * 0.5,
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          height: width * 0.08,
                                          width: width * 0.2,
                                          // color: Colors.pink,
                                          child: Text(
                                            "$weight Kg",
                                            style: TextStyle(
                                                color: darkGrey,
                                                fontSize: width * 0.05),
                                          ),
                                        ),
                                        SizedBox(
                                          height: width * 0.08,
                                          width: width * 0.2,
                                          // color: Colors.blue,
                                          child: Text(
                                            "$price\$",
                                            style: TextStyle(
                                                color: darkGrey,
                                                fontSize: width * 0.05),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      left: width * 0.05,
                      top: width * 0.13,
                      child: Container(
                        width: width * 0.35,
                        height: width * 0.25,
                        decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.white,
                                  spreadRadius: 1,
                                  blurRadius: 8)
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
                      left: width * 0.095,
                      child: Image(
                        image: AssetImage("assets/images/$image"),
                        width: width * 0.26,
                        height: width * 0.26,
                      )),
                ],
              ),
            ),
            SizedBox(
                width: width * 1.5,
                height: width * 0.2,
                // color: Colors.amber,
                child: Padding(
                  padding: EdgeInsets.only(left: width * 0.35),
                  child: Row(
                    children: [
                      Container(
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
                          backgroundColor: Colors.white.withOpacity(0),
                          child: Icon(
                            Icons.add,
                            size: width * 0.1,
                            color: darkGrey,
                          ),
                          onPressed: () {
                            setState(() {
                              updated(state);
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: width * 0.07,
                      ),
                      Container(
                        width: width * 0.2,
                        height: width * 0.13,
                        decoration: BoxDecoration(
                            border: Border.all(color: secondColor, width: 2),
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5))),
                        child: Center(
                          child: Text(
                            "$count",
                            style: const TextStyle(color: darkGrey),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width * 0.07,
                      ),
                      Container(
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
                          backgroundColor: Colors.white.withOpacity(0),
                          child: Icon(
                            Icons.remove,
                            size: width * 0.1,
                            color: darkGrey,
                          ),
                          onPressed: () {
                            setState(() {
                              dedated(state);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                )),
            SizedBox(
                height: width * 0.2,
                width: width * 1.5,
                // color: Colors.orange,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: width * 0.38,
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Total Weight :",
                        style:
                            TextStyle(color: darkGrey, fontSize: width * 0.05),
                      ),
                      SizedBox(
                        width: width * 0.2,
                      ),
                      Text(
                        "${count * weight}Kg",
                        style: TextStyle(
                            color: darkGrey.withOpacity(0.5),
                            fontSize: width * 0.05),
                      ),
                    ],
                  ),
                )),
            SizedBox(
                height: width * 0.2,
                width: width * 1.5,
                // color: Colors.blue,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: width * 0.38,
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Total Amount :",
                        style:
                            TextStyle(color: darkGrey, fontSize: width * 0.05),
                      ),
                      SizedBox(
                        width: width * 0.2,
                      ),
                      Text(
                        "${count * price}\$",
                        style: TextStyle(
                            color: darkGrey.withOpacity(0.5),
                            fontSize: width * 0.05),
                      ),
                    ],
                  ),
                )),
            SizedBox(
              height: width * 0.2,
            ),
            SizedBox(
                height: width * 0.2,
                width: width * 1.2,
                // color: Colors.pink,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: width * 0.04,
                  ),
                )),
          ],
        ),
      );
    });
  }

  Future<void> updated(StateSetter updateState) async {
    updateState(() {
      _increment();
    });
  }

  Future<void> dedated(StateSetter dedateState) async {
    dedateState(() {
      _decrement();
    });
  }
}
