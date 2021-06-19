import 'package:flutter/material.dart';
import 'package:flutter_notenapp/models/Lehrer_model.dart';

class LehrerDetailsscreen extends StatelessWidget {
  final Lehrer lehrer;
  LehrerDetailsscreen({this.lehrer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(lehrer.name),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          )),
      body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (lehrer != null) ...[
                Text(lehrer.name, style: Theme.of(context).textTheme.headline1),
                Text(lehrer.email,
                    style: Theme.of(context).textTheme.subtitle1),
                Text(lehrer.sonstiges,
                    style: Theme.of(context).textTheme.subtitle2)
              ]
            ],
          )),
    );
  }
}
