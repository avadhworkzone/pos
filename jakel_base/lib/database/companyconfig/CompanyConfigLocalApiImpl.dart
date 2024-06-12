import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jakel_base/restapi/companyconfiguration/model/CompanyConfigurationResponse.dart';

import 'CompanyConfigLocalApi.dart';

class CompanyConfigLocalApiImpl extends CompanyConfigLocalApi {
  final String _boxName = "companyConfigBox";
  final String _key = "companyConfigKey";

  Future<Box<dynamic>> _getBox() async {
    await Hive.openBox(_boxName);
    var box = Hive.box(_boxName);
    return box;
  }

  @override
  Future<bool> deleteAll() async {
    Box<dynamic> box = await _getBox();
    await box.delete(_key);
    return true;
  }

  @override
  Future<CompanyConfigurationResponse?> getConfig() async {
    var box = await _getBox();
    if (!box.containsKey(_key)) {
      return null;
    }
    var userBodyData = json.encode(box.get(_key));
    Map<String, dynamic> decodedMap = json.decode(userBodyData);
    return CompanyConfigurationResponse.fromJson(decodedMap);
  }

  @override
  Future<void> save(CompanyConfigurationResponse response) async {
    var box = await _getBox();
    await box.put(_key, response.toJson());
  }

  @override
  Future<void> clearBox() async {
    var box = await _getBox();
    await box.deleteFromDisk();
  }
}
