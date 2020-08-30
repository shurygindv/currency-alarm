import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import './application.dart' show Application;
import './features/bootstrap.dart' as features;

void registerDependencies() {
  features.setup(<T>(T feature) {
    GetIt.I.registerSingleton(feature);
  });
}

void main() {
  registerDependencies();
  // =
  runApp(Application());
}
