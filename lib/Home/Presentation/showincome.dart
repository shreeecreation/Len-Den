import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:merokarobar/Database/database.dart';
import 'package:merokarobar/Database/model.dart';
import 'package:merokarobar/EditData/Service/blcprovider.dart';
import 'package:merokarobar/Theme/theme.dart';
import 'package:merokarobar/ThemeManager/themeprovider.dart';
import 'package:merokarobar/tutorial/tutorial.dart';

class ShowIncome extends StatelessWidget {
  const ShowIncome({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    Color? primaryColor = context.watch<ThemeProvider>().themecolor;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: const Text("Income "),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header(context, context.watch<BlcProvider>().totalblc.toString(), primaryColor),
              const SizedBox(height: 10),
              const Text("  All Incomes", style: TextStyle(fontSize: 19)),
              SizedBox(
                child: FutureBuilder<List<PartyModel>>(
                  future: DatabaseHelper.getIncome(),
                  builder: (BuildContext context, AsyncSnapshot<List<PartyModel>> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text("Loading"),
                      );
                    }
                    return snapshot.data!.isEmpty
                        ? Center(
                            child: Column(children: const [
                            Icon(Icons.person, size: 150, color: Colors.black54),
                            Text("No Income found !", style: TextStyle(fontSize: 18, color: Colors.black54)),
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
                                                  child: cardView0(snapshot.data![index].date, snapshot.data![index].totalblc,
                                                      snapshot.data![index].blc, snapshot.data![index].name, snapshot.data![index].phone)),
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
                      const Text("Total Incoming", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 12),
                      Text("Rs. $blc", style: const TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 12),
                      SizedBox(
                          height: 35,
                          width: 160,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                              onPressed: () {
                                Get.to(() => Tutorial(mode: true));
                              },
                              child: const Text("Increase Incomes"))),
                    ])),
              ]))))
    ]);
  }

  Card cardView0(date, totalblc, currentblc, name, number) {
    var blc = currentblc - totalblc;
    if (blc < 0) {
      blc = 0;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ListTile(
            title: Text("Incoming from $name ", style: const TextStyle(fontSize: 18)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(date),
                const SizedBox(height: 2),
                TextButton(
                    style: TextButton.styleFrom(backgroundColor: Colors.black12),
                    onPressed: () {},
                    child: Text("Phone No. $number", style: TextStyle(color: Colors.black54)))
              ],
            ),
            trailing: Column(
              children: [
                Text(" Total Rs. $currentblc", style: TextStyle(color: CTheme.kPrimaryColor, fontSize: 16)),
                const SizedBox(height: 15),
                Text(" Received Rs. ${blc}", style: TextStyle(color: CTheme.kPrimaryColor, fontSize: 15)),
              ],
            )),
      ),
    );
  }
}
