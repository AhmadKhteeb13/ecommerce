import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DrawerItem{
  late String title;
  late IconData icon;
  late String pageUrl;
  late bool lastItem;
  DrawerItem({required this.title,required this.icon,required this.pageUrl,required this.lastItem});
}

List<DrawerItem> drawerItems = [
  DrawerItem(title: "Home",icon: FontAwesomeIcons.user,pageUrl: "/home",lastItem: false),
  DrawerItem(title: "Categories",icon: FontAwesomeIcons.user,pageUrl: "/categoriesscreen",lastItem: false),
  DrawerItem(title: "My Orders",icon: Icons.shopping_cart_outlined,pageUrl: "/order",lastItem: false),
  // DrawerItem(title: "Notifications",icon: Icons.notifications_active_outlined,pageUrl: "/notifications",lastItem: false),
  DrawerItem(title: "About",icon: Icons.settings,pageUrl: "/about",lastItem: true),
];