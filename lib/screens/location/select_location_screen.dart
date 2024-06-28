import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'location_provider.dart';
import 'location_search_dialog.dart';

class SelectLocationScreen extends StatefulWidget {
  final GoogleMapController? googleMapController;
  const SelectLocationScreen({Key? key, required this.googleMapController}) : super(key: key);

  @override
  SelectLocationScreenState createState() => SelectLocationScreenState();
}

class SelectLocationScreenState extends State<SelectLocationScreen> {
  GoogleMapController? _controller;
  final TextEditingController _locationController = TextEditingController();
  CameraPosition? _cameraPosition;

  @override
  void initState() {
    super.initState();

    Provider.of<LocationProvider>(context, listen: false).setPickData();
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  void _openSearchDialog(BuildContext context, GoogleMapController? mapController) async {
    showDialog(context: context, builder: (context) => LocationSearchDialog(mapController: mapController));
  }

  @override
  Widget build(BuildContext context) {
    _locationController.text = '${Provider.of<LocationProvider>(context).address.name ?? ''}, '
        '${Provider.of<LocationProvider>(context).address.subAdministrativeArea ?? ''}, '
        '${Provider.of<LocationProvider>(context).address.isoCountryCode ?? ''}';

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              // CustomAppBar(title: getTranslated('select_delivery_address', context)),
              Expanded(
                child: Consumer<LocationProvider>(
                  builder: (context, locationProvider, child) => Stack(
                    clipBehavior: Clip.none,
                    children: [
                      GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(locationProvider.position.latitude, locationProvider.position.longitude),
                          zoom: 15,
                        ),
                        zoomControlsEnabled: false,
                        compassEnabled: false,
                        indoorViewEnabled: true,
                        mapToolbarEnabled: true,
                        onCameraIdle: () {
                          locationProvider.updatePosition(_cameraPosition, false, null, context);
                        },
                        onCameraMove: ((position) => _cameraPosition = position),
                        // markers: Set<Marker>.of(locationProvider.markers),
                        onMapCreated: (GoogleMapController controller) {
                          _controller = controller;
                        },
                      ),
                      locationProvider.pickAddress != null
                          ? InkWell(
                        onTap: () => _openSearchDialog(context, _controller),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18.0),
                          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 23.0),
                          decoration:
                          BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10)),
                          child: Row(children: [
                            Expanded(child: Text(locationProvider.pickAddress!.name != null
                                ? '${locationProvider.pickAddress?.name ?? ''} ${locationProvider.pickAddress?.subAdministrativeArea ?? ''} ${locationProvider.pickAddress?.isoCountryCode ?? ''}'
                                : '', maxLines: 1, overflow: TextOverflow.ellipsis)),
                            const Icon(Icons.search, size: 20),
                          ]),
                        ),
                      )
                          : const SizedBox.shrink(),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                locationProvider.getCurrentLocation(context, false, mapController: _controller);
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                margin: const EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.black,
                                ),
                                child: Icon(
                                  Icons.my_location,
                                  color: Theme.of(context).primaryColor,
                                  size: 35,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Container(child: InkWell( child: Text('Select Location'),)),
                                // child: CustomButton(
                                //   buttonText: getTranslated('select_location', context),
                                //   onTap: () {
                                //
                                //   },
                                // ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Center(
                          child: Icon(
                            Icons.location_on,
                            color: Theme.of(context).primaryColor,
                            size: 50,
                          )),
                      locationProvider.loading
                          ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)))
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
