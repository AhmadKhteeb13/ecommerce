import 'dart:convert';
import '/constant/constants.dart';
import 'globals.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthServices {
  static final storage = FlutterSecureStorage();

  static Future<String> _authenticate(String email, String password) async {
    Map data = {
      "email": email,
      "password": password,
    };
    final response = await http.post(
      Uri.parse('${url}shipping/Login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(data),
    );
    // print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      String token = jsonResponse['token'];
      return token;
    } else {
      throw Exception('Failed to authenticate user.');
    }
  }

  static Future<void> _saveToken(String token) async {
    await storage.write(key: 'jwt_token', value: token);
  }

  static Future<bool> login(String email, String password) async {
    try {
      String token = await _authenticate(
        email,
        password,
      );
      await _saveToken(token);
      print(")))))))))))))))))))))))))))))))))))))))))))))))))))");
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
  // static Future<http.Response> login(String email, String password) async {
  //   Map data = {
  //     "email": email,
  //     "password": password,
  //   };
  //   var body = json.encode(data);
  //   var theurl = Uri.parse(url + 'shipping/Login');
  //   http.Response response = await http.post(
  //     theurl,
  //     headers: headers,
  //     body: body,
  //   );
  //   // print(response.body);
  //   return response;
  // }
}
