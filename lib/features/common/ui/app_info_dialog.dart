import 'package:flutter/material.dart'
    show
        Text,
        Widget,
        Column,
        Center,
        Navigator,
        EdgeInsets,
        FlatButton,
        Container,
        AlertDialog,
        BorderRadius,
        BuildContext,
        StatelessWidget,
        CrossAxisAlignment,
        SingleChildScrollView,
        RoundedRectangleBorder;

import 'package:currency_alarm/ui/exporter.dart' show MailtoStaticLink;
import 'package:currency_alarm/libs/l10n/exporter.dart' show IntlText;

class CloseDialogButton extends StatelessWidget {
  const CloseDialogButton();

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        child: IntlText('dialog.close'),
        onPressed: () {
          Navigator.of(context).pop();
        });
  }
}

class AppInfoDialog extends StatelessWidget {
  final IntlText dialogTitle = const IntlText('about.name');

  final IntlText appVersion = const IntlText(
    'about.appVersion',
    namedArgs: {"ver": 'v1.1'},
  );

  final Widget mailToLink = const MailtoStaticLink(
    subject: '[CurrencyAlarm] There is a proposal',
    body: 'Hi!',
  );

  final Widget appreciation = const IntlText('about.thankYou');

  final Widget rateUpdate = const IntlText("about.howOftenRateUpdate");

  final Widget thankYouAlot = const Text('Thank you');

  Widget _buildDialogContent() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        appVersion,
        rateUpdate,
        Container(
            child: appreciation, margin: EdgeInsets.only(top: 15, bottom: 10)),
        Center(child: mailToLink)
      ]);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: dialogTitle,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: SingleChildScrollView(
        child: _buildDialogContent(),
      ),
      actions: <Widget>[const CloseDialogButton()],
    );
  }
}
