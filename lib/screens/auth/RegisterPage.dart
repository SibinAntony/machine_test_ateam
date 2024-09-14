import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/Constants.dart';
import '../../constants/Images.dart';
import '../../constants/color.dart';
import '../../constants/show_custom_snakbar.dart';
import '../home/HomePage.dart';
import '../location/select_location_screen.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key, required this.mobileNumber});

  String mobileNumber;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController controllerMobile = TextEditingController();
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  bool isLoading = false;

  final DatabaseReference submitData =
      FirebaseDatabase.instance.reference().child('users');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controllerMobile.text = widget.mobileNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // mainAxisSize: MainAxisSize.max,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(top: 30),
              height: MediaQuery.of(context).size.width / 2,
              child: Image.asset(
                Images.logo,
                fit: BoxFit.contain,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  top: 0, left: 30, right: 30, bottom: 30),
              child: TextFormField(
                enabled: false,
                controller: controllerMobile,
                decoration: InputDecoration(
                  labelText: "Mobile Number",
                  labelStyle: const TextStyle(color: primaryColor),
                  fillColor: primaryColor,
                  counterText: "",
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(
                      color: primaryColor,
                      width: 2.0,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(
                      color: primaryColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(
                      color: primaryColor,
                    ),
                  ),
                ),
                // autofocus: true,
                keyboardType: TextInputType.number,
                maxLines: 1,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  top: 0, left: 30, right: 30, bottom: 30),
              child: TextFormField(
                controller: controllerName,
                decoration: InputDecoration(
                  labelText: "Enter Full Name",
                  labelStyle: const TextStyle(color: primaryColor),
                  fillColor: primaryColor,
                  counterText: "",
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(
                      color: primaryColor,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(
                      color: primaryColor,
                    ),
                  ),
                ),
                // autofocus: true,
                keyboardType: TextInputType.name,
                maxLines: 1,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  top: 0, left: 30, right: 30, bottom: 30),
              child: TextFormField(
                controller: controllerEmail,
                decoration: InputDecoration(
                  labelText: "Enter Your Email",
                  labelStyle: const TextStyle(color: primaryColor),
                  fillColor: primaryColor,
                  counterText: "",
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(
                      color: primaryColor,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(
                      color: primaryColor,
                    ),
                  ),
                ),
                // autofocus: true,
                keyboardType: TextInputType.emailAddress,
                maxLines: 1,
              ),
            ),
            Stack(
              children: [
                Visibility(
                  visible: !isLoading,
                  child: Container(
                    height: 55,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(
                        top: 20, left: 30, right: 30, bottom: 30),
                    child: TextButton(
                        child: Text("Register".toUpperCase(),
                            style: const TextStyle(fontSize: 14)),
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(primaryColor),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ))),
                        onPressed: () async => {
                              validateNumber()
                              // setStat78787
                            }),
                  ),
                ),
                Visibility(
                  visible: isLoading,
                  child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(
                          top: 20, left: 30, right: 30, bottom: 30),
                      child: const CircularProgressIndicator(
                        color: primaryColor,
                      )),
                )
              ],
            ),
          ],
        ),
      ),
    ));
  }

  validateNumber() {
    if (controllerName.text.isEmpty) {
      showCustomSnackBar("Please enter your name", context);
      return;
    }
    if (controllerEmail.text.isEmpty) {
      showCustomSnackBar("Please enter your email", context);
      return;
    }
    if (!isValidEmail(controllerEmail.text)) {
      showCustomSnackBar("Invalid Email", context);
      return;
    }

    setState(() {
      isLoading = true;
    });

    String? newKey = submitData.push().key;
    Map<String, dynamic> newData = {
      'key': newKey,
      'userName': controllerName.text,
      'mobileNumber': controllerMobile.text,
      'userEmail': controllerEmail.text,
      'userType': '2',
      'isActive': true,
    };
    submitData.child(newKey!).set(newData).then((value) {
      success(newData);

      showCustomSnackBar("User Created Successfully", context, isError: false,isToaster: false);
    }).catchError((error) {
      showCustomSnackBar("${error.toString()}", context, isError: true);
    });
  }

  void saveUserData(Object? value, String newKey) {}

  Future<void> success(Map<String, dynamic> user) async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    sharedPref.setString("userData", jsonEncode(user));
    sharedPref.setBool('isLoggedIn', true);


    setState(() {
      isLoading = false;
    });

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) =>  SelectLocationScreen(
              isDeliveryAddress: false,isFromAuthDeliveryAddress: true
            )));

  }
}
