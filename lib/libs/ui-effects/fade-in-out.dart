import "package:flutter/material.dart";

import '../debouncer.dart' show setTimeout;

class FadeInOutUiEffect extends StatefulWidget {
  final Widget child;

  FadeInOutUiEffect({this.child});

  @override
  _FadeInOutUiEffectState createState() => _FadeInOutUiEffectState();
}

class _FadeInOutUiEffectState extends State<FadeInOutUiEffect> {
  bool _visible = false;

  _toggleVisibility() {
    setState(() {
      _visible = !_visible;
    });
  }

  @override
  void initState() {
    super.initState();

    const IN_30_MS = 30;

    setTimeout(IN_30_MS, () {
      _toggleVisibility();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
        opacity: _visible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: widget.child);
  }
}
