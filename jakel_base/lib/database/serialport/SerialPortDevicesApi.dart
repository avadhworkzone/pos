import 'package:jakel_base/database/printer/model/MyPrinter.dart';
import 'package:jakel_base/serialportdevices/model/MySerialPortDevices.dart';

abstract class SerialPortDevicesApi {
  /// Save
  Future<void> save(MySerialPortDevices element);

  /// Get My Display Device
  Future<MySerialPortDevices?> getMyDisplayDevice();

  /// Get My Display Device
  Future<MySerialPortDevices?> getMyPaymentTerminalDevice();

  /// Delete display device
  Future<bool> deleteDisplayDevice();

  /// Delete display device
  Future<bool> deletePaymentTerminalDevice();
}
