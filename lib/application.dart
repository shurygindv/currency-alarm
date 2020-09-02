import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:get_it/get_it.dart';

import 'package:currency_alarm/screens/main.dart';

import './features/bootstrap.dart' as features;
import 'package:currency_alarm/features/exporter.dart'
    show
        CurrencyRateResult,
        CurrencyRateService,
        ConverterResult,
        CurrencyConverterService,
        CurrencyType;

T resolveDependency<T>() {
  return GetIt.instance.get<T>();
}

// todo: rework
class AppStore extends ChangeNotifier {
  static AppStore getProvider(ctx) => Provider.of<AppStore>(ctx, listen: false);

  CurrencyRateResult _rateResult = CurrencyRateResult();

  DateTime get timestamp => DateTime.parse(_rateResult.updateTime);
  String get updateTime => DateFormat("d MMMM, hh:mm a").format(timestamp);
  CurrencyRateResult get rate => _rateResult;

  // =
  CurrencyRateService _getRateService() =>
      resolveDependency<CurrencyRateService>();

  CurrencyConverterService _getConverterService() =>
      resolveDependency<CurrencyConverterService>();

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

    _initializdeDeps();
  }

  _initializdeDeps() {
    features.setup();
  }

  Widget _buildApp() => FutureBuilder(
      future: GetIt.I.allReady(), // todo: loader, connector wrapper
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MaterialApp(
              title: _title,
              theme: ThemeData(fontFamily: 'Rubik'),
              home: MainScreen());
        }

        return Container();
      });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppStore(),
      child: _buildApp(),
    );
  }
}
