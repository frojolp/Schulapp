import 'package:flutter/material.dart';

class UnknownScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('wurde nicht gefunden )='),
      ),
      body: Center(
        child: Text(
            'Da diese Seite nichtmehr auffindbar ist solltest du sie verlassen'),
      ),
    );
  }
}
