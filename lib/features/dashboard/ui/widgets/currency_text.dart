import 'package:flutter/material.dart';

// todo enum, intl
Map<String, String> names = {'usd': 'USD', 'eur': 'EUR', 'rub': 'RUB'};

class CurrencyText extends StatelessWidget {
  final String name;

  const CurrencyText({@required this.name});

  @override
  Widget build(BuildContext context) {
    final n = names[name];

    return Text(n);
  }
}
