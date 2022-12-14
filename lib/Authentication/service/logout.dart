import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:merokarobar/Database/database.dart';
import 'package:merokarobar/Expenses/services/database.dart';
import 'package:path_provider/path_provider.dart';

class LogOut {
  static logOut() async {
    deleteCacheDir();
    deleteAppDir();
    DatabaseHelper.deleteDatabase();
    ExpenseDatabaseHelper.deleteDatabase();

    await FirebaseAuth.instance.signOut();
  }

  static Future<void> deleteCacheDir() async {
    Directory tempDir = await getTemporaryDirectory();

    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  }

  static Future<void> deleteAppDir() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();

    if (appDocDir.existsSync()) {
      appDocDir.deleteSync(recursive: true);
    }
  }
}
