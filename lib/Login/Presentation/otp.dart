import 'package:flutter/material.dart';
import 'package:merokarobar/Authentication/service/signin.dart';
import 'package:pinput/pinput.dart';

// ignore: must_be_immutable
class OTP extends StatelessWidget {
  OTP({super.key, required this.verificationId});
  String verificationId;
  String verifypin = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/Images/verify.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text("Enter the OTP that you received !", style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
              const SizedBox(height: 30),
              Pinput(
                length: 6,
                showCursor: true,
                onCompleted: (pin) => verifypin = pin,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    onPressed: () {
                      SignIn.verifyPin(verifypin, context, verificationId);
                    },
                    child: const Text("Verify Phone Number")),
              ),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Edit Phone Number ?",
                        style: TextStyle(color: Colors.green),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
