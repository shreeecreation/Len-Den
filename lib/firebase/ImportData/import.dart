import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:merokarobar/Utils/dialog.dart';
import 'package:path_provider/path_provider.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;

class ImportData {
  static Future<void> uploadFolder(var context) async {
    var firebaseuser = FirebaseAuth.instance.currentUser!;
    print(firebaseuser.uid);
    Reference ref = _storage.ref().child(firebaseuser.uid);
    ListResult files = await ref.listAll();
    if (files.items.length == 0) {
      Dialogs.nothingToImport(context);
    } else {
      // Loop through the files and download each one to the local storage
      for (var file in files.items) {
        String fileName = file.name;
        String localPath = (await getExternalStorageDirectory())!.path;
        String localFilePath = '$localPath/$fileName';

        // Download the file to the local storage
        file.writeToFile(File(localFilePath)).whenComplete(() {});
      }
      Dialogs.showDownloadedDialog(context);
    }
  }

//   static Future<void> deleteDirectory() async {
//     final Directory? externalDirectory = await getExternalStorageDirectory();

// // Create a function to clear all files in the external directory
//     Future<void> clearExternalDirectory() async {
//       // Get the list of files in the external directory
//       final List<FileSystemEntity> files = externalDirectory!.listSync();

//       // Loop through the files and delete each one
//       for (final FileSystemEntity file in files) {
//         if (file is File) {
//           file.delete();
//           print("deleted");
//         }
//       }
//     }

//     clearExternalDirectory();
//   }
}
