import 'package:flutter/material.dart';
import 'package:flutter_notenapp/Subject.dart';
import 'Grade.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'GradesMain.dart';
import 'NoteType.dart';
import 'GradeType.dart';

/*
 * Hauptklasse eines Faches, zuständig für die Anzeige aller Noten
 */


class GradeOverview extends StatefulWidget {
  static Subject subject;
  static StateSetter subjectStateSetter;
  static StateSetter gradeStateSetter;

  GradeOverview(StateSetter curSubjectStateSetter, Subject curSubject) {
    subject = curSubject;
    subjectStateSetter = curSubjectStateSetter;
  }

  @override
  _GradeOverviewState createState() => new _GradeOverviewState(subjectStateSetter, subject);
}

class _GradeOverviewState extends State<GradeOverview> {

  Subject subject;
  StateSetter stateSetter;

  _GradeOverviewState(StateSetter stateSetter, Subject subject) {
    this.subject = subject;
    this.stateSetter = stateSetter;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GradeOverview.gradeStateSetter = setState;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Main.gradeColorMarking ? subject.calcColor() : Colors.blue,
        title: Text("Fach: " + subject.subjectName),
      ),
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: TabBar(
            labelColor: Colors.black,
              tabs: [
                Tab(text: "Schriftlich"),
                Tab(text: "Mündlich"),
                Tab(text: "Sonstiges"),
              ],
            indicatorColor: Colors.black,
            unselectedLabelColor: Colors.deepOrange,
          ),
          body: TabBarView(
            children: [
              new Column(
                children: [
                  new Card(
                    child: ListTile(
                      title: Text(
                        "Schriftliche Note hinzufügen",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      leading: new Icon(Icons.add),
                      tileColor: Colors.lightGreen,
                      onTap: () => _addGradeDialog(GradeType.WRITING, true),
                    ),
                  ),
                  subject.hasWritingGrades() ?
                  Text("Aktueller schriftlicher Stand: " + subject.getWritingGradeString() + " NP") : SizedBox(),
                  Expanded(
                    child: new GradesListWidget(subject.writingGrades, GradeType.WRITING),
                  )
                ],
              ),
              new Column(
                children: [
                  new Card(
                    child: ListTile(
                      title: Text(
                        "Mündliche Note hinzufügen",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      leading: new Icon(Icons.add),
                      tileColor: Colors.lightGreen,
                      onTap: () => _addGradeDialog(GradeType.SPEAKING, true),
                    ),
                  ),
                  subject.hasSpeakingGrades() ?
                  Text("Aktueller mündlicher Stand: " + subject.getSpeakingGradeString() + " NP") : SizedBox(),
                  Expanded(
                    child: new GradesListWidget(subject.speakingGrades, GradeType.SPEAKING),
                  )
                ],
              ),
              new Column(
                children: [
                  new Card(
                    child: ListTile(
                      title: Text(
                        "Sonstige Note hinzufügen",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      leading: new Icon(Icons.add),
                      tileColor: Colors.lightGreen,
                      onTap: () => _addGradeDialog(GradeType.OTHERS, true),
                    ),
                  ),
                  Expanded(
                    child: new GradesListWidget(subject.furtherGrades, GradeType.OTHERS),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  DateTime dateTime;
  TextEditingController gradeController = new TextEditingController();
  TextEditingController pointsController = new TextEditingController();
  TextEditingController maxPointsController = new TextEditingController();
  TextEditingController dateController = new TextEditingController();
  TextEditingController weightingController = new TextEditingController();
  TextEditingController usernoteController = new TextEditingController();
  StateSetter _setState;

  GradeType influence;

  void _addGradeDialog(GradeType gradeType, bool clear) { //AlertDialog zum Erstellen einer Noten

    if(clear) {
      dateTime = null;
      gradeController.text = "";
      pointsController.text = "";
      maxPointsController.text = "";
      dateController.text = "";
      weightingController.text = "";
      usernoteController.text = "";
      influence = null;
    }

    if(dateTime == null) {
      dateTime = DateTime.now();
      dateController.text = (dateTime.day.toString().length == 1 ? "0" + dateTime.day.toString() : dateTime.day.toString()) + "." + (dateTime.month.toString().length == 1 ? "0" + dateTime.month.toString() : dateTime.month.toString()) + "." + dateTime.year.toString();
    }

    showDialog(context: context,
        builder: (BuildContext context) {
          _setState = setState;
          return new AlertDialog(
              title: new Row(
                children: [
                  Icon(Icons.add, color: Colors.green),
                  Text(gradeType == GradeType.WRITING ? "Schriftliche Note" : gradeType == GradeType.SPEAKING ? "Mündliche Note" : "Sonstige Note", style: TextStyle(color: Colors.green)),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Note',
                    ),
                      controller: gradeController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                  ),
                  SizedBox(height: 15),
                  gradeType == GradeType.WRITING ?
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Punkte',
                          ),
                          controller: pointsController,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                      Text("/"),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Maximum',
                          ),
                          controller: maxPointsController,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                    ],
                  ) : SizedBox(),
                  SizedBox(height: gradeType == GradeType.WRITING ? 15 : 0),
                  gradeType != GradeType.SPEAKING ?
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Gewichtung',
                      helperText: "Beispiel:\nZählt diese Note doppelt? => 200%\nZählt diese Note die Hälfte? => 50%",
                      hintText: '100',
                      suffix: Text(" %"),
                    ),
                    controller: weightingController,
                  ) : SizedBox(),
                  SizedBox(height: gradeType != GradeType.SPEAKING ? 15 : 0),
                  gradeType == GradeType.OTHERS ?
                  Column(
                    children: [
                      Text("Einfluss auf:"),
                      new Center(
                        child: new ButtonBar(
                          mainAxisSize: MainAxisSize.min, // this will take space as minimum as posible(to center)
                          children: <Widget>[
                            new RaisedButton(
                              child: new Text('Schriftlich'),
                              onPressed: () => setInflunce(GradeType.WRITING, context),
                              color: influence == GradeType.WRITING ? Colors.green : Colors.blueGrey,
                            ),
                            new RaisedButton(
                              child: new Text('Mündlich'),
                              onPressed: () => setInflunce(GradeType.SPEAKING, context),
                              color: influence == GradeType.SPEAKING ? Colors.green : Colors.blueGrey,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ) : SizedBox(),
                  TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Datum',
                      ),
                      controller: dateController,
                      readOnly: true,
                      onTap: () => _selectDate(context, dateController),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    maxLines: 2,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Notiz',
                    ),
                    controller: usernoteController,
                  ),
                ],
              ),
              actions:[
                new FlatButton(
                    onPressed:() {
                      //_eintragEntfernen(index);
                      Navigator.of(context).pop();
                    },
                    child: Text("Abbrechen")),

                new FlatButton(
                    onPressed:() {
                      _insertNewGrade(context, gradeType, influence);
                    },
                    child:Text("Erstellen"))
              ]
          );
        });
  }

  void setInflunce(GradeType influence, BuildContext context) {
    this.influence = influence;
    Navigator.pop(context);
    _addGradeDialog(GradeType.OTHERS, false);
  }

  void _insertNewGrade(BuildContext context, GradeType gradeType, GradeType influence) { //Neue Note erstellen
    if(gradeController.text.isEmpty) {
      return;
    }

    if(dateTime == null) {
      return;
    }

    int weighting = 100;
    if(weightingController.text.isNotEmpty)
      weighting = int.parse(weightingController.text);

    var userGrade;
    if(gradeController.text.contains(",") || gradeController.text.contains("."))
      userGrade = double.parse(gradeController.text.replaceAll(",", "."));
    else
      userGrade = int.parse(gradeController.text);

    var points;
    if(pointsController.text.isNotEmpty) {
      if(pointsController.text.contains(",") || pointsController.text.contains("."))
        points = double.parse(pointsController.text.replaceAll(",", "."));
      else
        points = int.parse(pointsController.text);
    } else
      points = 0;

    var maxPoints;
    if(maxPointsController.text.isNotEmpty) {
      if(maxPointsController.text.contains(",") || maxPointsController.text.contains("."))
        maxPoints = double.parse(maxPointsController.text.replaceAll(",", "."));
      else
        maxPoints = int.parse(maxPointsController.text);
    } else
      maxPoints = 0;


    Grade grade = new Grade(userGrade, points, maxPoints, weighting, usernoteController.text, dateTime, influence); //Grade instanziieren

    switch(gradeType) { //Zur jeweiligen Liste des Subjects hinzufügen
      case GradeType.WRITING:
        subject.writingGrades.add(grade);
        break;
      case GradeType.SPEAKING:
        subject.speakingGrades.add(grade);
        break;
      case GradeType.OTHERS:
        subject.furtherGrades.add(grade);
        break;
    }
    setState(() {}); //Notenanzeige aktualisieren um erstellten Eintrag hinzuzufügen
    stateSetter((){}); //Fächerübersicht aktualisieren, um den Schnitt anzupassen

    Navigator.of(context).pop();

    gradeController.text = "";
    pointsController.text = "";
    maxPointsController.text = "";
    dateController.text = "";
    usernoteController.text = "";

    Main.resaveAllSubjects(); //Alle Fächer neu speichern um die erstellte Note fest auf dem Gerät zu speichern
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    //AlertDialog zum Datum auswählen
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2019, 8),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        dateTime = picked;
        controller.text = (selectedDate.day.toString().length == 1 ? "0" + selectedDate.day.toString() : selectedDate.day.toString()) + "." + (selectedDate.month.toString().length == 1 ? "0" + selectedDate.month.toString() : selectedDate.month.toString()) + "." + selectedDate.year.toString();
      });
  }
}

class GradesListWidget extends StatefulWidget {
  List<Grade> list = [];
  GradeType gradeType;

  GradesListWidget(List<Grade> list, GradeType gradeType) {
    this.list = list;
    this.gradeType = gradeType;
  }

  @override
  _GradesListWidgetState createState() => _GradesListWidgetState(list, gradeType);
}

class _GradesListWidgetState extends State<GradesListWidget> {
  List<Grade> list = [];
  GradeType gradeType;

  _GradesListWidgetState(List<Grade> list, GradeType gradeType) {
    this.list = list;
    this.gradeType = gradeType;
  }

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return new Card(

            color: Main.gradeColorMarking ? //Farbliche Markierung aktiviert
              Main.noteType == NoteType.NOTEPOINTS ? //Notentyp
                  list[index].grade <= 5 ? //unter 5 Punkte -> Rot
                      Colors.red : list[index].grade <= 10 ? //unter 10 Punkte -> Gelb
                      Colors.orange :
                      Colors.green //über 10 Punkte -> Grün
                  : list[index].grade <= 2 ? //Note 2 oder besser -> Grün
                      Colors.green : list[index].grade <= 4 ? //Note 4 oder besser -> Gelb
                      Colors.orange :
                      Colors.red : //schlechter als 4
            Colors.white, //Farmliche Markierung nicht aktiviert

            child: ListTile(
                isThreeLine: true,
                trailing: PopupMenuButton<String>(
                  onSelected: (value) => handleClick(value, gradeType, index),
                  itemBuilder: (BuildContext context) {
                    return {'Bearbeiten','Entfernen'}.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                ),
                title: Text(
                  list[index].formatDate(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: new Column(
                  children: [
                    gradeType == GradeType.WRITING ?
                    new Row(
                      children: [
                        Main.noteType == NoteType.NOTEPOINTS ?
                        Text("Note: " + list[index].formatGrade() + " NP") :
                        Text("Note: " + list[index].formatGrade()),
                        SizedBox(width: 15),
                        Text("Punkte: " + list[index].points.toString() + "/" +
                            list[index].maxPoints.toString()),
                        SizedBox(width: 15),
                        Text("(" + list[index].weighting.toString() + "%)"),
                      ],
                    ) : gradeType == GradeType.SPEAKING ?
                    Row(
                      children: [
                        Main.noteType == NoteType.NOTEPOINTS ?
                        Text("Note: " + list[index].formatGrade() + " NP") :
                        Text("Note: " + list[index].formatGrade()),
                      ],
                    ) :
                    Row(
                      children: [
                        Main.noteType == NoteType.NOTEPOINTS ?
                        Text("Note: " + list[index].formatGrade() + " NP") :
                        Text("Note: " + list[index].formatGrade()),
                        SizedBox(width: 15),
                        Text("(" + list[index].weighting.toString() + "%)"),
                        SizedBox(width: 15),
                        Text(list[index].influence == GradeType.WRITING
                            ? "=> Schriftlich"
                            : list[index].influence == GradeType.SPEAKING
                            ? "=> Mündlich"
                            : "Fehler beim Laden"),
                      ],
                    ),
                    SizedBox(height: 15),
                    new Text(list[index].usernote),
                  ],
                )
            ),
          );
        });
  }


  void handleClick(String value, GradeType type, int position) {
    switch(value) {
      case "Entfernen":
        _createDeleteGradeDialog(type, position);
        break;
      case "Bearbeiten":
        _createEditGradeDialog(type, position, true);
        break;
    }
  }

  void _createDeleteGradeDialog(GradeType type, int position) {
    showDialog(context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
              title: new Row(
                children: [
                  Icon(Icons.warning, color: Colors.red,),
                  SizedBox(width: 15),
                  new Text("Note wirklich löschen?", style: new TextStyle(color: Colors.red),),
                ],
              ),
              content: Text(type == GradeType.WRITING ? "Bist du sicher, dass du diese schriftliche Note löschen möchtest?" : type == GradeType.SPEAKING ?
              "Bist du sicher, dass du diese mündliche Note löschen möchtest?":
              "Bist du sicher, dass du diese sonstige Note löschen möchtest?"),
              actions:[
                new FlatButton(
                    onPressed:() {
                      //_eintragEntfernen(index);
                      Navigator.of(context).pop();
                    },
                    child: Text("Abbrechen")),
                new FlatButton(
                    onPressed:() {
                      deleteGrade(type, position);
                      Navigator.of(context).pop();
                    },
                    child:Text("Bestätigen")),
              ]
          );
        });
  }

  DateTime dateTime;
  TextEditingController gradeController = new TextEditingController();
  TextEditingController pointsController = new TextEditingController();
  TextEditingController maxPointsController = new TextEditingController();
  TextEditingController dateController = new TextEditingController();
  TextEditingController weightingController = new TextEditingController();
  TextEditingController usernoteController = new TextEditingController();
  DateTime selectedDate = DateTime.now();

  GradeType influence;

  Grade gradeToEdit;

  void setInflunce(GradeType influence, int position, BuildContext context) {
    this.influence = influence;
    Navigator.pop(context);
    _createEditGradeDialog(GradeType.OTHERS, position, false);
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    //AlertDialog zum Datum auswählen
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2019, 8),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        dateTime = picked;
        controller.text = (selectedDate.day.toString().length == 1 ? "0" + selectedDate.day.toString() : selectedDate.day.toString()) + "." + (selectedDate.month.toString().length == 1 ? "0" + selectedDate.month.toString() : selectedDate.month.toString()) + "." + selectedDate.year.toString();
      });
  }

  void _createEditGradeDialog(GradeType type, int position, bool refresh) {

    switch(type) {
      case GradeType.WRITING:
        gradeToEdit = GradeOverview.subject.writingGrades[position];
        break;
      case GradeType.SPEAKING:
        gradeToEdit = GradeOverview.subject.speakingGrades[position];
        break;
      case GradeType.OTHERS:
        gradeToEdit = GradeOverview.subject.furtherGrades[position];
        break;

      default:
        return; //Fehler! Wird abgebrochen
    }

    if(refresh) {
      dateTime = gradeToEdit.date;
      selectedDate = gradeToEdit.date;
      gradeController.text = gradeToEdit.grade.toString();
      pointsController.text = gradeToEdit.points.toString();
      maxPointsController.text = gradeToEdit.maxPoints.toString();
      dateController.text = (selectedDate.day.toString().length == 1 ? "0" + selectedDate.day.toString() : selectedDate.day.toString()) + "." + (selectedDate.month.toString().length == 1 ? "0" + selectedDate.month.toString() : selectedDate.month.toString()) + "." + selectedDate.year.toString();
      weightingController.text = gradeToEdit.weighting.toString();
      usernoteController.text = gradeToEdit.usernote;

      influence = gradeToEdit.influence;
    }

    showDialog(context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
              title: new Row(
                children: [
                  Icon(Icons.edit, color: Colors.green,),
                  SizedBox(width: 15),
                  new Text("Note bearbeiten", style: new TextStyle(color: Colors.green),),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Note',
                    ),
                    controller: gradeController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                  ),
                  SizedBox(height: 15),
                  gradeType == GradeType.WRITING ?
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Punkte',
                          ),
                          controller: pointsController,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                      Text("/"),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Maximum',
                          ),
                          controller: maxPointsController,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                    ],
                  ) : SizedBox(),
                  SizedBox(height: gradeType == GradeType.WRITING ? 15 : 0),
                  gradeType != GradeType.SPEAKING ?
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Gewichtung',
                      helperText: "Beispiel:\nZählt diese Note doppelt? => 200%\nZählt diese Note die Hälfte? => 50%",
                      hintText: '100',
                      suffix: Text(" %"),
                    ),
                    controller: weightingController,
                  ) : SizedBox(),
                  SizedBox(height: gradeType != GradeType.SPEAKING ? 15 : 0),
                  gradeType == GradeType.OTHERS ?
                  Column(
                    children: [
                      Text("Einfluss auf:"),
                      new Center(
                        child: new ButtonBar(
                          mainAxisSize: MainAxisSize.min, // this will take space as minimum as posible(to center)
                          children: <Widget>[
                            new RaisedButton(
                              child: new Text('Schriftlich'),
                              onPressed: () => setInflunce(GradeType.WRITING, position, context),
                              color: influence == GradeType.WRITING ? Colors.green : Colors.blueGrey,
                            ),
                            new RaisedButton(
                              child: new Text('Mündlich'),
                              onPressed: () => setInflunce(GradeType.SPEAKING, position, context),
                              color: influence == GradeType.SPEAKING ? Colors.green : Colors.blueGrey,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ) : SizedBox(),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Datum',
                    ),
                    controller: dateController,
                    readOnly: true,
                    onTap: () => _selectDate(context, dateController),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    maxLines: 2,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Notiz',
                    ),
                    controller: usernoteController,
                  ),
                ],
              ),
              actions:[
                new FlatButton(
                    onPressed:() {
                      //_eintragEntfernen(index);
                      Navigator.of(context).pop();
                    },
                    child: Text("Abbrechen")),
                new FlatButton(
                    onPressed:() {
                      editGrade(type, position);
                      Navigator.of(context).pop();
                    },
                    child:Text("Speichern")),
              ]
          );
        });
  }

  void editGrade(GradeType type, int position) {

    if(gradeController.text.isEmpty) {
      return;
    }

    if(dateTime == null) {
      return;
    }

    int weighting = 100;
    if(weightingController.text.isNotEmpty)
      weighting = int.parse(weightingController.text);

    var userGrade;
    if(gradeController.text.contains(",") || gradeController.text.contains("."))
      userGrade = double.parse(gradeController.text.replaceAll(",", "."));
    else
      userGrade = int.parse(gradeController.text);

    var points;
    if(pointsController.text.isNotEmpty) {
      if(pointsController.text.contains(",") || pointsController.text.contains("."))
        points = double.parse(pointsController.text.replaceAll(",", "."));
      else
        points = int.parse(pointsController.text);
    } else
      points = 0;

    var maxPoints;
    if(maxPointsController.text.isNotEmpty) {
      if(maxPointsController.text.contains(",") || maxPointsController.text.contains("."))
        maxPoints = double.parse(maxPointsController.text.replaceAll(",", "."));
      else
        maxPoints = int.parse(maxPointsController.text);
    } else
      maxPoints = 0;

    Grade grade = new Grade(userGrade, points, maxPoints, weighting, usernoteController.text, dateTime, influence); //Grade instanziieren

    switch(gradeType) { //Zur jeweiligen Liste des Subjects hinzufügen
      case GradeType.WRITING:
        GradeOverview.subject.writingGrades[position] = grade;
        break;
      case GradeType.SPEAKING:
        GradeOverview.subject.speakingGrades[position] = grade;
        break;
      case GradeType.OTHERS:
        GradeOverview.subject.furtherGrades[position] = grade;
        break;
    }

    setState(() {}); //Notenanzeige aktualisieren um erstellten Eintrag hinzuzufügen
    GradeOverview.subjectStateSetter((){}); //Fächerübersicht aktualisieren, um den Schnitt anzupassen

    Main.resaveAllSubjects();
    setState(() {});
    GradeOverview.gradeStateSetter((){});
  }

  void deleteGrade(GradeType type, int position) {
    switch(type) {
      case GradeType.WRITING:
        print("Before: " + GradeOverview.subject.writingGrades.length.toString());
        GradeOverview.subject.writingGrades.removeAt(position);
        print("After:" + GradeOverview.subject.writingGrades.length.toString());
        break;
      case GradeType.SPEAKING:
        GradeOverview.subject.speakingGrades.removeAt(position);
        break;
      case GradeType.OTHERS:
        GradeOverview.subject.furtherGrades.removeAt(position);
        break;
    }

    Main.resaveAllSubjects();
    GradeOverview.gradeStateSetter((){});
    setState(() {});
  }
}
