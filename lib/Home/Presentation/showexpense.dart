import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:merokarobar/Database/database.dart';
import 'package:merokarobar/Database/model.dart';
import 'package:merokarobar/EditData/Service/blcprovider.dart';
import 'package:merokarobar/Theme/theme.dart';

class ShowExpense extends StatelessWidget {
  const ShowExpense({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CTheme.kPrimaryColor,
          title: const Text("Outgoings "),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header(context, context.watch<BlcProvider>().totalblc.toString()),
              const SizedBox(height: 10),
              const Text("  All Outgoings", style: TextStyle(fontSize: 19)),
              SizedBox(
                child: FutureBuilder<List<PartyModel>>(
                  future: DatabaseHelper.getOutgoing(),
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
                            Text("No Outgoings found !", style: TextStyle(fontSize: 18, color: Colors.black54)),
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
                                                  child: cardView0(snapshot.data![index].date, snapshot.data![index].blc, snapshot.data![index].name,
                                                      snapshot.data![index].phone)),
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

  Stack header(BuildContext context, blc) {
    return Stack(children: [
      Container(color: CTheme.kPrimaryColor, height: MediaQuery.of(context).size.height / 5),
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
                      const Text("Total Outgoing", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 12),
                      Text("Rs. $blc", style: const TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 12),
                      SizedBox(
                          height: 35,
                          width: 160,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              onPressed: () {},
                              child: const Text("Decrease Expenses"))),
                    ])),
              ]))))
    ]);
  }

  Card cardView0(date, blc, name, number) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
            title: Text("Outgoing to $name ", style: const TextStyle(fontSize: 18)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(date),
                const SizedBox(height: 2),
                TextButton(
                    style: TextButton.styleFrom(backgroundColor: Colors.black12),
                    onPressed: () {},
                    child: Text("Phone No. $number", style: TextStyle(color: CTheme.kPrimaryColor)))
              ],
            ),
            trailing: Text("Rs. $blc", style: const TextStyle(color: Colors.red))),
      ),
    );
  }
}
