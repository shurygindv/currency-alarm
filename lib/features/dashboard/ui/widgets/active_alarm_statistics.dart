import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // TODO: avoid the dep here

import '../../../common/exporter.dart' show CurrencySignIcon;

import 'package:currency_alarm/libs/ui-effects/exporter.dart'
    show FlusherAnimatedIcon;
import '../../../common/exporter.dart' show CurrencySignIcon, CurrencyType;

class ActiveAlarmStatistics extends StatefulWidget {
  final DateTime activationDate;
  final Future<void> Function() onDeactivate;
  final double currencyValue;
  final CurrencyType toCurrency;

  ActiveAlarmStatistics(
      {this.onDeactivate,
      this.toCurrency,
      this.currencyValue,
      this.activationDate});

  @override
  _ActiveAlarmStatisticsState createState() => _ActiveAlarmStatisticsState();
}

class _ActiveAlarmStatisticsState extends State<ActiveAlarmStatistics> {
  _deactivateAlarm() {
    widget.onDeactivate();
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

  _buildAlarmDetails() {
    final timestamp = widget.activationDate;
    final currency = widget.currencyValue.toStringAsFixed(3);
    final toCurrency = widget.toCurrency;
    final date = DateFormat("EEE, MMM d, hh:mm:ss a").format(timestamp);

    return Column(
      children: [
        Row(children: [
          Text(
            "$currency",
            style: TextStyle(fontSize: 25),
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              child: CurrencySignIcon(name: toCurrency, size: 15)),
        ]),
        Text("$date"),
      ],
    );
  }

  Widget _buildRowInfo() {
    return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FlusherAnimatedIcon(),
          _buildAlarmDetails(),
          _buildDeleteAlarmButton(),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black12,
            width: 1.0,
          ),
        ),
      ),
      child: _buildRowInfo(),
    );
  }
}
