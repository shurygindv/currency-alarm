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

  String getUSDRateIn(String key) {
    return usd.getRate(key).toStringAsFixed(3);
  }

  String getEURRateIn(String key) {
    return eur.getRate(key).toStringAsFixed(3);
  }

  String getRUBRateIn(String key) {
    return rub.getRate(key).toStringAsFixed(3);
  }

  factory CurrencyRateResult.fromJson(
          String updateTime, Map<String, dynamic> data) =>
      CurrencyRateResult(
          usd: Currency.fromJson(data['USD'] as Map<String, dynamic>),
          eur: Currency.fromJson(data['EUR'] as Map<String, dynamic>),
          rub: Currency.fromJson(data['RUB'] as Map<String, dynamic>),
          updateTime: updateTime);
}
