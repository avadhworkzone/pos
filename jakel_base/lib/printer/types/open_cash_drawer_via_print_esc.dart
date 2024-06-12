import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';

Future<bool> openCashDrawerViaPrinter(String name) async {
  var result = false;
  var defaultPrinterType = PrinterType.usb;
  _scan(defaultPrinterType, isBle: false, printerName: name);
  return result;
}

_scan(PrinterType type, {bool isBle = false, String printerName = ''}) {
  // Find printers
  PrinterManager.instance.discovery(type: type, isBle: isBle).listen((device) {
    MyLogUtils.logDebug(
        "_scan device : $device & ${device.name} , ${device.productId}");
    if (device.name == printerName) {
      _connect(type, device);
    }
  });
}

_connect(PrinterType type, PrinterDevice selectedPrinter) async {
  var connectResult = await PrinterManager.instance.connect(
      type: type,
      model: UsbPrinterInput(
          name: selectedPrinter.name,
          productId: selectedPrinter.productId,
          vendorId: selectedPrinter.vendorId));

  MyLogUtils.logDebug("connectResult : $connectResult");

  // ESC p m t1 t2
  // command = "ESC|p|0|25|251";
  // command = "\x1B|\x70|\x00|\x19|\xFB";
  // To open cash drawer via priner, we need to write thise codes to pritner.
  // Took code from : https://poshelp.robotill.com/OpenDrawerCodes.aspx
  var writeResult = await PrinterManager.instance
      .send(type: type, bytes: [27, 112, 0, 25, 250]);

  MyLogUtils.logDebug("writeResult : $writeResult");
}
