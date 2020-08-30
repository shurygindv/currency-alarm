import 'package:flutter/material.dart';

class Caption extends StatelessWidget {
  final String name;

  const Caption({this.name});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        name,
        style: TextStyle(color: Colors.white, fontSize: 30),
      ),
    );
  }
}
