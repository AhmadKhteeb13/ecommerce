import 'package:flutter/material.dart';
import '../../constant/constants.dart';
import '../../constant/form_messages.dart';
import '../../widgets/custom_button.dart';
import 'components/complete_profile_body.dart';

class RegisterScreen extends StatefulWidget {
  static String routeName = "/register";
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailFormFieldKey = GlobalKey<FormFieldState>();
  final _passwordFormFieldKey = GlobalKey<FormFieldState>();
  final _confirmPasswordFormFieldKey = GlobalKey<FormFieldState>();
  String confirmedPassword = '';
  String email = '';
  String password = '';
  String name = '';
  late FocusNode passwordFocusNode, confirmPasswordFocusNode;
  @override
  void initState() {
    super.initState();
    passwordFocusNode = FocusNode();
    confirmPasswordFocusNode = FocusNode();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign With Us"),
        centerTitle: true,
        backgroundColor: secondColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Text(
                    "Create an account",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.08,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 2),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  const Text(
                      "Please enter your details or sign up\n with your social media account",
                      textAlign: TextAlign.center),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      emailFormField(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      passwordFormField(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      confirmPasswordFormField(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      CustomButton(
                        title: "Continue",
                        backgroundColor: secondColor,
                        forgroundColor: Colors.white,
                        width: MediaQuery.of(context).size.width * 0.85,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CompleteProfileBody(
                              email: email,
                              password: password,
                            )),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              // const SocialMediaBox()
            ],
          ),
        ),
      ),
    );
  }

  TextFormField emailFormField() {
    return TextFormField(
      key: _emailFormFieldKey,
      onSaved: (newEmail) {
        setState(() {
          email = newEmail!;
        });
      },
      onChanged: (newEmail) {
        _emailFormFieldKey.currentState!.validate();
      },
      onFieldSubmitted: (newEmail) {
        passwordFocusNode.requestFocus();
      },
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
          labelText: "Email",
          hintText: "Enter your email",
          suffixIcon: Icon(Icons.email)),
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
      onChanged: (newPassword) {
        _passwordFormFieldKey.currentState!
            .validate(); // call passowrd field validator
        password = newPassword;
      },
      onFieldSubmitted: (newPassword) {
        confirmPasswordFocusNode.requestFocus();
      },
      keyboardType: TextInputType.visiblePassword,
      obscureText: false,
      decoration: const InputDecoration(
          labelText: "Password",
          hintText: "Enter your password",
          suffixIcon: Icon(Icons.lock)),
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

  TextFormField confirmPasswordFormField() {
    return TextFormField(
      key: _confirmPasswordFormFieldKey,
      focusNode: confirmPasswordFocusNode,
      onChanged: (newPassword) {
        _confirmPasswordFormFieldKey.currentState!
            .validate(); // call confirm passowrd field validator
        confirmedPassword = newPassword;
      },
      keyboardType: TextInputType.visiblePassword,
      obscureText: false,
      decoration: const InputDecoration(
          labelText: "Confrim Password",
          hintText: "Re-Enter your password",
          suffixIcon: Icon(Icons.lock)),
      validator: (newPassword) {
        setState(() {
          password = newPassword!;
        });
        if (newPassword!.isEmpty) {
          return kPasswordNullError;
        } else if (newPassword != password) {
          return kPasswordMatchError;
        }
        return null;
      },
    );
  }

  @override
  void dispose() {
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
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
