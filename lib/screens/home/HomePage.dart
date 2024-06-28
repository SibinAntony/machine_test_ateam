import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:door_step_customer/models/BannerModel.dart';
import 'package:door_step_customer/models/VendorsModel.dart';
import 'package:door_step_customer/screens/home/widget/CategoryItem.dart';
import 'package:door_step_customer/screens/home/widget/VendorItem.dart';
import 'package:door_step_customer/screens/location/LocationFetch.dart';
import 'package:door_step_customer/screens/orders/OrderListScreen.dart';
import 'package:door_step_customer/screens/vendorlist/VendorList.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/Images.dart';
import '../../constants/color.dart';
import '../../models/CategoryModel.dart';
import '../../resources/styles_manager.dart';
import '../location/select_location_screen.dart';
import '../vendorDetails/VendorDetails.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int maxDistanceInKm = 10;
  late SharedPreferences sharedPreferences;
  String? userPref;
  late final streamCategory = FirebaseDatabase.instance.ref('category').onValue;
  late final streamServices =
      FirebaseDatabase.instance.ref('bestServices').onValue;
  late final streamVendors = FirebaseDatabase.instance
      .ref('vendors')
      .orderByChild('categoryName')
      .equalTo('Restaurant')
      .onValue;
  late final streamBanners = FirebaseDatabase.instance.ref('banners').onValue;

  List<CategoryModel> category = [];
  List<CategoryModel> service = [];
  List<VendorsModel> vendorList = [];
  List<BannerModel> bannerList = [];

  late String userName = "";
  late String customerId = "";
  late String mobileNumber = "";

  GoogleMapController? _controllerMap;

  int _current = 0;
  final CarouselController _controller = CarouselController();

  Position? _currentPosition;

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);

      // getMandiList(isRefresh: true, apiKey: apiKey);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'isLocationServiceEnabled : listOfScreenData.createTicketLocationFetchError!')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'denied : listOfScreenData.createTicketLocationFetchError!')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'deniedForever :listOfScreenData.createTicketLocationFetchError!')));

      return false;
    }
    return true;
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

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFEDFF7E),
              // Color(0xFFEDFF7E),
              Colors.white,
            ],
            // begin: Alignment.topCenter,
            // end: Alignment.bottomCenter,
            begin: FractionalOffset(1.8, 0.0),
            end: FractionalOffset(0.0, 0.8),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.only(top: 50, left: 15, right: 15),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => SelectLocationScreen(
                                                googleMapController: _controllerMap,
                                                  )));
                                    },
                                    child: Container(
                                      margin:
                                          const EdgeInsets.only(right: 10),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Ponamaravthi',
                                        textAlign: TextAlign.center,
                                        style: getHeadingStyle2(
                                                color: Colors.black)
                                            .copyWith(
                                                fontSize: 12,
                                                fontWeight:
                                                    FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                  const Icon(Icons.location_on_rounded,size: 15,),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  print('haii ${customerId}');
                                  Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              OrderListScreen(
                                                userPref: mobileNumber,
                                              )));
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 35,
                                      width: 35,
                                      margin:
                                          const EdgeInsets.only(right: 15),
                                      decoration: BoxDecoration(
                                        color: Colors.black87,
                                        borderRadius:
                                            BorderRadius.circular(20),
                                        // borderRadius: BorderRadius.all(Radius.circular(10))
                                      ),
                                      child: const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                    Visibility(
                                      visible: false,
                                      child: Positioned(
                                          right: 15,
                                          top: 1,
                                          child: Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              color: Colors.orange,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              top: 0, left: 0, right: 10, bottom: 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width:
                                    MediaQuery.of(context).size.width / 2,

                                child: Image.asset(
                                  Images.top_images1,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin: const EdgeInsets.only(top: 0),
                                    child: Text(
                                      'Welcome back,',
                                      textAlign: TextAlign.center,
                                      style: getHeadingStyle2(
                                              color: Colors.black)
                                          .copyWith(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      '$userName',
                                      textAlign: TextAlign.center,
                                      style: getHeadingStyle2(
                                              color: Colors.black)
                                          .copyWith(
                                              fontSize: 23,
                                              fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 0, bottom: 0),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Our Services by Category',
                            textAlign: TextAlign.center,
                            style: getHeadingStyle2(color: Colors.black)
                                .copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                            // color: Colors.red,
                            margin:
                                const EdgeInsets.only(top: 25, bottom: 25),
                            child: StreamBuilder(
                              stream: streamCategory,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final data =
                                      snapshot.data?.snapshot.value as Map?;
                                  if (data == null) {
                                    return const Text('No data');
                                  }
                                  Map<dynamic, dynamic>? map =
                                      snapshot.data!.snapshot.value as Map?;
                                  category.clear();
                                  map!.forEach((key, value) {
                                    category.add(CategoryModel(key,
                                        value['name'], value['imageUrl']));
                                  });

                                  return category.isNotEmpty
                                      ? Center(
                                          child: GridView.builder(
                                            padding: EdgeInsets.zero,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: category.length,
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount:
                                                  4, // 5 items in a row
                                              mainAxisSpacing: 5.0,
                                              crossAxisSpacing: 5.0,
                                            ),
                                            itemBuilder: (context, index) =>
                                                InkWell(
                                              onTap: () {
                                                // print(object)
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            VendorListPage(
                                                              categoryModel:
                                                                  category[
                                                                      index],
                                                              index: index,
                                                            )));
                                              },
                                              child: CategoryItem(
                                                info: category[index],
                                              ),
                                            ),
                                          ),
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
                        Container(
                            height: 230,
                            margin: const EdgeInsets.only(top: 0),
                            child: StreamBuilder(
                              stream: streamBanners,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final data =
                                      snapshot.data?.snapshot.value as Map?;
                                  if (data == null) {
                                    return const Text('No data');
                                  }
                                  Map<dynamic, dynamic>? map =
                                      snapshot.data!.snapshot.value as Map?;
                                  bannerList.clear();
                                  map!.forEach((key, value) {
                                    bannerList.add(BannerModel(
                                        key,
                                        value['bannerImage'],
                                        value['categoryKey'],
                                        value['categoryName']));
                                  });

                                  // print(object)

                                  final List<Widget> imageSliders =
                                      bannerList
                                          .map((item) => Container(
                                                margin:
                                                    const EdgeInsets.all(
                                                        5.0),
                                                child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius
                                                                .all(
                                                            Radius.circular(
                                                                10.0)),
                                                    child: Stack(
                                                      children: <Widget>[
                                                        CachedNetworkImage(
                                                          imageUrl: item
                                                              .bannerImage,
                                                          width:
                                                              MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width,
                                                          fit: BoxFit.cover,
                                                          errorWidget: (context,
                                                                  url,
                                                                  error) =>
                                                              const Icon(Icons
                                                                  .error),
                                                        ),
                                                      ],
                                                    )),
                                              ))
                                          .toList();

                                  if (bannerList.isNotEmpty) {
                                    return Container(
                                      // color: Colors.red,

                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12),
                                                  color: Colors.white,
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
                                                child: CarouselSlider(
                                                  items: imageSliders,
                                                  carouselController:
                                                      _controller,
                                                  options: CarouselOptions(
                                                      autoPlay: true,
                                                      reverse: false,
                                                      viewportFraction: 1.0,
                                                      enlargeCenterPage: true,
                                                      initialPage: 0,
                                                      onPageChanged:
                                                          (index, reason) {
                                                        setState(() {
                                                          _current = index;
                                                        });
                                                      }),
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: bannerList
                                                  .asMap()
                                                  .entries
                                                  .map((entry) {
                                                return GestureDetector(
                                                  onTap: () => _controller
                                                      .animateToPage(
                                                          entry.key),
                                                  child: Container(
                                                    width: _current ==
                                                            entry.key
                                                        ? 10
                                                        : 8.0,
                                                    height: _current ==
                                                            entry.key
                                                        ? 10
                                                        : 8.0,
                                                    margin: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 8.0,
                                                        horizontal: 4.0),
                                                    decoration: BoxDecoration(
                                                        shape:
                                                            BoxShape.circle,
                                                        color: (Theme.of(context)
                                                                        .brightness ==
                                                                    Brightness
                                                                        .dark
                                                                ? Colors
                                                                    .white
                                                                : Colors
                                                                    .black)
                                                            .withOpacity(
                                                                _current ==
                                                                        entry.key
                                                                    ? 0.9
                                                                    : 0.4)),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ]),
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                }
                                if (snapshot.hasError) {
                                  print(snapshot.error.toString());
                                  return Text(snapshot.error.toString());
                                }

                                return const Text('....');
                              },
                            )),
                        Container(
                          // height: 150,
                          margin: const EdgeInsets.only(top: 0, bottom: 20),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                    top: 30, bottom: 25),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Our Best Services',
                                  textAlign: TextAlign.center,
                                  style:
                                      getHeadingStyle2(color: Colors.black)
                                          .copyWith(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                ),
                              ),
                              Center(
                                child: StreamBuilder(
                                  stream: streamServices,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final data = snapshot
                                          .data?.snapshot.value as Map?;
                                      if (data == null) {
                                        return const Text('No data');
                                      }
                                      Map<dynamic, dynamic>? map = snapshot
                                          .data!.snapshot.value as Map?;
                                      service.clear();
                                      map!.forEach((key, value) {
                                        service.add(CategoryModel(
                                            key,
                                            value['name'],
                                            value['imageUrl']));
                                      });

                                      return service.isNotEmpty
                                          ? GridView.builder(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              itemCount: service.length,
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount:
                                                    3, // 5 items in a row
                                                mainAxisSpacing: 5.0,
                                                crossAxisSpacing: 15.0,
                                              ),
                                              itemBuilder:
                                                  (context, index) =>
                                                      InkWell(
                                                onTap: () {
                                                  // Navigator.push(
                                                  //     context,
                                                  //     MaterialPageRoute(
                                                  //         builder: (_) =>
                                                  //             VendorListPage(
                                                  //               categoryModel:
                                                  //                   service[
                                                  //                       index],
                                                  //               index:
                                                  //                   index,
                                                  //             )));
                                                },
                                                child: ServiceItem(
                                                  info: service[index],
                                                ),
                                              ),
                                            )
                                          : const SizedBox();
                                    }
                                    if (snapshot.hasError) {
                                      print(snapshot.error.toString());
                                      return Text(
                                          snapshot.error.toString());
                                    }

                                    return const Text('....');
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 0, bottom: 0),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Near by Stores',
                                textAlign: TextAlign.center,
                                style: getHeadingStyle2(color: Colors.black)
                                    .copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => VendorListPage(
                                              categoryModel: category[0],
                                              index: 0,
                                            )));
                              },
                              child: Row(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin: const EdgeInsets.only(right: 8),
                                    child: Text(
                                      'See All',
                                      textAlign: TextAlign.center,
                                      style: getHeadingStyle2(
                                              color: Colors.black)
                                          .copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                  const Icon(
                                    CupertinoIcons.arrow_right,
                                    size: 18,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                            margin:
                                const EdgeInsets.only(top: 10, bottom: 30),
                            child: StreamBuilder(
                              stream: streamVendors,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final data =
                                      snapshot.data?.snapshot.value as Map?;
                                  if (data == null) {
                                    return const Text('No data');
                                  }

                                  Map<dynamic, dynamic>? map =
                                      snapshot.data!.snapshot.value as Map?;
                                  vendorList.clear();

                                  map!.forEach((key, value) {
                                    double itemLatitude = double.parse(
                                        value['vendorLatitude']);
                                    double itemLongitude = double.parse(
                                        value['vendorLongitude']);
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

                                  vendorList.sort((a, b) =>
                                      a.distance.compareTo(b.distance));
                                  vendorList = vendorList.take(6).toList();
                                  return vendorList.isNotEmpty
                                      ? GridView.builder(
                                          padding: EdgeInsets.zero,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: vendorList.length,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount:
                                                2, // 5 items in a row
                                            mainAxisSpacing: 15.0,
                                            crossAxisSpacing: 15.0,
                                          ),
                                          itemBuilder:
                                              (context, index) => InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (_) =>
                                                                  VendorDetails(
                                                                    vendorsModel:
                                                                        vendorList[index],
                                                                  )));
                                                    },
                                                    child: VendorItem(
                                                      info:
                                                          vendorList[index],
                                                    ),
                                                  ))
                                      : const SizedBox();
                                }
                                if (snapshot.hasError) {
                                  print(snapshot.error.toString());
                                  return Text(snapshot.error.toString());
                                }

                                return const Text('....');
                              },
                            )),

                        // Container(
                        //   margin: EdgeInsets.only(top: 30),
                        //   // height: 500,
                        //   child: RealtimeDBPagination(
                        //     query: FirebaseDatabase.instance.ref().child('vendors').orderByChild('ascending'),
                        //     orderBy: 'score',
                        //     viewType: ViewType.grid,
                        //     itemBuilder: (context, dataSnapshot, index) {
                        //
                        //       final data = dataSnapshot.value as Map<dynamic, dynamic>;
                        //
                        //       // Map<dynamic, dynamic> data1=dataSnapshot.value as Map;
                        //
                        //       print('haii ${data.toString()}');
                        //
                        //       VendorsModel vendorModel=VendorsModel(
                        //           dataSnapshot.key!,
                        //           data['vendorName'],
                        //           data['vendorImage'],
                        //           data['vendorLatitude'],
                        //           data['vendorLongitude'],
                        //           data['categoryKey'],
                        //           data['categoryName']);
                        //
                        //       return VendorItem(info: vendorModel,);
                        //
                        //       // Do something cool with the data
                        //     },
                        //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        //       crossAxisCount: 2,
                        //       mainAxisSpacing: 15.0,
                        //       crossAxisSpacing: 15.0,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 100),
                    child: Image.asset(
                      Images.happy_shopping,
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchUserData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String? userPref = sharedPreferences.getString('userData');

    Map<String, dynamic> userMap =
        jsonDecode(userPref!) as Map<String, dynamic>;
    String name = userMap['userName'];
    customerId = userMap['key'] ?? '';
    mobileNumber = userMap['mobileNumber'] ?? '';
    // userName = name.split(' ') as String?;
    List<String> parts = name.split(" ");
    userName = parts[0];
    print("First Name: $userName");
  }
}
