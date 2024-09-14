import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/CategoryModel.dart';
import '../../resources/styles_manager.dart';

class BestServicePage extends StatefulWidget {
   BestServicePage({super.key,required this.categoryModel});

  CategoryModel categoryModel;

  @override
  State<BestServicePage> createState() => _BestServicePageState();
}

class _BestServicePageState extends State<BestServicePage> {
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop()
          ),
          title: Text(
            '${widget.categoryModel.name}',
            style: getHeadingStyle(color: Colors.black).copyWith(fontSize: 18),
          ),
        ),
        body:  SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 0),
              color: Colors.white,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  'Choose your service',
                  style: getHeadingStyle(color: Colors.black).copyWith(fontSize: 15),
                ),
              ],),
            )));;
  }
}
