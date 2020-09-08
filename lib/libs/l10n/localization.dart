import "package:flutter/material.dart";
import 'package:easy_localization/easy_localization.dart';

class Localization extends StatelessWidget {
  final Widget widget;

  const Localization(this.widget);

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
        supportedLocales: [Locale('en', 'US'), Locale('ru', 'RU')],
        path: 'assets/t10n',
        fallbackLocale: Locale('en', 'US'),
        child: widget);
  }
}
