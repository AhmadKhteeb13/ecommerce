import 'package:flutter/material.dart';


import '../../constant/constants.dart';
import 'components/forgot_password_body.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static const String routeName = "/forgot_password";
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reset Password"),
        centerTitle: true,
        backgroundColor: secondColor,
      ),
      body: const ForgotPasswordBody(),
    );
  }
}
