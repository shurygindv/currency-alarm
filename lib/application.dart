import 'package:flutter/material.dart'
    show
        Center,
        State,
        Widget,
        ThemeData,
        MaterialApp,
        BuildContext,
        FutureBuilder,
        ChangeNotifier,
        StatefulWidget;

import 'package:provider/provider.dart' show Provider, ChangeNotifierProvider;

import 'package:easy_localization/easy_localization.dart';
import 'package:get_it/get_it.dart' show GetIt;

import './ui/exporter.dart' show Loader;
import './screens/main.dart' show MainScreen;
import './features/bootstrap.dart' as features;
import './features/exporter.dart'
    show
        CurrencyRateResult,
        CurrencyRateService,
        ConverterResult,
        CurrencyConverterService,
        CurrencyType;

T injectDependency<T>() {
  return GetIt.instance.get<T>();
}

// todo: rework, rethink this file
class AppStore extends ChangeNotifier {
  static AppStore getProvider(ctx) => Provider.of<AppStore>(ctx, listen: false);

  CurrencyRateResult _rateResult = CurrencyRateResult();

  DateTime get updateTime => DateTime.parse(_rateResult.updateTime);
  CurrencyRateResult get rate => _rateResult;

  // =
  CurrencyRateService _getRateService() =>
      injectDependency<CurrencyRateService>();

  CurrencyConverterService _getConverterService() =>
      injectDependency<CurrencyConverterService>();

  Future<CurrencyRateResult> _fetchCurrencyRates() {
    return _getRateService().fetchRate();
  }

  Future<ConverterResult> _convert(double amount,
      {CurrencyType buy, CurrencyType sell}) {
    return _getConverterService().convert(amount, buy, sell);
  }

  // ===== public house ===== /

  Future<void> fetchRates() async {
    _rateResult = await _fetchCurrencyRates();

    notifyListeners();
  }

  Future<ConverterResult> convertCurrency(double amount,
      {CurrencyType buy, CurrencyType sell}) async {
    return _convert(amount, buy: buy, sell: sell);
  }
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

  Widget _buildApp() => MaterialApp(
      title: _title,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(fontFamily: 'Rubik'),
      home: FutureBuilder(
          future: waitAppDependencies(), // todo: connector wrapper
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _buildMainScreen();
            }

            return _buildLoader();
          }));

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => AppStore(), child: _buildApp());
  }
}
