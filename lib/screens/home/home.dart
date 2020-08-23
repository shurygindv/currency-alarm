import 'package:flutter/material.dart';

import './widgets/currency-converter.dart';
import './widgets/dashboard.dart';

class HomePageWidget extends StatefulWidget {
  HomePageWidget({Key key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    DashboardView(),
    CurrencyConverter(),
  ];

  _onItemTapped(int index) {
    setState(() => {_selectedIndex = index});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffdc9a2a),
        extendBody: true,
        appBar: AppBar(
            toolbarHeight: 80,
            title: Center(
                child: Text(
              'Currency Alarm',
              style: TextStyle(color: Colors.white, fontSize: 30),
            )),
            elevation: 0.0,
            backgroundColor: Colors.transparent),
        body: Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                child: Container(
                  child:
                      Center(child: _widgetOptions.elementAt(_selectedIndex)),
                  color: Colors.white,
                ))),
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard), title: Text("Dashboard")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.assessment), title: Text("Converter")),
            ],
            selectedItemColor: Color(0xffdc9a2a),
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ));
  }
}
