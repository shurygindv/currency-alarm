import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:currency_alarm/widgets/flag_icon.dart';
import 'package:currency_alarm/widgets/currency_pluralizer.dart';
import 'package:currency_alarm/widgets/currency_text.dart';

class CurrencyDropdown extends StatefulWidget {
  String value = 'usd';
  bool backward = false;

  CurrencyDropdown({this.value, this.backward = false});

  @override
  _CurrencyDropdownState createState() =>
      _CurrencyDropdownState(value: value, backward: backward);
}

class _CurrencyDropdownState extends State<CurrencyDropdown> {
  String value;
  bool backward = false;

  _CurrencyDropdownState({this.value, this.backward = false});

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
            setState(() {
              value = v;
            });
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

class CurrencySwitcherControl extends StatefulWidget {
  @override
  _CurrencySwitcherControlState createState() =>
      _CurrencySwitcherControlState();
}

class _CurrencySwitcherControlState extends State<CurrencySwitcherControl> {
  Widget _buildLeftDropdown() => CurrencyDropdown(
        value: 'usd',
      );

  Widget _buildRightDropdown() =>
      CurrencyDropdown(value: 'eur', backward: true);

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
