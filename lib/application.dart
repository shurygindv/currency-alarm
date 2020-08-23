import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

import 'package:currency_alarm/screens/home/home.dart';
import 'package:currency_alarm/services/api.dart';

class GlobalStore extends ChangeNotifier {
  static GlobalStore getProvider(context) =>
      Provider.of<GlobalStore>(context, listen: false);

  CurrencyRateResult _rateResult;

  DateTime get timestamp => DateTime.parse(_rateResult.updateTime);

  Future<CurrencyRateResult> _fetchCurrencyRates() {
    return CurrencyApi.fetchRate();
  }

  Future<void> fetchRates() async {
    print("1234");
    _rateResult = await _fetchCurrencyRates();

    notifyListeners();
  }
}

class Application extends StatelessWidget {
  static const String _title = 'currency alarm';

  Widget _buildUi() => MaterialApp(
      title: _title,
      theme: ThemeData(fontFamily: 'Rubik'),
      home: HomePageWidget());

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GlobalStore(),
      child: _buildUi(),
    );
  }
}