import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';

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
  Future<CurrencyRateResult> fetchRate() async {
    final res = await http.get(rateurl);

    return compute(mapCurrencyRating, res.body);
  }
}
