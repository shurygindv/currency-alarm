import "package:flare_flutter/flare_actor.dart";
import "package:flare_flutter/flare_cache_builder.dart";
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flare_flutter/provider/asset_flare.dart';

class FlusherAnimatedIcon extends StatefulWidget {
  FlusherAnimatedIcon({Key key}) : super(key: key);

  @override
  _FlusherAnimatedIconState createState() => _FlusherAnimatedIconState();
}

class _FlusherAnimatedIconState extends State<FlusherAnimatedIcon> {
  bool _useAA = true;
  String _animationName = "idle";

  final asset =
      AssetFlare(bundle: rootBundle, name: "assets/scenes/flasher.flr");

  void _toggleAntialiasing() {
    setState(() {
      _useAA = !_useAA;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      child: FlareCacheBuilder(
        [asset],
        builder: (BuildContext context, bool isWarm) {
          return !isWarm
              ? Container(child: Text("loading..."))
              : FlareActor.asset(
                  asset,
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                  animation: _animationName,
                  antialias: false,
                );
        },
      ),
    );
  }
}
