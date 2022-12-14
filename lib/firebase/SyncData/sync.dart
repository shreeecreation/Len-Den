import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:merokarobar/Utils/dialog.dart';

class SyncData {
  static Future<void> uploadFolder(var a, var context) async {
    final storageRef = firebase_storage.FirebaseStorage.instance;
    var firebaseuser = FirebaseAuth.instance.currentUser!;
    try {
      var folderRef = storageRef.ref().child(firebaseuser.uid);
      var files = await folderRef.listAll();
      for (var file in files.items) {
        await file.delete();
      }
    } catch (e) {
      print('Error deleting files: $e');
    }
    String path = a!.path;
    final String folderPath = '$path';
    List<File> files = Directory(folderPath).listSync().map((item) => File(item.path)).toList();

    for (var file in files) {
      String fileName = file.path.split('/').last;

      firebase_storage.Reference ref = storageRef.ref('/${firebaseuser.uid}/${fileName}');
      firebase_storage.UploadTask uploadtask = ref.putFile(file);
      await Future.value(uploadtask).whenComplete(() {});
    }
    Dialogs.showSyncedDialog(context);
  }

  static Future<void> uploadFolderlogout(var a, var context) async {
    final storageRef = firebase_storage.FirebaseStorage.instance;
    var firebaseuser = FirebaseAuth.instance.currentUser!;
    try {
      var folderRef = storageRef.ref().child(firebaseuser.uid);
      var files = await folderRef.listAll();
      for (var file in files.items) {
        await file.delete();
      }
    } catch (e) {
      print('Error deleting files: $e');
    }
    String path = a!.path;
    final String folderPath = '$path';
    List<File> files = Directory(folderPath).listSync().map((item) => File(item.path)).toList();

    for (var file in files) {
      String fileName = file.path.split('/').last;

      firebase_storage.Reference ref = storageRef.ref('/${firebaseuser.uid}/${fileName}');
      firebase_storage.UploadTask uploadtask = ref.putFile(file);
      await Future.value(uploadtask).whenComplete(() {});
    }
    Dialogs.logOut(context);
  }
}
