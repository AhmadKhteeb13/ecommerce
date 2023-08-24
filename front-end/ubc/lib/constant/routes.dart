import 'package:flutter/cupertino.dart';
import '../screens/about/about_page.dart';
import '../screens/categories/categories_screen.dart';
import '../screens/categoryproducts/category_products.dart';
import '../screens/order/orders_screen.dart';
import '/screens/home/home_screen.dart';
import '/screens/sign_in/login_screen.dart';
import '/screens/sign_up/register_screen.dart';
import '/screens/splash/splash_screen.dart';
var categoryname,categoryid;
final Map<String, WidgetBuilder> routes = {
  HomeScreen.routeName: (context) => const HomeScreen(),
  SplashScreen.routeName: (context) => const SplashScreen(),
  LoginScreen.routeName: (context) => const LoginScreen(),
  RegisterScreen.routeName: (context) => const RegisterScreen(),
  CategoriesScreen.routeName: (context) => const CategoriesScreen(),
  CategoryProducts.routeName: (context) => CategoryProducts(categoryname: categoryname,categoryid: categoryid,),
  OrderScreen.routeName:(context) => const OrderScreen(),
  AboutPage.routeName:(context) => AboutPage(),
};
