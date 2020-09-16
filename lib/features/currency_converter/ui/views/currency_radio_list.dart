import 'package:flutter/material.dart'
    show
        Row,
        Text,
        Widget,
        Expanded,
        TextStyle,
        BuildContext,
        RadioListTile,
        StatelessWidget,
        MainAxisAlignment;

import '../../../common/exporter.dart' show CurrencyType;

class CurrencyRadioList extends StatelessWidget {
  final CurrencyType value;
  final void Function(CurrencyType v) onChanged;

  CurrencyRadioList({this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Expanded(
          child: RadioListTile(
        title: const Text('USD', style: TextStyle(fontSize: 13)),
        value: CurrencyType.USD,
        groupValue: value,
        onChanged: onChanged,
      )),
      Expanded(
          child: RadioListTile(
        title: const Text('RUB', style: TextStyle(fontSize: 13)),
        value: CurrencyType.RUB,
        groupValue: value,
        onChanged: onChanged,
      )),
      //=
      Expanded(
          child: RadioListTile(
        title: const Text('EUR', style: TextStyle(fontSize: 13)),
        value: CurrencyType.EUR,
        groupValue: value,
        onChanged: onChanged,
      ))
    ]);
  }
}
