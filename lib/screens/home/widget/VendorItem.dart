import 'dart:ffi';

import 'package:door_step_customer/resources/styles_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:geolocator/geolocator.dart';
import '../../../constants/color.dart';
import '../../../models/VendorsModel.dart';

class VendorItem extends StatelessWidget {
  final VendorsModel info;

  const VendorItem({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var _distanceBetweenLastTwoLocations = Geolocator.distanceBetween(
     latitudeCurrent,
     longitudeCurrent,
     double.parse(info.vendorLatitude),
      double.parse(info.vendorLongitude)
    );

    _distanceBetweenLastTwoLocations=_distanceBetweenLastTwoLocations/1000;

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 40),
          padding: const EdgeInsets.all(10),
          // decoration: BoxDecoration(
          //   color: cardColor,
          //   borderRadius: BorderRadius.circular(10),
          //   // border: Border.all(color: borderColor, width: 1),
          // ),

          decoration: BoxDecoration(

            borderRadius:
            BorderRadius.circular(
                10),
            color: cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey
                    .withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        info.vendorName,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        // overflow: TextOverflow.ellipsis,
                        style: getMediumStyle(color: Colors.black)
                            .copyWith(fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 3),
                      alignment: Alignment.center,
                      child: Text(
                        info.categoryName,
                        // overflow: TextOverflow.ellipsis,
                        style: getMediumStyle(color: Colors.black)
                            .copyWith(fontWeight: FontWeight.w400, fontSize: 12),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      alignment: Alignment.center,
                      child: Text(
                        '${_distanceBetweenLastTwoLocations.toStringAsFixed(2)} KM',
                        // overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: getHeadingStyle(color: Colors.green)
                            .copyWith(fontWeight: FontWeight.w800, fontSize: 10),
                      ),
                    ),
                  ],
                ),

              ),

            ],
          ),
        ),
        Container(
          alignment: Alignment.topCenter,
          child: CircleAvatar(
              radius: 40, backgroundImage: NetworkImage(info.vendorImage)),
        ),
      ],
    );
  }
}
