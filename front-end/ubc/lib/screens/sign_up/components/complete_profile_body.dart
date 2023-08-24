import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../../../Services/auth_services.dart';
import '../../../Services/globals.dart';
import '../../../constant/constants.dart';
import '../../../constant/form_messages.dart';
import '../../../widgets/custom_page_transition.dart';
import '../../../widgets/custom_suffix_icon.dart';
import '../../../widgets/form_errors.dart';
import '../../../widgets/locationpickermap.dart';
import '../../home/home_screen.dart';
import '../register_screen.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CompleteProfileBody extends StatefulWidget {
  String email = '';
  String password = '';

  CompleteProfileBody({Key? key, required this.email, required this.password})
      : super(key: key);

  @override
  State<CompleteProfileBody> createState() =>
      _CompleteProfileBodyState(email: this.email, password: this.password);
}

class _CompleteProfileBodyState extends State<CompleteProfileBody> {
  _CompleteProfileBodyState({required this.email, required this.password});
  final _formKey = GlobalKey<FormState>();

  final _firstNameFormFieldKey = GlobalKey<FormFieldState>();

  final _lastNameFormFieldKey = GlobalKey<FormFieldState>();

  final _phoneNumberFormFieldKey = GlobalKey<FormFieldState>();

  final _addressFormFieldKey = GlobalKey<FormFieldState>();
  String email = '';
  String password = '';
  FocusNode? lastNameNode, phoneNode, addressNode = FocusNode();

  String? firstName;

  String? lastName;

  String? phoneNumber;

  double targetLatitude = 33.5138;
  double targetLongitude = 36.2765;
  List<String?> errors = [];
  bool servicePermission = false;
  late LocationPermission permission;
  // LatLng _selectedLocation = LatLng(0, 0);
  @override
  void initState() {
    super.initState();
    lastNameNode = FocusNode();
    phoneNode = FocusNode();
    addressNode = FocusNode();
  }

  

  createAccountPressed(String email, String password) async {
    Position currentlocation =
                                await _sendCurrentLocation();
                            targetLatitude = currentlocation.latitude;
                            targetLongitude = currentlocation.longitude;


    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (emailValid) {
      http.Response response = await AuthServices.register(
          firstName!,
          lastName!,
          email,
          password,
          phoneNumber!,
          targetLatitude,
          targetLongitude
          );
      Map responseMap = jsonDecode(response.body);
      if (response.statusCode == 201) {
        const storage = FlutterSecureStorage();
        await storage.write(key: 'email', value: email);
        await storage.write(key: 'password', value: password);
        
      
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else {
        errorSnackBar(context, responseMap.values.first[0]);
      }
    } else {
      errorSnackBar(context, 'email not valid');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final String userName = email.split("@")[0];
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.053 * width),
        child: SingleChildScrollView(
            child: Column(
          children: [
            SizedBox(height: height * 0.08),
            Text(
              "Complete $userName Profile",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 0.074 * width,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2),
            ),
            const Text(
              "Please complete your information",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: height * 0.06),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  children: [
                    firstNameFormField(),
                    SizedBox(height: 0.036 * height),
                    lastNameFormField(),
                    SizedBox(height: 0.036 * height),
                    phoneNumberFormField(),
                    SizedBox(height: 0.036 * height),
                    // SizedBox(
                    //     width: (width / 375) * width,
                    //     height: 0.07 * height,
                    //     child: TextButton(
                    //       style: TextButton.styleFrom(
                    //         shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(10)),
                    //         foregroundColor: Colors.white,
                    //         backgroundColor: secondColor,
                    //       ),
                    //       onPressed: () => openDialog(),
                    //       child: Text(
                    //         "Detect location",
                    //         style: TextStyle(
                    //           fontSize: 0.042 * width,
                    //           color: Colors.white,
                    //         ),
                    //       ),
                    //     )),
                    FormError(errors: errors),
                    SizedBox(height: 0.049 * height),
                    SizedBox(
                        width: (width / 375) * width,
                        height: 0.1 * height,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            foregroundColor: Colors.white,
                            backgroundColor: secondColor,
                          ),
                          onPressed: ()  {
                            
                            createAccountPressed(email, password);
                          }
                          // Navigator.push(
                          //                     context,
                          //                     MaterialPageRoute(
                          //                         builder: (context) =>
                          //                             LocationPickerMap(
                          //                               email: email,
                          //                               password: password,
                          //                               firstName: firstName.toString(),
                          //                               lastName: lastName.toString(),
                          //                               phoneNumber: phoneNumber.toString(),
                          //                             )),
                          //                   )

                          // createAccountPressed(
                          //   email, password)
                          ,
                          child: Text(
                            "continue",
                            style: TextStyle(
                              fontSize: 0.042 * width,
                              color: Colors.white,
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),
            SizedBox(height: 0.036 * height),
            Text(
              "By continuing your confirm that you agree \nwith our Term and Condition",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.caption,
            ),
            SizedBox(height: 0.036 * height),
          ],
        )),
      ),
    );
  }
Future<Position> _sendCurrentLocation() async {
    servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {
      print("service disabled");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return Geolocator.getCurrentPosition();
    
  }
  // Future openDialog() => showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //           title: Text("Your Location"),
  //           content: FlutterMap(
  //             options: MapOptions(
  //               center: _selectedLocation,
  //               zoom: 13.0,
  //               onTap: (tapPosition, latLng) {
  //                 setState(() {
  //                   _selectedLocation = latLng;
  //                 });
  //               },
  //             ),
  //             layers: [
  //               TileLayerOptions(
  //                 urlTemplate:
  //                     "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
  //                 subdomains: ['a', 'b', 'c'],
  //               ),
  //               MarkerLayerOptions(
  //                 markers: [
  //                   Marker(
  //                     width: 40.0,
  //                     height: 40.0,
  //                     point: _selectedLocation,
  //                     builder: (ctx) => Icon(
  //                       Icons.location_pin,
  //                       color: Colors.red,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //           actions: [TextButton(onPressed: () {}, child: Text('Done'))],
  //         ));

  TextFormField phoneNumberFormField() {
    return TextFormField(
      key: _phoneNumberFormFieldKey,
      keyboardType: TextInputType.phone,
      onFieldSubmitted: (newValue) {
        addressNode!.requestFocus();
      },
      focusNode: phoneNode,
      onSaved: (newPhoneNumber) => phoneNumber = newPhoneNumber,
      onChanged: (newPhoneNumber) {
        _phoneNumberFormFieldKey.currentState!.validate();
        phoneNumber = newPhoneNumber;
      },
      validator: (newPhoneNumber) {
        if (newPhoneNumber!.isEmpty) {
          return kPhoneNumberNullError;
        } else if (!phoneNumberValidatorRegExp.hasMatch(newPhoneNumber)) {
          return kValidPhoneNumberError;
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Phone Number",
        hintText: "Enter your phone number",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(svgIconPath: "assets/icons/Phone.svg"),
      ),
    );
  }

  TextFormField firstNameFormField() {
    return TextFormField(
      key: _firstNameFormFieldKey,
      autofocus: true,
      onFieldSubmitted: (value) {
        lastNameNode!.requestFocus();
      },
      onSaved: (newFirstName) => firstName = newFirstName,
      onChanged: (newFirstName) {
        _firstNameFormFieldKey.currentState!.validate();
        firstName = newFirstName;
      },
      validator: (newFirstName) {
        if (newFirstName!.isEmpty) {
          return kFirstNameNullError;
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "First Name",
        hintText: "Enter your first name",
        suffixIcon: CustomSuffixIcon(svgIconPath: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField lastNameFormField() {
    return TextFormField(
      key: _lastNameFormFieldKey,
      onFieldSubmitted: (value) {
        phoneNode!.requestFocus();
      },
      onSaved: (newLastName) => lastName = newLastName,
      onChanged: (newLastName) {
        _lastNameFormFieldKey.currentState!.validate();
        lastName = newLastName;
      },
      focusNode: lastNameNode,
      validator: (newLastName) {
        if (newLastName!.isEmpty) {
          return kLastNameNullError;
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Last Name",
        hintText: "Enter your last name",
        suffixIcon: CustomSuffixIcon(svgIconPath: "assets/icons/User.svg"),
      ),
    );
  }
}
