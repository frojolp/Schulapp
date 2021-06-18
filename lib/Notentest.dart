import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color esssblau = Color(0xff3d6795);
Color esssrot = Color(0xffe23c4e);

class Notentest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Testseite', style: GoogleFonts.baiJamjuree()),
        backgroundColor: esssblau,
      ),
      body: Center(
        child: ElevatedButton(
          child: Text(
            'Startseite',
            style: GoogleFonts.roboto(),
          ),
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            primary: esssrot,
          ), // background),
        ),
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
              child: Text(
                '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                ),
              ),
            ),
            Divider(
              thickness: (1.5),
            ),
            ListTile(
              leading: Icon(Icons.calculate_outlined, color: esssrot),
              title: Text(
                'Noten',
                style: GoogleFonts.roboto(),
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: esssrot,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => Notentest(),
                    ));
              },
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
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => Notentest(),
                    ));
              },
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
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => Notentest(),
                    ));
              },
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
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => Notentest(),
                    ));
              },
            ),
            Divider(
              thickness: (1.5),
            ),
          ],
        ),
      ),
    );
  }
}
