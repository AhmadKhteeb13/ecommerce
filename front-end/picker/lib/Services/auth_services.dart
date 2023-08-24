import 'dart:convert';
import '/constant/constants.dart';
import 'globals.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class AuthServices {
  // static Future<http.Response> register(String firstName, String lastName,
  //     String email, String password, String phoneNum) async {
  //   Map data = {
  //     "firstName": firstName,
  //     "lastName": lastName,
  //     "email": email,
  //     "password": password,
  //     "phoneNum": phoneNum
  //   };
  //   var body = json.encode(data);
  //   // print("***************************" + body);
  //   var theurl = Uri.parse(url + 'customer/Register');
  //   http.Response response = await http.post(
  //     theurl,
  //     headers: headers,
  //     body: body,
  //   );
  //   // print("###########################" + response.body.toString());
  //   return response;
  // }

  static final storage = FlutterSecureStorage();

  static Future<String> _authenticate(String email, String password) async {
    // print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
      Map data = {
      "email": email,
      "password": password,
    };
    final response = await http.post(
      Uri.parse(url + 'picker/Login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      
      body: json.encode(data),
    );
    // print("QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ");
    // print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      String token = jsonResponse['token'];
      // print(token + "OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO");
      return token;
    } else {
      throw Exception('Failed to authenticate user.');
    }
  }

  static Future<void> _saveToken(String token) async {
    await storage.write(key: 'jwt_token', value: token);
  }

  static Future<bool> login(String email, String password) async {
    // print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    try {
      String token = await _authenticate(
        email,
        password,
      );
      await _saveToken(token);
      return true;
    } catch (e) {
      // print(e);
      return false;
    }
  }
}
