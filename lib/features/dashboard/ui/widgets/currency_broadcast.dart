import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:currency_alarm/libs/l10n/exporter.dart' show IntlText;
import 'package:currency_alarm/ui/exporter.dart' show Loader;
import 'package:currency_alarm/libs/ui-effects/exporter.dart' show FadeInUi;

import './currency_switcher_control.dart' show CurrencySwitcherControl;
import '../../../common/exporter.dart' show CurrencySignIcon, CurrencyType;
import '../../data/models.dart' show CurrencyRateResult;

typedef CurrencyChangeFn = void Function(CurrencyType t);

class CurrencyBroadcast extends StatelessWidget {
  final bool isFetching;

  final CurrencyType fromCurrencyValue;
  final CurrencyType toCurrencyValue;

  final CurrencyChangeFn onFromChanges;
  final CurrencyChangeFn onToChanges;

  final CurrencyRateResult rateResult;

  CurrencyBroadcast({
    this.fromCurrencyValue,
    this.toCurrencyValue,
    this.onFromChanges,
    this.onToChanges,
    this.isFetching,
    this.rateResult,
  });

  _getCurrentCurrency() {
    switch (fromCurrencyValue) {
      case CurrencyType.USD:
        return rateResult.getUSDRateIn(toCurrencyValue);
      case CurrencyType.EUR:
        return rateResult.getEURRateIn(toCurrencyValue);
      case CurrencyType.RUB:
        return rateResult.getRUBRateIn(toCurrencyValue);
      default:
        throw new Exception('currency_broadcast: unknown _fromCurrencyValue');
    }
  }

  Widget _buildCurrentRate(String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.only(right: 10),
          child: Text(
            '$value',
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.w500),
          ),
        ),
        CurrencySignIcon(size: 25.0, name: toCurrencyValue)
      ],
    );
  }

  Widget _buildLastRateUpdateTime(String updateTime) {
    return Column(
      children: [
        Container(
          child: IntlText(
            "dashboard.rateUpdate",
            namedArgs: {'date': updateTime},
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
        )
      ],
    );
  }

  // todo: enum
  String getDatePattern(String locale) {
    if (locale == 'ru_RU') {
      return "d MMMM, HH:MM:ss";
    }

    return "d MMMM, hh:mm a";
  }

  Widget _buildCurrencyRateDisplay(String localeName) {
    final updateTime = rateResult.updateTime;

    final timestamp = DateFormat(getDatePattern(localeName)).format(updateTime);

    return FadeInUi(
        child: Container(
            margin: EdgeInsets.only(top: 30, bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCurrentRate(_getCurrentCurrency()),
                _buildLastRateUpdateTime(timestamp),
              ],
            )));
  }

  Widget _buildLoader() => Container(
        margin: EdgeInsets.only(top: 33, bottom: 30),
        child: Loader(name: 'ripple'),
      );

  void _handleFromChanges(CurrencyType t) {
    onFromChanges(t);
  }

  void _handleToChanges(CurrencyType t) {
    onToChanges(t);
  }

  @override
  Widget build(BuildContext ctx) {
    final localeName = ctx.locale.toString();

    return Column(
      children: [
        isFetching || rateResult == null // TODO: empty
            ? _buildLoader()
            : _buildCurrencyRateDisplay(localeName),
        CurrencySwitcherControl(
          fromValue: fromCurrencyValue,
          toValue: toCurrencyValue,
          onFromChanges: _handleFromChanges,
          onToChanges: _handleToChanges,
        ),
      ],
    );
  }
}
