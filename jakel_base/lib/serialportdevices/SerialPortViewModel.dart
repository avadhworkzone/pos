import 'dart:typed_data';

import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:jakel_base/database/serialport/SerialPortDevicesApi.dart';
import 'package:jakel_base/serialportdevices/model/MySerialPortDevices.dart';
import 'package:jakel_base/serialportdevices/serial_port_helper.dart';
import 'package:jakel_base/serialportdevices/service/display_device_service.dart';
import 'package:jakel_base/serialportdevices/service/may_bank_terminal_service.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';

import '../locator.dart';

class SerialPortViewModel extends BaseViewModel{
  Future<List<SerialPort>> getAllSerialPorts() async {
    List<SerialPort> ports = List.empty(growable: true);
    List<String> availablePortAddresses = SerialPort.availablePorts;

    for (var address in availablePortAddresses) {
      final port = SerialPort(address);
      ports.add(port);
    }

    return Future(() => ports);
  }

  Future<SerialPort?> getMyDisplayDevice() async {
    var localApi = locator.get<SerialPortDevicesApi>();

    var device = await localApi.getMyDisplayDevice();

    if (device != null) {
      final port = SerialPort(device.address);
      return port;
    }
    return Future(() => null);
  }

  Future<SerialPort?> getMyPaymentTerminalDevice() async {
    var localApi = locator.get<SerialPortDevicesApi>();

    var device = await localApi.getMyPaymentTerminalDevice();

    if (device != null) {
      final port = SerialPort(device.address);
      return port;
    }
    return Future(() => null);
  }

  Future<SerialPort> saveDevice(String deviceType, SerialPort port) async {
    var localApi = locator.get<SerialPortDevicesApi>();

    MySerialPortDevices portDevices = MySerialPortDevices(
        name: port.name ?? "",
        address: port.name ?? "",
        deviceType: deviceType);

    await localApi.save(portDevices);

    return SerialPort(portDevices.address);
  }

  Future<int> writeToDisplayDevice(String data, SerialPort port) async {
    var localApi = locator.get<DisplayDeviceService>();
    var device = await localApi.sendMessage(data);
    return device ? 1 : 0;
  }

  Future<int> echoTextMayBankTerminal() async {
    var mayBankTerminalService = locator.get<MayBankTerminalService>();
    var result = await mayBankTerminalService.echoTerminalTest();
    MyLogUtils.logDebug("echoTextMayBankTerminal result : $result");
    return -1;
  }

  Future<bool> flushDisplayDevice() async {
    var localApi = locator.get<SerialPortDevicesApi>();

    var device = await localApi.getMyDisplayDevice();

    if (device != null) {
      final port = SerialPort(device.address);
      port.flush();
      return true;
    }
    return Future(() => false);
  }
}
