import 'package:flutter/material.dart';

import 'package:currency_alarm/services/storage.dart';
import 'package:currency_alarm/services/api.dart';
import 'package:currency_alarm/libs/debouncer.dart';

class DashboardView extends StatefulWidget {
  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  void _fetchRates() async {
    var response = await CurrencyApi.fetchRate();

    print(response.body);
  }

  void _fetchInitialRates() {
    Future.delayed(Duration.zero, _fetchRates);
  }

  @override
  void initState() {
    super.initState();

    _fetchInitialRates();
  }

  Future<void> _showTrackingRateDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
              title: Text('Title'),
              content:
                  SingleChildScrollView(child: Text("dollar ruble euro here")),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  Widget _buildTrackingRateButton() {
    return RaisedButton(
      onPressed: () {
        _showTrackingRateDialog();
      },
      color: Color(0xffe8b96a),
      textColor: Colors.white,
      child: Text(
        "Tap here to track downgrade of rate",
        style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildAlarmListSection() {}

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTrackingRateButton(),
        FittedBox(
          child: Text('Active alarms'.toUpperCase(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Text('Alarms not found', style: TextStyle(fontSize: 20)),
      ],
    ));
  }
}
