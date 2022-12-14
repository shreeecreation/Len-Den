import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:merokarobar/Expenses/services/expensedialog.dart';
import 'package:merokarobar/Expenses/services/model.dart';
import 'package:merokarobar/ThemeManager/themeprovider.dart';
import 'package:merokarobar/tutorial/tutorial.dart';

import 'services/database.dart';

class ShowExpenses extends StatelessWidget {
  const ShowExpenses({super.key, required this.totalblc});
  final int totalblc;
  @override
  Widget build(BuildContext context) {
    Color? primaryColor = context.watch<ThemeProvider>().themecolor;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: const Text("Expense Manager"),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header(context, totalblc.toString(), primaryColor),
              const SizedBox(height: 10),
              const Text("  All Expenses", style: TextStyle(fontSize: 19)),
              SizedBox(
                child: FutureBuilder<List<ExpensesModel>>(
                  future: ExpenseDatabaseHelper.getPartyName(),
                  builder: (BuildContext context, AsyncSnapshot<List<ExpensesModel>> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text("Loading"),
                      );
                    }
                    return snapshot.data!.isEmpty
                        ? Center(
                            child: Column(children: const [
                            Icon(Icons.person, size: 150, color: Colors.black54),
                            Text("No Expenses found !", style: TextStyle(fontSize: 18, color: Colors.black54)),
                            SizedBox(height: 10),
                          ]))
                        : AnimationLimiter(
                            child: ListView.builder(
                                shrinkWrap: true,
                                reverse: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) => Column(
                                      children: [
                                        AnimationConfiguration.staggeredList(
                                            position: index,
                                            child: SlideAnimation(
                                              verticalOffset: 50.0,
                                              duration: const Duration(seconds: 1),
                                              child: FadeInAnimation(
                                                  child: cardView1(
                                                      snapshot.data![index].date,
                                                      snapshot.data![index].blc,
                                                      snapshot.data![index].category,
                                                      snapshot.data![index].payment,
                                                      snapshot.data![index].notes,
                                                      context,
                                                      snapshot.data![index],
                                                      snapshot.data![index].id!,
                                                      primaryColor)),
                                            )),
                                        const Divider(),
                                      ],
                                    )),
                          );
                  },
                ),
              ),
            ],
          ),
        ));
  }

  Stack header(BuildContext context, blc, var primaryColor) {
    return Stack(children: [
      Container(color: primaryColor, height: MediaQuery.of(context).size.height / 5),
      Positioned(
          left: 10,
          child: SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              width: MediaQuery.of(context).size.width - 20,
              child: Card(
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text("Total Expenses", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Text("Rs. $blc", style: const TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      SizedBox(
                          height: 35,
                          width: 160,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                              onPressed: () {
                                Get.to(() => Tutorial(mode: false));
                              },
                              child: const Text("Minimize Expense"))),
                    ])),
              ]))))
    ]);
  }

  Card cardView1(date, blc, category, payment, notes, BuildContext context, ExpensesModel expense, int index, var primaryColor) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: const Text("Expenses", style: TextStyle(fontSize: 18)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(date),
              const SizedBox(height: 2),
              TextButton(
                  style: TextButton.styleFrom(backgroundColor: Colors.black12),
                  onPressed: () {},
                  child: Text("Category : $category", overflow: TextOverflow.clip, style: const TextStyle(color: Colors.red)))
            ],
          ),
          trailing: ElevatedButton(
            onPressed: () {
              ExpenseDialog.showAlertDialog(context, expense, index);
            },
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(8), backgroundColor: primaryColor // <-- Button color
                ),
            child: const Text("More Details"),
          ),
        ),
      ),
    );
  }
}
