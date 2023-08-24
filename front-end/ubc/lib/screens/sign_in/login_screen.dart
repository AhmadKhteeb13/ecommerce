import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../constant/constants.dart';
import '../../constant/form_messages.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_circle.dart';
import '../../widgets/custom_page_transition.dart';
import '../forgot_password/forgot_password_screen.dart';
import '../home/home_screen.dart';
import '../sign_up/register_screen.dart';
import '/Services/auth_services.dart';
import '/Services/globals.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = "/login";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '';
  String password = '';

  loginPressed() async {
    if (email.isNotEmpty && password.isNotEmpty) {
      bool response = await AuthServices.login(email, password);
      if (response) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const HomeScreen(),
            ));
      } else {
        // errorSnackBar(context, responseMap.values.first);
      }
    } else {
      errorSnackBar(context, 'enter all required fields');
    }
  }

  final _formKey = GlobalKey<FormState>();
  final _emailFormFieldKey = GlobalKey<FormFieldState>();
  final _passwordFormFieldKey = GlobalKey<FormFieldState>();
  late FocusNode passwordFocusNode;
  String paswordFieldSuffixText = "Show";
  bool _obscureText = true;
  @override
  void initState() {
    super.initState();
    passwordFocusNode = FocusNode();
  }

  Future<bool> attemptLogIn(emailo, passwordo) async {
    var res = await AuthServices.login(emailo, passwordo);
    return res;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SingleChildScrollView(
      reverse: true,
      child: Column(
        children: [
          Container(
              width: width,
              height: width * 0.7,
              decoration: BoxDecoration(
                color: secondColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: width * 0.2,
                    ),
                    Text(
                      "Welcome Back\n",
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: width * 0.08,
                          color: Colors.white),
                    ),
                    // SizedBox(
                    //   height: width * 0.15,
                    // ),
                    Text("Login",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.08)),
                  ],
                ),
              )),
          SizedBox(
            height: width * 0.1,
          ),
          Container(
            width: width * 0.8,
            height: width,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.02,
                  ),
                  emailFormField(),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  passwordFormField(),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () => Navigator.push(
                          context,
                          CustomScaleTransition(
                              nextPageUrl: ForgotPasswordScreen.routeName,
                              nextPage: const ForgotPasswordScreen())),
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                            color: secondColor,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  CustomButton(
                      title: "Login",
                      backgroundColor: secondColor,
                      forgroundColor: Colors.white,
                      width: width * 0.85,
                      onPressed: () async {
                        var logincheck = await attemptLogIn(email, password);
                        if (logincheck) {
                          const storage = FlutterSecureStorage();

                          await storage.write(key: 'email', value: email);
                          await storage.write(key: 'password', value: password);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()));
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => const HomeScreen()));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Stack(
                              children: [
                                Container(
                                    padding: EdgeInsets.all(16),
                                    height: 90,
                                    decoration: BoxDecoration(
                                      color: secondColor,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 48,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Oh snap!"),
                                              Text(
                                                "Some thing wrong.",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    )),
                              ],
                            ),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.white.withOpacity(0),
                            elevation: 0,
                          ));

                          // print(
                          //     "An Error Occurred No account was found matching that username and password");
                        }
                      }),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.push(
                            context,
                            CustomScaleTransition(
                                nextPageUrl: RegisterScreen.routeName,
                                nextPage: const RegisterScreen())),
                        child: const Text(
                          "Create an account?  ",
                          style: TextStyle(
                              color: secondColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: width * 0.2,
                      ),
                      InkWell(
                        onTap: () async{
                          await storage.write(key: 'jwt_token', value: "");
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const HomeScreen(),
                              ));
                        },
                        child: const Text(
                          "guest?",
                          style: TextStyle(
                              color: secondColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  TextFormField emailFormField() {
    return TextFormField(
      cursorColor: Colors.red,
      key: _emailFormFieldKey,
      onSaved: (newEmail) {
        setState(() {
          email = newEmail!;
        });
      },
      onChanged: (newEmail) {
        _emailFormFieldKey.currentState!
            .validate(); // call emailFormField validator
      },
      onFieldSubmitted: (newEmail) {
        passwordFocusNode.requestFocus();
      },
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
          // fillColor: Colors.amber,
          // focusColor: Colors.green,
          // hoverColor: Colors.orange,
          labelText: "Email",
          hintText: "Enter your email"),
      validator: (newEmail) {
        setState(() {
          email = newEmail!;
        });
        if (newEmail!.isEmpty) {
          return kEmailNullError;
        } else if (!emailValidatorRegExp.hasMatch(newEmail)) {
          return kInvalidEmailError;
        }
        return null;
      },
    );
  }

  TextFormField passwordFormField() {
    return TextFormField(
      key: _passwordFormFieldKey,
      focusNode: passwordFocusNode,
      onSaved: (newPassword) {
        setState(() {
          password = newPassword!;
        });
      },
      onChanged: (newPassword) {
        _passwordFormFieldKey.currentState!
            .validate(); // call passowrd field validator
      },
      keyboardType: TextInputType.visiblePassword,
      obscureText: _obscureText,
      decoration: InputDecoration(
          labelText: "Password",
          hintText: "Enter your password",
          suffixIcon: TextButton(
            child: Text(
              paswordFieldSuffixText,
              style: const TextStyle(color: secondColor),
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
                paswordFieldSuffixText =
                    (paswordFieldSuffixText == "Show") ? "Hide" : "Show";
              });
            },
          )),
      validator: (newPassword) {
        setState(() {
          password = newPassword!;
        });
        if (newPassword!.isEmpty) {
          return kPasswordNullError;
        } else if (newPassword.length < 8) {
          return kShortPasswordError;
        }
        return null;
      },
    );
  }

  @override
  void dispose() {
    passwordFocusNode.dispose();
    super.dispose();
  }
}

class ScreenArgs {
  final String email;
  final String password;
  const ScreenArgs({required this.email, required this.password});
}

class RoundedButton extends StatelessWidget {
  final String btnText;
  final Function onBtnPressed;

  const RoundedButton(
      {Key? key, required this.btnText, required this.onBtnPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      color: Colors.black,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        onPressed: () {
          onBtnPressed();
        },
        minWidth: 320,
        height: 60,
        child: Text(
          btnText,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
/*Row(
                              children: [
                                InkWell(
                                  onTap: () => Navigator.push(
                                      context,
                                      CustomScaleTransition(
                                          nextPageUrl: RegisterScreen.routeName,
                                          nextPage: const RegisterScreen())),
                                  child: const Text(
                                    "Create an account?  ",
                                    style: TextStyle(
                                        color: secondColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.2,
                                ),
                                InkWell(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            const HomeScreen(),
                                      )),
                                  child: const Text(
                                    "guest?",
                                    style: TextStyle(
                                        color: secondColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ), */