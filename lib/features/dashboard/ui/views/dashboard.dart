import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:currency_alarm/application.dart' show AppStore;

import '../widgets/currency_broadcast.dart' show CurrencyBroadcast;
import '../widgets/active_currency_alarms.dart' show ActiveCurrencyAlarms;
import '../../../common/exporter.dart' show CurrencyType;

import 'package:currency_alarm/features/exporter.dart'
    show AlarmStorageService, ActivatedAlarmOptions;
import 'package:currency_alarm/application.dart' show injectDependency;

class DashboardView extends StatefulWidget {
  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  bool _isRateFetching = false;
  CurrencyType _fromCurrencyValue = CurrencyType.USD;
  CurrencyType _toCurrencyValue = CurrencyType.RUB;

  ActivatedAlarmOptions alarmOptions;

  final alarmStorage = injectDependency<AlarmStorageService>();

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

  _setActiveAlarm(ActivatedAlarmOptions options) {
    setState(() {
      alarmOptions = options;
    });
  }

  Future<void> _pullActivatedAlarmValue() async {
    final result = await alarmStorage.getActiveAlarmOptions();

    if (result == null) return;

    _setActiveAlarm(result);
  }

  @override
  void initState() {
    super.initState();

    _fetchInitialRates();
    _pullActivatedAlarmValue();
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
    final result = await alarmStorage.activateCurrencyAlarm(
      currency: enteredCurrency,
      fromCurrency: _fromCurrencyValue,
      toCurrency: _toCurrencyValue,
    );

    setState(() {});

    return result;
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
              isAlarmActive: alarmOptions != null,
              alarmOptions: alarmOptions,
            )
          ],
        ));
  }
}
