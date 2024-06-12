import 'dart:async';

import 'package:connectivity/connectivity.dart';

class NetworkUtils {
  // Singleton approach
  static final NetworkUtils _instance = NetworkUtils._internal();

  factory NetworkUtils() => _instance;

  NetworkUtils._internal();

  var listenForNetwork = StreamController<bool>.broadcast();

  Future<bool> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  Stream<bool> listenNetworkChanges() {
    Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connectivityResult) {
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        listenForNetwork.add(true);
      } else {
        listenForNetwork.add(false);
      }
    });
    return listenForNetwork.stream.asBroadcastStream();
  }
}
