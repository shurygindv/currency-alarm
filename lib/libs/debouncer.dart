import 'dart:async';

import 'package:flutter/cupertino.dart';

Future<void> setTimeout(int ms, VoidCallback fn) {
  new Future.delayed(Duration(milliseconds: ms), () {
    fn();
  });
}

class Debouncer {
  final Duration delay;
  Timer _timer;

  Debouncer({this.delay});

  run(Function action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }
}
