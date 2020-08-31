import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  CurrencyType _fromCurrencyValue = CurrencyType.USD;
  CurrencyType _toCurrencyValue = CurrencyType.RUB;

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

    switch (_fromCurrencyValue) {
      case CurrencyType.USD:
        return currentRate.getUSDRateIn(_toCurrencyValue);
      case CurrencyType.EUR:
        return currentRate.getEURRateIn(_toCurrencyValue);
      case CurrencyType.RUB:
        return currentRate.getRUBRateIn(_toCurrencyValue);
      default:
        throw new Exception('currency_broadcast: unknown _fromCurrencyValue');
    }
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
        CurrencySignIcon(size: 25.0, name: _toCurrencyValue)
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

  void _handleFromChanges(CurrencyType t) {
    setState(() {
      _fromCurrencyValue = t;
    });
  }

  void _handleToChanges(CurrencyType t) {
    setState(() {
      _toCurrencyValue = t;
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
