import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class dbclass
{
  Database? database;
  Future<Database> createdb() async
  {

    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

// open the database
    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE notes (id INTEGER PRIMARY KEY, title TEXT, notes TEXT,theme TEXT)');
        });
    return database!;
  }
}