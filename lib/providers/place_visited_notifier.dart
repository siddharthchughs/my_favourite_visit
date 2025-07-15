import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_favourite_visit/model/placemodel.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> get _createDatabase async {
  final databasePath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(
      databasePath,
      'places.db',
    ),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_place_visited(id TEXT PRIMARY KEY, name TEXT, image TEXT, lat REAL, lng REAL, address TEXT)');
    },
    version: 2,
  );
  return db;
}

class PlaceVisitedNotifier extends StateNotifier<List<PlaceModel>> {
  // initial data being passed with the super keyword to the state for empty list.
  PlaceVisitedNotifier() : super([]);
//  late final Future<Database> _createDatabase;

  Future<void> loadOffline() async {
    final dbAccess = await _createDatabase;
    final queryResponse = await dbAccess.query('user_place_visited');
    final loadList = queryResponse.map((item) {
      return PlaceModel(
          id: item['id'] as String,
          name: item['name'] as String,
          image: File(item['image'] as String),
          location: PlaceLocation(
              latitude: item['lat'] as double,
              longitude: item['lng'] as double,
              address: item['address'] as String));
    }).toList();

    state = loadList;
  }

  void addPLace(
    String placeName,
    File image,
    PlaceLocation locationPicked,
  ) async {
    final pathDirectory = await syspaths.getApplicationDocumentsDirectory();
    final filePathName = path.basename(image.path);
    final copiedImage = await image.copy('${pathDirectory.path}/$filePathName');
    print('Path of copied image is $copiedImage');

    final newPlace = PlaceModel(
        name: placeName, image: copiedImage, location: locationPicked);

    final db = await _createDatabase;
    db.insert('user_place_visited', {
      'id': newPlace.id,
      'name': newPlace.name,
      'image': newPlace.image.path,
      'lat': newPlace.location.latitude,
      'lng': newPlace.location.longitude,
      'address': newPlace.location.address,
    });
    state = [...state, newPlace];
  }
}

// Within this StateNotifierProvider we pass two arguments
// 1. notifier class name it self.
// 2. type of data returned by the notifier.

final userPlaceProvider =
    StateNotifierProvider<PlaceVisitedNotifier, List<PlaceModel>>(
        (ref) => PlaceVisitedNotifier());
