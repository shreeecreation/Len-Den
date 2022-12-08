import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;

class ImportData {
  static var firebaseuser = FirebaseAuth.instance.currentUser!;

  static Future<void> uploadFolder() async {
    print("uploading");
    Reference ref = _storage.ref().child(firebaseuser.uid);
    ListResult files = await ref.listAll();

    // Loop through the files and download each one to the local storage
    for (var file in files.items) {
      String fileName = file.name;
      String localPath = (await getExternalStorageDirectory())!.path;
      String localFilePath = '$localPath/$fileName';

      // Download the file to the local storage
      file.writeToFile(File(localFilePath));
    }
  }
}
