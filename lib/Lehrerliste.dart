import 'package:flutter/material.dart';
import 'package:flutter_notenapp/models/Lehrer_model.dart';
import 'package:flutter_notenapp/screens/Lehrer_detail_screen.dart';
import 'package:flutter_notenapp/screens/Lehrer_screen.dart';
import 'package:flutter_notenapp/screens/unknown_screen.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  Lehrer _selectedLehrer;
  final bool showUnknown = false;
  List<Lehrer> lehrer = Lehrkraefte;

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedLehrer;
    });
  }

  bool onPopPage(Route<dynamic> route, dynamic result) {
    if (!route.didPop(result)) {
      return false;
    }
    //update state when pop page
    this.setState(() {
      _selectedLehrer = null;
    });
    return true;
  }

  void onTapLehrer(Lehrer lehrer) {
    this.setState(() {
      _selectedLehrer = lehrer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Lehrerliste',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Navigator(
          onPopPage: this.onPopPage,
          pages: [
            MaterialPage(
              key: ValueKey('home'),
              child: LehrerScreen(
                lehrkraefte: this.lehrer,
                onTap: this.onTapLehrer,
              ),
            ),
            if (this.showUnknown)
              MaterialPage(
                key: ValueKey('Unknown'),
                child: UnknownScreen(),
              )
            else if (this._selectedLehrer != null)
              MaterialPage(
                  key: ValueKey('SelectedLehrer'),
                  child: LehrerDetailsscreen(lehrer: this._selectedLehrer))
          ],
        ));
  }
}
