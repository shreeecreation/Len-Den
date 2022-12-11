import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:merokarobar/Authentication/Service/signIn.dart';
import 'package:merokarobar/Home/Presentation/home.dart';
import 'package:merokarobar/Utils/dialog.dart';
import 'package:merokarobar/Utils/snackbar.dart';
import 'package:merokarobar/firebase/internet/checkconnectivity.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final formGlobalKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // return OTP();
              return const Home();
            } else if (snapshot.hasError) {
              return const Center(child: Text("Error!"));
            } else {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    sendCode(context),
                  ],
                ),
              );
            }
          }),
    );
  }

  Widget sendCode(BuildContext context) {
    TextEditingController controller = TextEditingController();
    TextEditingController countrycode = TextEditingController(text: "+977");
    return Form(
      key: formGlobalKey,
      child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width - 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                      height: 100, width: MediaQuery.of(context).size.width / 2, child: Image.asset("assets/Images/logo.png", fit: BoxFit.fitWidth)),
                ],
              ),
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width - 50,
                child: Image.asset(
                  "assets/Images/verify.png",
                  fit: BoxFit.fitWidth,
                )),
            const SizedBox(height: 30),
            Container(
              height: 60,
              width: MediaQuery.of(context).size.width - 50,
              decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey), borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 10),
                  SizedBox(
                      width: 40,
                      child: TextField(
                          controller: countrycode,
                          readOnly: true,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(border: InputBorder.none))),
                  const Text(" |", style: TextStyle(fontSize: 33, color: Colors.grey)),
                  const SizedBox(width: 10),
                  Expanded(
                      child: TextFormField(
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    controller: controller,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                    ],
                    decoration: const InputDecoration(border: InputBorder.none, counterText: "", hintText: "Phone"),
                  ))
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width - 50,
              height: 50,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () async {
                    if (controller.text.length < 10) {
                      final snackbar = CustomSnackbar.customSnackbar("Enter a valid number !", Colors.red);
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    } else {
                      await context.read<CheckInternet>().checkConnectivity() ? SignIn.signIn(context, controller.text) : Dialogs.noInternet(context);
                      Dialogs.loading(context);
                    }
                  },
                  child: const Text("GET LOGIN OTP")),
            )
          ],
        ),
      ),
    );
  }
}
