import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DB  {

  static final DB _db = new DB._internal();
  DB._internal();
  static DB get instance => _db;
  static Database _database;

  Future<Database> get database async {
    if(_database != null)
      return _database;
    _database = await _init();
    return _database;

  }

  Future<Database> _init() async{
    return await openDatabase(

      join(await getDatabasesPath(), 'times_data.db'),
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE times(id INTEGER PRIMARY KEY, detail TEXT);",
        );

        // more create statements....

      },

      version: 5,
    );
  }
}