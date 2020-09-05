import 'package:flutter/material.dart';

import 'package:currency_alarm/ui/exporter.dart' show Caption;

import 'package:currency_alarm/core/exporter.dart' show AppColors;

import 'package:currency_alarm/features/exporter.dart'
    show DashboardView, CurrencyConverter;

import 'package:currency_alarm/features/exporter.dart' show AppInfoDialog;

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

  final dashboardNavItem = BottomNavigationBarItem(
      icon: Icon(Icons.dashboard), title: Text('Dashboard'));

  final converterNavItem = BottomNavigationBarItem(
      icon: Icon(Icons.assessment), title: Text('Converter'));

  void _onItemTapped(int index) {
    setState(() => {_selectedPanelIndex = index});
  }

  Future<void> _showAppInfoDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => AppInfoDialog());
  }

  Widget _buildHeader() => AppBar(
      toolbarHeight: 80,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Caption(name: 'Currency Alarm'),
          IconButton(
            icon: Icon(Icons.info),
            enableFeedback: true,
            color: Colors.white,
            iconSize: 28,
            onPressed: () {
              _showAppInfoDialog();
            },
          )
        ],
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent);

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
        selectedItemColor: AppColors.Primary,
        currentIndex: _selectedPanelIndex,
        onTap: _onItemTapped,
      );

  _buildFooter() => ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      child: _buildBottomNavbar());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.Primary,
      extendBody: true,
      appBar: _buildHeader(),
      body: _buildBody(),
      bottomNavigationBar: _buildFooter(),
    );
  }
}
