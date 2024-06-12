import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:jakel_base/restapi/configurationkey/model/ConfigurationResponse.dart';
import 'package:jakel_base/restapi/me/model/CurrentUserResponse.dart';

import 'UserLocalApi.dart';

class UserLocalApiImpl extends UserLocalApi {
  final String _boxName = "userdata";
  final String _token = "token";
  final String _password = "password";
  final String _currentUser = "currentUser";
  final String _configuration = "configuration";
  final String _configKey = "configKey";
  final String _userName = "userNameKey";
  final String _deviceId = "deviceId";

  @override
  Future<String?> getPassword() async {
    Box<dynamic> box = await _getBox();
    return await box.get(_password, defaultValue: null);
  }

  @override
  savePassword(String password) async {
    Box<dynamic> box = await _getBox();
    await box.put(_password, password);
  }

  @override
  Future<String?> getDeviceId() async {
    Box<dynamic> box = await _getBox();
    return await box.get(_deviceId, defaultValue: null);
  }

  @override
  saveDeviceId(String deviceId) async {
    Box<dynamic> box = await _getBox();
    await box.put(_deviceId, deviceId);
  }

  @override
  Future<String?> getToken() async {
    Box<dynamic> box = await _getBox();
    return await box.get(_token, defaultValue: null);
  }

  @override
  saveToken(String token) async {
    Box<dynamic> box = await _getBox();
    await box.put(_token, token);
  }

  @override
  Future<bool?> logout() async {
    Box<dynamic> box = await _getBox();
    await box.delete(_token);
    return true;
  }

  Future<Box<dynamic>> _getBox() async {
    await Hive.openBox(_boxName);
    var box = Hive.box(_boxName);
    return box;
  }

  @override
  Future<CurrentUserResponse?> getCurrentUser() async {
    Box<dynamic> box = await _getBox();
    var content = box.get(_currentUser);

    if (content != null) {
      String? encoded = json.encode(content);
      Map<String, dynamic> decoded = json.decode(encoded);
      CurrentUserResponse? currentUser = CurrentUserResponse.fromJson(decoded);
      return Future.value(currentUser);
    }

    return Future.value(null);
  }

  @override
  Future<bool> saveCurrentUser(CurrentUserResponse currentUser) async {
    Box<dynamic> box = await _getBox();
    await box.put(_currentUser, currentUser.toJson());
    return true;
  }

  @override
  Future<ConfigurationResponse?> getConfiguration() async {
    Box<dynamic> box = await _getBox();
    var content = box.get(_configuration);

    if (content != null) {
      String? encoded = json.encode(content);
      Map<String, dynamic> decoded = json.decode(encoded);
      ConfigurationResponse? configs = ConfigurationResponse.fromJson(decoded);
      return Future.value(configs);
    }

    return Future.value(null);
  }

  @override
  Future<bool?> saveConfiguration(ConfigurationResponse configs) async {
    Box<dynamic> box = await _getBox();
    await box.put(_configuration, configs.toJson());
    return true;
  }

  @override
  Future<String?> getConfigKey() async {
    Box<dynamic> box = await _getBox();
    return await box.get(_configKey, defaultValue: null);
  }

  @override
  Future<void> saveConfigKey(String key) async {
    Box<dynamic> box = await _getBox();
    await box.put(_configKey, key);
  }

  @override
  Future<bool?> deleteConfiguration() async {
    Box<dynamic> box = await _getBox();
    await box.delete(_configKey);
    await box.delete(_configuration);
    return true;
  }

  @override
  Future<String?> getUserName() async {
    Box<dynamic> box = await _getBox();

    var userName = await box.get(_userName, defaultValue: null);

    if (userName != null) {
      return userName;
    }

    var user = await getCurrentUser();
    if (user != null) {
      return user.cashier?.username;
    }
    return null;
  }

  @override
  Future<void> saveUserName(String userName) async {
    Box<dynamic> box = await _getBox();
    await box.put(_userName, userName);
  }

  @override
  Future<void> clearBox() async {
    var box = await _getBox();
    await box.deleteFromDisk();
  }
}
