import "package:flare_flutter/flare_actor.dart";
import "package:flare_flutter/flare_cache_builder.dart";
import "package:flutter/material.dart";

import 'package:flutter/services.dart';
import 'package:flare_flutter/provider/asset_flare.dart';

class FlusherAnimatedIcon extends StatelessWidget {
  final asset =
      AssetFlare(bundle: rootBundle, name: "assets/scenes/flasher.flr");

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      child: FlareCacheBuilder(
        [asset],
        builder: (BuildContext context, bool isWarm) {
          return !isWarm
              ? Container(child: Text("wait..."))
              : FlareActor.asset(
                  asset,
                  alignment: Alignment.center,
                  fit: BoxFit.cover,
                  animation: "idle",
                  antialias: true,
                );
        },
      ),
    );
  }
}
