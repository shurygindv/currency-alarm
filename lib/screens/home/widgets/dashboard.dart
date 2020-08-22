import 'package:flutter/material.dart';

import 'package:currency_alarm/services/storage.dart';
import 'package:currency_alarm/services/api.dart';
import 'package:currency_alarm/libs/debouncer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashboardView extends StatefulWidget {
  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  void _fetchRates() async {
    final currencyInfo = await CurrencyApi.fetchRate();
    final ss = currencyInfo.getUSDRateIn('RUB');
    print(ss + 1);
  }

  void _fetchInitialRates() {
    Future.delayed(Duration.zero, _fetchRates);
  }

  @override
  void initState() {
    super.initState();

    _fetchInitialRates();
  }

  /*
  Future<void> _showTrackingRateDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
              title: Text('Title'),
              content:
                  SingleChildScrollView(child: Text("dollar ruble euro here")),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }
 

  Widget _buildTrackingRateButton() {
    return RaisedButton(
      onPressed: () {
        _showTrackingRateDialog();
      },
      color: Color(0xffe8b96a),
      textColor: Colors.white,
      child: Text(
        "Tap here to track downgrade of rate",
        style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
      ),
    );
  }
  */

  Widget _buildCurrencyIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 45,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: SvgPicture.asset(
                'lib/assets/img/us-flag.svg',
                fit: BoxFit.cover,
              )),
        ),
        Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Text(
              "1 USD",
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.bold),
            )),
        Container(
          child: Icon(Icons.trending_flat, size: 27.0),
          padding: EdgeInsets.all(7),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50), color: Colors.grey[200]),
        ),
        Container(
            padding: EdgeInsets.only(left: 20, right: 20), child: Text("EUR")),
        Container(
          width: 40,
          height: 45,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: SvgPicture.asset(
                'lib/assets/img/eur-union-flag.svg',
                fit: BoxFit.cover,
              )),
        ),
      ],
    );
  }

  Widget _buildCurrentCurrencyRate() => Container(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(right: 10),
            margin: EdgeInsets.symmetric(vertical: 30),
            child: Text(
              '74.57',
              style: TextStyle(
                  fontSize: 47,
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.w500),
            ),
          ),
          SvgPicture.asset(
            'lib/assets/img/euro-sign.svg',
            alignment: Alignment.topCenter,
            height: 30.0,
            width: 30.0,
          )
        ],
      ));

  _buildCurrencyTracker() {
    return Column(
      children: [
        _buildCurrentCurrencyRate(),
        _buildCurrencyIndicator(),
      ],
    );
  }

  Widget _buildAlarmListSection() {}

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCurrencyTracker(),
            Container(
              margin: EdgeInsets.only(top: 35),
              child: Text('Active alarms'.toUpperCase(),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Text('Alarms not found', style: TextStyle(fontSize: 20)),
          ],
        ));
  }
}
