import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class InternetChecker {
  static late List<ConnectivityResult> connectivityResult;

  // Asynchronously checks for internet connectivity
  static Future<bool> checkInternet() async {
    connectivityResult = await (Connectivity().checkConnectivity());
    // Returns "true" if there is no internet connection
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return true;
    // Returns "false" if an internet connection is available
    } else {
      return false;
    }
  }
}
