import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'model.dart';

class EditDatabaseHelper {
  static final EditDatabaseHelper instance = EditDatabaseHelper();
  static late String databasepath;
  static Database? _database;

  static Future<Database> initDatabase(String pathname) async {
    databasepath = pathname;
    final appStorage = await getExternalStorageDirectory();

    String path = join(appStorage!.path, '$pathname.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  static Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $databasepath(
          id INTEGER PRIMARY KEY,
          initialblc INTEGER,
          totalblc INTEGER,
          name TEXT ,
          blc INTEGER ,
          date TEXT ,
          mode INTEGER  
      )
      ''');
  }

  Future<List<EditModel>> getPartyName(String pathname) async {
    Database database = await initDatabase(pathname);

    Database? db = database;
    var groceries = await db.query(databasepath, orderBy: 'name');
    List<EditModel> groceryList = groceries.isNotEmpty ? groceries.map((c) => EditModel.fromMap(c)).toList() : [];
    return groceryList;
  }

  Future<int> add(EditModel grocery, String pathname) async {
    Database database = await initDatabase(pathname);

    Database? db = database;
    return await db.insert(databasepath, grocery.toMap());
  }

  Future<int> deleteparty(int id, String pathname) async {
    Database database = await initDatabase(pathname);

    Database? db = database;
    return await db.rawDelete('DELETE FROM $databasepath WHERE id = $id');
  }

  static void deleteDatabase() async {
    final appStorage = await getExternalStorageDirectory();

    String path = join(appStorage!.path, '$databasepath.db');
    databaseFactory.deleteDatabase(path);
    print("deleted");
  }
}
