import 'package:flutter/services.dart' as rootbundle;
import 'dart:convert';

class CategorieModel {
  int? id;
  late String nameCategory, image, created_at, updated_at;
  CategorieModel(
      {this.id,
      required this.nameCategory,
      required this.created_at,
      required this.updated_at,
      required this.image});
  CategorieModel.fromjson(Map<String, dynamic> json) {
    id = json["id"];
    nameCategory = json["nameCategory"];
    image = json["image"];
    created_at = json["created_at"];
    updated_at = json["updated_at"];
  }
}

Future<List<CategorieModel>> readCategorieJsonData(namejsonfile) async {
  final jsondata =
      await rootbundle.rootBundle.loadString(namejsonfile.toString());
  final list = json.decode(jsondata) as List<dynamic>;

  return list.map((e) => CategorieModel.fromjson(e)).toList();
}
