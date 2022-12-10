import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' as gets;
import 'package:get/get.dart';
import 'package:merokarobar/Database/database.dart';
import 'package:merokarobar/Database/editdatabase.dart/editdatabase.dart';
import 'package:merokarobar/Login/Presentation/home.dart';
import 'package:merokarobar/Theme/theme.dart';
import 'package:merokarobar/ThemeManager/themeprovider.dart';
import 'package:merokarobar/firebase/ImportData/import.dart';
import 'package:merokarobar/firebase/SyncData/sync.dart';
import 'package:path_provider/path_provider.dart';

class Dialogs {
  static Future<void> showAlertDialog(BuildContext context) async {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                backgroundColor: CTheme.kPrimaryColor,
                shape: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                title: const Text('Record Added Successfully'),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(elevation: 0, backgroundColor: Colors.black12),
                        onPressed: () async {
                          Navigator.pop(context);
                          await Future.delayed(const Duration(milliseconds: 500));
                          gets.Get.offAll(() => const HomePage(), transition: gets.Transition.downToUp);
                        },
                        child: const Text("Ok")),
                  ],
                ),
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return const Text("dasdas");
        });
  }

  static void showMoreamount(BuildContext context) {
    showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: AlertDialog(
            title: const Text("Error !", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
            content: const Text("Amount can't be greater than Total Balance ", style: TextStyle(fontWeight: FontWeight.w600)),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Continue",
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ))
            ],
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static void showsetteld(BuildContext context, Map<String, dynamic> model, void Function() a) {
    showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: AlertDialog(
            title: Text("Setteled", style: TextStyle(color: CTheme.kPrimaryColor, fontWeight: FontWeight.w600, fontSize: 20)),
            content: SizedBox(
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Setteled the  ${model["name"]} user payment", style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 5),
                  Text("Total Amount was ${model["totalblc"]}", style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await Future.delayed(const Duration(milliseconds: 500));
                    a();
                  },
                  style: TextButton.styleFrom(backgroundColor: CTheme.kPrimaryColor),
                  child: const Text("Ok", style: TextStyle(color: Colors.white, fontSize: 16))),
              TextButton(
                  style: TextButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () async {
                    DatabaseHelper.deleteparty(model["id"]);
                    EditDatabaseHelper.deleteDatabase();
                    Navigator.of(context).pop();
                    await Future.delayed(const Duration(milliseconds: 500));
                    gets.Get.offAll(() => const HomePage());
                  },
                  child: const Text("Delete", style: TextStyle(color: Colors.white, fontSize: 16)))
            ],
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static void chooseTheme(BuildContext context) {
    showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: AlertDialog(
            title: const Text("Choose Theme", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 20)),
            content: SizedBox(
                height: 100,
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                  GestureDetector(
                    onTap: () {
                      context.read<ThemeProvider>().setThemeColor(1);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.green),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.read<ThemeProvider>().setThemeColor(2);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.orange),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.read<ThemeProvider>().setThemeColor(3);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.read<ThemeProvider>().setThemeColor(4);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.purple),
                    ),
                  )
                ])),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static void importData(BuildContext context) {
    showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: AlertDialog(
            title: const Text("Import Data", style: TextStyle(color: Colors.green, fontWeight: FontWeight.w700)),
            content: const Text("Do you sure want to Import Data ?", style: TextStyle(fontWeight: FontWeight.w600)),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    // ImportData.deleteDirectory();
                    ImportData.uploadFolder(context);
                    // DatabaseHelper.deleteDatabase();
                    // ExpenseDatabaseHelper.deleteDatabase();

                    Navigator.of(context).pop();
                    Dialogs.importDownloadIndicator(context, "Importing");
                  },
                  child: const Text(
                    "Import",
                    style: TextStyle(color: Colors.green, fontSize: 16),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ))
            ],
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static void syncData(BuildContext context) {
    showGeneralDialog(
      barrierDismissible: false,
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: AlertDialog(
            title: const Text("Sync Data", style: TextStyle(color: Colors.green, fontWeight: FontWeight.w700)),
            content: const Text("Do you sure want to Sync Data ?", style: TextStyle(fontWeight: FontWeight.w600)),
            actions: <Widget>[
              TextButton(
                  onPressed: () async {
                    final appStorage = await getExternalStorageDirectory();

                    SyncData.uploadFolder(appStorage, context);

                    Navigator.of(context).pop();
                    Dialogs.importDownloadIndicator(context, "Syncing");
                  },
                  child: const Text(
                    "Sync",
                    style: TextStyle(color: Colors.green, fontSize: 16),
                  )),
              TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ))
            ],
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static void noInternet(BuildContext context) {
    showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: AlertDialog(
            title: const Text("No Internet", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700)),
            content: const Text("No Internet Connection ! ", style: TextStyle(fontWeight: FontWeight.w600)),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Ok",
                    style: TextStyle(color: Colors.green, fontSize: 16),
                  )),
            ],
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static void importDownloadIndicator(BuildContext context, var a) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: Transform.scale(
            scale: curve,
            child: AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(a, style: TextStyle(color: Colors.green, fontSize: 24, fontWeight: FontWeight.w500)),
                ],
              ),
              content: SizedBox(
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SizedBox(height: 10),
                    LinearProgressIndicator(),
                    SizedBox(height: 10),
                    Text("Please connect to the internet while syncing your data to the server",
                        textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: Colors.black45))
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static void showDownloadedDialog(BuildContext context) {
    showGeneralDialog(
      barrierDismissible: false,
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: Transform.scale(
            scale: curve,
            child: AlertDialog(
              title: const Text("Imported", style: TextStyle(color: Colors.green, fontWeight: FontWeight.w700)),
              content: SizedBox(
                height: 60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SizedBox(height: 10),
                    SizedBox(height: 10),
                    Text("Please restart your Len - Den application",
                        textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: Colors.black))
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      // Restart.restartApp(webOrigin: '/');
                      Get.offAll(() => HomePage());
                    },
                    child: const Text(
                      "Restart",
                      style: TextStyle(color: Colors.green, fontSize: 16),
                    )),
              ],
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static void showSyncedDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: Transform.scale(
            scale: curve,
            child: AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Synced", style: TextStyle(color: Colors.green, fontSize: 24, fontWeight: FontWeight.w500)),
                ],
              ),
              content: SizedBox(
                height: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // SizedBox(height: 10),
                    SizedBox(height: 10),
                    Text("Your data have been saved in database and you can access it from anywhere",
                        textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: Colors.black45)),
                    TextButton(
                        style: TextButton.styleFrom(backgroundColor: Colors.green),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "Continue",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        )),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static void nothingToImport(BuildContext context) {
    showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: AlertDialog(
            title: const Text("Nothing To Import", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700)),
            content: const Text("You are having a new account ", style: TextStyle(fontWeight: FontWeight.w600)),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Ok",
                    style: TextStyle(color: Colors.green, fontSize: 16),
                  )),
            ],
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
