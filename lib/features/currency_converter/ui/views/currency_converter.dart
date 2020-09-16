import 'dart:async';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:currency_alarm/libs/debouncer.dart';
import 'package:currency_alarm/application.dart' show AppStore;
import 'package:currency_alarm/libs/l10n/exporter.dart' show t;

import '../../data/models.dart' show ConverterResult;
import '../../../common/types.dart' show CurrencyType;

import './currency_text_input.dart' show CurrencyTextInput;
import './currency_radio_section.dart' show CurrencyRadioSection;

final _debouncer = Debouncer(delay: Duration(milliseconds: 300));

// TODO: !!rework!!: code, ux, test version
class CurrencyConverterView extends StatefulWidget {
  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverterView> {
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

  void _enableSellLoader() {
    _isSellFetching = true;
  }

  void _offSellLoader() {
    _isSellFetching = false;
  }

  _enableBuyLoader() {
    _isBuyFetching = true;
  }

  _disableBuyLoader() {
    _isBuyFetching = false;
  }

  _handleBuyInputChanges(String v) {
    _disableSellCurrencyInput();

    _enableSellLoader();

    _debounceConvertingBuyField(double.parse(v)).then((value) {
      _enableSellCurrencyInput();
      _offSellLoader();
      _setSellInputValue(value.rate.toString());
    }).catchError((error) {
      _offSellLoader();
      _enableSellCurrencyInput();
    });
  }

  _handleSellInputChanges(String v) {
    _disableBuyCurrencyInput();

    _enableBuyLoader();
    _debounceConvertingSellField(double.parse(v)).then((value) {
      _enableBuyCurrencyInput();
      _disableBuyLoader();
      _setBuyInputValue(value.rate.toString());
    }).catchError((error) {
      _disableBuyLoader();
      _enableBuyCurrencyInput();
    });
  }

  _handleBuyRadioInputChanges(CurrencyType v) {
    setState(() {
      _buyCurrencyType = v;
    });

    if (buyInput.text != "") {
      _handleBuyInputChanges(buyInput.text);
    }
  }

  _handleSellRadioInputChanges(CurrencyType v) {
    setState(() {
      _sellCurrencytype = v;
    });

    if (buyInput.text != "") {
      _handleBuyInputChanges(buyInput.text);
    }
  }

  Widget _buildBuyInput() => CurrencyTextInput(
        labelText: t("converter.buyLabel"),
        type: _buyCurrencyType,
        isEnabled: _isBuyEnabled,
        onChanged: _handleBuyInputChanges,
        isFetching: _isBuyFetching,
        controller: buyInput,
      );

  Widget _buildBuyCurrencySelector() => CurrencyRadioSection(
      titleText: t('converter.buy'),
      value: _buyCurrencyType,
      onChanged: _handleBuyRadioInputChanges);

  Widget _buildSellInput() => CurrencyTextInput(
        labelText: t("converter.sellLabel"),
        type: _sellCurrencytype,
        isEnabled: _isSellEnabled,
        onChanged: _handleSellInputChanges,
        isFetching: _isSellFetching,
        controller: sellInput,
      );

  Widget _buildSellCurrencySelector() => CurrencyRadioSection(
      titleText: t('converter.sell'),
      value: _sellCurrencytype,
      onChanged: _handleSellRadioInputChanges);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: Column(children: [
        _buildBuyInput(),
        _buildSellInput(),
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: Column(children: [
            _buildBuyCurrencySelector(),
            _buildSellCurrencySelector(),
          ]),
        )
      ]),
    );
  }
}
