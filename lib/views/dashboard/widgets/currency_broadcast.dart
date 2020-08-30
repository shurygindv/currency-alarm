import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:currency_alarm/widgets/loader.dart';
import 'package:currency_alarm/widgets/currency_switcher_control.dart';
import 'package:currency_alarm/services/storage.dart';
import 'package:currency_alarm/services/api.dart';
import 'package:currency_alarm/libs/debouncer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:currency_alarm/application.dart';

class CurrencyBroadcast extends StatefulWidget {
  @override
  _CurrencyBroadcastState createState() => _CurrencyBroadcastState();
}

class _CurrencyBroadcastState extends State<CurrencyBroadcast> {
  bool isFetching = false;

  void _fetchInitialRates() {
    // Ы
    Future.microtask(() async {
      setState(() {
        isFetching = true;
      });

      await AppStore.getProvider(context).fetchRates();

      if (mounted) {
        setState(() {
          isFetching = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _fetchInitialRates();
  }

  Widget _buildCurrentRate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.only(right: 10),
          child: Text(
            '74.57',
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.w500),
          ),
        ),
        SvgPicture.asset(
          'lib/assets/img/euro-sign.svg',
          alignment: Alignment.topCenter,
          height: 30.0,
          width: 30.0,
        ),
      ],
    );
  }

  Widget _buildLastRateUpdateTime() {
    final updateTime = context.watch<AppStore>().updateTime;

    return Column(
      children: [
        Container(
          child: Text(
            "last updated on $updateTime",
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
        )
      ],
    );
  }

  Widget _buildCurrencyRateDisplay() {
    return Container(
        margin: EdgeInsets.only(top: 30, bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCurrentRate(),
            _buildLastRateUpdateTime(),
          ],
        ));
  }

  Widget _buildLoader() => Container(
        margin: EdgeInsets.only(top: 33, bottom: 30),
        child: Loader(name: 'ripple'),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isFetching ? _buildLoader() : _buildCurrencyRateDisplay(),
        CurrencySwitcherControl(),
      ],
    );
  }
}
