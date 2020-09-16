import 'package:flutter_spinkit/flutter_spinkit.dart' show SpinKitRing;
import 'package:flutter/material.dart'
    show
        Widget,
        Colors,
        Container,
        TextField,
        EdgeInsets,
        BuildContext,
        TextInputType,
        StatelessWidget,
        InputDecoration,
        TextEditingController,
        OutlineInputBorder;

import 'package:currency_alarm/ui/exporter.dart' show NoContent;
import 'package:currency_alarm/libs/l10n/exporter.dart' show t;

import '../../../common/exporter.dart' show CurrencySignIcon, CurrencyType;

class CurrencyTextInput extends StatelessWidget {
  final TextEditingController controller;
  final CurrencyType type;
  final bool isFetching;
  final bool isEnabled;
  final void Function(String v) onChanged;

  CurrencyTextInput(
      {this.type,
      this.isEnabled,
      this.isFetching,
      this.controller,
      this.onChanged});

  Widget _buildRingLoader() {
    return Container(
      width: 40,
      child: SpinKitRing(
        color: Colors.black38,
        size: 20.0,
        lineWidth: 2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: TextField(
        controller: controller,
        enabled: isEnabled,
        keyboardType: TextInputType.number,
        onChanged: onChanged,
        decoration: InputDecoration(
            icon: CurrencySignIcon(name: type, size: 20),
            border: OutlineInputBorder(),
            suffixIcon: isFetching ? _buildRingLoader() : NoContent(),
            labelText: t("converter.buyLabel")),
      ),
    );
  }
}
