import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_button/group_button.dart';
import 'package:intl/intl.dart';
import 'package:merokarobar/Expenses/services/database.dart';
import 'package:merokarobar/ThemeManager/themeprovider.dart';
import 'package:merokarobar/Utils/dialog.dart';

import 'services/model.dart';

// ignore: must_be_immutable
class AddExpenses extends StatelessWidget {
  AddExpenses({super.key});
  final TextEditingController partyName = TextEditingController();
  final TextEditingController notescontroller = TextEditingController();
  final TextEditingController phoneNo = TextEditingController();
  final TextEditingController openingBlc = TextEditingController();
  final TextEditingController address = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();
  final String category = "Home";
  String payment = "Cash";

  @override
  Widget build(BuildContext context) {
    Color? primaryColor = context.watch<ThemeProvider>().themecolor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Add Expense"),
      ),
      body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Padding(padding: EdgeInsets.all(8.0), child: Text("Expenses Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600))),
          widthLongTextField(context, primaryColor),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [SizedBox(width: MediaQuery.of(context).size.width / 2, child: savebutton(context, primaryColor))]),
        ]),
      ),
    );
  }

  Container widthLongTextField(BuildContext context, var primaryColor) {
    return Container(
        color: const Color.fromARGB(31, 199, 199, 199),
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: formGlobalKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(padding: EdgeInsets.all(8.0), child: Text("Category", style: TextStyle(fontSize: 16))),
              const Category(),
              const Padding(padding: EdgeInsets.all(8.0), child: Text("Amount", style: TextStyle(fontSize: 16))),
              amount(),
              const Padding(padding: EdgeInsets.all(8.0), child: Text("Payment Method", style: TextStyle(fontSize: 16))),
              paymethod(primaryColor),
              const Padding(padding: EdgeInsets.all(8.0), child: Text("Add Notes", style: TextStyle(fontSize: 16))),
              notes(),
            ],
          ),
        ));
  }

  SizedBox amount() {
    const inputDecoration = InputDecoration(
        counterText: "",
        border: InputBorder.none,
        filled: true,
        fillColor: Color.fromARGB(31, 128, 128, 128),
        hintText: 'Enter Amount',
        hintStyle: TextStyle(fontSize: 16));

    return SizedBox(
        height: 80,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]"))],
                controller: openingBlc,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Amount can\'t be empty';
                  }
                  return null;
                },
                maxLength: 10,
                cursorColor: Colors.black,
                keyboardType: TextInputType.number,
                decoration: inputDecoration)));
  }

  Padding paymethod(var primaryColor) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: GroupButton(
        borderRadius: BorderRadius.circular(25),
        spacing: 5,
        selectedColor: primaryColor,
        buttons: const ['Cash', 'Cheque', 'Others'],
        onSelected: (index, isSelected) {
          switch (index) {
            case 0:
              payment = "Cash";
              break;
            case 1:
              payment = "Cheque";
              break;
            case 2:
              payment = "Others";
              break;
          }
        },
      ),
    );
  }

  SizedBox notes() {
    const inputDecoration = InputDecoration(border: InputBorder.none, filled: true, fillColor: Color.fromARGB(31, 128, 128, 128));

    return SizedBox(
        height: 80,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
                textCapitalization: TextCapitalization.words,
                controller: notescontroller,
                maxLength: 100,
                maxLines: 5,
                cursorColor: Colors.black,
                decoration: inputDecoration)));
  }

  ElevatedButton savebutton(BuildContext context, var primaryColor) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
        onPressed: () async {
          FocusManager.instance.primaryFocus?.unfocus();
          if (formGlobalKey.currentState!.validate()) {
            Dialogs.showAlertDialog(context);
            formGlobalKey.currentState!.save();
            DateTime now = DateTime.now();
            String formattedDate = DateFormat('MMMM d , y – kk:mm a').format(now);
            await ExpenseDatabaseHelper.instance.add(ExpensesModel(
                payment: payment,
                blc: int.parse(openingBlc.text),
                category: CategoryState.dropdownvalue,
                notes: notescontroller.text,
                date: formattedDate));
          }
        },
        child: const Text("Save", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300)));
  }
}

class Category extends StatefulWidget {
  const Category({Key? key}) : super(key: key);

  @override
  CategoryState createState() => CategoryState();
}

class CategoryState extends State<Category> {
  // Initial Selected Value
  static String dropdownvalue = 'Home';

  // List of items in our dropdown menu
  var items = ['Home', 'School/College', 'Entertainment', 'Travel', 'Miscellanous'];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: Container(
              height: 40.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.black12,
              ),
              child: DropdownButtonHideUnderline(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton(
                    // Initial Value
                    value: dropdownvalue,

                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue = newValue!;
                      });
                    },
                  ),
                ),
              ))),
    );
  }
}
// Category
// Amount
// pay method
// note
// date