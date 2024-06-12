import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jakel_base/database/loyaltypointvoucherconfiguration/LoyaltyPointVoucherConfigurationLocalApi.dart';
import 'package:jakel_base/restapi/loyaltypointvoucherconfiguration/model/LoyaltyPointVoucherConfigurationResponse.dart';


class LoyaltyPointVoucherConfigurationLocalApiImpl extends LoyaltyPointVoucherConfigurationLocalApi {
  final String _boxName = "loyaltyPointVoucherConfigurationBox";
  final String _key = "loyaltyPointVoucherConfigurationKey";

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
  Future<LoyaltyPointVoucherConfigurationResponse?> getConfig() async {
    var box = await _getBox();
    if (!box.containsKey(_key)) {
      return null;
    }
    var userBodyData = json.encode(box.get(_key));
    Map<String, dynamic> decodedMap = json.decode(userBodyData);
    return LoyaltyPointVoucherConfigurationResponse.fromJson(decodedMap);
  }

  @override
  Future<void> save(LoyaltyPointVoucherConfigurationResponse response) async {
    var box = await _getBox();
    await box.put(_key, response.toJson());
  }

  @override
  Future<void> clearBox() async {
    var box = await _getBox();
    await box.deleteFromDisk();
  }
}
