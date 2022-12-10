import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:merokarobar/Alarm/app/data/models/menu_info.dart';
import 'package:merokarobar/EditData/Service/blcprovider.dart';
import 'package:merokarobar/Home/bloc/list_bloc.dart';
import 'package:merokarobar/ThemeManager/themeprovider.dart';
import 'package:merokarobar/firebase/internet/checkconnectivity.dart';
import 'package:provider/provider.dart';
import 'Alarm/app/data/enums.dart';
import 'Routes/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');

  var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (details) => print(details),
  );
  WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
  await Firebase.initializeApp();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => BlcProvider()),
    ChangeNotifierProvider(create: (_) => ExpenseProvider()),
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
    ChangeNotifierProvider(create: (_) => CheckInternet()),
    ChangeNotifierProvider<MenuInfo>(
      create: (context) => MenuInfo(MenuType.clock),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ListBloc()..add(ListfetchingEvent())),
        ],
        child: GetMaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              fontFamily: 'Georgia',
            ),
            initialRoute: "/",
            onGenerateRoute: router.generateRoute),
      ),
    );
  }
}
