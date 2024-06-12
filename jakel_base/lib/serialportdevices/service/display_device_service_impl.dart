import 'dart:typed_data';

import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:jakel_base/serialportdevices/service/display_device_service.dart';
import 'package:jakel_base/serialportdevices/service/process_runner_service.dart';

import '../../database/serialport/SerialPortDevicesApi.dart';
import '../../locator.dart';
import '../../utils/MyLogUtils.dart';

class DisplayDeviceServiceImpl with DisplayDeviceService {
  final tag = 'DisplayDeviceService';

  @override
  Future<bool> sendMessage(String message) async {
    var localApi = locator.get<SerialPortDevicesApi>();

    var device = await localApi.getMyDisplayDevice();

    if (device != null) {
      final port = SerialPort(device.address);

      await initDevice();

      MyLogUtils.logDebug("$tag, writeToDevice port is open: ${port.isOpen}");

      if (!port.isOpen) {
        port.openReadWrite();
      }

      MyLogUtils.logDebug("$tag, writeToDevice port is open: ${port.isOpen}");

      List<int> list = message.codeUnits;

      MyLogUtils.logDebug("$tag, writeToDevice list: $list");

      Uint8List bytes = Uint8List.fromList(list);

      //SerialPortReader reader = SerialPortReader(port, timeout: 10000);
      try {
        var writtenBytes = port.write(bytes);

        MyLogUtils.logDebug('writtenBytes : $writtenBytes');

        // reader.stream.listen((data) {
        //   MyLogUtils.logDebug('Bytes ack data: $data');
        //   closeTheDevice(port);
        // });
        await Future.delayed(const Duration(seconds: 2));

        closeTheDevice(port);
      } on SerialPortError catch (_, err) {
        MyLogUtils.logDebug('writeToDevice err : $err');
        closeTheDevice(port);
      }
    }

    return false;
  }

  void closeTheDevice(SerialPort port) {
    if (port.isOpen) {
      port.close();
    }
    port.dispose();

    MyLogUtils.logDebug('closeTheDevice');
  }

  @override
  Future<bool> initDevice() async {
    var localApi = locator.get<SerialPortDevicesApi>();
    var device = await localApi.getMyDisplayDevice();

    if (device != null) {
      var processRunner = locator.get<ProcessRunnerService>();
      //Set the configuration Using process runner
      await processRunner
          .execute("mode ${device.address}: BAUD=9600 PARITY=N data=8 stop=1");
    }
    return true;
  }
}
