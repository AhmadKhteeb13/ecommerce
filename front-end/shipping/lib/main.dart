import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/screen/splash/splash_screen.dart';

import 'routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Picker',
        theme: ThemeData(
          fontFamily: 'Raleway',
          primarySwatch: Colors.grey
        ),
        initialRoute: SplashScreen.routeName,
        routes: routes);
  }
}
