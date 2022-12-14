import 'package:flutter/material.dart';
import 'package:merokarobar/ThemeManager/themeprovider.dart';
import 'package:provider/provider.dart';

class ComingSoon extends StatelessWidget {
  const ComingSoon({super.key});

  @override
  Widget build(BuildContext context) {
    Color? primaryColor = context.watch<ThemeProvider>().themecolor;

    return Scaffold(
        appBar: AppBar(
          title: Text("Feature"),
          backgroundColor: primaryColor,
        ),
        body: Center(child: Text("Features Coming Soon !", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700))));
  }
}
