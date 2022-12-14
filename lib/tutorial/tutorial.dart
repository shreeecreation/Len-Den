import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merokarobar/ThemeManager/themeprovider.dart';

class Tutorial extends StatefulWidget {
  Tutorial({super.key, required this.mode});
  final bool mode;

  @override
  State<Tutorial> createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  String content = "Loading";
  @override
  void initState() {
    super.initState();
    fetch();
  }

  fetch() async {
    String response;
    response = widget.mode ? await rootBundle.loadString("assets/increaseincome.txt") : await rootBundle.loadString("assets/decreaseexpense.txt");
    setState(() {
      content = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color? primaryColor = context.watch<ThemeProvider>().themecolor;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text(widget.mode ? "Manage Incoming" : "Manage Expense"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(content),
        ));
  }
}
