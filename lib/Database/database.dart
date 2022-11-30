import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'model.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  static Future<Database> _initDatabase() async {
    final appStorage = await getExternalStorageDirectory();

    String path = join(appStorage!.path, 'groceriess.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  static Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE groceriess(
          id INTEGER PRIMARY KEY,
          name TEXT ,
          totalblc INTEGER,
          phone TEXT ,
          blc INTEGER ,
          address TEXT ,
          date TEXT ,
          mode INTEGER  
      )
      ''');
  }

  Future<List<PartyModel>> getPartyName() async {
    Database db = await instance.database;
    var groceries = await db.query('groceriess', orderBy: 'name');
    List<PartyModel> groceryList = groceries.isNotEmpty ? groceries.map((c) => PartyModel.fromMap(c)).toList() : [];
    return groceryList;
  }

  Future<int> add(PartyModel grocery) async {
    Database db = await instance.database;
    return await db.insert('groceriess', grocery.toMap());
  }

  Future<int> deleteparty(int id) async {
    Database db = await instance.database;
    return await db.rawDelete('DELETE FROM groceriess WHERE id = $id');
  }

  static Future<int> intialBlc(int id, int balance) async {
    Database db = await instance.database;
    return await db.rawUpdate('UPDATE groceriess SET totalblc = $balance  where id = $id ');
  }

  static Future<List<Map<String, dynamic>>> totalblc() async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT totalblc FROM groceriess WHERE mode = 1');
  }

  static void deleteDatabase() async {
    final appStorage = await getExternalStorageDirectory();

    String path = join(appStorage!.path, 'groceriess.db');
    databaseFactory.deleteDatabase(path);
    print("deleted");
  }
}
