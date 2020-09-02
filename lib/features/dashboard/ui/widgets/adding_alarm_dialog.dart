import 'package:flutter/material.dart';

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
  final Future<bool> Function(double c) onSubmit;

  AddingAlarmDialog({this.currencyNumber = 71.42, this.onSubmit});

  @override
  _AddingAlarmDialogState createState() => _AddingAlarmDialogState(
        onSubmit: onSubmit,
      );
}

class _AddingAlarmDialogState extends State<AddingAlarmDialog> {
  double currencyValue;

  Future<bool> Function(double c) onSubmit;

  _AddingAlarmDialogState({this.onSubmit});

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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: SingleChildScrollView(
          child: Container(
              child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Counter(
              value: currencyValue,
              onIncrement: _handleIncremening,
              onDecrement: _handleDecremeting)
        ],
      ))
          //=
          ),
      actions: <Widget>[
        FlatButton(
          child: Text('Notify me'),
          onPressed: () {
            onSubmit(currencyValue)
                .whenComplete(() => Navigator.of(context).pop());
          },
        ),
      ],
    );
  }
}
