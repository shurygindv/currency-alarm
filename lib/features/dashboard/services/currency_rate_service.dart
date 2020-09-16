import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/foundation.dart' show compute;
import 'package:http/http.dart' as http;
import 'dart:convert' show json;

import '../../common/interface.dart' show BaseService;
import '../data/models.dart' show CurrencyRateResult;

const rateurl =
    'https://ia500r2mmf.execute-api.eu-west-3.amazonaws.com/default/get-currency-rating';

CurrencyRateResult mapCurrencyRating(String body) {
  final parsed = json.decode(body);

  final data = parsed['data'] as Map<String, dynamic>;
  final updateTime = parsed['date'] as String;

  return CurrencyRateResult.fromJson(updateTime, data);
}

class CurrencyRateService extends BaseService {
  final _currencyRate = BehaviorSubject<CurrencyRateResult>();

  Stream get getCurrencyRate => _currencyRate.stream;

  void dispose() {
    _currencyRate.close();
  }

  _updateCurrencyRate(CurrencyRateResult v) {
    _currencyRate.sink.add(v);
  }

  Future<CurrencyRateResult> fetchRate() async {
    final res = await http.get(rateurl);
    final result = await compute(mapCurrencyRating, res.body);

    _updateCurrencyRate(result);

    return result; // only for isolation msg
  }
}
