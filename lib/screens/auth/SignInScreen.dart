
import 'package:door_step_customer/constants/color.dart';
import 'package:door_step_customer/screens/auth/OTPVerification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/Images.dart';
import '../../constants/show_custom_snakbar.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController controllerMobile = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    isLoading = false;
    controllerMobile.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // mainAxisSize: MainAxisSize.max,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Image.asset(
                Images.logo,
                fit: BoxFit.contain,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  top: 0, left: 30, right: 30, bottom: 30),
              child: TextFormField(
                controller: controllerMobile,
                decoration: InputDecoration(
                  labelText: "Enter Mobile Number",
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
                autofocus: true,
                keyboardType: TextInputType.number,
                maxLines: 1,
                maxLength: 10,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
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
                        child: Text("Login".toUpperCase(),
                            style: const TextStyle(fontSize: 14)),
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(primaryColor),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(const RoundedRectangleBorder(
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

  validateNumber() async {
    print(controllerMobile.text);
    print("${controllerMobile.text.length} + ${controllerMobile.text}");

    if (controllerMobile.text.isEmpty) {
      showCustomSnackBar("Please enter the mobile number", context);
      return;
    }
    if (controllerMobile.text.length < 10) {
      showCustomSnackBar("Invalid Mobile Number", context);
      return;
    }

    setState(() {
      isLoading = true;
    });

    // showCustomSnackBar("send otp", context);
    sendOTP(context, controllerMobile.text);
  }

  String phoneNumber = "";

  void sendOTP(BuildContext context, String phoneNumber) async {
    this.phoneNumber = phoneNumber;

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91$phoneNumber',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            isLoading = false;
          });
          showModalBottomSheet(
              context: context,
              backgroundColor: Colors.white,
              builder: (context) {
                return OTPVerification(
                  mobileNumber: phoneNumber,
                  verificationID: verificationId,
                );
              });
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if(kDebugMode) {
        print("Failure status ${e.message}");
      }
      showCustomSnackBar("${e.message}", context,isToaster: true);
    }
  }
}
