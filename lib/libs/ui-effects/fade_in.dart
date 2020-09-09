import "package:flutter/material.dart";

import '../debouncer.dart' show setTimeout;

class FadeInUi extends StatefulWidget {
  final Widget child;

  FadeInUi({this.child});

  @override
  _FadeInUiState createState() => _FadeInUiState();
}

class _FadeInUiState extends State<FadeInUi> {
  bool _visible = false;

  void _doVisible() {
    setState(() {
      _visible = true;
    });
  }

  @override
  void initState() {
    super.initState();

    const IN_30_MS = 30;

    setTimeout(IN_30_MS, () {
      _doVisible();
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
