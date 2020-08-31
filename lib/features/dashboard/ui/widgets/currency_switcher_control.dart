import 'package:flutter/material.dart';

import 'package:currency_alarm/ui/exporter.dart' show FlagIcon;

import './currency_pluralizer.dart' show CurrencyPluralizer;
import './currency_text.dart' show CurrencyText;

typedef StringVoidFn = void Function(String);

class CurrencyDropdown extends StatelessWidget {
  final String value;
  final bool backward;

  final StringVoidFn onChanged;

  CurrencyDropdown({this.value, this.onChanged, this.backward = false});

  final List<DropdownMenuItem> _menuItems = [
    DropdownMenuItem(value: 'usd', child: CurrencyText(name: 'usd')),
    DropdownMenuItem(value: 'eur', child: CurrencyText(name: 'eur')),
    DropdownMenuItem(value: 'rub', child: CurrencyText(name: 'rub')),
  ];

  Widget _buildFlag(String flagName) => Container(
        width: 40,
        height: 45,
        child: FlagIcon(name: flagName),
      );

  Widget _buildFlagLabel(String name) => Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: CurrencyPluralizer(amount: 1, name: name));

  Widget _buildSelectedItem() =>
      Row(children: [_buildFlag(value), _buildFlagLabel(value)]);

  @override
  Widget build(BuildContext context) {
    return Flexible(
        fit: FlexFit.loose,
        child: DropdownButton(
          value: value,
          elevation: 16,
          isDense: true,
          icon: backward ? _buildFlag(value) : null,
          iconSize: backward ? 24.0 : 0.0,
          isExpanded: true,
          onChanged: (v) {
            onChanged(v);
          },
          items: _menuItems,
          selectedItemBuilder: backward
              ? null
              : (BuildContext ctx) => [
                    _buildSelectedItem(),
                    _buildSelectedItem(),
                    _buildSelectedItem(),
                  ],
        ));
  }
}

class CurrencySwitcherControl extends StatelessWidget {
  final String fromValue;
  final String toValue;
  final StringVoidFn onFromChanges;
  final StringVoidFn onToChanges;

  const CurrencySwitcherControl({
    this.fromValue,
    this.toValue,
    this.onFromChanges,
    this.onToChanges,
  });

  Widget _buildLeftDropdown() => CurrencyDropdown(
        value: fromValue,
        onChanged: onFromChanges,
      );

  Widget _buildRightDropdown() =>
      CurrencyDropdown(value: toValue, onChanged: onToChanges, backward: true);

  Widget _buildDirectionWidget() => Flexible(
          child: Container(
        child: Icon(Icons.trending_flat, size: 27.0),
        padding: EdgeInsets.all(7),
        margin: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50), color: Colors.grey[200]),
      ));

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLeftDropdown(),
        _buildDirectionWidget(),
        _buildRightDropdown(),
      ],
    );
  }
}
