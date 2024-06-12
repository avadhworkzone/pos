import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:jakel_base/serialportdevices/model/MySerialPortDevices.dart';

import 'SerialPortDevicesApi.dart';

class SerialPortDevicesApiImpl extends SerialPortDevicesApi {
  final String _boxName = "serialPortDevicesBox";

  Future<Box<dynamic>> _getBox() async {
    await Hive.openBox(_boxName);
    var box = Hive.box(_boxName);
    return box;
  }

  @override
  Future<bool> deleteDisplayDevice() async {
    Box<dynamic> box = await _getBox();
    await box.delete(deviceTypeDisplay);
    return true;
  }

  @override
  Future<bool> deletePaymentTerminalDevice() async {
    Box<dynamic> box = await _getBox();
    await box.delete(deviceTypePaymentTerminal);
    return true;
  }

  @override
  Future<MySerialPortDevices?> getMyDisplayDevice() async {
    Box<dynamic> box = await _getBox();
    var content = box.get(deviceTypeDisplay);

    if (content != null) {
      String? encoded = json.encode(content);
      Map<String, dynamic> decoded = json.decode(encoded);
      MySerialPortDevices? myDevice = MySerialPortDevices.fromJson(decoded);
      return Future.value(myDevice);
    }

    return Future.value(null);
  }

  @override
  Future<MySerialPortDevices?> getMyPaymentTerminalDevice() async {
    Box<dynamic> box = await _getBox();
    var content = box.get(deviceTypePaymentTerminal);

    if (content != null) {
      String? encoded = json.encode(content);
      Map<String, dynamic> decoded = json.decode(encoded);
      MySerialPortDevices? myDevice = MySerialPortDevices.fromJson(decoded);
      return Future.value(myDevice);
    }

    return Future.value(null);
  }

  @override
  Future<void> save(MySerialPortDevices element) async {
    Box<dynamic> box = await _getBox();
    await box.put(element.deviceType, element.toJson());
  }
}
