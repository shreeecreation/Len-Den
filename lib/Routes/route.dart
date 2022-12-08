import 'package:get/get.dart';
import 'package:merokarobar/Add%20Todos/Presentation/addtodos.dart';
import 'package:merokarobar/Add%20Todos/Presentation/addtodosoutgoing.dart';
import 'package:merokarobar/Alarm/app/modules/views/homepage.dart';
import 'package:merokarobar/Expenses/expenses.dart';
import 'package:merokarobar/Expenses/showexpense.dart';
import 'package:merokarobar/Home/Presentation/showoutgoings.dart';
import 'package:merokarobar/Home/Presentation/showincome.dart';

class AllRoutes {
  static routeToShowIncome() {
    Get.to(() => const ShowIncome(), transition: Transition.downToUp, duration: const Duration(milliseconds: 300));
  }

  static routeToshowExpenses(var totalblc) {
    Get.to(() => ShowExpenses(totalblc: totalblc), transition: Transition.rightToLeftWithFade, duration: const Duration(milliseconds: 300));
  }

  static routeToshowOutgoings() {
    Get.to(() => const ShowOutgoings(), transition: Transition.downToUp, duration: const Duration(milliseconds: 300));
  }

  static routeToshowalarm() {
    Get.to(() => const AlarmMain(), transition: Transition.leftToRightWithFade, duration: const Duration(milliseconds: 300));
  }

  static routeToAddIncome() {
    Get.to(AddTodos(), transition: Transition.fadeIn, duration: const Duration(milliseconds: 200));
  }

  static routeToAddExpenses() {
    Get.to(AddExpenses(), transition: Transition.fadeIn, duration: const Duration(milliseconds: 200));
  }

  static routeToAddOutgoings() {
    Get.to(AddTodosOut(), transition: Transition.fadeIn, duration: const Duration(milliseconds: 200));
  }
}
