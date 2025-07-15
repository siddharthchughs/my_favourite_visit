import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_favourite_visit/providers/place_visited_notifier.dart';
import 'package:my_favourite_visit/widgets/image_input.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_favourite_visit/widgets/location_input.dart';

import '../model/placemodel.dart';

class AddPlace extends ConsumerStatefulWidget {
  const AddPlace({super.key});

  @override
  ConsumerState<AddPlace> createState() => _AddPlaceState();
}

class _AddPlaceState extends ConsumerState<AddPlace> {
  final _placeTextController = TextEditingController();
  File? _selectedImage;
  PlaceLocation? _pickedLocation;

  void _savePlaces() {
    final enteredText = _placeTextController.text;
    if (enteredText.isEmpty ||
        _selectedImage == null ||
        _pickedLocation == null) {
      return;
    }

    ref.read(userPlaceProvider.notifier).addPLace(
          enteredText,
          _selectedImage!,
          _pickedLocation!,
        );

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _placeTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: AppBar(
        title: Text("Add Place"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: "Title",
              ),
              controller: _placeTextController,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(
              height: 20,
            ),
            ImageInput(
              onPickImage: (image) {
                _selectedImage = image;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            LocationInput(
              onLocationPicked: (location) {
                _pickedLocation = location;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(
              onPressed: _savePlaces,
              icon: const Icon(Icons.add),
              label: const Text("Add Place"),
            )
          ],
        ),
      ),
    );
  }
}
