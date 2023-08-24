import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const Map<String, String> headers= {'Content-Type': 'application/json'}; //headers = {"Content-Type": "application/json"};

errorSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.red,
    content: Text(text),
    duration: const Duration(seconds: 1),
  ));
}