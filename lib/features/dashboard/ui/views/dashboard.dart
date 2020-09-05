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

  Future<void> _updateActivationStatus() async {
    final result = await alarmStorage.getActiveAlarmOptions();

    if (result == null) return;

    _setActiveAlarm(result);
  }

  @override
  void initState() {
    super.initState();

    _fetchInitialRates();
    _updateActivationStatus();
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

  Future<void> _deactivateAlarm() async {
    await alarmStorage.deactivateAlarm();
    // todo: rework, reactive
    setState(() {
      alarmOptions = null;
    });
  }

  Future<bool> _activateAlarm(double enteredCurrency) async {
    final result = await alarmStorage.activateCurrencyAlarm(
      currency: enteredCurrency,
      fromCurrency: _fromCurrencyValue,
      toCurrency: _toCurrencyValue,
    );
    // todo: rework, reactive
    await _updateActivationStatus();

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final updateTime = context.watch<AppStore>().updateTime;
    final currentRate = context.watch<AppStore>().rate;

    return Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // todo: rework
            CurrencyBroadcast(
                fromCurrencyValue: _fromCurrencyValue,
                toCurrencyValue: _toCurrencyValue,
                onFromChanges: _handleFromChanges,
                onToChanges: _handleToChanges,
                isFetching: _isRateFetching,
                currentRate: currentRate,
                updateTime: updateTime),
            ActiveCurrencyAlarms(
              onAlarmActivate: _activateAlarm,
              onAlarmDeactivate: _deactivateAlarm,
              isAlarmActive: alarmOptions != null,
              alarmOptions: alarmOptions,
            )
          ],
        ));
  }
}
