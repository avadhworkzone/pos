import 'package:jakel_base/restapi/bookingpayment/model/BookingPaymentsResponse.dart';
import 'package:jakel_base/restapi/bookingpayment/model/ResetBookingResponse.dart';

import '../../constants.dart';

import '../../database/companyconfig/CompanyConfigLocalApi.dart';
import '../../database/user/UserLocalApi.dart';
import '../../locator.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../utils/num_utils.dart';

import '../printer_helper.dart';
import 'all_types_sale_print.dart';

Future<bool> printResetBookingPayment(
    String? title, BookingPaymentProducts sale, bool duplicateCopy) async {
  var localUserApi = locator.get<UserLocalApi>();
  var user = await localUserApi.getCurrentUser();

  var companyConfigApi = locator.get<CompanyConfigLocalApi>();
  var companyConfig = await companyConfigApi.getConfig();

  List<pw.Widget> widgets = List.empty(growable: true);

  widgets.addAll(getStoreDetails(user?.store, user?.company?.name ?? '',
      companyConfig?.storeRegistrationNumber ?? '')); // Store details & header


  if (title != null && title.isNotEmpty) {
    widgets.add(mySeparator());
    widgets.add(pw.Container(height: 3));
    widgets.add(pw.Center(child: pw.Text(title, style: getNormalTextStyle())));
    widgets.add(pw.Container(height: 3));
    widgets.add(mySeparator());
  }

  if (duplicateCopy) {
    widgets.add(mySeparator());
    widgets.add(pw.Container(height: 3));
    widgets.add(pw.Center(
        child: pw.Text('Duplicate Copy', style: getNormalTextStyle())));
    widgets.add(pw.Container(height: 3));
    widgets.add(mySeparator());
  }

  widgets.addAll(getDateInfo(sale.createdAt)); // Date

  widgets.addAll(getInvoice(sale)); // Invoice

  widgets.addAll(getItemsWidget(sale)); // Items

  widgets.add(getItemsAmountWidget(sale)); // Amounts widget

  widgets.add(mySeparator());

  widgets.add(pw.Container(height: 3));

  widgets.add(getPaymentTypes(sale)); // Payment Type widget

  widgets.add(pw.Container(height: 3));

  widgets.add(mySeparator());

  widgets.add(pw.Container(height: 3));
  widgets.add(getLeftRightText1("STATUS", "${sale.status}")); // Status widget
  widgets.add(pw.Container(height: 3));

  widgets.add(mySeparator());

  widgets.addAll(getCustomerDetails(sale.member)); //  Customer Details

  widgets.add(pw.Container(height: 5));

  widgets.add(getLeftRightText1("Remarks", sale.remarks ?? noData));

  widgets.add(pw.Container(height: 5));

  widgets.add(
      getLeftRightText1("Bill Ref No", sale.billReferenceNumber ?? noData));

  widgets.add(pw.Container(height: 5));

  widgets.addAll(promotersWidget(sale));

  widgets.add(pw.Container(height: 5));

  widgets.addAll(await getFooter(user)); // Receipt Footer

  var openCashCounter = false;

  sale.payments?.forEach((element) {
    if (element.paymentType?.toLowerCase() == 'cash') {
      openCashCounter = true;
    }
  });

  if (duplicateCopy) {
    openCashCounter = false;
  }
  return printWidgets(widgets, true, openCashCounter);
}

pw.Widget getItemsAmountWidget(BookingPaymentProducts sale) {
  return pw.Table(columnWidths: {
    0: const pw.FractionColumnWidth(.6),
    1: const pw.FractionColumnWidth(.4),
  }, children: amountsRows(sale));
}

List<pw.TableRow> amountsRows(BookingPaymentProducts sale) {
  List<pw.TableRow> tableRows = List.empty(growable: true);

  tableRows.add(amountsRowBoldWidget(
    "TOTAL AMOUNT",
    getOnlyReadableAmount((sale.totalAmount ?? 0)),
  ));

  tableRows.add(amountsRowBoldWidget(
    "AVAILABLE AMOUNT",
    getOnlyReadableAmount((sale.availableAmount ?? 0)),
  ));
  return tableRows;
}

List<pw.Widget> getInvoice(BookingPaymentProducts sale) {
  List<pw.Widget> pwWidgets = List.empty(growable: true);

  pwWidgets.add(mySeparator());
  pwWidgets.add(pw.Container(height: 3));

  if (sale.offlineId != null) {
    pwWidgets.add(pw.Center(
        child: pw.Text('Invoice : ${sale.offlineId ?? noData}',
            style: getNormalTextStyle())));

    pwWidgets.add(pw.Container(height: 3));
    pwWidgets.add(barCodeWidget('${sale.offlineId}'));
    pwWidgets.add(pw.Container(height: 3));
  } else {
    if (sale.id != null) {
      pwWidgets.add(pw.Center(
          child: pw.Text('Invoice : ${sale.id ?? noData}',
              style: getNormalTextStyle())));

      pwWidgets.add(pw.Container(height: 3));
      pwWidgets.add(barCodeWidget('${sale.id}'));
      pwWidgets.add(pw.Container(height: 3));
    }
  }

  pwWidgets.add(pw.Container(height: 3));
  pwWidgets.add(mySeparator());
  return pwWidgets;
}

List<pw.Widget> getItemsWidget(BookingPaymentProducts sale) {
  List<pw.Widget> itemsWidgets = List.empty(growable: true);
  itemsWidgets.add(pw.Container(height: 5));
  itemsWidgets.add(getItemRowHeader());
  itemsWidgets.add(pw.Container(height: 5));
  itemsWidgets.add(mySeparator());
  itemsWidgets.add(pw.Container(height: 5));

  // Regular Sale Items
  sale.products?.forEach((element) {
    //itemsWidgets.add(getSingleLineWidget(element.productName ?? noData));
    // itemsWidgets
    //     .add(getSingleLineWidget(element.product?.size?.name ?? noData));
    // itemsWidgets
    //     .add(getSingleLineWidget(element.product?.color?.name ?? noData));
    itemsWidgets.add(getItemRow(element));
  });
  itemsWidgets.add(pw.Container(height: 5));
  itemsWidgets.add(mySeparator());
  itemsWidgets.add(pw.Container(height: 5));
  return itemsWidgets;
}

pw.Widget getItemRowHeader() {
  return pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly, children: [
    pw.Expanded(
        flex: 3,
        child: pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Align(
            alignment: pw.Alignment.centerLeft,
            child: pw.Text("Item", style: getBoldTextStyle()),
          ),
        )),
    pw.Expanded(
        flex: 1,
        child: pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text("Qty", style: getBoldTextStyle()),
          ),
        )),
  ]);
}

pw.Widget getItemRow(BookingProducts product) {
  return pw.Row(children: [
    pw.Expanded(
        flex: 3,
        child: pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Align(
            alignment: pw.Alignment.centerLeft,
            child: pw.Text(product.productName ?? noData,
                style: getNormalTextStyle()),
          ),
        )),
    pw.Expanded(
        flex: 1,
        child: pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text('${product.quantity}', style: getNormalTextStyle()),
          ),
        )),
  ]);
}

pw.Widget getSingleLineWidget(String value) {
  return pw.Row(children: [
    pw.Expanded(
        flex: 1,
        child: pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Align(
            alignment: pw.Alignment.centerLeft,
            child: pw.Text(value, style: getNormalTextStyle()),
          ),
        )),
  ]);
}

pw.Widget getSingleLineSmallWidget(String value) {
  return pw.Row(children: [
    pw.Expanded(
        flex: 1,
        child: pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Align(
            alignment: pw.Alignment.centerLeft,
            child: pw.Text(value, style: getSmallBoldTextStyle()),
          ),
        )),
  ]);
}

pw.Widget getPaymentTypes(BookingPaymentProducts sale) {
  return pw.Table(
      // border: pw.TableBorder(color: PdfColor.fromHex("000000")),
      columnWidths: {
        0: const pw.FractionColumnWidth(.6),
        1: const pw.FractionColumnWidth(.4),
      }, children: getPaymentTypesRow(sale));
}

List<pw.TableRow> getPaymentTypesRow(BookingPaymentProducts sale) {
  List<pw.TableRow> tableRows = List.empty(growable: true);

  sale.payments?.forEach((element) {
    tableRows.add(amountsRowWidget(element.paymentType ?? noData,
        getOnlyReadableAmount(element.amount ?? 0)));
    if (element.createdAt != null) {
      tableRows.add(pw.TableRow(children: [
        pw.Text('at ${element.createdAt ?? noData}',
            style: getNormalTextStyle())
      ]));
    }
  });

  return tableRows;
}

List<pw.Widget> promotersWidget(BookingPaymentProducts sale) {
  List<pw.Widget> widgets = List.empty(growable: true);
  widgets.add(mySeparator());

  var index = 1;
  List<int> alreadyAdded = List.empty(growable: true);
  sale.products?.forEach((element) {
    element.promoters?.forEach((element) {
      if (!alreadyAdded.contains(element.id)) {
        alreadyAdded.add(element.id ?? 0);
        widgets.add(pw.Align(
            alignment: pw.Alignment.centerLeft,
            child: pw.Text(
                '$index. ${element.firstName}(${element.staffId ?? ''})',
                style: getNormalTextStyle()))); //
        index = index + 1;
      }
    });
  });

  sale.promoters?.forEach((element) {
    if (!alreadyAdded.contains(element.id)) {
      alreadyAdded.add(element.id ?? 0);
      widgets.add(pw.Align(
          alignment: pw.Alignment.centerLeft,
          child: pw.Text(
              '$index. ${element.firstName}(${element.staffId ?? ''})',
              style: getNormalTextStyle()))); //
      index = index + 1;
    }
  });

  widgets.add(mySeparator());

  return widgets;
}

bool isMoreThanOnePromoter(BookingPayments sale) {
  List<int> alreadyAdded = List.empty(growable: true);
  sale.products?.forEach((element) {
    element.promoters?.forEach((element) {
      if (!alreadyAdded.contains(element.id)) {
        alreadyAdded.add(element.id ?? 0);
      }
    });
  });

  return alreadyAdded.length > 1;
}
