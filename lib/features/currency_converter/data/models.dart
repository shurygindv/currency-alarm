class ConverterResult {
  final double rate;
  final String from;
  final String to;

  ConverterResult({this.rate, this.to, this.from});

  factory ConverterResult.fromJson(Map<String, dynamic> data) {
    double rate = data['rate'] + .0;

    return ConverterResult(
        rate: rate, to: data['to'] as String, from: data['from'] as String);
  }
}
