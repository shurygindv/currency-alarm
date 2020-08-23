import 'package:flutter/material.dart';

import 'package:currency_alarm/services/storage.dart';
import 'package:currency_alarm/services/api.dart';
import 'package:currency_alarm/libs/debouncer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:currency_alarm/application.dart';

class DashboardView extends StatefulWidget {
  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  bool _isRateExchangeFetching = false;

  void _fetchInitialRates() {
    // Ы
    Future.microtask(() async {
      setState(() {
        _isRateExchangeFetching = true;
      });

      await GlobalStore.getProvider(context).fetchRates();

      setState(() {
        _isRateExchangeFetching = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _fetchInitialRates();
  }

  Future<void> _showAddingAlarmDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              content: SingleChildScrollView(
                  child: Container(
                      child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove, size: 30),
                    onPressed: () {},
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Text('76.6', style: TextStyle(fontSize: 25)),
                  ),
                  IconButton(
                    icon: Icon(Icons.add, size: 30),
                    onPressed: () {},
                  )
                ],
              ))
                  //=
                  ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Notify me'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

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
      margin: EdgeInsets.only(top: 30, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
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
          ),
          Column(
            children: [
              Container(
                child: Text(
                  'last updated on 20 August 20:22',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              )
            ],
          )
        ],
      ));

  Widget _buildLoader() => Container(
        margin: EdgeInsets.only(top: 33, bottom: 30),
        child: SpinKitRipple(
          color: Colors.black38,
          size: 60.0,
        ),
      );

  _buildCurrencyTracker() => Column(
        children: [
          _isRateExchangeFetching
              ? _buildLoader()
              : _buildCurrentCurrencyRate(),
          _buildCurrencyIndicator(),
        ],
      );

  Widget _buildAlarmListSection() => Column(children: [
        Container(
            margin: EdgeInsets.only(top: 40, bottom: 25),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 5),
                  child: Icon(Icons.access_time, size: 27),
                ),
                Text('Active alarms'.toUpperCase(),
                    style:
                        TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
              ],
            )),
        Center(
          child: RaisedButton(
            color: Colors.amber[400],
            textColor: Colors.black54,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    height: 65,
                    margin: EdgeInsets.only(right: 10),
                    child: Icon(Icons.add, size: 26)),
                Text("Add currency alarm", style: TextStyle(fontSize: 16))
              ],
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onPressed: () {
              _showAddingAlarmDialog();
            },
          ),
        )
      ]);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildCurrencyTracker(), _buildAlarmListSection()],
        ));
  }
}
