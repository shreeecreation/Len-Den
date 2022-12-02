import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:merokarobar/Database/database.dart';
import 'package:merokarobar/Database/model.dart';
import 'package:merokarobar/Login/Presentation/home.dart';
import 'package:merokarobar/Theme/theme.dart';

// ignore: must_be_immutable
class AddTodosOut extends StatelessWidget {
  AddTodosOut({super.key});
  TextEditingController partyName = TextEditingController();
  TextEditingController phoneNo = TextEditingController();
  TextEditingController openingBlc = TextEditingController();
  TextEditingController address = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();
  final formGlobalKey2 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add New Party (Outgoing)"),
          backgroundColor: CTheme.kPrimaryColor,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                  padding: EdgeInsets.all(8.0), child: Text("Party Information", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800))),
              widthLongTextField(context),
              balance(context),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: savebutton(context),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget savebutton(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: CTheme.kPrimaryColor),
        onPressed: () async {
          if (formGlobalKey.currentState!.validate() && formGlobalKey2.currentState!.validate()) {
            formGlobalKey.currentState!.save();
            formGlobalKey2.currentState!.save();
            DateTime now = DateTime.now();
            String formattedDate = DateFormat('MMMM d , y – kk:mm a').format(now);
            await DatabaseHelper.instance.add(PartyModel(
                name: partyName.text,
                phone: phoneNo.text,
                blc: int.parse(openingBlc.text),
                address: address.text,
                date: formattedDate,
                mode: 0,
                totalblc: int.parse(openingBlc.text)));
            await Future.delayed(const Duration(seconds: 1), () {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                Navigator.pushAndRemoveUntil<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => const HomePage(),
                    ),
                    (route) => false);
              });
            });
          }
        },
        child: const Text("Save"));
  }

  Container balance(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('y – kk:mm a').format(now);
    return Container(
        color: Colors.black12,
        child: Column(children: [
          const SizedBox(height: 20),
          Form(
            key: formGlobalKey2,
            child: Container(
                color: Colors.white,
                child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                        title: const Text(
                          "Opening Balance",
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                        ),
                        textColor: Colors.black,
                        iconColor: Colors.black,
                        trailing: const Icon(Icons.add),
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                                SizedBox(
                                    height: 60,
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: TextFormField(
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                                        ], // O
                                        validator: (text) {
                                          if (text == null || text.isEmpty) {
                                            return 'Error !!!';
                                          }

                                          return null;
                                        },
                                        cursorColor: Colors.black,
                                        controller: openingBlc,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            filled: true,
                                            fillColor: Color.fromARGB(31, 128, 128, 128),
                                            hintText: 'Enter Amount',
                                            hintStyle: TextStyle(fontSize: 16)))),
                                const SizedBox(width: 20),
                                SizedBox(
                                    height: 50,
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: TextFormField(
                                        initialValue: formattedDate,
                                        cursorColor: Colors.black,
                                        decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            filled: true,
                                            fillColor: Color.fromARGB(31, 128, 128, 128),
                                            hintText: 'Date',
                                            hintStyle: TextStyle(fontSize: 16))))
                              ]))
                        ]))),
          ),
          const SizedBox(height: 20),
          Container(
              color: Colors.white,
              child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                      title: const Text("Additional Details", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
                      textColor: Colors.black,
                      iconColor: Colors.black,
                      trailing: const Icon(Icons.add),
                      children: <Widget>[
                        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                                height: 50,
                                width: MediaQuery.of(context).size.width - 20,
                                child: TextFormField(
                                    controller: address,
                                    cursorColor: Colors.black,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        filled: true,
                                        fillColor: Color.fromARGB(31, 128, 128, 128),
                                        hintText: 'Add Address',
                                        hintStyle: TextStyle(fontSize: 16)))),
                          )
                        ])
                      ]))),
          const SizedBox(height: 20)
        ]));
  }

  Container widthLongTextField(BuildContext context) {
    return Container(
        color: const Color.fromARGB(31, 199, 199, 199),
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: formGlobalKey,
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
                          textCapitalization: TextCapitalization.words,
                          controller: partyName,
                          cursorColor: Colors.black,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Party Name can\'t be empty';
                            }

                            return null;
                          },
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Color.fromARGB(31, 128, 128, 128),
                              hintText: 'Enter Party Name',
                              hintStyle: TextStyle(fontSize: 16))))),
              const Padding(padding: EdgeInsets.all(8.0), child: Text("Phone Number", style: TextStyle(fontSize: 16))),
              SizedBox(
                  height: 80,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                          ],
                          controller: phoneNo,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Phone Number can\'t be empty';
                            }
                            if (text.length <= 9) {
                              return 'Enter a valid phone number';
                            }

                            return null;
                          },
                          maxLength: 10,
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              counterText: "",
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Color.fromARGB(31, 128, 128, 128),
                              hintText: 'Enter Contact Number',
                              hintStyle: TextStyle(fontSize: 16))))),
            ],
          ),
        ));
  }
}
