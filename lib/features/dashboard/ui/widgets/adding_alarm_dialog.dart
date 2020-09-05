import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:currency_alarm/application.dart' show AppStore;

import '../../../common/exporter.dart' show CurrencyType;
import './currency_text.dart' show CurrencyText;

import '../../../common/exporter.dart' show CurrencySignIcon;
import '../../data/models.dart' show CurrencyRateResult;

class Counter extends StatelessWidget {
  final double value;
  final CurrencyType type;

  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const Counter({
    this.value,
    this.type,
    this.onIncrement,
    this.onDecrement,
  });

  Widget _buildCounterValue() {
    final v = value.toStringAsFixed(2);

    return Container(
      margin: EdgeInsets.only(left: 10, right: 5),
      child: Text('$v', style: TextStyle(fontSize: 25)),
    );
  }

  Widget _buildSignIcon() {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: CurrencySignIcon(name: type, size: 20),
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
        _buildSignIcon(),
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
  final CurrencyType from;
  final CurrencyType to;
  final Future<bool> Function(double c) onSubmit;

  AddingAlarmDialog({this.from, this.to, this.onSubmit});

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
    double value;

    try {
      final v = context.read<AppStore>().rate;

      value = double.parse(_getCurrentCurrency(v));
    } catch (e) {
      value = 0.0;
    }

    setCurrency(value);
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

  // todo: remake it
  String _getCurrentCurrency(CurrencyRateResult rate) {
    switch (widget.from) {
      case CurrencyType.USD:
        return rate.getUSDRateIn(widget.to);
      case CurrencyType.EUR:
        return rate.getEURRateIn(widget.to);
      case CurrencyType.RUB:
        return rate.getRUBRateIn(widget.to);
      default:
        throw new Exception('currency_broadcast: unknown _fromCurrencyValue');
    }
  }

  // todo: enum, and avoid it too
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

  // TOOD: abstract
  Widget _buildBadge(String v) => Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[100],
      ),
      child: Text(v, style: TextStyle(color: Colors.black54)));

  Widget _buildDescription() {
    final from = _getCurrencyText(widget.from);
    final to = _getCurrencyText(widget.to);

    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildBadge("1 $from"),
          Container(
              child: Text("will equal about", style: TextStyle(fontSize: 16))),
          _buildBadge("$to"),
        ]);
  }

  Widget _buildCounter() {
    return Container(
        margin: EdgeInsets.only(top: 10),
        child: Counter(
            type: widget.to,
            value: currencyValue,
            onIncrement: _handleIncremening,
            onDecrement: _handleDecremeting));
  }

  Widget _buildDialogContent() => Column(
        children: [
          _buildDescription(),
          _buildCounter(),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Trigger when"),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: SingleChildScrollView(child: _buildDialogContent()),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.pop(context, false), // passing false
          child: Text('Close'),
        ),
        FlatButton(
          child: Text('Set'),
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
