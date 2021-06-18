import'package:flutter/material.dart';
import 'SubjectOverview.dart';
import 'Subject.dart';
import 'dart:convert';
import 'NoteType.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
 * Main-Klasse des Notenbereiches, Auslagerung aus der main.dart für einfaches Zusammenführen
 */



void main()=>runApp(new GradeApp());


class GradeApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) { //Äußerste Schicht der App
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        title:'Notenübersicht',
        color: Colors.deepOrange,
        home: new SubjectOverview() //Fächerübersicht laden
    );
  }
}

class Main {

  static NoteType noteType; // Zwischenspeichern des gewählten Notentyps
  static bool gradeColorMarking = true; // Sollen Noten farblich markiert werden

  static void saveNoteType(NoteType type) async { // Speichern des Notentyps
    noteType = type;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("notetype", type.toString());
  }

  static void saveGradeColorMarking() async { // Speichern der farblichen Markierung
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("gradeColorMarking", gradeColorMarking);
  }

  static Future<NoteType> loadNoteType() async { // Laden des Notentyps
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey("notetype")) {
      switch(prefs.getString("notetype")) {
        case "NoteType.NOTE":
          noteType = NoteType.NOTE;
          break;
        case "NoteType.NOTEPOINTS":
          noteType = NoteType.NOTEPOINTS;
          break;
      }
    }
    return Future.value(noteType);
  }

  static Future<void> loadGradeColorMarking() async { // Laden der farblichen Markierung
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey("gradeColorMarking")) {
      gradeColorMarking = prefs.getBool("gradeColorMarking");
      return Future.value();
    }
    return Future.value();
  }

  static void saveSubject(Subject subject) async { // Einzelnes Fach fest auf dem Handy speichern
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> list = [];
    if(prefs.containsKey("subjects")) {
      list = prefs.getStringList("subjects");
    }
    list.add(subject.toJson());
    await prefs.setStringList("subjects", list);
  }

  static void resaveAllSubjects() async { // Alle Fächer neu Speichern anhand aktueller temporären Liste
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> list = [];

    for(Subject subject in subjectList)
      list.add(subject.toJson());

    await prefs.setStringList("subjects", list);
  }

  static void deleteAllData() async { // Alle Daten löschen
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey("subjects"))
      prefs.remove("subjects");
    if(prefs.containsKey("notetype"))
      prefs.remove("notetype");
  }

  static String saveAllDataToJson() { // Alle Daten zu JSON konvertieren
    List<dynamic> list = [];
    Map<String, dynamic> map = new Map<String, dynamic>();

    for(Subject subject in subjectList) {
      list.add(subject.toMap());
    }

    map.putIfAbsent("subjects", () => list);
    map.putIfAbsent("noteType", () => noteType.toString());
    map.putIfAbsent("gradeColorMarking", () => gradeColorMarking);

    return jsonEncode(map);
  }

  static void loadAllDataFromJson(String jsonData) { // Alle Daten von JSON laden
    Map<String, dynamic> map = jsonDecode(jsonData);

    List<dynamic> list = map["subjects"];
    String noteTypeString = map["noteType"];
    gradeColorMarking = map["gradeColorMarking"];

    switch(noteTypeString) {
      case "NoteType.NOTE":
        noteType = NoteType.NOTE;
        break;
      case "NoteType.NOTEPOINTS":
        noteType = NoteType.NOTEPOINTS;
        break;
    }

    for(dynamic subjectData in list) {
      Subject subject = new Subject.fromMap(subjectData);
      subjectList.add(subject);
    }
    resaveAllSubjects();
  }
}