import "package:flutter/material.dart";
import 'package:easy_localization/easy_localization.dart';

String t(String id) => id.tr();

class IntlText extends StatelessWidget {
  final String id;
  final TextStyle style;
  final Map<String, String> namedArgs;

  const IntlText(this.id, {this.namedArgs, this.style});

  @override
  Widget build(BuildContext context) {
    return Text(id, style: style).tr(namedArgs: namedArgs);
  }
}
