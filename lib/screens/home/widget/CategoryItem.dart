import 'package:door_step_customer/resources/styles_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants/color.dart';
import '../../../models/CategoryModel.dart';

class CategoryItem extends StatelessWidget {
  final CategoryModel info;

  const CategoryItem({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(radius: 30, backgroundImage: NetworkImage(info.image)),
        Container(
          margin: EdgeInsets.only(top: 10),
          child: Text(
            info.name,
            style: getHeadingStyle2(color: Colors.black)
                .copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class ServiceItem extends StatelessWidget {
  final CategoryModel info;

  const ServiceItem({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 80,
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 28, left: 8, bottom: 8, right: 8),
          decoration: BoxDecoration(
              color: purple,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          margin: EdgeInsets.only(top: 30),
          child: Text(
            info.name,
            textAlign: TextAlign.center,
            style: getHeadingStyle(color: Colors.black)
                .copyWith(fontSize: 12,fontWeight: FontWeight.w700, height: 1.5),
            // overflow: TextOverflow.ellipsis,
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: 55,
            width: 55,
            child:  CircleAvatar(radius: 60,backgroundColor: Colors.white , backgroundImage: NetworkImage(info.image)),

            // alignment: Alignment.center,
            // child: Image.network(info.image),
          ),
        ),
      ],
    );
  }
}
