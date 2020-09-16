import 'package:flutter/material.dart'
    show
        Center,
        State,
        Widget,
        ThemeData,
        MaterialApp,
        BuildContext,
        FutureBuilder,
        StatefulWidget;

import 'package:easy_localization/easy_localization.dart';
import 'package:get_it/get_it.dart' show GetIt;

import './ui/exporter.dart' show Loader;
import './screens/main.dart' show MainScreen;
import './features/bootstrap.dart' as features;

T injectDependency<T>() {
  return GetIt.instance.get<T>();
}

class Application extends StatefulWidget {
  @override
  _ApplicationState createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  static const String _title = 'currency alarm';

  @override
  void initState() {
    super.initState();

    _registerAppDependencies();
  }

  _registerAppDependencies() {
    features.setup();
  }

  Widget _buildMainScreen() => MainScreen();

  Widget _buildLoader() => Center(
        child: Loader(name: 'ripple'),
      );

  Future<void> waitAppDependencies() => GetIt.I.allReady();

  Widget _buildHome() => FutureBuilder(
      future: waitAppDependencies(), // todo: connector wrapper
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _buildMainScreen();
        }

        return _buildLoader();
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: _title,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: ThemeData(fontFamily: 'Rubik'),
        home: _buildHome());
  }
}
