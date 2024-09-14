import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/MapUtils.dart';
import '../../resources/styles_manager.dart';

class HelpSupport extends StatefulWidget {
  const HelpSupport({super.key});

  @override
  State<HelpSupport> createState() => _HelpSupportState();
}

class _HelpSupportState extends State<HelpSupport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop()
          ),
          title: Text(
            'Help & Support',
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

                  InkWell(onTap: (){
                    MapUtils.makeCall('+91 9787239396');
                  }, child: Container( alignment: Alignment.topLeft,child: Text('+91 9787239396', style: getHeadingStyle2(
                      color: Colors.black)
                      .copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w300),),),),
                  const Divider(color: Colors.grey,thickness: 0.1,height: 30,),

                  InkWell(onTap: (){
                    MapUtils.makeEmail('doorsteppmv@gmail.com');
                  }, child: Container( alignment: Alignment.topLeft,child: Text('doorsteppmv@gmail.com', style: getHeadingStyle2(
                      color: Colors.black)
                      .copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w300),),),),
                  const Divider(color: Colors.grey,thickness: 0.1,height: 30,),

                ],
              ),
            )));
  }
}
