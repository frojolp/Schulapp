import 'package:flutter/material.dart';
import 'package:flutter_notenapp/Grade.dart';
import 'dart:convert';
import 'GradesMain.dart';
import 'NoteType.dart';
import 'GradeType.dart';

/*
 * Blueprint für alle Fächer
 */

class Subject {

  String subjectName; //Name des Faches

  @deprecated //Wird nicht verwendet
  String subjectAbbreviation; // Kürzel des Faches

  double weighting; //Gewichtung Schriftlich:Mündlich

  List<Grade> writingGrades = []; //Liste aller schriftlichen Noten
  List<Grade> speakingGrades = []; //Liste aller mündlichen Noten
  List<Grade> furtherGrades = []; //Liste aller "weiteren" Noten


  Subject(String subjectName, int weightingWriting, int weightingSpeaking) { //Klassische Instanziierung
    this.subjectName = subjectName;
    this.weighting = weightingWriting/weightingSpeaking;
  }

  Subject.fromJson(String jsonData) { //Instanziierung durch JSON
    loadJson(jsonData);
  }

  Subject.fromMap(dynamic mapData) { //Instanziierung durch eine Map
    loadMap(mapData);
  }

  Map<String, dynamic> toMap() { //Konvertieren in eine Map
    List<Map<String, dynamic>> convertedWritingGrades = [];
    for(Grade grade in writingGrades)
      convertedWritingGrades.add(grade.toMap());

    List<Map<String, dynamic>> convertedSpeakingGrades = [];
    for(Grade grade in speakingGrades)
      convertedSpeakingGrades.add(grade.toMap());

    List<Map<String, dynamic>> convertedFurtherGrades = [];
    for(Grade grade in furtherGrades)
      convertedFurtherGrades.add(grade.toMap());

    Map<String, dynamic> map = {
      "subjectName" : this.subjectName,
      //"subjectAbbreviation" : this.subjectAbbreviation,
      "weighting": this.weighting,
      "writingGrades" : convertedWritingGrades,
      "speakingGrades" : convertedSpeakingGrades,
      "furtherGrades" : convertedFurtherGrades,
    };
    return map;
  }

  String toJson() { //Konvertieren zu JSON
    return json.encode(toMap());
  }

  void loadJson(String jsonData) { //Von JSON laden
    dynamic data = json.decode(jsonData);

    this.subjectName = data['subjectName'];
    //this.subjectAbbreviation = data['subjectAbbreviation'];
    this.weighting = data['weighting'];

    dynamic convertetWritingGrades = data["writingGrades"];
    if(convertetWritingGrades != null) {
      for(dynamic map in convertetWritingGrades) {
        writingGrades.add(new Grade.fromMap(map));
      }
    }

    dynamic convertetSpeakingGrades = data["speakingGrades"];
    if(convertetSpeakingGrades != null) {
      for(dynamic map in convertetSpeakingGrades) {
        speakingGrades.add(new Grade.fromMap(map));
      }
    }

    dynamic convertetFurtherGrades = data["furtherGrades"];
    if(convertetFurtherGrades != null) {
      for(dynamic map in convertetFurtherGrades) {
        furtherGrades.add(new Grade.fromMap(map));
      }
    }
  }

  void loadMap(dynamic data) { //Von Map laden
    this.subjectName = data['subjectName'];
    //this.subjectAbbreviation = data['subjectAbbreviation'];
    this.weighting = data['weighting'];

    dynamic convertetWritingGrades = data["writingGrades"];
    if(convertetWritingGrades != null) {
      for(dynamic map in convertetWritingGrades) {
        writingGrades.add(new Grade.fromMap(map));
      }
    }

    dynamic convertetSpeakingGrades = data["speakingGrades"];
    if(convertetSpeakingGrades != null) {
      for(dynamic map in convertetSpeakingGrades) {
        speakingGrades.add(new Grade.fromMap(map));
      }
    }

    dynamic convertetFurtherGrades = data["furtherGrades"];
    if(convertetFurtherGrades != null) {
      for(dynamic map in convertetFurtherGrades) {
        furtherGrades.add(new Grade.fromMap(map));
      }
    }
  }

  void deleteAllGrades() { //Methode um alle Noten des Faches zu löschen
    writingGrades.clear();
    speakingGrades.clear();
    furtherGrades.clear();
  }

  double calcWritingGrade() { //Schnitt aller schriftlichen Noten ausrechnen
    double totalWeightings = 0;
    double totalGradeWeightings = 0;


    for(Grade grade in writingGrades) {
      totalWeightings += grade.weighting;
      totalGradeWeightings += grade.weighting*grade.grade;
    }

    for(Grade grade in furtherGrades) {
      if(grade.influence == GradeType.WRITING) {
        totalWeightings += grade.weighting;
        totalGradeWeightings += grade.weighting*grade.grade;
      }
    }

    return totalGradeWeightings/totalWeightings;
  }

  bool hasWritingGrades() { //Existiert eine schriftliche Note?
    if(writingGrades.length != 0)
      return true;

    for(Grade grade in furtherGrades)
      if(grade.influence == GradeType.WRITING)
        return true;
      return false;
  }

  double calcSpeakingGrade() { //Schnitt aller mündlichen Noten ausrechnen

    double totalWeightings = 0;
    double totalGradeWeightings = 0;


    for(Grade grade in speakingGrades) {
      totalWeightings += grade.weighting;
      totalGradeWeightings += grade.weighting*grade.grade;
    }

    for(Grade grade in furtherGrades) {
      if(grade.influence == GradeType.SPEAKING) {
        totalWeightings += grade.weighting;
        totalGradeWeightings += grade.weighting*grade.grade;
      }
    }

    return totalGradeWeightings/totalWeightings;
  }


  bool hasSpeakingGrades() { //Existiert eine mündliche Note?
    if(speakingGrades.length != 0)
      return true;

    for(Grade grade in furtherGrades)
      if(grade.influence == GradeType.SPEAKING)
        return true;
    return false;
  }

  double calcTotalGrade() { //Gesamtschnitt ausrechnen
    if(!hasWritingGrades()) {
      return calcSpeakingGrade();
    }

    if(!hasSpeakingGrades()) {
      return calcWritingGrade();
    }

    double writingGrade = calcWritingGrade();
    double speakingGrade = calcSpeakingGrade();

    return (writingGrade*weighting + speakingGrade)/(1+weighting);
  }

  String getTotalGradeString() { //Gesamtschnitt für Anzeige formatieren
    double grade = calcTotalGrade();

    if(grade % 1 == 0)
      return grade.toInt().toString();

    return grade.toStringAsFixed(1).replaceAll(".", ",");
  }

  String getSpeakingGradeString() { //Mündlicher Schnitt für Anzeige formatieren
    double grade = calcSpeakingGrade();

    if(grade % 1 == 0)
      return grade.toInt().toString();

    return grade.toStringAsFixed(1).replaceAll(".", ",");
  }

  String getWritingGradeString() { //Schriftlicher Schnitt für Anzeige formatieren
    double grade = calcWritingGrade();

    if(grade % 1 == 0)
      return grade.toInt().toString();

    return grade.toStringAsFixed(1).replaceAll(".", ",");
  }

  bool hasTotalGrade() { //Existiert irgendeine Note für den Gesamtschnitt?
    if(!hasSpeakingGrades() && !hasWritingGrades())
      return false;
    return true;
  }

  Color calcColor() { //Farbe für die Fächerübersicht berechnen
    if(!hasTotalGrade())
      return Colors.blueGrey;

    double grade = calcTotalGrade();

    if(Main.noteType == NoteType.NOTEPOINTS) {
      if(grade >= 10)
        return Colors.green;

      if(grade >= 5)
        return Colors.orange;

    } else if(Main.noteType == NoteType.NOTE) {
      if(grade <= 2)
        return Colors.green;

      if(grade <= 4)
        return Colors.orange;
    }

    return Colors.red;
  }

}

