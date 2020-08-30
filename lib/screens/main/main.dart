import 'package:flutter/material.dart';

import 'package:currency_alarm/ui/exporter.dart' show Caption;

import 'package:currency_alarm/features/exporter.dart'
    show DashboardView, CurrencyConverter;

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedPanelIndex = 0;

  final List<Widget> _widgetViews = <Widget>[
    DashboardView(),
    CurrencyConverter(),
  ];

  final appBar = AppBar(
      toolbarHeight: 80,
      title: const Caption(name: 'Currency Alarm'),
      elevation: 0.0,
      backgroundColor: Colors.transparent);

  final dashboardNavItem = BottomNavigationBarItem(
      icon: Icon(Icons.dashboard), title: Text('Dashboard'));

  final converterNavItem = BottomNavigationBarItem(
      icon: Icon(Icons.assessment), title: Text('Converter'));

  void _onItemTapped(int index) {
    setState(() => {_selectedPanelIndex = index});
  }

  Widget _buildHeader() => appBar;

  Widget _buildBody() {
    final currentView = _widgetViews.elementAt(_selectedPanelIndex);

    return Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            child: Container(
              child: Center(child: currentView),
              color: Colors.white,
            )));
  }

  _buildBottomNavbar() => BottomNavigationBar(
        items: [dashboardNavItem, converterNavItem],
        selectedItemColor: Color(0xffdc9a2a),
        currentIndex: _selectedPanelIndex,
        onTap: _onItemTapped,
      );

  _buildFooter() => ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      child: _buildBottomNavbar());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffdc9a2a),
      extendBody: true,
      appBar: _buildHeader(),
      body: _buildBody(),
      bottomNavigationBar: _buildFooter(),
    );
  }
}
