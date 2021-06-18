import 'package:flutter/material.dart';
import 'dart:math';
import 'GradesMain.dart';
import 'Serverapi.dart';

/*
 * Klasse zum Exportieren und Importieren von Daten
 */

class ExportOverview extends StatefulWidget {

  StateSetter stateSetter;

  ExportOverview(StateSetter stateSetter) {
    this.stateSetter = stateSetter; //StateSetter der Fächerübersicht zum Aktualisieren nach Importieren der Daten
  }

  @override
  _ExportOverviewState createState() => new _ExportOverviewState(stateSetter);
}

class _ExportOverviewState extends State<ExportOverview> {

  StateSetter stateSetter;
  String code;
  ExportStatus exportStatus = ExportStatus.WAITING_USER_INPUT;
  ImportStatus importStatus = ImportStatus.WAITING_USER_INPUT;

  TextEditingController codeController = new TextEditingController();

  _ExportOverviewState(StateSetter stateSetter) {
    this.stateSetter = stateSetter;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daten übertragen"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text("Exportieren",
                    style: new TextStyle(fontSize: 20)),
                  Text("Zum Exportieren deiner Noten und Fächer werden diese anonymisiert und verschlüsselt an unseren Server gesendet. Nach erfolgreichem Abruf deiner Daten werden diese vom Server entfernt."),
                  SizedBox(height: 30),

                  exportStatus == ExportStatus.WAITING_USER_INPUT ?
                  TextButton(
                    onPressed: sendData,
                    child: Text("Daten Exportieren"),
                  ) : exportStatus == ExportStatus.WAITING_SERVER_RESPONSE ?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 15,),
                      Text("Daten werden exportiert..."),
                    ],
                  ) :
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Erfolgreich exportiert",
                      style: new TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10,),
                      Text("Dein Code lautet: $code",
                      style: new TextStyle(fontSize: 16)),
                      SizedBox(height: 10,),
                      Text("Gebe diesen Code auf dem zu importierenden Gerät ein, um deine Daten zu übertragen. Danach werden diese von unserem Server entfernt.")
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text("Importieren",
                      style: new TextStyle(fontSize: 20)),
                  Text("Um deine Noten und Fächer zu übertragen, benötigst du einen Übertragungscode. Diesen erhältst du, indem du bei dem Gerät, auf dem deine Daten gespeichert sind, auf \"Exportieren\" drückst. Diesen Code kannst du nun hier eingeben."),
                  SizedBox(height: 30),

                  importStatus == ImportStatus.WAITING_USER_INPUT ?
                  Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Übertragungscode eingeben',
                        ),
                        keyboardType: TextInputType.number,
                        controller: codeController,
                      ),
                      TextButton(
                        onPressed: importData,
                        child: Text("Daten Importieren"),
                      )
                    ],
                  ) : importStatus == ImportStatus.WAITING_SERVER_RESPONSE ?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 15,),
                      Text("Daten werden importiert..."),
                    ],
                  ) : importStatus == ImportStatus.WRONG_CODE ?
                  Column(
                    children: [
                        new Text(
                        'Der Übertragunscode ist ungültig!',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(height: 5,),
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Übertragungscode eingeben',
                        ),
                        keyboardType: TextInputType.number,
                        controller: codeController,
                      ),
                      TextButton(
                        onPressed: importData,
                        child: Text("Daten Importieren"),
                      )
                    ],
                  ) :   
                  Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.assignment_turned_in, color: Colors.green,),
                          new Text(
                            'Alle Daten wurden erfolgreich übertragen',
                            style: TextStyle(
                              color: Colors.green,
                            ),
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                      ),
                      Text("Du kannst diese Seite nun schließen"),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void importData() { //Methode zum Importieren von Daten
    setState(() {
      importStatus = ImportStatus.WAITING_SERVER_RESPONSE;
    });

    String code = codeController.text;
    if(code.isEmpty) {
      importStatus = ImportStatus.WRONG_CODE;
      return;
    }

    ServerAPI serverAPI = new ServerAPI();
    serverAPI.pullData(code).then((value) => _importData(value));
  }

  void _importData(String jsonData) { //Untermethode (async) nach Serverantwort
    if(jsonData == "error_column_not_found") {
      setState(() {
        importStatus = ImportStatus.WRONG_CODE;
      });
      return;
    }

    Main.loadAllDataFromJson(jsonData); //Laden der neuen Fächer und Noten mit dem übertragenen JSON-String

    stateSetter(() {}); //Aktualisieren der Fächerübersicht

    setState(() {
      importStatus = ImportStatus.FINISHED; //Aktualisierung des Import-Status
    });
  }


  void sendData() { //Daten senden
    setState(() {
      exportStatus = ExportStatus.WAITING_SERVER_RESPONSE; //Aktualisierung des Export-Status
    });

    code =  getRandomString(6); //random Code generieren
    String jsonData = Main.saveAllDataToJson(); //Alle Daten zu JSON konvertieren

    ServerAPI serverAPI = new ServerAPI();
    serverAPI.pushData(code, jsonData).then((value) => value == "success" ?
    sendingDataSuccess() : //Daten erfolgreich importiert, Server hat mit "success" geantwortet
    sendingDataError()); //Ein Fehler ist aufgetreten
  }

  void sendingDataSuccess() {
    setState(() {
      exportStatus = ExportStatus.FINISHED; //Aktualisierung des Export-Status
    });
  }

  void sendingDataError() {
    //TODO
  }

  //Methode zum Generieren eines Random Codes
  var _chars = '1234567890';
  Random _rnd = Random();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}

enum ExportStatus { //ExportStatus-Enum
  WAITING_USER_INPUT, //Keine Eingabe vom User getätigt
  WAITING_SERVER_RESPONSE, //Eingabe erfolgreich, warten auf Serverantwort
  FINISHED, //Server hat geantwortet
}

enum ImportStatus { //ImportStatus-Enum
  WAITING_USER_INPUT, //Keine Eingabe vom User getätigt
  WAITING_SERVER_RESPONSE, //Eingabe erfolgreich, warten auf Serverantwort
  WRONG_CODE, //Server hat geantwortet, Code ist nicht korrekt
  FINISHED, //Server hat geantwortet, erfolgreich importiert
}