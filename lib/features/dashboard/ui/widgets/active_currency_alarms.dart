import 'package:flutter/material.dart';

/*
  1. Currency value (observing)

  Keep specified value in local store
  Set background task and fetch in specified period
  when time comes -> show push notification
*/

class ActiveCurrencyAlarms extends StatefulWidget {
  @override
  _ActiveCurrencyAlarmsState createState() => _ActiveCurrencyAlarmsState();
}

class _ActiveCurrencyAlarmsState extends State<ActiveCurrencyAlarms> {
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
    return _buildAlarmListSection();
  }
}
