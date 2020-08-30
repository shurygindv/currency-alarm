import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

// todo enum loader-types
class Loader extends StatelessWidget {
  final String name;

  const Loader({@required this.name});

  @override
  Widget build(BuildContext context) {
    if (name == 'ripple') {
      return SpinKitRipple(
        color: Colors.black38,
        size: 60.0,
      );
    }

    throw new Error();
  }
}
