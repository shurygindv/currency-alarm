import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:currency_alarm/services/api.dart';
import 'package:currency_alarm/libs/debouncer.dart';

final _debouncer = Debouncer(delay: Duration(milliseconds: 300));

class CurrencyConverter extends StatefulWidget {
  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  CurrencyType _buyCurrencyType = CurrencyType.USD;
  CurrencyType _sellCurrencytype = CurrencyType.USD;

  _buildCurrencyIcon(CurrencyType t) {
    var assetName = "";

    if (t == CurrencyType.USD) {
      assetName = 'lib/assets/img/dollar-sign.svg';
    }

    if (t == CurrencyType.EUR) {
      assetName = 'lib/assets/img/euro-sign.svg';
    }

    if (t == CurrencyType.RUB) {
      assetName = 'lib/assets/img/ruble-sign.svg';
    }

    return SvgPicture.asset(
      assetName,
      height: 20.0,
      width: 20.0,
    );
  }

  Future<void> _convertCurrency(String currency) async {
    return await CurrencyApi.convertRate(currency,
        from: _buyCurrencyType, to: _sellCurrencytype);
  }

  _updateConvertingValuesAsync(String currency) async {
    var result = await _convertCurrency(currency);
  }

  _debounceConvertCurrencies(String currency) {
    _debouncer.run(() => {_updateConvertingValuesAsync(currency)});
  }

  _handleBuyInputChanges(String v) {
    _debounceConvertCurrencies(v);
  }

  _handleSellInputChanges(String v) {
    _debounceConvertCurrencies(v);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(children: [
        Container(
          margin: EdgeInsets.only(bottom: 20),
          child: TextField(
            keyboardType: TextInputType.number,
            onChanged: _handleBuyInputChanges,
            decoration: InputDecoration(
                icon: _buildCurrencyIcon(_buyCurrencyType),
                border: OutlineInputBorder(),
                labelText: 'Buy (from)'),
          ),
        ),
        Container(
          child: TextField(
            keyboardType: TextInputType.number,
            onChanged: _handleSellInputChanges,
            decoration: InputDecoration(
                icon: _buildCurrencyIcon(_sellCurrencytype),
                border: OutlineInputBorder(),
                labelText: 'Sell (to)'),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          child: Column(children: [
            const Text(
              'Buy currency',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
            ),
            Row(mainAxisSize: MainAxisSize.min, children: [
              Expanded(
                  child: RadioListTile(
                title: const Text('USD'),
                value: CurrencyType.USD,
                groupValue: _buyCurrencyType,
                onChanged: (CurrencyType v) {
                  setState(() {
                    _buyCurrencyType = v;
                  });
                },
              )),
              Expanded(
                  child: RadioListTile(
                title: const Text('RUB'),
                value: CurrencyType.RUB,
                groupValue: _buyCurrencyType,
                onChanged: (CurrencyType v) {
                  setState(() {
                    _buyCurrencyType = v;
                  });
                },
              )),
              //=
              Expanded(
                  child: RadioListTile(
                title: const Text('EUR'),
                value: CurrencyType.EUR,
                groupValue: _buyCurrencyType,
                onChanged: (CurrencyType v) {
                  setState(() {
                    _buyCurrencyType = v;
                  });
                },
              ))
            ]),

            // ===

            const Text(
              'Sell currency',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
            ),
            Row(mainAxisSize: MainAxisSize.min, children: [
              Expanded(
                  child: RadioListTile(
                title: const Text('USD'),
                value: CurrencyType.USD,
                groupValue: _sellCurrencytype,
                onChanged: (CurrencyType v) {
                  setState(() {
                    _sellCurrencytype = v;
                  });
                },
              )),
              Expanded(
                  child: RadioListTile(
                title: const Text('RUB'),
                value: CurrencyType.RUB,
                groupValue: _sellCurrencytype,
                onChanged: (CurrencyType v) {
                  setState(() {
                    _sellCurrencytype = v;
                  });
                },
              )),
              //=
              Expanded(
                  child: RadioListTile(
                title: const Text('EUR'),
                value: CurrencyType.EUR,
                groupValue: _sellCurrencytype,
                onChanged: (CurrencyType v) {
                  setState(() {
                    _sellCurrencytype = v;
                  });
                },
              ))
            ])
          ]),
        )
      ]),
    );
  }
}
