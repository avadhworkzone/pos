import 'dart:collection';

import 'package:jakel_base/constants.dart';
import 'package:jakel_base/jakel_base.dart';
import 'package:jakel_base/restapi/counters/model/CloseCounterRequest.dart';
import 'package:jakel_base/restapi/counters/model/ShiftDetailsResponse.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../database/companyconfig/CompanyConfigLocalApi.dart';
import '../../database/user/UserLocalApi.dart';
import '../../locator.dart';
import '../printer_helper.dart';

Future<bool> printCashDeclarationReceipt(
    String? title,
    CounterClosingDetails counterClosingDetails,
    List<Denominations> denominations,
    HashMap<int, double>? paymentDeclaration) async {
  var localUserApi = locator.get<UserLocalApi>();
  var user = await localUserApi.getCurrentUser();

  var companyConfigApi = locator.get<CompanyConfigLocalApi>();
  var companyConfig = await companyConfigApi.getConfig();

  List<pw.Widget> widgets = List.empty(growable: true);

  widgets.addAll(getStoreDetails(
      user?.store,
      user?.company?.name ?? '',
      companyConfig?.storeRegistrationNumber ??
          '')); // Store details & header // Store details & header

  widgets.addAll(getDateInfo(null)); // Date

  if (title != null && title.isNotEmpty) {
    widgets.add(mySeparator());
    widgets.add(pw.Container(height: 3));
    widgets.add(pw.Center(
        child: pw.Text("Cashier Declaration", style: getNormalTextStyle())));
    widgets.add(pw.Container(height: 3));
    widgets.add(mySeparator());
  }

  widgets.addAll(getCashierDetails(
      user?.counter, user?.cashier)); // Cashier Detailshier Details

  widgets.add(mySeparator());

  widgets.add(pw.Container(height: 5));
  widgets.addAll(getPaymentDeclarations(
      counterClosingDetails, denominations, paymentDeclaration));
  widgets.add(pw.Container(height: 5));

  widgets.add(mySeparator());

  widgets.add(pw.Container(height: 5));

  widgets.addAll(await getFooter(user)); // Receipt Footer

  return printWidgets(widgets, true, false);
}

List<pw.Widget> getPaymentDeclarations(
    CounterClosingDetails counterClosingDetails,
    List<Denominations> denominations,
    HashMap<int, double>? paymentDeclaration) {
  List<pw.Widget> widgets = List.empty(growable: true);

  int index = 1;
  double totalAmount = 0.0;
  counterClosingDetails.payments?.forEach((element) {
    if (element.paymentTypeId != bookingPaymentId &&
        element.paymentTypeId != loyaltyPointPaymentId &&
        element.paymentTypeId != creditNotePaymentId) {
      widgets.add(pw.Align(
          alignment: pw.Alignment.centerLeft,
          child: pw.Text('$index. ${element.paymentType ?? noData}',
              style: getNormalTextStyle())));

      // For cash Type
      if (element.paymentTypeId == cashPaymentId) {
        for (var value in denominations) {
          widgets.add(getDeclarations(
              "   >> RM ${value.denomination}",
              'x ${getInValue(value.quantity)}',
              getOnlyReadableAmount(getDoubleValue(value.denomination) *
                  getDoubleValue(value.quantity))));

          widgets.add(pw.Container(height: 2));
        }
      }

      double amount = paymentDeclaration?[element.paymentTypeId] ?? 0.0;
      totalAmount = totalAmount + amount;
      widgets.add(getLeftRightText1(
          "   >> Total", getReadableAmount(getCurrency(), amount)));
      index = index + 1;
      widgets.add(pw.Container(height: 4));
    }
  });

  widgets.add(mySeparator());
  widgets.add(pw.Container(height: 2));
  widgets.add(mySeparator());

  widgets.add(getLeftRightText1(
      "Grand Total", getReadableAmount(getCurrency(), totalAmount)));

  widgets.add(mySeparator());
  widgets.add(pw.Container(height: 2));
  widgets.add(mySeparator());

  widgets.add(pw.Container(height: 20));

  return widgets;
}

pw.Widget getDeclarations(String text1, String text2, String text3) {
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
      pw.Expanded(
        flex: 1,
        child: pw.Padding(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Align(
              alignment: pw.Alignment.center,
              child: pw.Text(text2, style: getNormalTextStyle())),
        ),
      ),
      pw.Expanded(
        flex: 1,
        child: pw.Padding(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(text3, style: getNormalTextStyle())),
        ),
      ),
    ],
  );
}
