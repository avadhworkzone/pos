import 'package:jakel_base/constants.dart';
import 'package:jakel_base/database/printer/PrinterLocalApi.dart';
import 'package:jakel_base/database/printer/model/MyPrinter.dart';
import 'package:printing/printing.dart';

import '../locator.dart';

class PrinterViewModel {
  Future<List<Printer>> findPrinters() async {
    return await Printing.listPrinters();
  }

  Future<MyPrinter> savePrimaryPrinter(Printer printer) async {
    var localApi = locator.get<PrinterLocalApi>();
    MyPrinter myPrinter = getMyPrinter(printer);
    await localApi.save(myPrinter);
    return myPrinter;
  }

  Future<MyPrinter?> getPrimaryPrinter() async {
    var localApi = locator.get<PrinterLocalApi>();
    return await localApi.getMyPrinter();
  }

  MyPrinter getMyPrinter(Printer printer) {
    MyPrinter myPrinter = MyPrinter(
        url: printer.url,
        model: printer.model ?? noData,
        name: printer.name,
        comment: printer.comment ?? noData,
        location: printer.location ?? printer.url,
        isDefault: printer.isDefault,
        isAvailable: printer.isAvailable);
    return myPrinter;
  }

  Printer getPrinterFromMyPrinter(MyPrinter myPrinter) {
    Printer printer = Printer(
        url: myPrinter.url,
        model: myPrinter.model,
        name: myPrinter.name,
        comment: myPrinter.comment,
        isAvailable: myPrinter.isAvailable,
        location: myPrinter.location,
        isDefault: myPrinter.isDefault);

    return printer;
  }
}
