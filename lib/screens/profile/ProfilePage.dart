import 'dart:convert';

import 'package:door_step_customer/screens/auth/SignInScreen.dart';
import 'package:door_step_customer/screens/helpSupport/HelpSupport.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../resources/styles_manager.dart';
import '../home/HomePage.dart';
import '../orders/OrderListScreen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  late String userName = "";
  late String mobileNumber = "";
  late String email = "";
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }


  Future<void> fetchUserData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String? userPref = sharedPreferences.getString('userData');

    Map<String, dynamic> userMap = jsonDecode(userPref!) as Map<String, dynamic>;
    userName = userMap['userName']??'';
    mobileNumber = userMap['mobileNumber'] ?? '';
    email = userMap['email'] ?? '';
    email=email.isNotEmpty?'/ $email':'';
    setState(() {
    });



  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (BuildContext context) => const MyHomePage())),
          ),
          title: Text(
            'Profile',
            style: getHeadingStyle(color: Colors.black).copyWith(fontSize: 18),
          ),
        ),
        body:  SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 0),
              color: Colors.white,
              child: Column(
                children: [
                 Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                   Container(
                     height: 45,
                     width: 45,
                     margin:
                     const EdgeInsets.only(right: 15),
                     decoration: BoxDecoration(
                       color: Colors.black87,
                       borderRadius:
                       BorderRadius.circular(25),
                       // borderRadius: BorderRadius.all(Radius.circular(10))
                     ),
                     child: const Icon(
                       Icons.person,
                       color: Colors.white,
                       size: 18,
                     ),
                   ),
                   Column(
                     crossAxisAlignment:
                     CrossAxisAlignment.start,
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children: [
                       Container(
                         margin: const EdgeInsets.only(top: 0),
                         child: Text(
                           '$userName',
                           textAlign: TextAlign.center,
                           style: getHeadingStyle2(
                               color: Colors.black)
                               .copyWith(
                               fontSize: 22,
                               fontWeight: FontWeight.w300),
                         ),
                       ),
                       Container(
                         margin: const EdgeInsets.only(top: 5),
                         child: Text(
                           '$mobileNumber $email',
                           style: getHeadingStyle2(
                               color: Colors.black)
                               .copyWith(
                               fontSize: 16,
                               fontWeight: FontWeight.w300),
                         ),
                       ),
                     ],
                   ),
                 ],),
                  const Divider(color: Colors.grey,thickness: 0.1,height: 40,),
                  InkWell(onTap:(){
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                OrderListScreen(
                                  userPref: mobileNumber,
                                  isOrderSucess: false,
                                )));
                  },child: Container( alignment: Alignment.topLeft,child: Text('My Orders', style: getHeadingStyle2(
                      color: Colors.black)
                      .copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w300),),),),
                  const Divider(color: Colors.grey,thickness: 0.1,height: 30,),
                  InkWell(onTap: (){
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                            const HelpSupport(
                            )));
                  }, child: Container( alignment: Alignment.topLeft,child: Text('Help & Support', style: getHeadingStyle2(
                      color: Colors.black)
                      .copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w300),),),),
                  const Divider(color: Colors.grey,thickness: 0.1,height: 30,),
                  InkWell(onTap:(){
                    sharedPreferences.clear();
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const SignInScreen(
                                )));
                  },child: Container( alignment: Alignment.topLeft,child: Text('Sign Out', style: getHeadingStyle2(
                      color: Colors.black)
                      .copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w300),),),),
                  const Divider(color: Colors.grey,thickness: 0.1,height: 30,),

                  Center(
                    child: Container(margin: const EdgeInsets.only(top: 30), child: Text('Version 1.0.0', style: getHeadingStyle2(
                        color: Colors.black)
                        .copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w300),),),
                  )

                ],
              ),
            )));
  }
}
