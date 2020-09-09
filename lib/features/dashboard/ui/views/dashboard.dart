import 'package:flutter/material.dart';

import 'package:currency_alarm/application.dart' show AppStore;
import 'package:currency_alarm/features/exporter.dart'
    show AlarmStorageService, ActivatedAlarmOptions;
import 'package:currency_alarm/application.dart' show injectDependency;

import '../widgets/currency_broadcast.dart' show CurrencyBroadcast;
import '../widgets/active_currency_alarms.dart' show ActiveCurrencyAlarms;
import '../../../common/exporter.dart' show CurrencyType;

class DashboardView extends StatefulWidget {
  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  bool _isRateFetching = true;
  CurrencyType _fromCurrencyValue = CurrencyType.USD;
  CurrencyType _toCurrencyValue = CurrencyType.RUB;

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

  Future<void> _deactivateAlarm() async {
    await alarmStorage.deactivateAlarm();
  }

  Future<bool> _activateAlarm(double enteredCurrency) async {
    final result = await alarmStorage.activateCurrencyAlarm(
      currency: enteredCurrency,
      fromCurrency: _fromCurrencyValue,
      toCurrency: _toCurrencyValue,
    );

    return result;
  }

  Widget _buildCurrencyBroadcast() => CurrencyBroadcast(
        fromCurrencyValue: _fromCurrencyValue,
        toCurrencyValue: _toCurrencyValue,
        onFromChanges: _handleFromChanges,
        onToChanges: _handleToChanges,
        isFetching: _isRateFetching,
      );

  Widget _buildActiveAlarms() => StreamBuilder(
      stream: alarmStorage.getActiveAlarm,
      initialData: null,
      builder: (context, snapshot) {
        final activeAlarm = snapshot.data;

        print(activeAlarm);

        return ActiveCurrencyAlarms(
          onAlarmActivate: _activateAlarm,
          onAlarmDeactivate: _deactivateAlarm,
          isAlarmActive: activeAlarm != null,
          alarmOptions: activeAlarm,
          fromCurrencySwitcher: _fromCurrencyValue,
          toCurrencySwitcher: _toCurrencyValue,
        );
      });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildCurrencyBroadcast(), _buildActiveAlarms()],
        ));
  }
}
