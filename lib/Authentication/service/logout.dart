import 'package:firebase_auth/firebase_auth.dart';

class LogOut {
  static logOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
