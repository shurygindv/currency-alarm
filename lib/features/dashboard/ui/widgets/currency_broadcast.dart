import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:currency_alarm/ui/exporter.dart' show Loader;
import 'package:currency_alarm/application.dart' show AppStore;

import './currency_switcher_control.dart' show CurrencySwitcherControl;

import '../../../common/exporter.dart' show CurrencySignIcon, CurrencyType;

class CurrencyBroadcast extends StatefulWidget {
  @override
  _CurrencyBroadcastState createState() => _CurrencyBroadcastState();
}

class _CurrencyBroadcastState extends State<CurrencyBroadcast> {
  bool isFetching = false;

  String _fromCurrencyValue = 'usd';
  String _toCurrencyValue = 'rub';

  void _fetchInitialRates() {
    // Ы
    Future.microtask(() async {
      setState(() {
        isFetching = true;
      });

      await AppStore.getProvider(context).fetchRates();

      if (mounted) {
        setState(() {
          isFetching = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _fetchInitialRates();
  }

  _getCurrentCurrencyNumber() {
    final currentRate = context.watch<AppStore>().rate;
    var v;

    switch (_fromCurrencyValue) {
      case 'usd':
        v = currentRate.getUSDRateIn(_toCurrencyValue.toUpperCase());
        break;
      case 'eur':
        v = currentRate.getEURRateIn(_toCurrencyValue.toUpperCase());
        break;
      case 'rub':
        v = currentRate.getRUBRateIn(_toCurrencyValue.toUpperCase());
        break;
    }

    print(v);

    return v;
  }

  Widget _buildCurrentRate() {
    final value = _getCurrentCurrencyNumber();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.only(right: 10),
          child: Text(
            '$value',
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.w500),
          ),
        ),
        CurrencySignIcon(
            alignment: Alignment.topCenter, size: 30.0, name: CurrencyType.EUR)
      ],
    );
  }

  Widget _buildLastRateUpdateTime() {
    final updateTime = context.watch<AppStore>().updateTime;

    return Column(
      children: [
        Container(
          child: Text(
            "last updated on $updateTime",
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
        )
      ],
    );
  }

  Widget _buildCurrencyRateDisplay() {
    return Container(
        margin: EdgeInsets.only(top: 30, bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCurrentRate(),
            _buildLastRateUpdateTime(),
          ],
        ));
  }

  Widget _buildLoader() => Container(
        margin: EdgeInsets.only(top: 33, bottom: 30),
        child: Loader(name: 'ripple'),
      );

  void _handleFromChanges(v) {
    setState(() {
      _fromCurrencyValue = v;
    });
  }

  void _handleToChanges(v) {
    setState(() {
      _toCurrencyValue = v;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isFetching ? _buildLoader() : _buildCurrencyRateDisplay(),
        CurrencySwitcherControl(
          fromValue: _fromCurrencyValue,
          toValue: _toCurrencyValue,
          onFromChanges: _handleFromChanges,
          onToChanges: _handleToChanges,
        ),
      ],
    );
  }
}
