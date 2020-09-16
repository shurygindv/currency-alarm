import 'package:flutter/material.dart'
    show
        Widget,
        Column,
        TextStyle,
        Text,
        FontWeight,
        BuildContext,
        StatelessWidget;

import '../../../common/exporter.dart' show CurrencyType;

import './currency_radio_list.dart' show CurrencyRadioList;

class CurrencyRadioSection extends StatelessWidget {
  final String titleText;
  final CurrencyType value;
  final void Function(CurrencyType v) onChanged;

  CurrencyRadioSection({this.titleText, this.value, this.onChanged});

  Widget _buildTitle() => Text(
        titleText,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
      );

  Widget _buildBody() => CurrencyRadioList(
        value: value,
        onChanged: onChanged,
      );

  @override
  Widget build(BuildContext context) {
    return Column(children: [_buildTitle(), _buildBody()]);
  }
}
