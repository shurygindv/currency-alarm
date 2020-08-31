import 'package:flutter/material.dart';

import 'package:currency_alarm/ui/exporter.dart' show FlagIcon;

import './currency_pluralizer.dart' show CurrencyPluralizer;
import './currency_text.dart' show CurrencyText;

import '../../../common/exporter.dart' show CurrencyType;

typedef StringVoidFn = void Function(CurrencyType);

String mapCurrencyTypeToFlagName(CurrencyType t) {
  // todo: enum const
  switch (t) {
    case CurrencyType.EUR:
      return 'eur';
    case CurrencyType.USD:
      return 'us';
    case CurrencyType.RUB:
      return 'rus';
    default:
      throw new FormatException('CurrectSwitcherControl: unknown error');
  }
}

String mapCurrencyTypeToName(CurrencyType t) {
  switch (t) {
    case CurrencyType.EUR:
      return 'eur';
    case CurrencyType.USD:
      return 'usd';
    case CurrencyType.RUB:
      return 'rub';
    default:
      throw new FormatException('CurrencySwitcherControl: unknown error');
  }
}

class CurrencyDropdown extends StatelessWidget {
  final CurrencyType value;
  final bool backward;

  final StringVoidFn onChanged;

  CurrencyDropdown({this.value, this.onChanged, this.backward = false});

  final List<DropdownMenuItem> _menuItems = [
    DropdownMenuItem(value: CurrencyType.USD, child: CurrencyText(name: 'usd')),
    DropdownMenuItem(value: CurrencyType.EUR, child: CurrencyText(name: 'eur')),
    DropdownMenuItem(value: CurrencyType.RUB, child: CurrencyText(name: 'rub')),
  ];

  Widget _buildFlag(String flagName) {
    return Container(
      width: 40,
      height: 45,
      child: FlagIcon(name: flagName),
    );
  }

  Widget _buildFlagByCurrentValue() =>
      _buildFlag(mapCurrencyTypeToFlagName(value));

  Widget _buildFlagLabel(String name) => Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: CurrencyPluralizer(amount: 1, name: name));

  Widget _buildFlagLabelByCurrentValue() =>
      _buildFlagLabel(mapCurrencyTypeToName(value));

  Widget _buildSelectedItem() => Row(children: [
        _buildFlagByCurrentValue(),
        _buildFlagLabelByCurrentValue(),
      ]);

  @override
  Widget build(BuildContext context) {
    return Flexible(
        fit: FlexFit.loose,
        child: DropdownButton(
          value: value,
          elevation: 16,
          isDense: true,
          icon: backward ? _buildFlagByCurrentValue() : null,
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
  final CurrencyType fromValue;
  final CurrencyType toValue;
  // =
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
