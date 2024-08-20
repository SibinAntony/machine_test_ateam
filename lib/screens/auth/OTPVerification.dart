import 'dart:async';
import 'dart:convert';

import 'package:door_step_customer/constants/color.dart';
import 'package:door_step_customer/screens/home/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/show_custom_snakbar.dart';
import '../../models/UserModel.dart';
import '../../resources/styles_manager.dart';
import '../location/select_location_screen.dart';
import 'RegisterPage.dart';

class OTPVerification extends StatefulWidget {
  OTPVerification(
      {super.key, required this.mobileNumber, required this.verificationID});

  String mobileNumber;
  String verificationID;

  @override
  State<OTPVerification> createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
  late SharedPreferences sharedPref;

  TextEditingController controller = TextEditingController();
  int secondsRemaining = 30;
  bool enableResend = false;
  late Timer timer;

  @override
  initState() {
    super.initState();
    controller.text = '';
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 10, top: 20),
          alignment: Alignment.centerLeft,
          child: Text(
            'We have send an OTP to this mobile number +91${widget.mobileNumber}',
            textAlign: TextAlign.center,
            style: getHeadingStyle2(color: Colors.black)
                .copyWith(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
        Container(
            margin: const EdgeInsets.only(left: 25, right: 25, top: 25),
            child: Pinput(
              controller: controller,
              length: 6,
              defaultPinTheme: defaultPinTheme,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              autofocus: true,
              // onChanged: (value) => otp = value,
              onCompleted: (value) => {
                // otp = value,
                setState(() {
                  // if (otp.isEmpty || otp.length < 6) {
                  //   // EasyLoading.showToast("Invalid Otp");
                  // } else {
                  //   checkUserConnection();
                  // }
                })
              },
            )),
        Visibility(
          visible: enableResend,
          child: Container(
            margin: const EdgeInsets.only(top: 10),
            child: TextButton(
              onPressed: enableResend ? _resendCode : null,
              child: Text(
                'Resend Code',
                style:
                    getHeadingStyle(color: primaryColor).copyWith(fontSize: 15),
              ),
            ),
          ),
        ),
        Visibility(
          visible: !enableResend,
          child: Container(
            margin: const EdgeInsets.only(top: 20),
            child: Text(
              'after $secondsRemaining seconds',
              style: const TextStyle(color: primaryColor, fontSize: 12),
            ),
          ),
        ),
        Container(
          height: 55,
          width: MediaQuery.of(context).size.width,
          margin:
              const EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 30),
          child: TextButton(
              child: Text("Verify OTP".toUpperCase(),
                  style: TextStyle(fontSize: 14)),
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(primaryColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ))),
              onPressed: () async => {validate()}),
        )
      ],
    );
  }

  void _resendCode() {
    //other code here
    setState(() {
      secondsRemaining = 10;
      enableResend = false;
    });

    sendOTP(context, widget.mobileNumber);
  }

  @override
  dispose() {
    timer.cancel();
    super.dispose();
  }

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
        fontSize: 20,
        color: Colors.black,
        // fontFamily: ApiConstants.fontFamily,
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black12),
      borderRadius: BorderRadius.circular(10),
    ),
  );

  void sendOTP(BuildContext context, String phoneNumber) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91$phoneNumber',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) {},
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      showCustomSnackBar("${e.message}", context, isToaster: true);
      print('failed ${e.message}');
    }
  }

  Future<void> verifyOTP(
      BuildContext context, String verificationId, String otp) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otp);

      // Sign the user in (or link) with the credential
      await FirebaseAuth.instance.signInWithCredential(credential);



      checkExistingUer(widget.mobileNumber);
    } on FirebaseAuthException catch (e) {
      showCustomSnackBar("Invalid OTP", context);
    }
  }

  validate() {
    if (controller.text.isEmpty) {
      showCustomSnackBar("Please enter the OTP", context, isToaster: true);
      return;
    }
    if (controller.text.length < 6) {
      showCustomSnackBar("Invalid OTP", context, isToaster: true);
      return;
    }

    verifyOTP(context, widget.verificationID, controller.text);
  }

  Future<void> checkExistingUer(String phoneNumber) async {
    DatabaseReference usersRef = FirebaseDatabase.instance.ref('users');
    usersRef
        .orderByChild('mobileNumber')
        .equalTo(phoneNumber)
        .once()
        .then((value) async => {
              if (value.snapshot.value == null)
                {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => RegisterPage(
                            mobileNumber: phoneNumber,
                          )))
                }
              else
                {
                  saveUserData(value.snapshot.value, value.snapshot.key),
                }
            });
  }

  late UserModel userModel;

  saveUserData(Object? value, String? key) async {
    sharedPref = await SharedPreferences.getInstance();
    Map<dynamic, dynamic>? map = value as Map?;
    late Map<String, dynamic> user;
    map!.forEach((key, value) {
      user = {
        'key': key,
        'userName': value!['userName'],
        'userEmail': value['userEmail'],
        'mobileNumber': value['mobileNumber']
      };
    });

    sharedPref.setString("userData", jsonEncode(user));
    sharedPref.setBool('isLoggedIn', true);

    print('haii user ${user.toString()}');

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) =>  SelectLocationScreen(
              isFromAuth: true,
            )));

  }
}
