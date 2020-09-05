import 'package:flutter/material.dart';

import 'package:currency_alarm/features/exporter.dart'
    show ActivatedAlarmOptions;

import '../../../common/exporter.dart' show CurrencyType;
import './adding_alarm_dialog.dart' show AddingAlarmDialog;
import './active_alarm_statistics.dart' show ActiveAlarmStatistics;

class ActiveCurrencyAlarms extends StatefulWidget {
  final bool isAlarmActive;

  final CurrencyType fromCurrencySwitcher;
  final CurrencyType toCurrencySwitcher;
  final ActivatedAlarmOptions alarmOptions;
  final Future<bool> Function(double c) onAlarmActivate;
  final Future<void> Function() onAlarmDeactivate;

  ActiveCurrencyAlarms({
    this.onAlarmActivate,
    this.onAlarmDeactivate,
    this.alarmOptions,
    this.isAlarmActive,
    this.fromCurrencySwitcher,
    this.toCurrencySwitcher,
  });

  @override
  _ActiveCurrencyAlarmsState createState() => _ActiveCurrencyAlarmsState();
}

class _ActiveCurrencyAlarmsState extends State<ActiveCurrencyAlarms> {
  Future<void> _showAddingAlarmDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => AddingAlarmDialog(
            to: widget.toCurrencySwitcher,
            from: widget.fromCurrencySwitcher,
            onSubmit: widget.onAlarmActivate));
  }

  _buildTitle() => Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 5),
            child: Icon(Icons.access_time, size: 27),
          ),
          Text('Active tracker'.toUpperCase(),
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
        ],
      );

  _buildSubtitleInfo() => Visibility(
      visible: widget.isAlarmActive,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
        ),
        child: Text(
            'Push you when exchange rate will be about the same again (probably, time to sell!)',
            style: TextStyle(fontSize: 13)),
      ));

  _buildAlarmListHeader() => Container(
      margin: EdgeInsets.only(top: 35, bottom: 10),
      child: Column(
        children: [
          _buildTitle(),
          _buildSubtitleInfo(),
        ],
      ));

  Widget _buildAddingAlarmButton() {
    return Center(
        child: Container(
      margin: EdgeInsets.only(top: 5),
      child: RaisedButton(
        color: Colors.amber[400],
        textColor: Colors.black54,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                height: 65,
                margin: EdgeInsets.only(right: 10),
                child: Icon(Icons.add, size: 26)),
            Text("Add currency alarm", style: TextStyle(fontSize: 16))
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onPressed: () {
          _showAddingAlarmDialog();
        },
      ),
    ));
  }

  // todo: avoid nested .. . . ..  .
  Widget _buildActiveAlarmStatistics() => ActiveAlarmStatistics(
        toCurrency: widget.alarmOptions.to,
        onDeactivate: widget.onAlarmDeactivate,
        currencyValue: widget.alarmOptions.currency,
        activationDate: widget.alarmOptions.activationDate,
      );

  _buildAlarmContent() {
    return widget.isAlarmActive
        ? _buildActiveAlarmStatistics()
        : _buildAddingAlarmButton();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _buildAlarmListHeader(),
      _buildAlarmContent(),
    ]);
  }
}
