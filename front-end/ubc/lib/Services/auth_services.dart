import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '/constant/constants.dart';
import 'globals.dart';
import 'package:http/http.dart' as http;

const storage = FlutterSecureStorage();

class AuthServices {
  static Future<http.Response> register(String firstName, String lastName,
      String email, String password, String phoneNum,double targetLatitude ,double targetLongitude) async {
    Map data = {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "password": password,
      "phoneNum": phoneNum,
      "latitude": targetLatitude,
      "longitude": targetLongitude
    };

    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(
      Uri.parse('${url}customer/Register'),
      headers: headers,
      body: json.encode(data),
    );
    // print(
    //     "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    // print("${response.body}");
    // print(":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::");
    // print(json.encode(data));
    // if(response.statusCode == 201)
    // {
    //   Map<String, dynamic> jsonResponse = json.decode(response.body);
    //   String token = jsonResponse['token'];
    //   await _saveToken(token);
    // }
    return response;
  }

  static const storage = FlutterSecureStorage();

  static Future<String> _authenticate(String email, String password) async {
    Map data = {
      "email": email,
      "password": password,
    };
    final response = await http.post(
      Uri.parse('${url}customer/Login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(data),
    );
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
      return true;
    } catch (e) {
      return false;
    }
  }
}
