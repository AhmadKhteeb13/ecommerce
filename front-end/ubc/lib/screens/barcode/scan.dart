import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/material.dart';
import '/constant/constants.dart';
// import 'globals.dart';
import 'package:http/http.dart' as http;

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final GlobalKey _gLobalkey = GlobalKey();
  QRViewController? controller;
  Barcode? result;
  void qr(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((event) {
      setState(() {
        result = event;
        
      });

    });
    
  }

  Future<void> scanorder(code) async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'jwt_token');
    Map data = {"firstName": code};
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    // final headers = {'Content-Type': 'application/json'};
    final response = await http.post(
      Uri.parse('${url}customer/scanorderbyCustomer'),
      headers: headers,
      body: json.encode(data),
    );
    print(
        "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    print("${response.body}");
    print(":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::");
    print(json.encode(data));
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: height - 50,
              width: width,
              child: QRView(key: _gLobalkey, onQRViewCreated: qr),
            ),
            Center(
              child: (result != null)
                  ? Text('${result!.code}')
                  : const Text('Scan a code'),
            )
          ],
        ),
      ),
    );
  }
}
