import 'package:flutter/material.dart'
    show
        Key,
        Row,
        Icon,
        State,
        Icons,
        Widget,
        Colors,
        Center,
        AppBar,
        Radius,
        Container,
        Scaffold,
        ClipRRect,
        EdgeInsets,
        showDialog,
        IconButton,
        BuildContext,
        BorderRadius,
        StatefulWidget,
        MainAxisAlignment,
        BottomNavigationBar,
        BottomNavigationBarItem;

import 'package:currency_alarm/core/exporter.dart' show AppColors;
import 'package:currency_alarm/ui/exporter.dart' show Caption;
import 'package:currency_alarm/libs/l10n/exporter.dart' show IntlText;
import 'package:currency_alarm/features/exporter.dart' show AppInfoDialog;
import 'package:currency_alarm/features/exporter.dart'
    show DashboardView, CurrencyConverterView;

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _activePanelIndex = 0;

  final List<Widget> _widgetViews = <Widget>[
    DashboardView(),
    CurrencyConverterView(),
  ];

  final dashboardNavItem = const BottomNavigationBarItem(
      icon: Icon(Icons.dashboard), title: IntlText('dashboard.name'));

  final converterNavItem = const BottomNavigationBarItem(
      icon: Icon(Icons.assessment), title: IntlText('converter.name'));

  void _onItemTapped(int index) {
    setState(() => {_activePanelIndex = index});
  }

  Future<void> _showAppInfoDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => AppInfoDialog());
  }

  Widget _getActiveView() => _widgetViews.elementAt(_activePanelIndex);

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
              onPressed: () => _showAppInfoDialog())
        ],
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent);

  Widget _buildBody() => Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          child: Container(
            child: Center(child: _getActiveView()),
            color: Colors.white,
          )));

  _buildBottomNavbar() => BottomNavigationBar(
        items: [dashboardNavItem, converterNavItem],
        selectedItemColor: AppColors.Primary,
        currentIndex: _activePanelIndex,
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
