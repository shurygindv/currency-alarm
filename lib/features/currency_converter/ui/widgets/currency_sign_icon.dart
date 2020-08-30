import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/types.dart' show CurrencyType;

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

  const CurrencySignIcon({@required this.name});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      resolveAssetPath(name),
      height: 20.0,
      width: 20.0,
    );
  }
}
