import 'dart:convert';

import 'package:member_app/common/app_constants.dart';
import 'package:member_app/data/all_bloc/get_members_details_bloc/repo/member_details.dart';
import 'package:member_app/data/local/security/crypto_utils.dart';
import 'package:member_app/data/remote/web_request.dart';
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

  /// App Member details
  Future<void> setMember(String? bearerToken) async {
    WebRequest.sMember = bearerToken ?? "";
    setEncryptedString(PrefConstants.member, bearerToken ?? "");
  }

  Future<MemberDetails> getMember() async {
    WebRequest.sMember = getDecryptedString(PrefConstants.member) ?? "";
    return WebRequest.sMember.isEmpty?MemberDetails():MemberDetails.fromJson(jsonDecode(getDecryptedString(PrefConstants.member) ?? ""));
  }

  ///clear all
  Future<bool> clearSharedPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.clear();
  }




}
