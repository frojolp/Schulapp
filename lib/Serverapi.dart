import 'dart:html';

import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart';

/*
 * ServerAPI zur Kommunikation mit der Datenbank
 */

class ServerAPI {
  String urlstring = 'https://larskiefer.de/esssindex.php'; // Link zur REST-API
  Uri url = Uri.dataFromString('https://larskiefer.de/esssindex.php');

  Future<String> pushData(String code, String data) async {
    // Daten hochladen
    String encrypted = encrypt(data);
    var response = await http.post(url, body: {
      "key": "c9b2CUT70O5PPYIC13SvL4StK",
      "mode": "push",
      "code": "$code",
      "data": "$encrypted"
    });
    return Future.value(response.body);
  }

  Future<String> pullData(String code) async {
    // Daten downloaden
    var response = await http.post(url, body: {
      "key": "c9b2CUT70O5PPYIC13SvL4StK",
      "mode": "pull",
      "code": "$code"
    });

    if (response.body.toString() == "error_column_not_found") {
      return "error_column_not_found";
    }

    return Future.value(decrypt(response.body.toString()));
  }

  String encrypt(String raw) {
    // Daten verschlüsseln
    final key = Key.fromUtf8('D7E0PhTRNJf3M4ZU2DgV1L8jp5Hl9H6k');
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));

    final encrypted = encrypter.encrypt(raw, iv: iv);

    return encrypted.base64;
  }

  String decrypt(String raw) {
    // Daten entschlüsseln
    final key = Key.fromUtf8('D7E0PhTRNJf3M4ZU2DgV1L8jp5Hl9H6k');
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));

    final encrypted = Encrypted.from64(raw);

    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    return decrypted;
  }
}
