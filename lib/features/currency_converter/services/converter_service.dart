import 'dart:convert' show json;
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show describeEnum, compute;

import '../../common/interface.dart' show BaseService;
import '../../common/types.dart' show CurrencyType;
import '../data/models.dart' show ConverterResult;

const converterOrigin = 't2ubj7wmd0.execute-api.eu-west-3.amazonaws.com';
const converterPath = '/default/ConvertCurrencyApi';

ConverterResult mapConverterValues(String body) {
  final parsed = json.decode(body);

  final data = parsed['data'] as Map<String, dynamic>;

  return ConverterResult.fromJson(data);
}

Uri getConverterUri(double amount, CurrencyType from, CurrencyType to) {
  Map<String, String> queryParameters = {
    'amount': amount.toString(),
    'from': describeEnum(from),
    'to': describeEnum(to),
  };

  return Uri.https(converterOrigin, converterPath, queryParameters);
}

class CurrencyConverterService extends BaseService {
  Future<ConverterResult> convert(
      double amount, CurrencyType from, CurrencyType to) async {
    final res = await http.get(getConverterUri(amount, from, to));

    return compute(mapConverterValues, res.body);
  }
}
