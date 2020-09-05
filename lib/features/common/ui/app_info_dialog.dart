import 'package:flutter/material.dart';
import 'package:currency_alarm/ui/exporter.dart' show MailtoStaticLink;

class InfoText extends StatelessWidget {
  final String whatIs;
  final String clarify;
  final bool jumpToIdea;

  const InfoText({this.whatIs, this.clarify, this.jumpToIdea = false});

  @override
  Widget build(BuildContext context) {
    if (jumpToIdea) {
      return Text(clarify);
    }

    return Row(
        children: [Text("$whatIs: "), Flexible(child: Text("$clarify"))]);
  }
}

class AppInfoDialog extends StatelessWidget {
  final InfoText appVersion =
      const InfoText(whatIs: 'App version', clarify: "v1.01");

  final Widget appreciation = const InfoText(
      jumpToIdea: true,
      clarify:
          'I appreciate everybody for any ideas (to implement smth) or enhancement existing solutions (this app), please, knock me by email: ');

  final Widget mailToLink = const MailtoStaticLink(
    subject: '[CurrencyAlarm] There is a proposoal',
    body: 'Hi!',
  );

  final Widget thankYouAlot = const Text('Thank you');

  _buildDialogContent() {
    return Column(children: [
      appVersion,
      Container(
          child: appreciation, margin: EdgeInsets.only(top: 15, bottom: 10)),
      mailToLink,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('About'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: SingleChildScrollView(
          child: Container(
        child: _buildDialogContent(),
      )),
      actions: <Widget>[
        FlatButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ],
    );
  }
}
