import 'dart:async';

import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';

Future<bool> cutReceiptViaEsc(String name) async {
  MyLogUtils.logDebug("cutReceiptViaEsc for $name");
  await Future.delayed(const Duration(seconds: 1));
  var result = false;
  // var defaultPrinterType = PrinterType.usb;
  // PrinterDevice? device =
  //     await _scanAndGetDevice(defaultPrinterType, false, name.trim());
  // await _connect(defaultPrinterType, device, name);
  // await Future.delayed(const Duration(seconds: 1));
  return result;
}

Future<PrinterDevice> _scanAndGetDevice(
    PrinterType type, bool isBle, String printerName) async {
  MyLogUtils.logDebug("cutReceiptViaEsc _scanAndGetDevice for  $printerName");
  Completer<PrinterDevice> complete = Completer();

  PrinterDevice? device;
  PrinterManager.instance.discovery(type: type, isBle: isBle).listen((event) {
    if (event.name == printerName) {
      device = event;
    }
  }).onDone(() {
    MyLogUtils.logDebug("cutReceiptViaEsc onDone for  $device");
    complete.complete(device);
  });

  return complete.future;
}

_scan(PrinterType type, bool isBle, String printerName) {
  // Find printers
  MyLogUtils.logDebug("cutReceiptViaEsc _scan for device : ->$printerName<-");

  PrinterManager.instance.discovery(type: type, isBle: isBle).listen((device) {
    MyLogUtils.logDebug(
        "cutReceiptViaEsc _scan device : $device & ->${device.name}<- , ${device.productId}");
    if (device.name == printerName) {
      _connect(type, device, printerName);
    }
  });
}

Future<bool> _connect(
    PrinterType type, PrinterDevice selectedPrinter, String name) async {
  MyLogUtils.logDebug("cutReceiptViaEsc _connect to  : $name");
  List<int> bytes = [];

  try {
    final profile = await CapabilityProfile.load();
    // PaperSize.mm80 or PaperSize.mm58
    final generator = Generator(PaperSize.mm80, profile);
    bytes += generator.feed(2);
    bytes += generator.cut();

    var connectResult = await PrinterManager.instance.connect(
        type: type,
        model: UsbPrinterInput(
            name: selectedPrinter.name,
            productId: selectedPrinter.productId,
            vendorId: selectedPrinter.vendorId));

    MyLogUtils.logDebug("cutReceiptViaEsc connectResult : $connectResult");

    var writeResult =
        await PrinterManager.instance.send(type: type, bytes: bytes);

    MyLogUtils.logDebug("cutReceiptViaEsc writeResult : $writeResult");
    return writeResult;
  } catch (e) {
    MyLogUtils.logDebug("cutReceiptViaEsc exception  : $e");
    return false;
  }
}
