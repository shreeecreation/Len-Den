// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:merokarobar/Add%20Todos/Presentation/addtodos.dart';
import 'package:merokarobar/Add%20Todos/Presentation/addtodosoutgoing.dart';
import 'package:merokarobar/EditData/Presentation/editdata.dart';
import 'package:merokarobar/EditData/Presentation/editreceivedoutgoing.dart';
import 'package:merokarobar/Expenses/expenses.dart';
import 'package:merokarobar/Home/Presentation/home.dart';
import 'package:merokarobar/Home/Presentation/showexpense.dart';
import 'package:merokarobar/Home/Presentation/showincome.dart';
import 'package:merokarobar/Login/Presentation/home.dart';
import 'package:merokarobar/Login/Presentation/otp.dart';

class router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
        );
      case "home":
        return MaterialPageRoute(builder: (_) => const Home());
      case "addtodo":
        return MaterialPageRoute(builder: (_) => AddTodos());
      case "addexpense":
        return MaterialPageRoute(builder: (_) => AddExpenses());
      case "addtodoout":
        return MaterialPageRoute(builder: (_) => AddTodosOut());
      case "showincome":
        return MaterialPageRoute(builder: (_) => const ShowIncome());
      case "showexpenses":
        return MaterialPageRoute(builder: (_) => const ShowExpense());
      case "editr":
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => EditReceived(
                  username: args["username"],
                  model: args["model"],
                  mode: args["mode"],
                  modeString: args["modeString"],
                  totalblc: args["totalblc"],
                ));
      case "edit":
        final args = arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => EditParty(model: args!["model"]));
      case "otp":
        final args = settings.arguments as OTP;
        return MaterialPageRoute(builder: (_) => OTP(verificationId: args.verificationId));
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
