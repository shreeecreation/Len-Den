import 'package:flutter/material.dart';
import 'package:merokarobar/Utils/themedata.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  Color? _themecolor = AppColors.primaryThemeColor;
  int _id = 0;
  Color? get themecolor => _themecolor;
  int get id => _id;

  void manageTheme(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('id', id);
    _id = prefs.getInt('id') ?? 0;
    notifyListeners();
  }

  void getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _id = prefs.getInt('id') ?? 0;
    setThemeColor(_id);

    notifyListeners();
  }

  void setThemeColor(int id) {
    switch (id) {
      case 1:
        _themecolor = AppColors.themeColorGreen;
        manageTheme(1);
        notifyListeners();
        break;
      case 2:
        _themecolor = AppColors.themeColorOrange;
        manageTheme(2);

        notifyListeners();
        break;
      case 3:
        _themecolor = AppColors.themeColorBlue;
        manageTheme(3);

        notifyListeners();
        break;
      case 4:
        _themecolor = AppColors.themeColorPurple;
        manageTheme(4);

        notifyListeners();
        break;
      default:
        _themecolor = AppColors.primaryThemeColor;
        manageTheme(1);

        notifyListeners();
    }
  }
}
