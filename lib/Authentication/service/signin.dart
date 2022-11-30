// ignore_for_file: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:merokarobar/Home/Presentation/home.dart';
import 'package:merokarobar/Login/Presentation/otp.dart';

class SignIn {
  static String verificationId = "";
  static FirebaseAuth auth = FirebaseAuth.instance;
  static void signIn(BuildContext context, String phoneno) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+977-$phoneno',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) {
          SignIn.verificationId = verificationId;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => OTP(
                        verificationId: verificationId,
                      ))));
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
  }

  static void verifyPin(String pin, BuildContext context, String id) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(smsCode: pin, verificationId: id);
    await auth.signInWithCredential(credential);
    // ignore: use_build_context_synchronously
    Navigator.push(context, MaterialPageRoute(builder: ((context) => Home())));
  }
}
