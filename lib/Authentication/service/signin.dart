import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merokarobar/Login/Presentation/home.dart';
import 'package:merokarobar/Login/Presentation/otp.dart';
import 'package:merokarobar/Utils/snackbar.dart';

class SignIn {
  static String verificationId = "";
  static FirebaseAuth auth = FirebaseAuth.instance;
  static void signIn(BuildContext context, String phoneno) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+977-$phoneno',
        verificationCompleted: (PhoneAuthCredential credential) {
          print("dasdas");
        },
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) {
          SignIn.verificationId = verificationId;
          Get.off(() => OTP(
                verificationId: verificationId,
              ));
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: ((context) => OTP(
          //               verificationId: verificationId,
          //             ))));
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
  }

  static void verifyPin(String pin, BuildContext context, String id) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(smsCode: pin, verificationId: id);
    try {
      await auth.signInWithCredential(credential);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    } catch (FirebaseAuthException) {
      final snackbar = CustomSnackbar.customSnackbar("Enter a valid OTP !", Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }

    // ignore: use_build_context_synchronously
  }
}
