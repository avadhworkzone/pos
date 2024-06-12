import 'dart:math';

import 'package:uuid/uuid.dart';
import 'package:platform_device_id/platform_device_id.dart';

import '../database/user/UserLocalApi.dart';
import '../locator.dart';
import 'MyLogUtils.dart';

String createUniqueId(String key) {
  var uuid = const Uuid();
  return uuid.v5(Uuid.NAMESPACE_OID, key);
}

String getOfflineSaleUniqueId(int customerId, int registerId, int storeId) {
  return "$customerId$registerId$storeId${Random().nextInt(9)}${DateTime.now().millisecondsSinceEpoch}";
}

Future<String?> getUniqueDeviceId() async {
  try {
    var userLocalApi = locator.get<UserLocalApi>();
    var deviceId = await userLocalApi.getDeviceId();

    /// Check if device id is null locally , if so read from device.
    /// If we read from device all the time, a terminal will pop up in windows
    if (deviceId == null) {
      deviceId = await getUniqueDeviceIdFromDevice();
      if (deviceId != null) {
        await userLocalApi.saveDeviceId(deviceId);
      }
    }
    return deviceId;
  } catch (e) {
    MyLogUtils.logDebug("getUniqueDeviceId exception : $e");
    return "";
  }
}

Future<String?> getUniqueDeviceIdFromDevice() async {
  var deviceId = await PlatformDeviceId.getDeviceId;
  deviceId = deviceId?.trim();
  return deviceId;
}
