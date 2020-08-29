import 'package:flutter/material.dart';

// todo intl
Map<String, String> names = {'usd': 'USD', 'eur': 'EUR', 'rub': 'RUB'};

class CurrencyText extends StatelessWidget {
  final String name;

  CurrencyText({this.name});

  @override
  Widget build(BuildContext context) {
    final n = names[name];

    return Text(n);
  }
}