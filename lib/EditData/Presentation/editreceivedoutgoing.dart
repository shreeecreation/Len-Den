import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:merokarobar/Database/database.dart';
import 'package:merokarobar/Database/editdatabase.dart/editdatabase.dart';
import 'package:merokarobar/Database/editdatabase.dart/model.dart';
import 'package:merokarobar/Home/Presentation/home.dart';
import 'package:merokarobar/Theme/theme.dart';
import 'package:merokarobar/Utils/dialog.dart';

// ignore: must_be_immutable
class EditReceived extends StatefulWidget {
  String username;
  final Map<String, dynamic> model;
  String modeString;
  int mode;
  // ignore: prefer_typing_uninitialized_variables
  var totalblc;
  EditReceived({super.key, required this.totalblc, required this.username, required this.model, required this.modeString, required this.mode});

  @override
  State<EditReceived> createState() => _EditReceivedState();
}

class _EditReceivedState extends State<EditReceived> {
  TextEditingController phoneNo = TextEditingController();

  TextEditingController openingBlc = TextEditingController();

  TextEditingController address = TextEditingController();

  final formGlobalKeyedit = GlobalKey<FormState>();
  @override
  void initState() {
    EditDatabaseHelper.initDatabase(widget.username);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Transactions (${widget.modeString})"),
          backgroundColor: CTheme.kPrimaryColor,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                  padding: EdgeInsets.all(8.0), child: Text("Party Information", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800))),
              widthLongTextField(context),
              balance(context),
              const SizedBox(height: 20),
              SizedBox(
                  width: MediaQuery.of(context).size.width - 10,
                  height: 45,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: CTheme.kPrimaryColor),
                      onPressed: () async {
                        void mainfunction() async {
                          var price = widget.mode == 1
                              ? widget.modeString == "Receiving"
                                  ? widget.totalblc - int.parse(openingBlc.text)
                                  : widget.totalblc + int.parse(openingBlc.text)
                              : widget.modeString == "Outgoing"
                                  ? widget.totalblc - int.parse(openingBlc.text)
                                  : widget.totalblc + int.parse(openingBlc.text);
                          DateTime now = DateTime.now();
                          String formattedDate = DateFormat('MMMM d , y – kk:mm a').format(now);
                          await EditDatabaseHelper.instance.add(
                              EditModel(
                                  blc: int.parse(openingBlc.text),
                                  date: formattedDate,
                                  mode: widget.mode == 1
                                      ? widget.modeString == "Receiving"
                                          ? 1
                                          : 0
                                      : widget.modeString == "Outgoing"
                                          ? 0
                                          : 1,
                                  name: widget.model["name"],
                                  initialblc: widget.model["blc"],
                                  totalblc: price),
                              widget.username);
                          DatabaseHelper.intialBlc(widget.model["id"], price);
                          Get.offAll(const Home());
                        }

                        if (formGlobalKeyedit.currentState!.validate()) {
                          formGlobalKeyedit.currentState!.save();
                          if (widget.totalblc < int.parse(openingBlc.text)) {
                            if (widget.mode == 1) {
                              if (widget.modeString == "Receiving") {
                                Dialogs.showMoreamount(context);
                              } else {
                                mainfunction();
                              }
                            }
                          }
                          if (widget.totalblc < int.parse(openingBlc.text)) {
                            if (widget.mode == 0) {
                              if (widget.modeString == "Outgoing") {
                                Dialogs.showMoreamount(context);
                              } else {
                                mainfunction();
                              }
                            }
                          }
                          if (widget.totalblc == int.parse(openingBlc.text)) {
                            if (widget.mode == 1) {
                              if (widget.modeString == "Receiving") {
                                Dialogs.showsetteld(context, widget.model, mainfunction);
                              } else {
                                mainfunction();
                              }
                            }
                            if (widget.mode == 0) {
                              if (widget.modeString == "Outgoing") {
                                Dialogs.showsetteld(context, widget.model, mainfunction);
                              } else {
                                mainfunction();
                              }
                            }
                          }

                          if (widget.totalblc > int.parse(openingBlc.text)) {
                            mainfunction();
                          }
                        }
                      },
                      child: const Text("Save"))),
            ],
          ),
        ));
  }

  Container balance(BuildContext context) {
    return Container(
      color: Colors.black12,
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
              color: Colors.white,
              child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                      initiallyExpanded: true,
                      title: const Text("Add Balance", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
                      textColor: Colors.black,
                      iconColor: Colors.black,
                      trailing: const Icon(Icons.add),
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                              const Text("Total Cash Received", style: TextStyle(fontSize: 16)),
                              Form(
                                key: formGlobalKeyedit,
                                child: SizedBox(
                                    height: 60,
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: TextFormField(
                                        cursorColor: Colors.black,
                                        controller: openingBlc,
                                        validator: (text) {
                                          if (text == null || text.isEmpty) {
                                            return 'Enter valid amount';
                                          }
                                          return null;
                                        },
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            filled: true,
                                            fillColor: Color.fromARGB(31, 128, 128, 128),
                                            hintText: 'Enter Amount',
                                            hintStyle: TextStyle(fontSize: 16)))),
                              )
                            ]))
                      ]))),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Container widthLongTextField(BuildContext context) {
    return Container(
        color: const Color.fromARGB(31, 199, 199, 199),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(padding: EdgeInsets.all(8.0), child: Text("Party Name", style: TextStyle(fontSize: 16))),
            SizedBox(
                // width: 40,
                height: 80,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        cursorColor: Colors.black,
                        readOnly: true,
                        initialValue: widget.model["name"],
                        decoration: const InputDecoration(border: InputBorder.none, filled: true, fillColor: Color.fromARGB(31, 128, 128, 128))))),
            const Padding(padding: EdgeInsets.all(8.0), child: Text("Phone Number", style: TextStyle(fontSize: 16))),
            SizedBox(
                height: 80,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        initialValue: widget.model["phone"],
                        cursorColor: Colors.black,
                        readOnly: true,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(border: InputBorder.none, filled: true, fillColor: Color.fromARGB(31, 128, 128, 128))))),
            const Padding(padding: EdgeInsets.all(8.0), child: Text("Current Balance", style: TextStyle(fontSize: 16))),
            SizedBox(
                height: 80,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        initialValue: widget.model["totalblc"].toString(),
                        cursorColor: Colors.black,
                        readOnly: true,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(border: InputBorder.none, filled: true, fillColor: Color.fromARGB(31, 128, 128, 128))))),
          ],
        ));
  }
}
