import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:my_favourite_visit/model/placemodel.dart';
import '../screens/map_screen.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({
    super.key,
    required this.onLocationPicked,
  });

  final void Function(PlaceLocation locationPicked) onLocationPicked;

  @override
  State<StatefulWidget> createState() => _LocationInput();
}

class _LocationInput extends State<LocationInput> {
  PlaceLocation? _pickedlocation;
  var _isGettingLocation = false;
  PlaceModel? placeModel;

  String get locationImage {
    if (_pickedlocation == null) {
      return "";
    }
    final latOfLocation = _pickedlocation!.latitude;
    final lngOfLocation = _pickedlocation!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latOfLocation,$lngOfLocation=&zoom=10&size=400x600&mapType=roadmap&markers=color:blue%7Clabel:S%7C40.702147,-74.015794&key=AIzaSyD5mjOXc9l0y7A9To9_VMgNzYp7qviFKT4';
  }

  void _saveLatLng(double lat, double lng) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&markers=color:blue%7Clabel:S%7C40.702147,-74.015794&key=AIzaSyD5mjOXc9l0y7A9To9_VMgNzYp7qviFKT4');
    final response = await http.get(url);
    final finalData = json.decode(response.body);
    final address = finalData['results'][0]['formatted_address'];

    setState(() {
      _pickedlocation = PlaceLocation(
        latitude: lat,
        longitude: lng,
        address: address,
      );
      _isGettingLocation = false;
    });
    widget.onLocationPicked(_pickedlocation!);
  }

  void _getLocationByPermission() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;
    if (lat == null || lng == null) {
      return;
    }
    _saveLatLng(lat, lng);
  }

  void _navigateToMap() async {
    final pickedMapLocation = await Navigator.of(context)
        .push<LatLng>(MaterialPageRoute(builder: (cts) => const MapScreen()));

    if (pickedMapLocation == null) {
      return;
    }
    _saveLatLng(pickedMapLocation.latitude, pickedMapLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget? content = Text(
      "No Location Chosen",
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
    );

    if (_pickedlocation != null) {
      content = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (_isGettingLocation) {
      content = const CircularProgressIndicator();
    }

    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: content,
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: TextButton.icon(
                icon: Icon(Icons.location_on),
                onPressed: _getLocationByPermission,
                label: const Text("Current Location"),
              ),
            ),
            TextButton.icon(
              icon: Icon(Icons.map),
              onPressed: _navigateToMap,
              label: const Text("Select on Map"),
            )
          ],
        )
      ],
    );
  }
}
