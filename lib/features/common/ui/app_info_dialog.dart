import 'package:flutter/material.dart';
import 'package:currency_alarm/ui/exporter.dart' show MailtoStaticLink;

import 'package:currency_alarm/libs/l10n/exporter.dart' show IntlText;

class AppInfoDialog extends StatelessWidget {
  final IntlText appVersion = const IntlText(
    'about.appVersion',
    namedArgs: {"ver": 'v1.1'},
  );

  final Widget appreciation = const IntlText('about.thankYou');

  final Widget mailToLink = const MailtoStaticLink(
    subject: '[CurrencyAlarm] There is a proposal',
    body: 'Hi!',
  );

  final rateUpdate = const IntlText("about.howOftenRateUpdate");

  final Widget thankYouAlot = const Text('Thank you');

  _buildDialogContent() {
    return Column(children: [
      appVersion,
      rateUpdate,
      Container(
          child: appreciation, margin: EdgeInsets.only(top: 15, bottom: 10)),
      mailToLink,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: IntlText('about.name'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: SingleChildScrollView(
          child: Container(
        child: _buildDialogContent(),
      )),
      actions: <Widget>[
        FlatButton(
            child: IntlText('dialog.close'),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ],
    );
  }
}
