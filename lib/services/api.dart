import 'package:http/http.dart' as http;

// rate: https://ia500r2mmf.execute-api.eu-west-3.amazonaws.com/default/get-currency-rating
// converter: https://nzun06d9r4.execute-api.eu-west-3.amazonaws.com/default/convertCurrency

const rateurl =
    'https://ia500r2mmf.execute-api.eu-west-3.amazonaws.com/default/get-currency-rating';

const converterUrl =
    'https://nzun06d9r4.execute-api.eu-west-3.amazonaws.com/default/convertCurrency';

enum CurrencyType { USD, RUB, EUR }

class CurrencyApi {
  static Future<http.Response> fetchRate() {
    return http.get(rateurl);
  }

  static Future<http.Response> convertRate(String currency,
      {CurrencyType from, CurrencyType to}) {
    return http.get(converterUrl);
  }
}
