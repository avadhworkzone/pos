import 'dart:typed_data';

import 'package:barcode/barcode.dart';
import 'package:jakel_base/constants.dart';
import 'package:jakel_base/database/companyconfig/CompanyConfigLocalApi.dart';
import 'package:jakel_base/jakel_base.dart';
import 'package:jakel_base/printer/types/open_cash_drawer_via_print_esc.dart';
import 'package:jakel_base/printer/types/printer_cut_via_print_esc.dart';
import 'package:jakel_base/restapi/counters/model/GetStoresResponse.dart';
import 'package:jakel_base/restapi/me/model/CurrentUserResponse.dart';
import 'package:jakel_base/restapi/sales/model/history/SaveSaleResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
// import 'package:package_info_plus/package_info_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../database/printer/PrinterLocalApi.dart';
import '../database/printer/model/MyPrinter.dart';
import '../database/user/UserLocalApi.dart';
import '../locator.dart';
import '../restapi/counters/model/GetCountersResponse.dart';
import '../restapi/vouchers/model/VouchersListResponse.dart';
import '../utils/appinfo/get_app_info.dart';
import '../utils/my_date_utils.dart';
import '../utils/num_utils.dart';
import '../widgets/custom/MySeparator.dart';
import 'PrinterViewModel.dart';

pw.Document createPDF(List<pw.Widget> allWidgets, bool isMultiPageNeeded) {
  final doc = pw.Document(version: PdfVersion.pdf_1_5, compress: false);

  const width = 2.65 * PdfPageFormat.inch;

  var height = isMultiPageNeeded ? (300.0 * PdfPageFormat.mm) : double.infinity;
  var pageFormat = PdfPageFormat(width, height);

  if (isMultiPageNeeded) {
    doc.addPage(pw.MultiPage(
      maxPages: 100,
      pageFormat: pageFormat,
      build: (pw.Context context) => allWidgets,
    ));
  } else {
    doc.addPage(pw.Page(
      pageFormat: pageFormat,
      build: (pw.Context context) => pw.Wrap(children: allWidgets),
    ));
  }

  return doc;
}

Future<bool> printWidgets(List<pw.Widget> widgets, bool isMultiPageNeeded,
    bool openCashDrawer) async {
  var localPrinter = locator.get<PrinterLocalApi>();

  MyPrinter? printer = await localPrinter.getMyPrinter();

  if (printer != null) {
    // Open cash drawer
    if (openCashDrawer) {
      await openCashDrawerViaPrinter(printer.name);
    }

    var result = await initiateAutomaticPrint(
        createPDF(widgets, isMultiPageNeeded),
        PrinterViewModel().getPrinterFromMyPrinter(printer));

    await cutReceiptViaEsc(printer.name);

    if (!result) {
      return initiateManualPrint(createPDF(widgets, isMultiPageNeeded));
    }

    return true;
  } else {
    return initiateManualPrint(createPDF(widgets, isMultiPageNeeded));
  }
}

Future<Uint8List> getUint8List(pw.Document doc) async {
  return await doc.save();
}

Future<bool> initiateManualPrint(pw.Document doc) async {
  return await Printing.layoutPdf(onLayout: (format) async => await doc.save());
}

Future<bool> initiateAutomaticPrint(pw.Document doc, Printer printer) async {
  var result = await Printing.directPrintPdf(
      printer: printer, onLayout: (format) async => await doc.save());
  return result;
}

pw.TextStyle getSmallBoldTextStyle() {
  return pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 6);
}

pw.TextStyle getBoldTextStyle() {
  return pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8);
}

pw.TextStyle getBoldTextStyleMedium() {
  return pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10);
}

pw.TextStyle getBoldTextStyleBig() {
  return pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16);
}

pw.TextStyle getNormalTextStyle() {
  return pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 8);
}

pw.TextStyle getSmallTextStyle() {
  return pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 6);
}

pw.Widget getLeftRightText(String text1, String text2) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.start,
    children: [
      pw.Padding(
        padding: pw.EdgeInsets.all(2.0),
        child: pw.Text(text1, style: getNormalTextStyle()),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.all(2.0),
        child: pw.Text(text2, style: getNormalTextStyle()),
      )
    ],
  );
}

pw.Widget getLeftRightText1(String text1, String text2) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
    children: [
      pw.Expanded(
        flex: 1,
        child: pw.Padding(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Align(
              alignment: pw.Alignment.centerLeft,
              child: pw.Text(text1, style: getNormalTextStyle())),
        ),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.all(2.0),
        child: pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(text2, style: getNormalTextStyle())),
      )
    ],
  );
}

pw.Widget getLeftRightTextBold(String text1, String text2) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
    children: [
      pw.Expanded(
        flex: 1,
        child: pw.Padding(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Align(
              alignment: pw.Alignment.centerLeft,
              child: pw.Text(text1, style: getBoldTextStyle())),
        ),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.all(2.0),
        child: pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(text2, style: getBoldTextStyle())),
      )
    ],
  );
}

List<pw.Widget> getStoreDetails(
    Stores? store, String companyName, String registrationNumber) {
  List<pw.Widget> pwWidgets = List.empty(growable: true);

  pwWidgets.add(pw.Container(height: 20));

  pwWidgets.add(
      pw.Center(child: pw.Text(companyName, style: getSmallBoldTextStyle())));

  pwWidgets.add(pw.Center(
      child: pw.Text(registrationNumber, style: getSmallBoldTextStyle())));

  pwWidgets.add(pw.Container(height: 5));

  pwWidgets.add(pw.Center(
      child: pw.Text(_getStoreName(store), style: getNormalTextStyle())));

  pwWidgets.add(pw.Center(
      child: pw.Text(_addressLine1(store), style: getNormalTextStyle())));

  pwWidgets.add(pw.Center(
      child: pw.Text(_addressLine2(store), style: getNormalTextStyle())));

  pwWidgets.add(pw.Center(
      child: pw.Text(_cityPinCode(store), style: getNormalTextStyle())));

  pwWidgets.add(
      pw.Center(child: pw.Text(_phone(store), style: getNormalTextStyle())));

  return pwWidgets;
}

List<pw.Widget> getCashierDetails(Counters? counter, Cashier? cashier) {
  List<pw.Widget> pwWidgets = List.empty(growable: true);

  pwWidgets.add(mySeparator());
  pwWidgets.add(pw.Container(height: 3));
  pwWidgets.add(getLeftRightText1("Counter", _getCounterName(counter)));
  pwWidgets.add(pw.Container(height: 3));
  String cashierName = _getCashierName(cashier);

  //If cashier name is bigger, then reduce font size & print in new line
  if (cashierName.length > 30) {
    pwWidgets.add(pw.Padding(
      padding: const pw.EdgeInsets.all(2.0),
      child: pw.Align(
          alignment: pw.Alignment.centerLeft,
          child: pw.Text("Cashier", style: getSmallTextStyle())),
    ));
    pwWidgets.add(pw.Container(height: 3));
    pwWidgets.add(pw.Padding(
      padding: const pw.EdgeInsets.all(2.0),
      child: pw.Align(
          alignment: pw.Alignment.centerLeft,
          child: pw.Text(cashierName, style: getSmallTextStyle())),
    ));
  } else {
    pwWidgets.add(getLeftRightText1("Cashier", _getCashierName(cashier)));
  }

  pwWidgets.add(pw.Container(height: 3));
  pwWidgets.add(mySeparator());
  return pwWidgets;
}

List<pw.Widget> getDateInfo(String? dateTime) {
  List<pw.Widget> pwWidgets = List.empty(growable: true);

  pwWidgets.add(mySeparator());
  pwWidgets.add(pw.Container(height: 3));
  try {
    if (dateTime != null) {
      pwWidgets.add(pw.Center(
          child: pw.Text(
              "Date : ${readableDateVeryBig(getDateFromYmdHis(dateTime).millisecondsSinceEpoch)}",
              style: getNormalTextStyle())));
    } else {
      pwWidgets.add(pw.Center(
          child: pw.Text(
              "Date : ${readableDateVeryBig(DateTime.now().millisecondsSinceEpoch)}",
              style: getNormalTextStyle())));
    }
  } catch (e) {
    MyLogUtils.logDebug("getDateInfo  exce: ${e}");
    if (dateTime != null) {
      pwWidgets.add(pw.Center(
          child: pw.Text("Date : $dateTime", style: getNormalTextStyle())));
    } else {
      pwWidgets.add(pw.Center(
          child: pw.Text(
              "Date : ${readableDateVeryBig(DateTime.now().millisecondsSinceEpoch)}",
              style: getNormalTextStyle())));
    }
  }
  pwWidgets.add(pw.Container(height: 3));
  pwWidgets.add(mySeparator());
  return pwWidgets;
}

List<pw.Widget> getInvoice(Sale sale) {
  List<pw.Widget> pwWidgets = List.empty(growable: true);

  pwWidgets.add(mySeparator());
  pwWidgets.add(pw.Container(height: 3));

  if (sale.offlineSaleId != null) {
    pwWidgets.add(pw.Center(
        child: pw.Text('Invoice : ${sale.offlineSaleId ?? noData}',
            style: getNormalTextStyle())));

    pwWidgets.add(pw.Container(height: 3));
    pwWidgets.add(barCodeWidget(sale.offlineSaleId ?? noData));
    pwWidgets.add(pw.Container(height: 3));
  }

  if (sale.offlineSaleReturnId != null) {
    pwWidgets.add(pw.Center(
        child: pw.Text(
            'Returns Invoice Id : ${sale.offlineSaleReturnId ?? noData}',
            style: getNormalTextStyle())));
    pwWidgets.add(pw.Container(height: 3));

    pwWidgets.add(barCodeWidget(sale.offlineSaleReturnId ?? noData));
    pwWidgets.add(pw.Container(height: 3));
  }

  pwWidgets.add(pw.Container(height: 3));
  pwWidgets.add(mySeparator());
  return pwWidgets;
}

List<pw.Widget> getOriginalInvoice(Sale sale) {
  List<pw.Widget> pwWidgets = List.empty(growable: true);

  pwWidgets.add(mySeparator());
  pwWidgets.add(pw.Container(height: 3));

  if (sale.creditNote!.originalSaleReceiptNumber != null) {
    pwWidgets.add(pw.Center(
        child: pw.Text('Original Invoice Id : ${sale.creditNote!.originalSaleReceiptNumber ?? noData}',
            style: getNormalTextStyle())));

    pwWidgets.add(pw.Container(height: 3));
    pwWidgets.add(barCodeWidget(sale.creditNote!.originalSaleReceiptNumber?? noData));
    pwWidgets.add(pw.Container(height: 3));
  }

  pwWidgets.add(pw.Container(height: 3));
  pwWidgets.add(mySeparator());
  return pwWidgets;
}

Future<List<pw.Widget>> getFooter(CurrentUserResponse? user) async {
  List<pw.Widget> pwWidgets = List.empty(growable: true);

  pwWidgets.add(pw.Center(
      child: pw.Text('THANK YOU & PLEASE COME AGAIN.',
          style: getNormalTextStyle(), textAlign: pw.TextAlign.center)));

  pwWidgets.add(pw.Center(
      child: pw.Text(_getFooter(user?.store),
          style: getNormalTextStyle(), textAlign: pw.TextAlign.center)));

  pwWidgets.add(pw.Center(
      child: pw.Text(_getDisclaimer(user?.store),
          style: getNormalTextStyle(), textAlign: pw.TextAlign.center)));

  pwWidgets.add(pw.Container(height: 3));
  pwWidgets.add(mySeparator());
  pwWidgets.add(pw.Container(height: 3));

  pwWidgets.add(pw.Center(
      child: pw.Text(
          "Printed on : ${readableDateVeryBig(DateTime.now().millisecondsSinceEpoch)}",
          style: getNormalTextStyle())));
  pwWidgets.add(pw.Container(height: 3));
  pwWidgets.add(mySeparator());

  pwWidgets.add(pw.Container(height: 3));
  var info = await getAppInformation(); //PackageInfo.fromPlatform();

  pwWidgets.add(pw.Center(
      child: pw.Text("-------- POS Version : ${info.version} --------",
          style: getSmallTextStyle())));

  pwWidgets.add(pw.Container(height: 3));
  pwWidgets.add(mySeparator());
  pwWidgets.add(pw.Container(height: 3));
  return pwWidgets;
}

String _getStoreName(Stores? store) {
  return (store?.name ?? noData).toUpperCase();
}

String _addressLine1(Stores? store) {
  return (store?.addressLine1 ?? noData).toUpperCase();
}

String _addressLine2(Stores? store) {
  return (store?.addressLine2 ?? noData).toUpperCase();
}

String _cityPinCode(Stores? store) {
  return '${store?.city ?? noData} - ${store?.areaCode}'.toUpperCase();
}

String _phone(Stores? store) {
  return 'TEL: ${store?.phone ?? noData}'.toUpperCase();
}

String _getFooter(Stores? store) {
  return (store?.receiptFooter ?? noData).toUpperCase();
}

String _getDisclaimer(Stores? store) {
  return (store?.disclaimer ?? noData).toUpperCase();
}

String _getCashierName(Cashier? cashier) {
  return ('${cashier?.firstName ?? noData} ${cashier?.lastName ?? ''}')
      .toUpperCase();
}

String _getCounterName(Counters? counter) {
  return (counter?.name ?? noData).toUpperCase();
}

pw.Widget mySeparator() {
  return pw.Container(
      child: MySeparator(PdfColor.fromHex("000000"),
          dashHeight: 0.1, totalWidth: 200));
}

String getVoucherDescription(Vouchers voucher) {
  MyLogUtils.logDebug("getVoucherDescription voucher : ${voucher.toJson()}");

  if (voucher.discountType == "FLAT" ||
      voucher.discountType == "Flat" ||
      voucher.discountType?.toLowerCase() == "flat") {
    return "Get flat ${getReadableAmount(getCurrency(), voucher.flatAmount ?? 0.0)}"
        " on your next purchase with minimum cart value of ${getReadableAmount(getCurrency(), voucher.minimumSpendAmount ?? 0.0)} or above. Please bring this bill to use this voucher.";
  }
  return "Get ${getOnlyReadableAmount(voucher.percentage ?? 0.0)} %"
      " on your next purchase with minimum cart value of ${getReadableAmount(getCurrency(), voucher.minimumSpendAmount ?? 0.0)} or above. Please bring this bill to use this voucher.";
}

pw.Widget barCodeWidget(String value, {bool? drawText = false}) {
  var shouldDrawText = false;

  if (drawText != null && drawText == true) {
    shouldDrawText = true;
  }
  return pw.Center(
      child: pw.BarcodeWidget(
          data: value,
          barcode: Barcode.fromType(BarcodeType.Code128),
          width: 150,
          drawText: shouldDrawText,
          height: 30));
}
