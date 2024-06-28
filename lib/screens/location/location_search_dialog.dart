import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_location_picker/map_location_picker.dart';

class LocationSearchDialog extends StatelessWidget {
  final GoogleMapController? mapController;
  const LocationSearchDialog({Key? key, required this.mapController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    List<Prediction> _predictionList = [];
    return Container(
      margin: const EdgeInsets.only(top: 80),
      alignment: Alignment.topCenter,
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SizedBox(width: 1170, child: TypeAheadField(
          textFieldConfiguration: TextFieldConfiguration(
            controller: controller,
            textInputAction: TextInputAction.search,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            keyboardType: TextInputType.streetAddress,
            decoration: InputDecoration(
              hintText: 'Search Location',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(style: BorderStyle.none, width: 0),
              ),
              hintStyle: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 15, color: Theme.of(context).disabledColor,
              ),
              filled: true, fillColor: Theme.of(context).cardColor,
            ),
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
              color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: 20,
            ),
          ),
          suggestionsCallback: (pattern) async {
            // return [];
            return _predictionList;
          },
          itemBuilder: (context, Prediction suggestion) {
            return Padding(
              padding: const EdgeInsets.all(12),
              child: Row(children: [
                const Icon(Icons.location_on),
                Expanded(
                  child: Text(suggestion.description!, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: 20,
                  )),
                ),
              ]),
            );
          },
          onSuggestionSelected: (Prediction suggestion) {
            // Provider.of<LocationProvider>(context, listen: false).setLocation(suggestion.placeId, suggestion.description, mapController);
            Navigator.pop(context);
          },
        )),
      ),
    );
  }
}