import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:get_it/get_it.dart';

import 'package:currency_alarm/screens/main/main.dart';

import 'package:currency_alarm/features/exporter.dart'
    show
        CurrencyRateResult,
        CurrencyRateService,
        ConverterResult,
        CurrencyConverterService,
        CurrencyType;

// todo: rework
class AppStore extends ChangeNotifier {
  static AppStore getProvider(ctx) => Provider.of<AppStore>(ctx, listen: false);

  CurrencyRateResult _rateResult = CurrencyRateResult();

  DateTime get timestamp => DateTime.parse(_rateResult.updateTime);
  String get updateTime => DateFormat("d MMMM, hh:mm a").format(timestamp);

  CurrencyRateService _getRateService() =>
      GetIt.instance.get<CurrencyRateService>();

  CurrencyConverterService _getConverterService() =>
      GetIt.instance.get<CurrencyConverterService>();

  Future<CurrencyRateResult> _fetchCurrencyRates() {
    return _getRateService().fetchRate();
  }

  Future<ConverterResult> _convert(double amount,
      {CurrencyType buy, CurrencyType sell}) {
    return _getConverterService().convert(amount, buy, sell);
  }

  Future<void> fetchRates() async {
    _rateResult = await _fetchCurrencyRates();

    notifyListeners();
  }

  Future<ConverterResult> convertCurrency(double amount,
      {CurrencyType buy, CurrencyType sell}) async {
    return _convert(amount, buy: buy, sell: sell);
  }
}

class Application extends StatelessWidget {
  static const String _title = 'currency alarm';

  Widget _buildApp() => MaterialApp(
      title: _title, theme: ThemeData(fontFamily: 'Rubik'), home: MainScreen());

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppStore(),
      child: _buildApp(),
    );
  }
}
