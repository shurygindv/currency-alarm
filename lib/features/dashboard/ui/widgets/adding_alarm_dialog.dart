import 'dart:async';

import 'package:currency_alarm/features/dashboard/exporter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:currency_alarm/libs/l10n/exporter.dart' show IntlText;
import 'package:currency_alarm/application.dart' show injectDependency;

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
    this.value = 0.0,
    this.type,
    this.onIncrement,
    this.onDecrement,
  });

  Widget _buildCounterValue() {
    final v = value.toStringAsFixed(2);

    return Container(
      margin: EdgeInsets.only(left: 10, right: 5),
      child: Text('$v', style: TextStyle(fontSize: 35)),
    );
  }

  Widget _buildSignIcon() {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: CurrencySignIcon(name: type, size: 17),
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
  _AddingAlarmDialogState();

  double currencyValue = 0.0;
  StreamSubscription<CurrencyRateResult> rateSubscription;

  final currencyRateService = injectDependency<CurrencyRateService>();

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

  void _updateCurrency(event) {
    var v;

    try {
      v = double.parse(_getCurrentCurrency(event));
    } catch (e) {
      v = 0.0;
    }

    setCurrency(v);
  }

  void _listenServiceRateUpdates() {
    rateSubscription =
        currencyRateService.getCurrencyRate.listen(_updateCurrency);
  }

  void _disposeServiceRateUpdates() {
    rateSubscription.cancel();
  }

  @override
  void initState() {
    super.initState();

    _listenServiceRateUpdates();
  }

  @override
  void dispose() {
    super.dispose();

    _disposeServiceRateUpdates();
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

  void setCurrency(double v) {
    setState(() {
      currencyValue = v;
    });
  }

  void _handleIncremening() {
    setCurrency(currencyValue + 0.1);
  }

  void _handleDecremeting() {
    setCurrency(currencyValue - 0.1);
  }

  // TOOD: abstract
  Widget _buildBadge(String v) => Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[100],
      ),
      child: Text(v, style: TextStyle(fontSize: 10, color: Colors.black54)));

  Widget _buildCurrencyEq() {
    final from = _getCurrencyText(widget.from);
    final to = _getCurrencyText(widget.to);

    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildBadge("1 $from"),
          IntlText("dashboard.currencyEquals", style: TextStyle(fontSize: 15)),
          _buildBadge("$to"),
        ]);
  }

  Widget _buildCounter() {
    return Container(
        margin: EdgeInsets.only(top: 15),
        child: Counter(
            type: widget.to,
            value: currencyValue,
            onIncrement: _handleIncremening,
            onDecrement: _handleDecremeting));
  }

  _buildInfoTip() => Container(
      child: IntlText('dashboard.valuesTip',
          style: TextStyle(fontSize: 10, color: Colors.black45)));

  Widget _buildDialogContent() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildInfoTip(),
          _buildCurrencyEq(),
          _buildCounter(),
        ],
      );

  Widget _buildDialogTitle() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        IntlText("dashboard.notify"),
        IntlText("dashboard.notifyWhen",
            style: TextStyle(fontSize: 12, color: Colors.black45)),
      ]);

  List<Widget> _buildDialogActions() => <Widget>[
        FlatButton(
          onPressed: () => Navigator.pop(context, false), // passing false
          child: IntlText('dialog.cancel'),
        ),
        FlatButton(
          child: IntlText('dialog.notify'),
          onPressed: () {
            widget
                .onSubmit(currencyValue)
                .whenComplete(() => Navigator.of(context).pop());
          },
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: _buildDialogTitle(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: SingleChildScrollView(child: _buildDialogContent()),
        actions: _buildDialogActions());
  }
}
