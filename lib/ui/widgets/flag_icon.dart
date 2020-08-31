import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

Map<String, String> assetFlags = {
  'us': 'lib/assets/img/us-flag.svg',
  'eur': 'lib/assets/img/eur-union-flag.svg',
  'rus': 'lib/assets/img/ru-flag.svg',
};

class FlagIcon extends StatelessWidget {
  final String name;

  const FlagIcon({@required this.name});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6.0),
      child: SvgPicture.asset(
        assetFlags[name],
        fit: BoxFit.cover,
      ),
    );
  }
}
