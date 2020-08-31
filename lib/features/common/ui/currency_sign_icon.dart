import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../types.dart' show CurrencyType;

// todo: typed map
String resolveAssetPath(CurrencyType name) {
  switch (name) {
    case CurrencyType.USD:
      return 'lib/assets/img/dollar-sign.svg';

    case CurrencyType.RUB:
      return 'lib/assets/img/ruble-sign.svg';

    case CurrencyType.EUR:
      return 'lib/assets/img/euro-sign.svg';

    default:
      throw new FormatException('Expected CurrencyType v');
  }
}

class CurrencySignIcon extends StatelessWidget {
  final CurrencyType name;
  final Alignment alignment;
  final double size;

  const CurrencySignIcon(
      {@required this.name,
      @required this.size,
      this.alignment = Alignment.center});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      resolveAssetPath(name),
      alignment: alignment,
      height: size,
      width: size,
    );
  }
}
