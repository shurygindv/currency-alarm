import 'package:flutter/material.dart';

import '../../../common/exporter.dart' show CurrencyType;
import './currency_text.dart' show CurrencyText;

class Counter extends StatelessWidget {
  final double value;

  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const Counter({
    this.value,
    this.onIncrement,
    this.onDecrement,
  });

  _buildCounterValue() {
    final v = value.toStringAsFixed(2);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Text('$v', style: TextStyle(fontSize: 25)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.remove, size: 30),
          onPressed: () {
            onDecrement();
          },
        ),
        _buildCounterValue(),
        IconButton(
          icon: Icon(Icons.add, size: 30),
          onPressed: () {
            onIncrement();
          },
        )
      ],
    ));
  }
}

class AddingAlarmDialog extends StatefulWidget {
  final double currencyNumber;
  final CurrencyType from;
  final CurrencyType to;
  final Future<bool> Function(double c) onSubmit;

  AddingAlarmDialog(
      {this.from, this.to, this.currencyNumber = 71.228, this.onSubmit});

  @override
  _AddingAlarmDialogState createState() => _AddingAlarmDialogState();
}

class _AddingAlarmDialogState extends State<AddingAlarmDialog> {
  double currencyValue;

  _AddingAlarmDialogState();

  void setCurrency(double v) {
    setState(() {
      currencyValue = v;
    });
  }

  void setInitialCurrencyValue() {
    setCurrency(widget.currencyNumber);
  }

  @override
  void initState() {
    super.initState();

    setInitialCurrencyValue();
  }

  _handleIncremening() {
    setCurrency(currencyValue + 0.1);
  }

  _handleDecremeting() {
    setCurrency(currencyValue - 0.1);
  }

  // todo: enum
  String _getCurrencyText(CurrencyType t) {
    switch (t) {
      case CurrencyType.EUR:
        return 'EUR';
      case CurrencyType.RUB:
        return 'RUB';
      case CurrencyType.USD:
        return 'USD';
      default:
        return '';
    }
  }

  Widget _buildDescription() {
    final from = _getCurrencyText(widget.from);
    final to = _getCurrencyText(widget.to);

    final result = "1 $from will equal about $to";

    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(result)]);
  }

  Widget _buildCounter() {
    return Container(
        margin: EdgeInsets.only(top: 10),
        child: Counter(
            value: currencyValue,
            onIncrement: _handleIncremening,
            onDecrement: _handleDecremeting));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Trigger when"),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: SingleChildScrollView(
          child: Container(
              child: Column(
        children: [
          _buildDescription(),
          _buildCounter(),
        ],
      ))),
      actions: <Widget>[
        FlatButton(
          child: Text('Notify me'),
          onPressed: () {
            widget
                .onSubmit(currencyValue)
                .whenComplete(() => Navigator.of(context).pop());
          },
        ),
      ],
    );
  }
}
