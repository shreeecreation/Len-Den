import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merokarobar/Home/bloc/list_bloc.dart';
import 'Routes/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ListBloc()..add(ListfetchingEvent())),
        ],
        child: GetMaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Georgia'),
            initialRoute: "/",
            onGenerateRoute: router.generateRoute),
      ),
    );
  }
}
