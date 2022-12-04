import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merokarobar/Expenses/services/database.dart';
import 'package:merokarobar/Expenses/services/model.dart';
import 'package:merokarobar/Login/Presentation/home.dart';
import 'package:merokarobar/Theme/theme.dart';

class ExpenseDialog {
  static Future<void> showAlertDialog(BuildContext context, ExpensesModel expense, int index) async {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                title: Text("Category :  ${expense.category!}", style: const TextStyle(fontWeight: FontWeight.w500)),
                content: SizedBox(
                  height: MediaQuery.of(context).size.height / 3.5,
                  width: MediaQuery.of(context).size.width / 1.1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Total Expenses : ${expense.blc!.toString()}", style: const TextStyle(fontSize: 17)),
                      const SizedBox(height: 10),
                      Text(
                        expense.date!,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Payment Method : ${expense.payment!}",
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Additional Notes : ${expense.notes!}",
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: CTheme.kPrimaryColor),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Ok")),
                          ElevatedButton(
                              onPressed: () {
                                ExpenseDatabaseHelper.deleteparty(index);
                                Get.offAll(() => const HomePage());
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              child: const Text("Delete")),
                        ],
                      ),
                    ],
                  ),
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
}
