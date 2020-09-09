import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:currency_alarm/libs/l10n/exporter.dart' show IntlText;
import 'package:currency_alarm/ui/exporter.dart' show Loader;
import 'package:currency_alarm/application.dart' show AppStore;
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

  CurrencyBroadcast({
    this.fromCurrencyValue,
    this.toCurrencyValue,
    this.onFromChanges,
    this.onToChanges,
    this.isFetching,
  });

  _getCurrentCurrency(CurrencyRateResult rate) {
    switch (fromCurrencyValue) {
      case CurrencyType.USD:
        return rate.getUSDRateIn(toCurrencyValue);
      case CurrencyType.EUR:
        return rate.getEURRateIn(toCurrencyValue);
      case CurrencyType.RUB:
        return rate.getRUBRateIn(toCurrencyValue);
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
  String getDtPattern(String locale) {
    if (locale == 'ru_RU') {
      return "d MMMM, HH:MM:ss";
    }

    return "d MMMM, hh:mm a";
  }

  Widget _buildCurrencyRateDisplay() {
    return FadeInUi(child: Consumer<AppStore>(builder: (ctx, appStore, __) {
      final updateTime = appStore.updateTime;
      final rate = appStore.rate;

      final timestamp =
          DateFormat(getDtPattern(ctx.locale.toString())).format(updateTime);

      return Container(
          margin: EdgeInsets.only(top: 30, bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCurrentRate(_getCurrentCurrency(rate)),
              _buildLastRateUpdateTime(timestamp),
            ],
          ));
    }));
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        isFetching ? _buildLoader() : _buildCurrencyRateDisplay(),
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
