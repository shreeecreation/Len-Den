import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SyncData {
  static var firebaseuser = FirebaseAuth.instance.currentUser!;

  static final storageRef = firebase_storage.FirebaseStorage.instance;

  static Future<void> uploadFolder(var a) async {
    String path = a!.path;
    final String folderPath = '$path';
    List<File> files = Directory(folderPath).listSync().map((item) => File(item.path)).toList();

    for (var file in files) {
      String fileName = file.path.split('/').last;

      firebase_storage.Reference ref = storageRef.ref('/${firebaseuser.uid}/${fileName}');
      firebase_storage.UploadTask uploadtask = ref.putFile(file);
      await Future.value(uploadtask);
    }
  }
}
