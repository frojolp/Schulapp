import 'package:flutter/material.dart';
import 'GradesMain.dart';
// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:carousel_pro/carousel_pro.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

Color esssblau = Color(0xff3d6795);
Color esssrot = Color(0xffe23c4e);
const _url = 'https://www.esss.de/news';
void main() => runApp(MyApp());

void _launchURL() async =>
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

//pagetracker
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {
  @override
  build(BuildContext context) {
    return MaterialApp(navigatorObservers: [routeObserver], home: TodoApp());
  }
}

class TodoApp extends StatelessWidget {
  get floatingActionButton => null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text('E-Scho-Schu', style: GoogleFonts.baiJamjuree()),
        backgroundColor: esssblau,
      ),
      body: Column(children: [
        SizedBox(
            height: MediaQuery.of(context).size.height / 2.8,
            width: double.infinity,
            child: InkWell(
                onTap: _launchURL,
                child: Carousel(
                  images: [
                    NetworkImage(
                        'https://media-exp1.licdn.com/dms/image/C4E0BAQH9KpGCRB6R-g/company-logo_200_200/0/1572040662142?e=2159024400&v=beta&t=hCsamHbOlCDhF9diX4jGcJD0OwZIhZfmEq4ABsb7C04'),
                    NetworkImage(
                        'https://www.esss.de/wp-content/uploads/2019/01/Slider_Schulgeb%C3%A4ude.jpg'),
                    NetworkImage(
                        'https://www.esss.de/wp-content/uploads/2019/01/helloquence-61189-unsplash-1.jpg'),
                    NetworkImage(
                        'https://www.esss.de/wp-content/uploads/2019/01/F%C3%BCr-Sch%C3%BCler-e1546686434572.jpg'),
                    NetworkImage(
                        'https://www.esss.de/wp-content/uploads/2019/03/mechasys.jpg'),
                    //ExactAssetImage("assets/images/LaunchImage.jpg")
                  ],
                  showIndicator: true,
                  autoplay: true,
                  dotColor: Colors.grey[350],
                  dotIncreaseSize: 1.5,
                  dotSize: 7.5,
                ))),
        Expanded(
            child: ListView(
          children: <Widget>[
            SizedBox(height: 40),
            SizedBox(
                width: 250,
                height: 65,
                child: Center(
                    child: CupertinoButton(
                  minSize: 250,
                  onPressed: () => navigateToGradesApp(context),
                  color: esssblau,
                  child: Text("Noten",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(color: Colors.white),
                      )),
                ))),
            SizedBox(height: 7),
            SizedBox(
                width: 250,
                height: 65,
                child: Center(
                    child: CupertinoButton(
                  minSize: 250,
                  onPressed: () => navigateToGradesApp(context),
                  color: esssblau,
                  child: Text("Lehrerliste",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(color: Colors.white),
                      )),
                ))),
            SizedBox(height: 7),
            SizedBox(
                width: 250,
                height: 65,
                child: Center(
                    child: CupertinoButton(
                  minSize: 250,
                  onPressed: () => navigateToGradesApp(context),
                  color: esssblau,
                  child: Text("Linkliste",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(color: Colors.white),
                      )),
                ))),
            SizedBox(height: 7),
            SizedBox(
              width: 250,
              height: 65,
              child: Center(
                  child: CupertinoButton(
                      minSize: 250,
                      onPressed: () => navigateToGradesApp(context),
                      color: esssblau,
                      child: Text(
                        "To-Do Liste",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(color: Colors.white),
                        ),
                      ))),
            )
          ],
        ))
      ]),
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
                onTap: _launchURL,
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
              onTap: () => navigateToGradesApp(context),
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
    ));
  }

  void navigateToLehrerApp(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => new GradeApp()));
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
}
