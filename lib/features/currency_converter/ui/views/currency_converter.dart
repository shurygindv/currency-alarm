import 'dart:async';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:currency_alarm/libs/debouncer.dart';
import 'package:currency_alarm/application.dart' show AppStore;

import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../data/models.dart' show ConverterResult;
import '../../../common/types.dart' show CurrencyType;

final _debouncer = Debouncer(delay: Duration(milliseconds: 300));

class CurrencyConverter extends StatefulWidget {
  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  CurrencyType _buyCurrencyType = CurrencyType.USD;
  CurrencyType _sellCurrencytype = CurrencyType.USD;

  bool _isBuyEnabled = true;
  bool _isSellEnabled = true;

  bool _isBuyFetching = false;
  bool _isSellFetching = false;

  final buyInput = TextEditingController();
  final sellInput = TextEditingController();

  @override
  void dispose() {
    buyInput.dispose();
    sellInput.dispose();

    super.dispose();
  }

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

  Future<ConverterResult> _convertCurrency(double amount,
      {CurrencyType buy, CurrencyType sell}) async {
    return context
        .read<AppStore>()
        .convertCurrency(amount, buy: buy, sell: sell);
    // return await CurrencyApi.convert(amount, buy, sell);
  }

  Future<ConverterResult> _fetchBuy(double amount) async {
    var result = await _convertCurrency(amount,
        buy: _buyCurrencyType, sell: _sellCurrencytype);

    print(result.rate);

    return result;
  }

  Future<ConverterResult> _debounceConvertingBuyField(double amount) {
    final completer = new Completer<ConverterResult>();

    _debouncer.run(() async {
      final result = await _fetchBuy(amount);

      completer.complete(result);
    });

    return completer.future;
  }

  // ==

  Future<ConverterResult> _fetchSell(double amount) async {
    var result = await _convertCurrency(amount,
        buy: _sellCurrencytype, sell: _buyCurrencyType);

    print(result.rate);

    return result;
  }

  Future<ConverterResult> _debounceConvertingSellField(double amount) {
    final completer = new Completer<ConverterResult>();

    _debouncer.run(() async {
      final result = await _fetchSell(amount);

      completer.complete(result);
    });

    return completer.future;
  }

  _disableSellCurrencyInput() {
    setState(() {
      _isSellEnabled = false;
    });
  }

  _enableSellCurrencyInput() {
    setState(() {
      _isSellEnabled = true;
    });
  }

  _disableBuyCurrencyInput() {
    setState(() {
      _isBuyEnabled = false;
    });
  }

  _enableBuyCurrencyInput() {
    setState(() {
      _isBuyEnabled = true;
    });
  }

  _setBuyInputValue(String v) {
    buyInput.text = v;
  }

  _setSellInputValue(String v) {
    sellInput.text = v;
  }

  _toggleSellLoader() {
    setState(() {
      _isSellFetching = !_isSellFetching;
    });
  }

  _toggleBuyLoader() {
    setState(() {
      _isBuyFetching = !_isBuyFetching;
    });
  }

  _handleBuyInputChanges(String v) {
    _disableSellCurrencyInput();

    _toggleSellLoader();

    _debounceConvertingBuyField(double.parse(v)).then((value) {
      _enableSellCurrencyInput();
      _toggleSellLoader();
      _setSellInputValue(value.rate.toString());
    }).catchError((error) {
      _toggleSellLoader();
      _enableSellCurrencyInput();
    });
  }

  _handleSellInputChanges(String v) {
    _disableBuyCurrencyInput();

    _toggleBuyLoader();
    _debounceConvertingSellField(double.parse(v)).then((value) {
      _enableBuyCurrencyInput();
      _toggleBuyLoader();
      _setBuyInputValue(value.rate.toString());
    }).catchError((error) {
      _toggleBuyLoader();
      _enableBuyCurrencyInput();
    });
  }

  Widget _buildRingLoader() {
    return Container(
      width: 40,
      child: SpinKitRing(
        color: Colors.black38,
        size: 20.0,
        lineWidth: 2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: Column(children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: TextField(
            controller: buyInput,
            enabled: _isBuyEnabled,
            keyboardType: TextInputType.number,
            onChanged: _handleBuyInputChanges,
            decoration: InputDecoration(
                icon: _buildCurrencyIcon(_buyCurrencyType),
                border: OutlineInputBorder(),
                suffixIcon: _isBuyFetching ? _buildRingLoader() : null,
                labelText: 'Buy (from)'),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
          child: TextField(
            controller: sellInput,
            enabled: _isSellEnabled,
            keyboardType: TextInputType.number,
            onChanged: _handleSellInputChanges,
            decoration: InputDecoration(
                icon: _buildCurrencyIcon(_sellCurrencytype),
                border: OutlineInputBorder(),
                suffixIcon: _isSellFetching ? _buildRingLoader() : null,
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
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
