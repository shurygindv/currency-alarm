import 'package:flutter/foundation.dart' show describeEnum;

import '../../common/exporter.dart' show CurrencyType, transformToCurrencyEnum;

class Currency {
  final String date;
  final String base;
  final Map<String, dynamic> rates;

  Currency({this.date, this.base, this.rates});

  double getRate(String key) => rates[key] + 0.0 as double;

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      date: json['date'] as String,
      base: json['base'] as String,
      rates: json['rates'] as Map<String, dynamic>,
    );
  }
}

class CurrencyRateResult {
  final Currency usd;
  final Currency eur;
  final Currency rub;
  final String updateTime;

  CurrencyRateResult({this.usd, this.eur, this.rub, this.updateTime = ""});

  String getUSDRateIn(CurrencyType key) {
    return usd.getRate(describeEnum(key)).toStringAsFixed(3);
  }

  String getEURRateIn(CurrencyType key) {
    return eur.getRate(describeEnum(key)).toStringAsFixed(3);
  }

  String getRUBRateIn(CurrencyType key) {
    return rub.getRate(describeEnum(key)).toStringAsFixed(3);
  }

  factory CurrencyRateResult.fromJson(
      String updateTime, Map<String, dynamic> data) {
    Currency want(String v) =>
        Currency.fromJson(data[v] as Map<String, dynamic>);

    return CurrencyRateResult(
        usd: want('USD'),
        eur: want('EUR'),
        rub: want('RUB'),
        updateTime: updateTime);
  }
}

class ActivatedAlarmOptions {
  final CurrencyType from;
  final CurrencyType to;
  final double currency;
  final DateTime activationDate;

  ActivatedAlarmOptions(
      {this.from, this.to, this.currency, this.activationDate});

  factory ActivatedAlarmOptions.fromJson(Map<String, dynamic> data) {
    final currency = (data['currency'] as double) + 0.0;
    final dt = data['activationDate'] as String;
    final from = data['from'] as String;
    final to = data['to'] as String;

    return ActivatedAlarmOptions(
        from: transformToCurrencyEnum(from),
        to: transformToCurrencyEnum(to),
        currency: currency,
        activationDate: DateTime.parse(dt));
  }

  static Map<String, dynamic> toMap(
      CurrencyType from, CurrencyType to, double currency) {
    return {
      'from': describeEnum(from),
      'to': describeEnum(to),
      'currency': currency,
      'activationDate': DateTime.now().toIso8601String(),
    };
  }
}
