import 'package:flutter/material.dart';

import './adding_alarm_dialog.dart' show AddingAlarmDialog;

class ActiveCurrencyAlarms extends StatefulWidget {
  final double currencyNumber;
  final Future<bool> Function(double c) onAlarmSubmit;

  ActiveCurrencyAlarms({this.currencyNumber = 0.0, this.onAlarmSubmit});

  @override
  _ActiveCurrencyAlarmsState createState() =>
      _ActiveCurrencyAlarmsState(onAlarmSubmit: onAlarmSubmit);
}

class _ActiveCurrencyAlarmsState extends State<ActiveCurrencyAlarms> {
  Future<bool> Function(double c) onAlarmSubmit;

  _ActiveCurrencyAlarmsState({@required this.onAlarmSubmit});

  Future<void> _showAddingAlarmDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) =>
            AddingAlarmDialog(onSubmit: onAlarmSubmit));
  }

  _buildAlarmListHeader() => Container(
      margin: EdgeInsets.only(top: 40, bottom: 25),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 5),
            child: Icon(Icons.access_time, size: 27),
          ),
          Text('Active alarms'.toUpperCase(),
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
        ],
      ));

  Widget _buildAddingCurrencyAlarmButton() {
    return Center(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _buildAlarmListHeader(),
      _buildAddingCurrencyAlarmButton(),
    ]);
  }
}
