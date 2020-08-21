import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';

const rateurl =
    'https://ia500r2mmf.execute-api.eu-west-3.amazonaws.com/default/get-currency-rating';

const converterOrigin = 'nzun06d9r4.execute-api.eu-west-3';
const converterPath = '/default/convertCurrency';

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

class CurrencyRateResult {
  final Currency usd;
  final Currency eur;
  final String updateTime;

  CurrencyRateResult({this.usd, this.eur, this.updateTime});

  double getUSDRateIn(String key) {
    return usd.getRate(key);
  }

  double getEURRateIn(String key) {
    return eur.getRate(key);
  }

  factory CurrencyRateResult.fromJson(
          String updateTime, Map<String, dynamic> data) =>
      CurrencyRateResult(
          usd: Currency.fromJson(data['USD'] as Map<String, dynamic>),
          eur: Currency.fromJson(data['EUR'] as Map<String, dynamic>),
          updateTime: updateTime);
}

CurrencyRateResult mapCurrencyRating(String body) {
  final parsed = json.decode(body);

  final data = parsed['data'] as Map<String, dynamic>;
  final updateTime = parsed['date'] as String;

  return CurrencyRateResult.fromJson(updateTime, data);
}

class ConverterResult {
  final double converted;

  ConverterResult({this.converted});

  factory ConverterResult.fromJson(Map<String, dynamic> data) =>
      ConverterResult(converted: data['converted']);
}

ConverterResult mapConverterValues(String body) {
  final parsed = json.decode(body);

  final data = parsed['data'] as Map<String, dynamic>;

  return ConverterResult.fromJson(data);
}

Uri getConverterUri(CurrencyType from, CurrencyType to) {
  final queryParameters = {
    'from': from.toString(),
    'to': to.toString(),
  };

  print(queryParameters);

  return Uri.https(converterOrigin, converterPath, queryParameters);
}

class CurrencyApi {
  static Future<CurrencyRateResult> fetchRate() async {
    final res = await http.get(rateurl);

    return compute(mapCurrencyRating, res.body);
  }

  static Future<ConverterResult> convertRate(String currency,
      {CurrencyType from, CurrencyType to}) async {
    final res = await http.get(getConverterUri(from, to));

    return compute(mapConverterValues, res.body);
  }
}
