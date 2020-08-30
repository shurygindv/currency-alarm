import 'package:flutter/material.dart';

// todo intl
Map<String, String> names = {'usd': 'USD', 'eur': 'EUR', 'rub': 'RUB'};

class CurrencyPluralizer extends StatelessWidget {
  final int amount;
  final String name;

  const CurrencyPluralizer({this.amount, this.name});

  @override
  Widget build(BuildContext context) {
    final n = names[name];

    return Text(
      '$amount $n',
      style: TextStyle(
          fontSize: 15, color: Colors.grey[500], fontWeight: FontWeight.bold),
    );
  }
}
