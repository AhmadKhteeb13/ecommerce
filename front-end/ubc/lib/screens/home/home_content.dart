import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '../../constant/constants.dart';
import '../../model/categorie_model.dart';
import '../../widgets/card_for_carousel.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../widgets/the_card.dart';
import '../../widgets/title_with_btn.dart';
import '../barcode/scan.dart';
import '../categoryproducts/category_products.dart';
import '../categoryproducts/new_products.dart';
import '../categoryproducts/trending_products.dart';
import '../profile/profile_view.dart';
import '../shoppingcart/shoppingcartsceen.dart';
import '/model/product_model.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  late double xOffset, yOffset, scaleFactor;
  late bool isDrawerOpen;
  List<Widget> pages = [
    const HomeView(),
    const ProfileView(),
  ];
  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    xOffset = yOffset = 0.0;
    scaleFactor = 1.0;
    isDrawerOpen = false;
  }

  int currentIndex = 0;
  Widget currentScreen = const HomeView();
  final PageStorageBucket bucket = PageStorageBucket();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return AnimatedContainer(
        transform: Matrix4.translationValues(xOffset, yOffset, 0.0)
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
                    padding: const EdgeInsets.only(left: 0, top: 10),
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
                SizedBox(
                  width: width * 0.75,
                  height: width * 0.25,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 0, left: width * 0.17),
                        child: Stack(
                          children: [
                            Positioned(
                                child: SizedBox(
                              width: width * 0.15,
                              child: const FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  "UBC",
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
                                color: secondColor.withOpacity(0.2),
                              ),
                            )
                          ],
                        ),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.only(left: width * 0.15, top: 10),
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
                        padding:  EdgeInsets.only(left: width * 0.25, top: width * 0.026),
                        child: IconButton(
                          splashColor: Colors.white,
                          iconSize: 32,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ShoppingCartScreen()),
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
          body: PageStorage(
            bucket: bucket,
            child: currentScreen,
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: secondColor,
              child: const Icon(Icons.barcode_reader, color: Colors.white,),
              onPressed: () {
                // Navigator.of(context).push(
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const ScanPage(title: 'Flutter BLE Example')),
                );
              }),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
              shape: const CircularNotchedRectangle(),
              notchMargin: 10,
              child: SizedBox(
                height: 60,
                child: Row(children: [
                  SizedBox(
                    width: width * 0.1,
                    height: 2,
                  ),
                  MaterialButton(
                    minWidth: width * 0.111,
                    onPressed: () {
                      setState(() {
                        currentScreen = const HomeView();
                        currentIndex = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          AntDesign.home,
                          // CupertinoIcons.house_fill,
                          // Icons.home,
                          color: currentIndex == 0 ? secondColor : Colors.grey,
                        ),
                        Text(
                          "Home",
                          style: TextStyle(
                              color: currentIndex == 0
                                  ? secondColor
                                  : Colors.grey),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: width * 0.35,
                    height: 2,
                  ),
                  MaterialButton(
                    minWidth: width * 0.111,
                    onPressed: () {
                      setState(() {
                        currentScreen = const ProfileView();
                        currentIndex = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                          child: Image.asset(
                            'assets/icons/persone.png',
                            color:
                                currentIndex == 3 ? secondColor : Colors.grey,
                          ),
                        ),
                        // Icon(
                        //   // Icons.person,
                        //   color: currentIndex == 3 ? Colors.blue : Colors.grey,
                        // ),
                        Text(
                          "My page",
                          style: TextStyle(
                              color: currentIndex == 3
                                  ? secondColor
                                  : Colors.grey),
                        )
                      ],
                    ),
                  ),
                ]),
              )),
        ));
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;

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

    Future<List<dynamic>> getProductTrending() async {
      final response = await http.get(
        Uri.parse('${url}guest/showProductTrending'),
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

    Future<List<dynamic>> getSponsorSlide() async {
      final response = await http.get(
        Uri.parse('${url}guest/showProductFinal'),
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

    return Scaffold(
        body: Stack(
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
        ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            SizedBox(
              height: width * 0.111,
            ),
            SizedBox(
              height: width * 0.6,
              child: FutureBuilder<List<dynamic>>(
                future: getSponsorSlide(),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? SponsorList(
                          list: snapshot.data ?? [],
                        )
                      : const Center(child: CircularProgressIndicator(color: secondColor,));
                },
              ),
            ),
            SizedBox(
              height: width * 0.055,
            ),
            SizedBox(
              height: width * 0.1,
              child: const TitleWithBtn(
                press: "/categoriesscreen",
                title: "CATEGORIES",
                titleofbutton: "More",
              ),
            ),
            SizedBox(
              height: width * 0.055,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                height: width * 0.47,
                child: FutureBuilder(
                  future: getcategories(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text("${snapshot.error}"));
                    } else if (snapshot.hasData) {
                      var items = snapshot.data as List<dynamic>;
                      return GridView.count(
                          crossAxisCount: 1,
                          padding: const EdgeInsets.only(
                              left: 12.0, right: 12.0, top: 8.0),
                          scrollDirection: Axis.horizontal,
                          childAspectRatio: 1.2,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: List.generate(items.length, (index) {
                            return InkWell(
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
                                        builder: (context) => CategoryProducts(
                                              categoryname:
                                                  items[index].nameCategory,
                                              categoryid: items[index].id,
                                            )),
                                  );
                                });
                          }));
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: secondColor,
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            SizedBox(
              height: width * 0.055,
            ),
            SizedBox(
                height: width * 0.1,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: height / 33),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                          height: height / 22,
                          child: Stack(
                            children: [
                              Positioned(
                                child: Text(
                                  "TRENDING",
                                  style: TextStyle(
                                      fontSize: height / 30,
                                      fontWeight: FontWeight.w100,
                                      color: darkGrey),
                                ),
                              ),
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
                          )),
                      const Spacer(),
                      Container(
                        width: width / 4,
                        height: width / 10,
                        decoration: BoxDecoration(
                            color: secondColor.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(20)),
                        child: InkWell(
                          child: Container(
                            width: width,
                            height: height,
                            decoration: BoxDecoration(
                                border: Border.all(color: secondColor),
                                color: secondColor,
                                borderRadius: BorderRadius.circular(20)),
                            child: const Center(
                              child: Text(
                                "More",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TrendingProducts()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )),
            SizedBox(
              height: width * 0.055,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                height: width * 0.47,
                child: FutureBuilder(
                  future: getProductTrending(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text("${snapshot.error}"));
                    } else if (snapshot.hasData) {
                      var items = snapshot.data as List<dynamic>;
                      return GridView.count(
                          crossAxisCount: 1,
                          padding: const EdgeInsets.only(
                              left: 12.0, right: 12.0, top: 8.0),
                          scrollDirection: Axis.horizontal,
                          childAspectRatio: 1,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: List.generate(items.length, (index) {
                            return InkWell(
                              child: TheCard(
                                  image: items[index].image,
                                  title: items[index].name,
                                  width: width * 0.7,
                                  height: height * 0.7),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TrendingProducts()),
                                );
                              },
                            );
                          }));
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: secondColor,
                        ),
                      );
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ],
    ));
  }
}

class SponsorList extends StatefulWidget {
  final List<dynamic> list;
  const SponsorList({super.key, required this.list});

  @override
  _SponsorListState createState() => _SponsorListState();
}

class _SponsorListState extends State<SponsorList> {
  int _current = 0;
  int index = 1;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        CarouselSlider(
          options: CarouselOptions(
            height: width * 0.55,
            aspectRatio: 1.5,
            viewportFraction: 0.9,
            enlargeCenterPage: true,
            autoPlay: true,
            enlargeStrategy: CenterPageEnlargeStrategy.height,
            onPageChanged: (index, _) {
              setState(() {
                _current = index;
              });
            },
          ),
          items: widget.list.map((images) {
            return Builder(builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.all(9),
                child: InkWell(
                  child: CardForCarousel(image: images.image, width: width),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NewProducts(
                              )),
                    );
                  },
                ),
              );
            });
          }).toList(),
        )
      ],
    );
  }
}
