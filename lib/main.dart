import 'package:flutter/material.dart' show runApp;

import './libs/localization.dart' show Localization;
import './application.dart' show Application;

void main() async {
  runApp(Localization(Application()));
}
