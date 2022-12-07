import 'package:flutter/material.dart';
import 'package:merokarobar/Alarm/app/data/data.dart';
import 'package:merokarobar/Alarm/app/data/enums.dart';
import 'package:merokarobar/Alarm/app/data/models/menu_info.dart';
import 'package:merokarobar/Alarm/app/data/theme_data.dart';
import 'package:merokarobar/Alarm/app/modules/views/clock_page.dart';
import 'package:provider/provider.dart';

import 'alarm_page.dart';

class AlarmMain extends StatefulWidget {
  const AlarmMain({super.key});

  @override
  _AlarmMainState createState() => _AlarmMainState();
}

class _AlarmMainState extends State<AlarmMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.pageBackgroundColor,
      body: Row(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: menuItems.map((currentMenuInfo) => buildMenuButton(currentMenuInfo)).toList(),
          ),
          VerticalDivider(
            color: CustomColors.dividerColor,
            width: 1,
          ),
          Expanded(
            child: Consumer<MenuInfo>(
              builder: (BuildContext context, MenuInfo value, Widget? child) {
                if (value.menuType == MenuType.clock) {
                  return const ClockPage();
                } else if (value.menuType == MenuType.alarm) {
                  return const AlarmPage();
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMenuButton(MenuInfo currentMenuInfo) {
    return Consumer<MenuInfo>(
      builder: (BuildContext context, MenuInfo value, Widget? child) {
        return MaterialButton(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(32))),
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0),
          color: currentMenuInfo.menuType == value.menuType ? CustomColors.menuBackgroundColor : CustomColors.pageBackgroundColor,
          onPressed: () {
            var menuInfo = Provider.of<MenuInfo>(context, listen: false);
            menuInfo.updateMenu(currentMenuInfo);
          },
          child: Column(
            children: <Widget>[
              Image.asset(
                currentMenuInfo.imageSource!,
                scale: 1.5,
              ),
              const SizedBox(height: 16),
              Text(
                currentMenuInfo.title ?? '',
                style: TextStyle(fontFamily: 'avenir', color: CustomColors.primaryTextColor, fontSize: 14),
              ),
            ],
          ),
        );
      },
    );
  }
}
