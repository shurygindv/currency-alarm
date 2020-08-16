import 'package:flutter/material.dart';

import 'package:currency_alarm/screens/home/home.dart';

void main() => runApp(Application());

class Application extends StatelessWidget {
  static const String _title = 'currency alarm';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: _title, home: HomePageWidget());
  }
}
