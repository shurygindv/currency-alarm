import 'package:flutter/material.dart';

import './widgets/currency_broadcast.dart';
import './widgets/active_currency_alarms.dart';

class DashboardView extends StatefulWidget {
  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [CurrencyBroadcast(), ActiveCurrencyAlarms()],
        ));
  }
}
