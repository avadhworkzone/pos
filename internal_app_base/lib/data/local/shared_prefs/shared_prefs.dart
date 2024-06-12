import 'dart:convert';

import 'package:internal_base/common/app_constants.dart';
import 'package:internal_base/data/local/security/crypto_utils.dart';
import 'package:internal_base/data/remote/web_request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pref_constants.dart';

class SharedPrefs {
  // Singleton approach
  static final SharedPrefs _instance = SharedPrefs._internal();

  factory SharedPrefs() => _instance;

  SharedPrefs._internal();

  SharedPreferences? sharedPreferences;

  sharedPreferencesInstance() async {
    if (sharedPreferences == null) {
      return sharedPreferences = await SharedPreferences.getInstance();
    } else {
      return sharedPreferences;
    }
  }

  ///getDecrypted
  getDecryptedString(String key) {
    if (sharedPreferences != null) {
      if (AppConstants.isSharedPrefToEncrypt) {
        String value = sharedPreferences!.getString(key) ?? "";
        if (value.isNotEmpty) {
          return CryptoUtils.decryptedPayload(value);
        }
      } else {
        return sharedPreferences!.getString(key) ?? "";
      }
    }
  }

  ///setEncrypted
  setEncryptedString(String key, String value) {
    if (sharedPreferences != null) {
      if (AppConstants.isSharedPrefToEncrypt) {
        if (value.isNotEmpty) {
          String encryptedStringValue = CryptoUtils.encryptedString(value);
          sharedPreferences!.setString(key, encryptedStringValue);
        }
      } else {
        sharedPreferences!.setString(key, value);
      }
    }
  }

  /// App Token
  Future<void> setUserToken(String? bearerToken) async {
    WebRequest.sBearerToken = bearerToken ?? "";
    setEncryptedString(PrefConstants.token, bearerToken ?? "");
  }

  Future<String> getUserToken() async {
    WebRequest.sBearerToken = getDecryptedString(PrefConstants.token) ?? "";
    return WebRequest.sBearerToken.isNotEmpty?(getDecryptedString(PrefConstants.token) ?? ""):"";
  }

 /// App Token Type
  Future<void> setUserTokenType(String? bearerTokenType) async {
    WebRequest.sBearerTokenType = bearerTokenType ?? "";
    setEncryptedString(PrefConstants.tokenType, bearerTokenType ?? "");
  }

  Future<String> getUserTokenType() async {
    WebRequest.sBearerTokenType = getDecryptedString(PrefConstants.tokenType) ?? "";
    return WebRequest.sBearerTokenType.isNotEmpty?(getDecryptedString(PrefConstants.tokenType) ?? ""):"";
  }


 /// App Token Type
  Future<void> setSelectStore(String? bearerSelectStore) async {
    WebRequest.sBearerSelectStore = bearerSelectStore ?? "";
    setEncryptedString(PrefConstants.sSelectStore, bearerSelectStore ?? "");
  }

  Future<String> getSelectStore() async {
    WebRequest.sBearerSelectStore = getDecryptedString(PrefConstants.sSelectStore) ?? "";
    return WebRequest.sBearerSelectStore.isNotEmpty?(getDecryptedString(PrefConstants.sSelectStore) ?? ""):"";
  }


  ///clear all
  Future<bool> clearSharedPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.clear();
  }




}
