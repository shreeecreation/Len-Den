import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'model.dart';

class ExpenseDatabaseHelper {
  ExpenseDatabaseHelper._privateConstructor();
  static final ExpenseDatabaseHelper instance = ExpenseDatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  static Future<Database> _initDatabase() async {
    final appStorage = await getExternalStorageDirectory();

    String path = join(appStorage!.path, 'expense.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  static Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE expense(
          id INTEGER PRIMARY KEY,
          payment TEXT,
          blc INTEGER,
          category TEXT,
          notes TEXT ,  
          date TEXT
      )
      ''');
  }

  static Future<List<Map<String, Object?>>> totalblc() async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT blc FROM expense');
  }

  // static Future<List<Map<String, Object?>>> paidblc() async {
  //   Database db = await instance.database;
  //   return await db.rawQuery('SELECT totalblc FROM expense WHERE mode = 0');
  // }

  Future<List<ExpensesModel>> getPartyName() async {
    Database db = await instance.database;
    var expense = await db.query('expense', orderBy: 'id');
    List<ExpensesModel> groceryList = expense.isNotEmpty ? expense.map((c) => ExpensesModel.fromMap(c)).toList() : [];
    return groceryList;
  }

  Future<int> add(ExpensesModel expense) async {
    Database db = await instance.database;
    return await db.insert('expense', expense.toMap());
  }

  static Future<int> deleteparty(int id) async {
    Database db = await instance.database;
    return await db.rawDelete('DELETE FROM expense WHERE id = $id');
  }

  static Future<int> intialBlc(int id, int balance) async {
    Database db = await instance.database;
    return await db.rawUpdate('UPDATE expense SET totalblc = $balance  where id = $id ');
  }

  static void deleteDatabase() async {
    final appStorage = await getExternalStorageDirectory();
    String path = join(appStorage!.path, 'expense.db');
    databaseFactory.deleteDatabase(path);
  }
}
