import 'package:flutter/material.dart';
import 'package:merokarobar/Database/database.dart';
import 'package:merokarobar/Expenses/services/database.dart';

class BlcProvider extends ChangeNotifier {
  int _totalblc = 0;
  int _paidblc = 0;
  int get totalblc => _totalblc;
  int get paidblc => _paidblc;
  void gettotalblc() {
    var totalamount = [];
    _totalblc = 0;
    var totalblcchecker = DatabaseHelper.totalblc();
    totalblcchecker.then((value) {
      for (var element in value) {
        totalamount.add(element.values.join());
      }
      for (var element in totalamount) {
        _totalblc += int.parse(element);
        notifyListeners();
      }
    });
  }

  void getpaidblc() {
    var paidamount = [];
    _paidblc = 0;

    var paidblcchecker = DatabaseHelper.paidblc();

    paidblcchecker.then((value) {
      for (var element in value) {
        paidamount.add(element.values.join());
      }
      for (var element in paidamount) {
        _paidblc += int.parse(element);
        notifyListeners();
      }
    });
  }
}

class ExpenseProvider extends ChangeNotifier {
  int _totalblc = 0;
  int get totalblc => _totalblc;
  void gettotalblc() {
    var totalamount = [];
    _totalblc = 0;
    var totalblcchecker = ExpenseDatabaseHelper.totalblc();
    totalblcchecker.then((value) {
      for (var element in value) {
        totalamount.add(element.values.join());
      }
      for (var element in totalamount) {
        _totalblc += int.parse(element);
        notifyListeners();
      }
    });
  }
}
