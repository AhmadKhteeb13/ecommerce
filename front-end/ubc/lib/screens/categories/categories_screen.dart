import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';
import '../../constant/constants.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/no_internet_connection.dart';
import '../../widgets/the_card.dart';
import '../categoryproducts/category_products.dart';
import '/model/categorie_model.dart';
import 'package:http/http.dart' as http;
import '../shoppingcart/shoppingcartsceen.dart';

class CategoriesScreen extends StatefulWidget {
  static const String routeName = "/categoriesscreen";
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
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

  late StreamSubscription subscription;
  late bool isDeviceConnected = true;

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
                                      colors: [
                                        secondColor,
                                        secondColor
                                      ],
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
                                            top: 0, left: width * 0.07),
                                        child: Stack(
                                          children: [
                                            Positioned(
                                                child: SizedBox(
                                              width: width * 0.34,
                                              child: const FittedBox(
                                                fit: BoxFit.fitWidth,
                                                child: Text(
                                                  "Categories",
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
                                      // Padding(
                                      //   padding: EdgeInsets.only(
                                      //       left: width * 0.04, top: 10),
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
                                           left: width * 0.17, top: width * 0.026),
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
                            Padding(
                              padding: EdgeInsets.only(left: width * 0.1),
                              child: FutureBuilder(
                                  future: getcategories(),
                                  builder: (buildContext, snapshot) {
                                    if (snapshot.hasError) {
                                      return Center(
                                          child: Text("${snapshot.error}"));
                                    }

                                    if (!snapshot.hasData) {
                                      return const Center(
                                          child: CircularProgressIndicator(
                                            color: secondColor,
                                          ));
                                    }
                                    var items = snapshot.data as List<dynamic>;
                                    return GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              childAspectRatio: 1,
                                              mainAxisSpacing: height / 16,
                                              crossAxisCount: (snapshot ==
                                                      Orientation.portrait)
                                                  ? 2
                                                  : 2),
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: items.length,
                                      itemBuilder: (buildContext, index) =>
                                          InkWell(
                                        child: TheCard(
                                          image: items[index].image,
                                          title: items[index].nameCategory,
                                          width: width * 0.7,
                                          height: height * 0.7,
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CategoryProducts(
                                                      categoryname: items[index]
                                                          .nameCategory,
                                                      categoryid:
                                                          items[index].id,
                                                    )),
                                          );
                                        },
                                      ),
                                    );
                                  }),
                            )
                          ])))
                ],
              )
            : const NoInternet(),
      ),
    );
  }

  Future<List<dynamic>> getcategories() async {
    final response = await http.get(
      Uri.parse('${url}guest'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      var result = response.body;
      final list = json.decode(result) as Map<String, dynamic>;
      var tot = list["data"];
      return tot.map((e) => CategorieModel.fromjson(e)).toList();
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

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}
