import 'package:flutter/material.dart';
import '../screens/sign_in/login_screen.dart';
import '../constant/constants.dart';
import 'circle.dart';
import 'drawer_item.dart';
import 'drawer_menu_item.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.white,
      child: ListView(children: [
        SizedBox(
          height: height * 0.2,
          child: Stack(
            children: [
              // Positioned(
              //     top: 0.123 * height,
              //     right: 0.106 * width,
              //     child: Circle(
              //       width: 0.072 * width,
              //       height: 0.033 * height,
              //       borderWidth: 6,
              //     )),
              // Positioned(
              //     top: -0.061 * height,
              //     right: 0.133 * width,
              //     child: Circle(
              //       width: 0.33 * width,
              //       height: 0.153 * height,
              //       color: circleColor,
              //     ))
            ],
          ),
        ),
        Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: (MediaQuery.of(context).size.height * 0.4) + 24,
                child: Column(
                    children: drawerItems
                        .map(
                          (drawerItem) => DrawerMenuItem(
                            title: drawerItem.title,
                            icon: drawerItem.icon,
                            lastItem: drawerItem.lastItem,
                            pageUrl: drawerItem.pageUrl,
                          ),
                        )
                        .toList()),
              ),
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: Stack(
            children: [
              // Positioned(
              //     left: 0.4 * width,
              //     child: Circle(
              //       width: 0.072 * width,
              //       height: 0.033 * height,
              //       borderWidth: 6,
              //     )),
              // Positioned(
              //     top: 0.061 * height,
              //     left: 0.08 * width,
              //     child: Circle(
              //       width: 0.3 * width,
              //       height: 0.2 * height,
              //       color: circleColor,
              //     )),
              Positioned.fill(
                top: 0.197 * height,
                left: 0.013 * width,
                child: DrawerMenuItem(
                  title: "Sign out",
                  icon: Icons.logout,
                  lastItem: true,
                  pageUrl: LoginScreen.routeName,
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
