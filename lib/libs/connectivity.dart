import 'dart:async';

import 'package:connectivity/connectivity.dart';

typedef ListenerFn = void Function(ConnectivityResult res);

class Connection {
  static Function listenConnectionState(ListenerFn fn) {
    final subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      fn(result);
    });

    void dispose() {
      subscription.cancel();
    }

    return dispose;
  }

  static Future<bool> hasAnyConnection() async {
    final status = await Connectivity().checkConnectivity();

    return status != ConnectivityResult.none;
  }
}
