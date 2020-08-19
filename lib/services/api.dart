import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';

const rateurl =
    'https://ia500r2mmf.execute-api.eu-west-3.amazonaws.com/default/get-currency-rating';

const converterUrl =
    'https://nzun06d9r4.execute-api.eu-west-3.amazonaws.com/default/convertCurrency';

enum CurrencyType { USD, RUB, EUR }

class Currency {
  final String date;
  final String base;
  final Map<String, dynamic> rates;

  Currency({this.date, this.base, this.rates});

  double getRate(String key) => rates[key] as double;

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      date: json['date'] as String,
      base: json['base'] as String,
      rates: json['rates'] as Map<String, dynamic>,
    );
  }
}

class CurrencyInfo {
  final Currency usd;
  final Currency eur;
  final String updateTime;

  CurrencyInfo({this.usd, this.eur, this.updateTime});

  double getUSDRateIn(String key) {
    return usd.getRate(key);
  }

  double getEURRateIn(String key) {
    return eur.getRate(key);
  }

  factory CurrencyInfo.fromJson(String updateTime, Map<String, dynamic> data) =>
      CurrencyInfo(
          usd: Currency.fromJson(data['USD'] as Map<String, dynamic>),
          eur: Currency.fromJson(data['EUR'] as Map<String, dynamic>),
          updateTime: updateTime);
}

CurrencyInfo mapCurrencyRating(String body) {
  final parsed = json.decode(body);

  final data = parsed['data'] as Map<String, dynamic>;
  final updateTime = parsed['date'] as String;

  return CurrencyInfo.fromJson(updateTime, data);
}

class CurrencyApi {
  static Future<CurrencyInfo> fetchRate() async {
    final res = await http.get(rateurl);

    return compute(mapCurrencyRating, res.body);
  }

  static Future<http.Response> convertRate(String currency,
      {CurrencyType from, CurrencyType to}) {
    return http.get(converterUrl);
  }
}
