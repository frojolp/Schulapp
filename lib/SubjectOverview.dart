import 'package:flutter/material.dart';
import 'Subject.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'GradeOverview.dart';
import 'GradesMain.dart';
import 'ExportOverview.dart';
import 'Grade.dart';
import 'NoteType.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

Color esssblau = Color(0xff3d6795);
Color esssrot = Color(0xffe23c4e);
const _url = 'https://www.esss.de/news';
void _launchURL() async =>
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
/*
 * Hauptklasse aller Fächer, zuständig für die Fächerübersicht
 */

List<Subject> subjectList = [];
bool loaded = false;

class SubjectOverview extends StatefulWidget {
  static StateSetter globlaStateSetter;

  @override
  _SubjectOverviewState createState() => _SubjectOverviewState();
}

class _SubjectOverviewState extends State<SubjectOverview> {
  @override
  void initState() {
    super.initState();

    if (!loaded) {
      Main.loadNoteType()
          .then((value) => Main.noteType = value)
          .then((value) => Main.loadGradeColorMarking())
          .then((value) => loadSubjects())
          .then((value) => alertNoteType());
    }

    loaded = true;
  }

  void alertNoteType() {
    if (Main.noteType == null) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return new AlertDialog(
                title: new Row(
                  children: [
                    Icon(
                      Icons.warning,
                      color: Colors.red,
                    ),
                    SizedBox(width: 15),
                    new Text(
                      "Notensystem einstellen",
                      style: new TextStyle(color: Colors.red),
                    ),
                  ],
                ),
                content: Text("Welches Notensystem möchtest du verwenden?"),
                actions: [
                  new FlatButton(
                      onPressed: () {
                        Main.saveNoteType(NoteType.NOTE);
                        Navigator.of(context).pop();
                      },
                      child: Text("Klassische Noten (1-6)")),
                  new FlatButton(
                      onPressed: () {
                        Main.saveNoteType(NoteType.NOTEPOINTS);
                        Navigator.of(context).pop();
                      },
                      child: Text("Notenpunkte (1-15)")),
                ]);
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    SubjectOverview.globlaStateSetter = setState;

    return Scaffold(
      appBar: AppBar(
        title: Text('Notenübersicht', style: GoogleFonts.baiJamjuree()),
        backgroundColor: esssblau,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuClick(value),
            itemBuilder: (BuildContext context) {
              return {
                'Daten übertragen',
                'Alle Daten löschen',
                Main.gradeColorMarking
                    ? 'Noten nicht farblich markieren'
                    : 'Noten farblich markieren'
              }.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: new SubjectOverviewWidget(setState, context),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _createSubjectDialog,
        tooltip: 'Fach hinzufügen',
        child: Icon(Icons.add),
      ),
    );
  }

  void _handleMenuClick(String value) {
    switch (value) {
      case "Alle Daten löschen":
        _createDeleteAllDialog();
        break;

      case "Daten übertragen":
        onExportClick();
        break;

      case "Noten nicht farblich markieren":
      case "Noten farblich markieren":
        toggleGradeColorMarking();
        break;
    }
  }

  void toggleGradeColorMarking() {
    Main.gradeColorMarking =
        !Main.gradeColorMarking; //boolean zur farblichen Markierung toggeln
    Main.saveGradeColorMarking();
    setState(() {});
  }

  void onExportClick() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => new ExportOverview(setState)));
  }

  void _createDeleteAllDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
              title: new Row(
                children: [
                  Icon(
                    Icons.warning,
                    color: Colors.red,
                  ),
                  SizedBox(width: 15),
                  new Text(
                    "Alle Daten löschen?",
                    style: new TextStyle(color: Colors.red),
                  ),
                ],
              ),
              content: Text(
                  "Bist du sicher, dass du alle Daten löschen möchtest?\nAlle erstellten Fächer und eingetragenen Noten gehen dabei unwiederruflich verloren!"),
              actions: [
                new FlatButton(
                    onPressed: () {
                      //_eintragEntfernen(index);
                      Navigator.of(context).pop();
                    },
                    child: Text("Abbrechen")),
                new FlatButton(
                    onPressed: () {
                      deleteAllGrades();
                      Navigator.of(context).pop();
                    },
                    child: Text("Fächer beibehalten, nur Noten löschen")),
                new FlatButton(
                    onPressed: () {
                      deleteAllData();
                      Navigator.of(context).pop();
                    },
                    child: Text("Alle Fächer und Noten löschen")),
              ]);
        });
  }

  void deleteAllData() {
    //Alle Daten löschen
    Main.deleteAllData();
    subjectList.clear();
    setState(() {});
    Main.saveNoteType(null);

    Main.loadNoteType()
        .then((value) => Main.noteType = value)
        .then((value) => loadSubjects())
        .then((value) => alertNoteType());
  }

  void deleteAllGrades() {
    //Alle Noten aller Fächer löschen, Fächer beibehalten
    for (Subject subject in subjectList) subject.deleteAllGrades();
    Main.resaveAllSubjects();
    Main.saveNoteType(null);

    setState(() {});
    Main.loadNoteType()
        .then((value) => Main.noteType = value)
        .then((value) => loadSubjects())
        .then((value) => alertNoteType());
  }

  TextEditingController subjectNameController = new TextEditingController();
  TextEditingController subjectWeightingWritingController =
      new TextEditingController();
  TextEditingController subjectWeightingSpeakingController =
      new TextEditingController();

  void _createSubjectDialog() {
    //Vorbereitung für die Anzeige zum Erstellen eines Faches
    subjectNameController.text = "";
    subjectWeightingWritingController.text = "";
    subjectWeightingSpeakingController.text = "";

    Main.loadNoteType()
        .then((value) => Main.noteType = value)
        .then((value) => loadSubjects())
        .then((value) => alertNoteType())
        .then((value) => _showCreateSubjectDialog());
  }

  void _showCreateSubjectDialog() {
    //AlertDialog zum Erstellen eines Faches anzeigen
    if (Main.noteType != null) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return new AlertDialog(
                title: new Row(
                  children: [
                    Icon(Icons.add, color: Colors.green),
                    Text("Fach hinzufügen",
                        style: TextStyle(color: Colors.green)),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Name des Faches',
                      ),
                      controller: subjectNameController,
                    ),
                    SizedBox(height: 15),
                    new Text("Gewichtung:"),
                    SizedBox(height: 5),
                    new Row(
                      children: [
                        new Flexible(
                          child: new TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'schriftlich',
                              hintText: '1',
                            ),
                            keyboardType: TextInputType.number,
                            controller: subjectWeightingWritingController,
                          ),
                        ),
                        SizedBox(width: 5),
                        new Text(":"),
                        SizedBox(width: 5),
                        new Flexible(
                          child: new TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'mündlich',
                              hintText: '1',
                            ),
                            keyboardType: TextInputType.number,
                            controller: subjectWeightingSpeakingController,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text("Beispiel: 1:1, 1:2, usw."),
                  ],
                ),
                actions: [
                  new FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Abbrechen")),
                  new FlatButton(
                      onPressed: () {
                        createNewSubject();
                        Navigator.of(context).pop();
                      },
                      child: Text("Erstellen"))
                ]);
          });
    }
  }

  void createNewSubject() {
    //Neues Fach anlegen
    if (subjectNameController.text.isEmpty) return;

    int weightingWriting = 1;
    int weightingSpeaking = 1;

    if (subjectWeightingWritingController.text.isNotEmpty)
      weightingWriting = int.parse(subjectWeightingWritingController.text);

    if (subjectWeightingSpeakingController.text.isNotEmpty)
      weightingSpeaking = int.parse(subjectWeightingSpeakingController.text);

    Subject subject = new Subject(
        subjectNameController.text, weightingWriting, weightingSpeaking);
    subjectList.add(subject); //Fach zur lokalen Liste hinzufügen
    setState(() {}); //Anzeige aktualisieren

    Main.saveSubject(subject); //Fach auf dem Gerät speichern
  }

  void loadSubjects() async {
    //Alle Fächer vom Gerät laden (async)
    subjectList.clear();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("subjects")) {
      List<String> list = prefs.getStringList("subjects");

      for (String jsonData in list) {
        Subject subject = new Subject.fromJson(jsonData);
        subjectList.add(subject);
      }
      setState(() {});
    }
  }
}

class SubjectOverviewWidget extends StatelessWidget {
  StateSetter stateSetter;
  BuildContext context;

  SubjectOverviewWidget(StateSetter stateSetter, BuildContext context) {
    this.stateSetter = stateSetter;
    this.context = context;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(subjectList.length, (index) {
        return Container(
            child: GestureDetector(
          onTap: () => onSubjectClick(context, subjectList[index]),
          onLongPress: () => _createDeleteSubjectDialog(index),
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  subjectList[index].subjectName,
                  style: TextStyle(color: Colors.white, fontSize: 28),
                  textAlign: TextAlign.center,
                ),
                subjectList[index].hasTotalGrade()
                    ? Text(
                        Main.noteType == NoteType.NOTEPOINTS
                            ? subjectList[index].getTotalGradeString() + " NP"
                            : "Note: " +
                                subjectList[index].getTotalGradeString(),
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        textAlign: TextAlign.center,
                      )
                    : SizedBox(),
              ],
            ),
            color: Main.gradeColorMarking
                ? subjectList[index].calcColor()
                : Colors.grey,
          ),
        ));
      }),
    );
  }

  void onSubjectClick(BuildContext context, Subject subject) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => new GradeOverview(stateSetter, subject)));
  }

  void _createDeleteSubjectDialog(int position) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
              title: new Row(
                children: [
                  Icon(
                    Icons.warning,
                    color: Colors.red,
                  ),
                  SizedBox(width: 15),
                  new Text(
                    "Fach wirklich löschen?",
                    style: new TextStyle(color: Colors.red),
                  ),
                ],
              ),
              content: Text("Bist du sicher, dass du \"" +
                  subjectList[position].subjectName +
                  "\" löschen möchtest?\nAlle darin enthaltende Noten gehen unwiederruflich verloren!"),
              actions: [
                new FlatButton(
                    onPressed: () {
                      //_eintragEntfernen(index);
                      Navigator.of(context).pop();
                    },
                    child: Text("Abbrechen")),
                new FlatButton(
                    onPressed: () {
                      deleteSubject(position);
                      Navigator.of(context).pop();
                    },
                    child: Text("Bestätigen")),
              ]);
        });
  }

  void deleteSubject(int position) {
    subjectList.removeAt(position);
    Main.resaveAllSubjects();
    SubjectOverview.globlaStateSetter(() {});
  }
}

void navigateToGradesApp(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => new GradeApp()));
}
