import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class CheckInternet extends ChangeNotifier {
  bool _isConnected = false;
  bool get isConnected => _isConnected;

  Future<bool> checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      _isConnected = true;
      notifyListeners();
    } else if (connectivityResult == ConnectivityResult.wifi) {
      _isConnected = true;
      notifyListeners();
    } else {
      _isConnected = false;
      notifyListeners();
    }
    return isConnected;
  }
}
