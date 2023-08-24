import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootbundle;
import '/constant/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DoneOrders extends StatefulWidget {
  const DoneOrders({super.key});

  @override
  State<DoneOrders> createState() => _DoneOrdersState();
}

class _DoneOrdersState extends State<DoneOrders> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    //******************************** */
    // Future<List<CategorieModel>> getcategories() async {
    //   List<CategorieModel> temp = <CategorieModel>[];
    //   var response1 =
    //       await http.get(Uri.parse('http://127.0.0.1:8000/api/category'));
    //   print(response1.body);
    //   try {
    //     setState(() {
    //       var result = response1.body;
    //       final list = json.decode(result) as List<dynamic>;
    //       print(list);
    //       temp = list.map((e) => CategorieModel.fromjson(e)).toList();
    //     });
    //     return temp;
    //   } catch (exc) {
    //     print(exc);
    //     rethrow;
    //   }
    //   return temp;
    // }

    return Scaffold(
        body: Stack(
      children: [
        Container(
          height: size.height,
          width: width / 4,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 255, 255, 255), Color(0xFF3664F4)],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
        ),
      ],
    ));
  }
}
