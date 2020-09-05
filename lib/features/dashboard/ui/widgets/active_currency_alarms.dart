import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // TODO: avoid the dep here

import './adding_alarm_dialog.dart' show AddingAlarmDialog;

import 'package:currency_alarm/libs/flusher-animated-icon.dart'
    show FlusherAnimatedIcon;
import 'package:currency_alarm/features/exporter.dart'
    show ActivatedAlarmOptions;

import '../../../common/exporter.dart' show CurrencySignIcon;

class ActiveCurrencyAlarms extends StatefulWidget {
  final bool isAlarmActive;
  final ActivatedAlarmOptions alarmOptions;
  final Future<bool> Function(double c) onAlarmActivate;
  final Future<void> Function() onAlarmDeactivate;

  ActiveCurrencyAlarms(
      {this.onAlarmActivate,
      this.onAlarmDeactivate,
      this.alarmOptions,
      this.isAlarmActive});

  @override
  _ActiveCurrencyAlarmsState createState() => _ActiveCurrencyAlarmsState();
}

class _ActiveCurrencyAlarmsState extends State<ActiveCurrencyAlarms> {
  Future<void> _showAddingAlarmDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) =>
            AddingAlarmDialog(onSubmit: widget.onAlarmActivate));
  }

  _buildAlarmListHeader() => Container(
      margin: EdgeInsets.only(top: 35, bottom: 10),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 5),
                child: Icon(Icons.access_time, size: 27),
              ),
              Text('Active tracker'.toUpperCase(),
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
            ],
          ),
          widget.isAlarmActive
              ? Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
                  ),
                  child: Flexible(
                    flex: 0,
                    child: Text(
                        'Push you when exchange rate will be (greater a little bit, equal) to specified value',
                        style: TextStyle(fontSize: 13)),
                  ))
              : Container()
        ],
      ));

  Widget _buildAddingCurrencyAlarmButton() {
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

  _deactivateAlarm() {
    widget.onAlarmDeactivate();
  }

  _buildDeleteAlarmButton() {
    return Material(
      color: Colors.white.withOpacity(0.0),
      child: InkWell(
        child: IconButton(
          onPressed: () {
            _deactivateAlarm();
          },
          enableFeedback: true,
          icon: Icon(Icons.delete, size: 35, color: Colors.black87),
        ),
        onTap: () {},
      ),
    );
  }

  _buildActiveAlarmStatistics() {
    final timestamp = widget.alarmOptions.activationDate;
    final currency = widget.alarmOptions.currency.toStringAsFixed(3);
    final toCurrency = widget.alarmOptions.to;
    final date = DateFormat("EEE, MMM d, hh:mm:ss a").format(timestamp);

    return Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.black12,
              width: 1.0,
            ),
          ),
        ),
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FlusherAnimatedIcon(),
              Column(
                children: [
                  Container(
                      child: Row(children: [
                    Text(
                      "$currency",
                      style: TextStyle(fontSize: 25),
                    ),
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        child: CurrencySignIcon(name: toCurrency, size: 15)),
                  ])),
                  Container(child: Text("on $date"))
                ],
              ),
              _buildDeleteAlarmButton(),
            ]));
  }

  _buildAlarmContent() {
    return Container(
        child: widget.isAlarmActive
            ? _buildActiveAlarmStatistics()
            : _buildAddingCurrencyAlarmButton());
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _buildAlarmListHeader(),
      _buildAlarmContent(),
    ]);
  }
}
