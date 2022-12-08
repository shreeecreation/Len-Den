import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' as gets;
import 'package:merokarobar/ThemeManager/themeprovider.dart';
import 'package:merokarobar/Utils/dialog.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    var styleFrom = ElevatedButton.styleFrom(
        shape: const CircleBorder(), padding: const EdgeInsets.all(8), backgroundColor: context.watch<ThemeProvider>().themecolor);
    const subtitleStyle = TextStyle(fontSize: 13);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: context.watch<ThemeProvider>().themecolor,
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(height: 20),
          SizedBox(
            height: 60,
            child: ListTile(
              title: const Text("App Settings"),
              onTap: () {
                gets.Get.to(() => const AppSettings(), transition: gets.Transition.downToUp);
              },
              subtitle: const Text(
                "Theme Mode, Language, Enable App Lock",
                style: subtitleStyle,
              ),
              trailing: Icon(Icons.chevron_right_sharp, color: context.watch<ThemeProvider>().themecolor),
              leading: ElevatedButton(onPressed: () {}, style: styleFrom, child: const Icon(Icons.settings, color: Colors.white, size: 30)),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 70,
            child: ListTile(
              title: const Text("Account Settings"),
              subtitle: const Text("Name, Personal Details", style: subtitleStyle),
              trailing: Icon(Icons.chevron_right_sharp, color: context.watch<ThemeProvider>().themecolor),
              leading: ElevatedButton(onPressed: () {}, style: styleFrom, child: const Icon(Icons.person, color: Colors.white, size: 30)),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 70,
            child: ListTile(
              title: const Text("About"),
              subtitle: const Text("Len Den App, Privacy Policy, Terms & Conditions", style: subtitleStyle),
              trailing: Icon(Icons.chevron_right_sharp, color: context.watch<ThemeProvider>().themecolor),
              leading:
                  ElevatedButton(onPressed: () {}, style: styleFrom, child: const Icon(Icons.attribution_outlined, color: Colors.white, size: 30)),
            ),
          )
        ],
      ),
    );
  }
}

class AppSettings extends StatelessWidget {
  const AppSettings({super.key});

  @override
  Widget build(BuildContext context) {
    var styleFrom = ElevatedButton.styleFrom(
        shape: const CircleBorder(), padding: const EdgeInsets.all(8), backgroundColor: context.watch<ThemeProvider>().themecolor);
    return Scaffold(
      appBar: AppBar(
        title: const Text("App Settings"),
        backgroundColor: context.watch<ThemeProvider>().themecolor,
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(height: 20),
          SizedBox(
            height: 60,
            child: ListTile(
              onTap: () {
                Dialogs.chooseTheme(context);
              },
              title: const Text("Theme Mode"),
              trailing: ElevatedButton(
                onPressed: () {},
                style: styleFrom,
                child: const Text(""),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 70,
            child: ListTile(
              title: const Text("App Lock"),
              trailing: Icon(Icons.chevron_right_sharp, color: context.watch<ThemeProvider>().themecolor),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 70,
            child: ListTile(
              title: const Text("About"),
              trailing: Icon(Icons.chevron_right_sharp, color: context.watch<ThemeProvider>().themecolor),
            ),
          )
        ],
      ),
    );
  }
}
