import 'package:flutter/material.dart';
import 'dart:convert';
import 'GradeType.dart';

/*
 * Blueprint für alle Noten
 */

class Grade {

  var grade;
  int weighting;
  String usernote;
  DateTime date;

  var points, maxPoints;

  GradeType influence; //Nur für "weitere" Noten relevant

  Grade(var grade, var points, var maxPoints, int weighting, String usernote, DateTime date, GradeType influence) { //Klassische Instanziierung
    this.grade = grade;
    this.points = points;
    this.maxPoints = maxPoints;
    this.weighting = weighting;
    this.usernote = usernote;
    this.date = date;
    this.influence = influence;
  }

  Grade.fromMap(Map<String, dynamic> map) { //Instanziierung über eine Map
    this.grade = map["grade"];
    this.points = map["points"];
    this.maxPoints = map["maxPoints"];
    this.weighting = map["weighting"];
    this.date = DateTime.now();
    this.usernote = map["usernote"];
    this.influence = convertStringToGradeType(map["influence"]);
    this.date = new DateTime.fromMicrosecondsSinceEpoch(map["date"]);
  }

  String formatDate() { //Konvertieren des Datums
    return (date.day.toString().length == 1 ? "0" + date.day.toString() : date.day.toString()) + "." + (date.month.toString().length == 1 ? "0" + date.month.toString() : date.month.toString()) + "." + date.year.toString();
  }

  String formatGrade() {
    if(grade %1 != 0)
      return grade.toString().replaceAll(".", ",");
    return grade.toString();
  }

  Map<String, dynamic> toMap() { //Konvertieren in eine Map
    Map<String, dynamic> map = {
      "grade" : this.grade,
      "points": this.points,
      "maxPoints": this.maxPoints,
      "weighting": this.weighting,
      "date": this.date.microsecondsSinceEpoch,
      "usernote": this.usernote,
      "influence": this.influence.toString(),
    };
   return map;
  }

  GradeType convertStringToGradeType(String typeString) {
    switch(typeString) {
      case "GradeType.WRITING":
        return GradeType.WRITING;
      case "GradeType.SPEAKING":
        return GradeType.SPEAKING;
    }
    return null;
  }
}