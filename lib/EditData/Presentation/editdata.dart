import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merokarobar/Database/editdatabase.dart/editdatabase.dart';
import 'package:merokarobar/Database/editdatabase.dart/model.dart';
import 'package:merokarobar/Theme/theme.dart';

class EditParty extends StatelessWidget {
  final Map<String, dynamic> model;

  const EditParty({super.key, required this.model});
  @override
  Widget build(BuildContext context) {
    var name = model["name"];
    var blc = model["blc"];
    var totalblc = model["totalblc"];
    var date = model["date"];
    var phone = model["phone"];
    var mode = model["mode"];
    var finalName = name.toString().removeAllWhitespace;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: CTheme.kPrimaryColor,
          title: Text(model["name"]),
        ),
        bottomNavigationBar: BottomAppBar(
          notchMargin: 0,
          color: Colors.transparent,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                    width: (MediaQuery.of(context).size.width / 2.5),
                    height: 50,
                    child: TextButton(
                        onPressed: () {
                          final finalName = name.toString().replaceAll(' ', "");
                          Navigator.pushReplacementNamed(context, "editr",
                              arguments: {"username": finalName, "model": model, "mode": mode, "modeString": "Receiving", "totalblc": totalblc});
                        },
                        style: TextButton.styleFrom(backgroundColor: CTheme.kPrimaryColor),
                        child: const Text("Received", style: TextStyle(fontSize: 18, color: Colors.white)))),
                IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
                SizedBox(
                    width: (MediaQuery.of(context).size.width / 2.5),
                    height: 50,
                    child: TextButton(
                        onPressed: () {
                          final finalName = name.toString().replaceAll(' ', "");
                          Navigator.pushReplacementNamed(context, "editr",
                              arguments: {"username": finalName, "model": model, "mode": mode, "modeString": "Outgoing", "totalblc": totalblc});
                        },
                        style: TextButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text("Outgoing", style: TextStyle(fontSize: 18, color: Colors.white)))),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(context, name, phone, mode, totalblc),
            const SizedBox(height: 10),
            const Text("  All Transactions", style: TextStyle(fontSize: 19)),
            cardView0(mode, date, blc),
            SizedBox(
              child: FutureBuilder<List<EditModel>>(
                future: EditDatabaseHelper.instance.getPartyName(finalName),
                builder: (BuildContext context, AsyncSnapshot<List<EditModel>> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: Text("Loading"),
                    );
                  }
                  return snapshot.data!.isEmpty
                      ? const Text("")
                      : ListView.builder(
                          shrinkWrap: true,
                          reverse: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) => Column(
                                children: [
                                  cardView1(snapshot.data![index].mode, snapshot.data![index].date, snapshot.data![index].totalblc,
                                      snapshot.data![index].blc.toString()),
                                  const Divider(),
                                ],
                              ));
                },
              ),
            )
          ],
        )));
  }

  Card cardView0(mode, date, blc) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
            title: Text(mode == 1 ? "Received " : "Outgoing", style: const TextStyle(fontSize: 18)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(date),
                const SizedBox(height: 2),
                TextButton(
                    style: TextButton.styleFrom(backgroundColor: Colors.black12),
                    onPressed: () {},
                    child: Text(" Blc: Rs. $blc", style: TextStyle(color: mode == 1 ? CTheme.kPrimaryColor : Colors.red)))
              ],
            ),
            trailing: Text("Rs. $blc", style: TextStyle(color: mode == 1 ? CTheme.kPrimaryColor : Colors.red))),
      ),
    );
  }

  Stack header(BuildContext context, name, phone, mode, blc) {
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
                    padding: const EdgeInsets.all(10),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(name, style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 4),
                      Text("+977- $phone", style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 10),
                      Text(mode == 1 ? "To Receive : " : "To Give :", style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 4),
                      Text("Rs. $blc", style: TextStyle(fontSize: 15, color: mode == 1 ? CTheme.kPrimaryColor : Colors.red))
                    ])),
                Row(children: [rowButtons(Icons.phone), rowButtons(Icons.message)])
              ]))))
    ]);
  }

  ElevatedButton rowButtons(IconData icon) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
          shape: const CircleBorder(), padding: const EdgeInsets.all(8), backgroundColor: CTheme.kPrimaryColor // <-- Button color
          ),
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }

  Card cardView1(mode, date, blc, currentblc) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
            title: Text(mode == 1 ? "Received " : "Outgoing", style: const TextStyle(fontSize: 18)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(date),
                const SizedBox(height: 2),
                TextButton(
                    style: TextButton.styleFrom(backgroundColor: Colors.black12),
                    onPressed: () {},
                    child: Text(" Blc: Rs. $blc", style: TextStyle(color: mode == 1 ? CTheme.kPrimaryColor : Colors.red)))
              ],
            ),
            trailing: Text("Rs. $currentblc", style: TextStyle(color: mode == 1 ? CTheme.kPrimaryColor : Colors.red))),
      ),
    );
  }
}
