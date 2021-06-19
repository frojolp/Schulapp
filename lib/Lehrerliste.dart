import 'package:flutter/material.dart';
import 'package:flutter_notenapp/models/Lehrer_model.dart';
import 'package:flutter_notenapp/screens/Lehrer_detail_screen.dart';
import 'package:flutter_notenapp/screens/Lehrer_screen.dart';
import 'package:flutter_notenapp/screens/unknown_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_notenapp/main.dart';
import 'GradesMain.dart';

Color esssblau = Color(0xff3d6795);
Color esssrot = Color(0xffe23c4e);
const _url = 'https://www.esss.de/news';

class App extends StatefulWidget {
  @override
  _Lehrerliste createState() => _Lehrerliste();
}

class _Lehrerliste extends State<App> {
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
      home: Scaffold(
        appBar: AppBar(
          title: Text('Lehrerliste', style: GoogleFonts.baiJamjuree()),
          backgroundColor: esssblau,
        ),
        body: Navigator(
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
        ),

        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                          'https://www.esss.de/wp-content/uploads/2019/01/Slider_Schulgeb%C3%A4ude.jpg')),
                  color: esssrot,
                ),
                child: InkWell(
                    //onTap: _launchURL,
                    ),
              ),
              Divider(
                thickness: (1.5),
              ),
              ListTile(
                leading: Icon(
                  Icons.calculate_outlined,
                  color: esssrot,
                ),
                title: Text(
                  'Noten',
                  style: GoogleFonts.roboto(),
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: esssrot,
                ),
                onTap: () => navigateToGradesApp(context),
              ),
              Divider(
                thickness: (1.5),
              ),
              ListTile(
                leading: Icon(
                  Icons.account_circle,
                  color: esssrot,
                ),
                title: Text(
                  'Lehrerliste',
                  style: GoogleFonts.roboto(),
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: esssrot,
                ),
                onTap: () => navigateToLehrerApp(context),
              ),
              Divider(
                thickness: (1.5),
              ),
              ListTile(
                leading: Icon(
                  Icons.alternate_email,
                  color: esssrot,
                ),
                title: Text(
                  'Linkliste',
                  style: GoogleFonts.roboto(),
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: esssrot,
                ),
                onTap: () => navigateToGradesApp(context),
              ),
              Divider(
                thickness: (1.5),
              ),
              ListTile(
                leading: Icon(
                  Icons.assignment_outlined,
                  color: esssrot,
                ),
                title: Text(
                  'To-Do Liste',
                  style: GoogleFonts.roboto(),
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: esssrot,
                ),
                onTap: () => navigateToGradesApp(context),
              ),
              Divider(
                thickness: (1.5),
              ),
            ],
          ),
        ),
        //theme: ThemeData(
        //  primarySwatch: Colors.blue,
        //  visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home:
    );
  }
}

void navigateToLehrerApp(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => new App()));
}

void navigateToGradesApp(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => new GradeApp()));
}

void navigateToLinkApp(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => new GradeApp()));
}

void navigateToTodoApp(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => new GradeApp()));
}
