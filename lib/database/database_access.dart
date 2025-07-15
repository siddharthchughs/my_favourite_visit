import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;

class CreateDatabase {
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
      version: 1,
    );
    return db;
  }
}
