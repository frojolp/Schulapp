import 'package:flutter/material.dart';
import 'package:flutter_notenapp/models/Lehrer_model.dart';

class LehrerScreen extends StatelessWidget {
  final List<Lehrer> lehrkraefte;
  final ValueChanged<Lehrer> onTap;
  LehrerScreen({this.lehrkraefte, this.onTap});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          for (var lehrer in this.lehrkraefte)
            ListTile(
              title: Text(lehrer.name),
              subtitle: Text(lehrer.email),
              onTap: () => this.onTap(lehrer),
            ),
        ],
      ),
    );
  }
}
