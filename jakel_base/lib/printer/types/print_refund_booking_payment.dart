import 'package:jakel_base/restapi/bookingpayment/model/BookingPaymentsRefundResponse.dart';
import 'package:jakel_base/restapi/bookingpayment/model/BookingPaymentsResponse.dart';
import 'package:jakel_base/restapi/creditnotedetailsbyid/model/CreditNotesRefundResponce.dart';

import '../../constants.dart';

import '../../database/companyconfig/CompanyConfigLocalApi.dart';
import '../../database/user/UserLocalApi.dart';
import '../../jakel_base.dart';
import '../../locator.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../utils/num_utils.dart';

import '../printer_helper.dart';
import 'all_types_sale_print.dart';

Future<bool> printRefundBookingPayment(String? title,
    BookingPaymentRefund bookingPayment, bool duplicateCopy) async {
  var localUserApi = locator.get<UserLocalApi>();
  var user = await localUserApi.getCurrentUser();

  var companyConfigApi = locator.get<CompanyConfigLocalApi>();
  var companyConfig = await companyConfigApi.getConfig();

  List<pw.Widget> widgets = List.empty(growable: true);

  widgets.addAll(getStoreDetails(user?.store, user?.company?.name ?? '',
      companyConfig?.storeRegistrationNumber ?? '')); // Store details & header

  widgets.addAll(
      getCashierDetails(user?.counter, user?.cashier)); // Cashier Details

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

  widgets.addAll(getId(bookingPayment)); // Invoice
  widgets.add(mySeparator());
  widgets.add(pw.Container(height: 3));
  widgets.add(getLeftRightText(
      "Authorized By", "${bookingPayment.member!.id}")); // Status widget
  widgets.add(pw.Container(height: 3));
  widgets.add(mySeparator());
  widgets.add(pw.Container(height: 3));
  widgets.add(getItemsAmountWidget(bookingPayment)); // Invoice
  widgets.add(pw.Container(height: 3));
  widgets.add(mySeparator());
  widgets.add(pw.Container(height: 5));
  widgets.addAll(await getFooter(user)); // Receipt Footer

  return printWidgets(widgets, false, true);
}

pw.Widget getItemsAmountWidget(BookingPaymentRefund sale) {
  return pw.Table(columnWidths: {
    0: const pw.FractionColumnWidth(.6),
    1: const pw.FractionColumnWidth(.4),
  }, children: amountsRows(sale));
}

List<pw.TableRow> amountsRows(BookingPaymentRefund sale) {
  List<pw.TableRow> tableRows = List.empty(growable: true);

  tableRows.add(amountsRowBoldWidget(
    "REFUNDED AMOUNT",
    getOnlyReadableAmount((sale.totalAmount ?? 0)),
  ));

  tableRows.add(amountsRowBoldWidget(
    "BALANCE AMOUNT",
    getOnlyReadableAmount((sale.availableAmount ?? 0)),
  ));
  return tableRows;
}

List<pw.Widget> getId(BookingPaymentRefund sale) {
  List<pw.Widget> pwWidgets = List.empty(growable: true);

  pwWidgets.add(mySeparator());
  pwWidgets.add(pw.Container(height: 3));

  if (sale.id != null) {
    pwWidgets.add(pw.Center(
        child: pw.Text('Invoice : ${sale.id ?? noData}',
            style: getNormalTextStyle())));

    pwWidgets.add(pw.Container(height: 3));
    pwWidgets.add(barCodeWidget('${sale.id}'));
    pwWidgets.add(pw.Container(height: 3));
  }

  pwWidgets.add(pw.Container(height: 3));
  pwWidgets.add(mySeparator());
  return pwWidgets;
}

List<pw.Widget> getItemsWidget(BookingPayments sale) {
  List<pw.Widget> itemsWidgets = List.empty(growable: true);
  itemsWidgets.add(pw.Container(height: 5));
  itemsWidgets.add(getItemRowHeader());
  itemsWidgets.add(pw.Container(height: 5));
  itemsWidgets.add(mySeparator());
  itemsWidgets.add(pw.Container(height: 5));

  sale.products?.forEach((element) {
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
