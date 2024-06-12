import 'dart:convert' show JsonCodec, json, jsonDecode, jsonEncode, utf8;

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encryptor;

class CryptoUtils {
  static String encryptKey = "ED7a\$c6BdgXw`g9N+&J{cb6aP<aKL4nP";
  static String encryptIV = "CT4UWeVW\$q6RzV,W";
  static final key = encryptor.Key.fromUtf8(encryptKey);
  static final iv = encryptor.IV.fromUtf8(encryptIV);

  static Map<String, String> encryptedStringPayload(
      Map<String, String> mapText) {
    String plainText = "";
    if (mapText.isNotEmpty) {
      plainText = jsonEncode(mapText);
    }
    final encryptionMode =
        encryptor.Encrypter(encryptor.AES(key, mode: encryptor.AESMode.cbc));
    final encrypted = encryptionMode.encrypt(plainText, iv: iv);
    Map<String, String> productMap = Map();
    productMap['data'] = encrypted.base64.toString();
    return productMap;
  }

  static String decryptedPayload(String plainText) {
    final decryptionMode =
        encryptor.Encrypter(encryptor.AES(key, mode: encryptor.AESMode.cbc));
    final decrypted = decryptionMode.decrypt64(plainText, iv: iv);
    return decrypted;
  }

  ///------------------- below encrypted string method for shared pref -------------------
  static String encryptedString(String plainText) {
    final encryptionMode =
        encryptor.Encrypter(encryptor.AES(key, mode: encryptor.AESMode.cbc));
    final encrypted = encryptionMode.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  static String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }
}
