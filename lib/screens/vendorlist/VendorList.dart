import 'dart:convert';
import 'dart:math';

import 'package:door_step_customer/constants/color.dart';
import 'package:door_step_customer/resources/styles_manager.dart';
import 'package:door_step_customer/screens/vendorDetails/VendorDetails.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/CategoryModel.dart';
import '../../models/VendorsModel.dart';
import '../../providers/VendorProviders.dart';
import '../home/widget/VendorItem.dart';

class VendorListPage extends StatefulWidget {
  const VendorListPage(
      {super.key, required this.categoryModel, required this.index});

  final CategoryModel categoryModel;
  final int index;

  @override
  State<VendorListPage> createState() => _VendorListPageState();
}

class _VendorListPageState extends State<VendorListPage> with WidgetsBindingObserver  {
  late final stream = FirebaseDatabase.instance.ref('category').onValue;
  late var streamVendors = FirebaseDatabase.instance
      .ref('vendors')
      .orderByChild('categoryKey')
      .equalTo(widget.categoryModel.key)
      .onValue;
  List<VendorsModel> vendorList = [];
  List<CategoryModel> service = [];

  int maxDistanceInKm = 10;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    fetchUserData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    fetchUserData();
  }


  @override
  Widget build(BuildContext context) {
    Provider.of<VendorProviders>(context, listen: false)
        .changeCategorySelectedIndex(widget.index);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'All Stores',
            style: getHeadingStyle(color: Colors.black).copyWith(fontSize: 18),
          ),
        ),
        body: Consumer<VendorProviders>(builder: (context, provider, child) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 65,
                child: Container(
                    margin: const EdgeInsets.only(
                        top: 20, bottom: 0, left: 10, right: 10),
                    child: StreamBuilder(
                      stream: stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final data = snapshot.data?.snapshot.value as Map?;
                          if (data == null) {
                            return const Text('No data');
                          }
                          Map<dynamic, dynamic>? map =
                              snapshot.data!.snapshot.value as Map?;
                          service.clear();
                          map!.forEach((key, value) {
                            service.add(CategoryModel(
                                key, value['name'], value['imageUrl']));
                          });


                          return service.isNotEmpty
                              ? ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: service.length,
                                  itemBuilder: (context, index) => InkWell(
                                      onTap: () {
                                        Provider.of<VendorProviders>(context,
                                                listen: false)
                                            .changeCategorySelectedIndex(index);

                                        streamVendors = FirebaseDatabase
                                            .instance
                                            .ref('vendors')
                                            .orderByChild('categoryKey')
                                            .equalTo(service[index].key)
                                            .onValue;
                                      },
                                      child: SubSubCategoryItem(
                                        title: service[index].name,
                                        isSelected:
                                            provider.categorySelectedIndex ==
                                                index,
                                      )),
                                )
                              : const SizedBox();
                        }
                        if (snapshot.hasError) {
                          print(snapshot.error.toString());
                          return Text(snapshot.error.toString());
                        }

                        return const Text('....');
                      },
                    )),
              ),
              Expanded(
                // scrollDirection: Axis.vertical,
                child: Container(
                    margin: const EdgeInsets.only(
                        top: 20, bottom: 0, left: 15, right: 15),
                    child: StreamBuilder(
                      stream: streamVendors,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final data = snapshot.data?.snapshot.value as Map?;
                          if (data == null) {
                            return const Text('No data');
                          }

                          Map<dynamic, dynamic>? map =
                              snapshot.data!.snapshot.value as Map?;
                          vendorList.clear();

                          map!.forEach((key, value) {
                            double itemLatitude =
                                double.parse(value['vendorLatitude']);
                            double itemLongitude =
                                double.parse(value['vendorLongitude']);
                            double distance = _calculateDistance(
                                latitudeCurrent,
                                longitudeCurrent,
                                itemLatitude,
                                itemLongitude);
                            if (distance <= maxDistanceInKm) {
                              vendorList.add(VendorsModel(
                                  key,
                                  value['vendorName'],
                                  value['vendorImage'],
                                  value['vendorLatitude'],
                                  value['vendorLongitude'],
                                  value['categoryKey'],
                                  value['categoryName'],
                                  distance.toString()));
                            }
                          });
                          vendorList
                              .sort((a, b) => a.distance.compareTo(b.distance));
                          return vendorList.isNotEmpty
                              ? Container(
                            margin: EdgeInsets.only(top: 20),
                                child: GridView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: vendorList.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, // 5 items in a row
                                      mainAxisSpacing: 15.0,
                                      crossAxisSpacing: 15.0,
                                    ),
                                    itemBuilder: (context, index) => InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) => VendorDetails(
                                                          vendorsModel:
                                                              vendorList[index],
                                                        )));
                                          },
                                          child: VendorItem(
                                            info: vendorList[index],
                                          ),
                                        )),
                              )
                              : const SizedBox();
                        }
                        if (snapshot.hasError) {
                          print(snapshot.error.toString());
                          return Text(snapshot.error.toString());
                        }

                        return const Text('....');
                      },
                    )),
              ),
            ],
          );
        })
    );


  }

  late SharedPreferences sharedPreferences;
  late double latitudeCurrent = 0.0;
  late double longitudeCurrent = 0.0;
  Future<void> fetchUserData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String? userPref = sharedPreferences.getString('userData');
    String? userLocationPref = sharedPreferences.getString('userLocation');

    Map<String, dynamic> userMap = jsonDecode(userPref!) as Map<String, dynamic>;
    Map<String, dynamic> userLocationMap = jsonDecode(userLocationPref!) as Map<String, dynamic>;
    latitudeCurrent =userLocationMap['currentLatitude'] ;
    longitudeCurrent = userLocationMap['currentLongitude'];
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const int radiusOfEarthInKm = 6371;
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * asin(sqrt(a));
    return radiusOfEarthInKm * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }
}

class SubSubCategoryItem extends StatelessWidget {
  final String? title;

  final bool isSelected;

   SubSubCategoryItem(
      {Key? key, required this.title, required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, top: 5, left: 10),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: isSelected ? primaryColor : Colors.white,
            boxShadow: [
              BoxShadow(
                  color: isSelected ? Colors.transparent : primaryColor,
                  spreadRadius: 1)
            ]),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 10),
          child: SizedBox(
            child: Center(
                child: Text(
              title!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: getMediumStyle(color: Colors.black12).copyWith(
                  fontSize: 12,
                  color: isSelected ? Colors.white : primaryColor),
            )),
          ),
        ),
      ),
    );
  }


}
