import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_favourite_visit/model/placemodel.dart';
import 'package:my_favourite_visit/screens/map_screen.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({super.key, required this.place});
  final PlaceModel place;

  String get locationImage {
    final latOfLocation = place.location.latitude;
    final lngOfLocation = place.location.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latOfLocation,$lngOfLocation&zoom=10&size=400x500&key=AIzaSyD5mjOXc9l0y7A9To9_VMgNzYp7qviFKT4';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          place.name,
        ),
      ),
      body: Center(
        child: Stack(
          children: [
            Image.file(
              place.image,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.fill,
            ),
            Positioned(
              top: 10,
              left: 10,
              right: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => MapScreen(
                            location: place.location,
                            isSelecting: false,
                          ),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: NetworkImage(locationImage),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    place.name,
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge!
                        .copyWith(color: Colors.blueAccent),
                  ),
                  Text(
                    place.location.address,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.amberAccent),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
