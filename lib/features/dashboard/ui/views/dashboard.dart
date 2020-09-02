import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:currency_alarm/application.dart' show AppStore;

import '../widgets/currency_broadcast.dart' show CurrencyBroadcast;
import '../widgets/active_currency_alarms.dart' show ActiveCurrencyAlarms;
import '../../../common/exporter.dart' show CurrencyType;

import 'package:currency_alarm/features/exporter.dart' show AlarmStorageService;
import 'package:currency_alarm/application.dart' show resolveDependency;

class DashboardView extends StatefulWidget {
  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  bool _isRateFetching = false;
  CurrencyType _fromCurrencyValue = CurrencyType.USD;
  CurrencyType _toCurrencyValue = CurrencyType.RUB;

  final alarmStorage = resolveDependency<AlarmStorageService>();

  void _fetchInitialRates() {
    // Ы
    Future.microtask(() async {
      setState(() {
        _isRateFetching = true;
      });

      await AppStore.getProvider(context).fetchRates();

      if (mounted) {
        setState(() {
          _isRateFetching = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _fetchInitialRates();
  }

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

  Future<bool> _handleAlarmSubmit(double enteredCurrency) async {
    await alarmStorage.addCurrencyAlarm(
      currency: enteredCurrency,
      fromCurrency: _fromCurrencyValue,
      toCurrency: _toCurrencyValue,
    );

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final updateTime = context.watch<AppStore>().updateTime;
    final currentRate = context.watch<AppStore>().rate;

    return Container(
        margin: EdgeInsets.only(left: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // todo: rework
            CurrencyBroadcast(
                fromCurrencyValue: _fromCurrencyValue,
                toCurrencyValue: _fromCurrencyValue,
                onFromChanges: _handleFromChanges,
                onToChanges: _handleToChanges,
                isFetching: _isRateFetching,
                currentRate: currentRate,
                updateTime: updateTime),
            ActiveCurrencyAlarms(
              onAlarmSubmit: _handleAlarmSubmit,
            )
          ],
        ));
  }
}
