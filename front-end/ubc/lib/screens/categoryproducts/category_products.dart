import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../shoppingcart/shoppingcartsceen.dart';
import 'dart:convert';
import '../../constant/constants.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/no_internet_connection.dart';
import '/model/product_model.dart';
import 'package:http/http.dart' as http;
import '/model/product_order.dart';

Box productid = Hive.box('productid');
Box quantity = Hive.box('quantity');
List<ProductOrder> products = [];

class CategoryProducts extends StatefulWidget {
  static const String routeName = "/categoryproducts";
  CategoryProducts(
      {Key? key, required this.categoryname, required this.categoryid})
      : super(key: key);
  String categoryname;
  int categoryid = -1;
  @override
  State<CategoryProducts> createState() => _CategoryProductsState(
      categoryname: this.categoryname, categoryid: this.categoryid);
}

class _CategoryProductsState extends State<CategoryProducts> {
  _CategoryProductsState(
      {required this.categoryname, required this.categoryid});
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 0;
  // int _count = 0;
  String categoryname;
  int categoryid;
  late bool isDrawerOpen;
  @override
  void initState() {
    super.initState();
    checkConnectivity();
    xOffset = yOffset = 0.0;
    scaleFactor = 1.0;
    isDrawerOpen = false;
  }

  late StreamSubscription subscription;
  late bool isDeviceConnected = true;
  @override
  Widget build(BuildContext context) {
    Future<List<dynamic>> getproductsofcategories() async {
      var response;
      response = await http.get(
        Uri.parse('${url}guest/viewCategoryInProductForCustomer/$categoryid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
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
                                              categoryname,
                                              style: TextStyle(
                                                  color: darkGrey,
                                                  fontSize: width * 0.07),
                                            )),
                                      ),
                                      // Padding(
                                      //   padding: const EdgeInsets.only(
                                      //       left: 0, top: 10, right: 0),
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
                                      Padding(
                                        padding:  EdgeInsets.only(
                                            left: width * 0.1, top: width * 0.026),
                                        child: IconButton(
                                          splashColor: Colors.white,
                                          iconSize: 32,
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ShoppingCartScreen()),
                                            );
                                          },
                                          icon: Image.asset(
                                            'assets/icons/shopping-cart.png',
                                            width: 25,
                                            height: 25,
                                          ),
                                        ),
                                      )
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
                            FutureBuilder(
                                future: getproductsofcategories(),
                                builder: (buildContext, snapshot) {
                                  if (snapshot.hasError) {
                                    return Center(
                                        child: Text("${snapshot.error}"));
                                  }

                                  if (!snapshot.hasData) {
                                    return _buildEmpty();
                                    // return const Center(
                                    //     child: CircularProgressIndicator());
                                  } else {
                                    var items = snapshot.data as List<dynamic>;
                                    return ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: items.length,
                                      itemBuilder: (buildContext, index) =>
                                          TheCard_for_child(
                                        image: items[index].image,
                                        title: items[index].name,
                                        width: width * 0.7,
                                        height: height * 0.7,
                                        weight: items[index].weight,
                                        price: items[index].price,
                                        categoryname: categoryname,
                                        productid: items[index].id,
                                        available: items[index].available,
                                      ),
                                    );
                                  }
                                }),
                          ])))
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
              "Sorry, this category does not contain any products.",
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

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}

class TheCard_for_child extends StatefulWidget {
  const TheCard_for_child(
      {super.key,
      required this.productid,
      required this.image,
      required this.title,
      required this.width,
      required this.height,
      required this.weight,
      required this.price,
      required this.categoryname,
      required this.available});

  final String image, title, categoryname;
  final double width, height;
  final num weight, price, available;
  final int productid;
  @override
  State<TheCard_for_child> createState() => _TheCard_for_childState(
      image: image,
      title: title,
      width: width,
      height: height,
      weight: weight,
      price: price,
      categoryname: categoryname,
      productid: productid,
      available: available);
}

class _TheCard_for_childState extends State<TheCard_for_child> {
  _TheCard_for_childState(
      {required this.image,
      required this.productid,
      required this.title,
      required this.width,
      required this.height,
      required this.weight,
      required this.price,
      required this.categoryname,
      required this.available});
  bool lovSelected = false;
  int _count = 0, productid;
  num available;
  final String image, title, categoryname;
  double width, height;
  @override
  void initState() {
    super.initState();
  }

  void _increment() {
    setState(() {
      _count++;
    });
  }

  void _decrement() {
    if (_count > 0) {
      setState(() {
        _count--;
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
                      left: width * 0.33,
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
                                "$_count",
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
                              child: Image.asset(
                                "assets/icons/add-to-cart.png",
                                width: width * 0.12,
                                height: width * 0.12,
                              ),
                              onPressed: () {
                                products.add(ProductOrder(
                                    productId: productid,
                                    orderedQuantity: _count,
                                    available: available,
                                    image: image,
                                    name: title,
                                    price: price,
                                    weight: weight,
                                    categoryname: categoryname));
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
                            "$_count",
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
                        "${_count * weight}Kg",
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
                        "${_count * price}\$",
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
                  child: Row(
                    children: [
                      Container(
                        height: width * 0.25,
                        width: width * 0.25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              20), // make sure the borderRadius matches the shape of FloatingActionButton
                          border: Border.all(
                            color: secondColor,
                            width: 2.0,
                          ),
                        ),
                        child: FloatingActionButton.small(
                            elevation: 0,
                            heroTag: null,
                            backgroundColor: Colors.white.withOpacity(0),
                            child: Image.asset(
                              'assets/icons/shopping-cart.png',
                              width: 25,
                              height: 25,
                            ),
                            onPressed: () {}),
                      ),
                      SizedBox(
                        width: width * 0.1,
                      ),
                      Container(
                        height: width * 0.2,
                        width: width * 0.8,
                        decoration: BoxDecoration(
                          color: secondColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: FloatingActionButton.small(
                            elevation: 0,
                            heroTag: null,
                            backgroundColor: Colors.white.withOpacity(0),
                            child: Text(
                              "Add To Cart",
                              style: TextStyle(
                                  color: Colors.white, fontSize: width * 0.05),
                            ),
                            onPressed: () async {
                              products.add(ProductOrder(
                                  productId: productid,
                                  orderedQuantity: _count,
                                  available: available,
                                  image: image,
                                  name: title,
                                  price: price,
                                  weight: weight,
                                  categoryname: categoryname));
                            }),
                      ),
                    ],
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
