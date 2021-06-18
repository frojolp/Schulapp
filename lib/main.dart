import'package:flutter/material.dart';
import 'GradesMain.dart';

/*
 * Main-Klasse der App, diese wird NICHT benötigt, diese Klasse verweist lediglich auf die Main-Klasse des Notenbereiches (GradesMain.dart) für ein einfacheres Zusammenführen
 */

void main()=>runApp(new MyApp());


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title:'ESSS - App',
      home: MainWidget(),
    );
  }
}

class MainWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ESS - App"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Hier ist die Main-Klasse, über die später auf den Notenbereich verwiesen werden kann.\n"
                "Der Name der Main-Klasse für den Notenbereich ist \"GradesMain.dart\" => \"GradeApp()\"\n\n"
                "Achten Sie beim zusammenführen darauf, dass in der \"pubspec.yaml\"-Date folgende Änderungen vorgenommen wurden:\n\n"
                "dependencies:\n"
                "  json_annotation: ^3.0.1\n"
                "  shared_preferences: ^0.5.12+4\n"
                "  http: ^0.12.2\n"
                "  encrypt: ^4.1.0\n\n"
                "dev_dependencies:\n"
                "  json_serializable: ^3.3.0"),
            FlatButton(
              child: Text("Zum Notenbereich"),
              onPressed: () => navigateToGradesApp(context),
            ),
          ],
        )
      ),
    );
  }

  void navigateToGradesApp(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => new GradeApp())
    );
  }
}



