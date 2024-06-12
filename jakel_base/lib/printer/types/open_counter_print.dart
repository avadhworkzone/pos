import '../../database/companyconfig/CompanyConfigLocalApi.dart';
import '../../database/user/UserLocalApi.dart';
import '../../jakel_base.dart';
import '../../locator.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../restapi/counters/model/GetCountersResponse.dart';
import '../../restapi/counters/model/GetStoresResponse.dart';
import '../../utils/my_date_utils.dart';
import '../../utils/num_utils.dart';
import 'package:pdf/pdf.dart';
import '../../widgets/custom/MySeparator.dart';
import '../printer_helper.dart';

Future<bool> printOpenCounter(String? title, Stores? store, Counters? counters,
    double openingBalance, bool duplicateCopy) async {
  var localUserApi = locator.get<UserLocalApi>();
  var user = await localUserApi.getCurrentUser();

  var companyConfigApi = locator.get<CompanyConfigLocalApi>();
  var companyConfig = await companyConfigApi.getConfig();

  List<pw.Widget> widgets = List.empty(growable: true);

  // Store details
  widgets.addAll(getStoreDetails(
      store ?? user?.store,
      user?.company?.name ?? '',
      companyConfig?.storeRegistrationNumber ?? '')); // Store details & header

  // Date
  widgets.add(pw.Container(height: 5));
  widgets.addAll(getDateInfo(counters?.openedAt ?? dateTimeYmdHis())); // Date
  widgets.add(pw.Container(height: 30));

  // Title
  if (title != null && title.isNotEmpty) {
    widgets.add(mySeparator());
    widgets.add(pw.Container(height: 2));
    widgets.add(mySeparator());
    widgets.add(pw.Container(height: 3));
    widgets.add(pw.Center(child: pw.Text(title, style: getNormalTextStyle())));
    widgets.add(pw.Container(height: 3));
    widgets.add(mySeparator());
    widgets.add(pw.Container(height: 2));
    widgets.add(mySeparator());
  }

  // Cashier
  widgets.addAll(getCashierDetails(
      counters ?? user?.counter, user?.cashier)); // Cashier Details

  //Cash In Amount
  widgets.add(pw.Container(height: 3));
  widgets.add(getLeftRightText1(
      "Opening Amount", getReadableAmount(getCurrency(), openingBalance)));
  widgets.add(pw.Container(height: 3));

  widgets.add(mySeparator());
  widgets.add(pw.Container(height: 5));
  widgets.add(getSignOption());
  widgets.add(mySeparator());
  widgets.add(pw.Container(height: 5));
  widgets.addAll(await getFooter(user)); // Receipt Footer
  return printWidgets(widgets, false, !duplicateCopy);
}

pw.Widget getSignOption() {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
    children: [
      pw.Expanded(
        flex: 1,
        child: pw.Padding(
            padding: const pw.EdgeInsets.all(2.0),
            child: getSignatureWidget("Prepared By")),
      ),
      pw.Container(width: 20),
      pw.Expanded(
        flex: 1,
        child: pw.Padding(
            padding: const pw.EdgeInsets.all(2.0),
            child: getSignatureWidget("Checked By")),
      ),
    ],
  );
}

pw.Widget getSignatureWidget(String title) {
  return pw.Column(children: [
    pw.Align(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(title, style: getNormalTextStyle())),
    pw.Container(height: 40),
    pw.Container(
        child: MySeparator(PdfColor.fromHex("000000"),
            dashHeight: 0.1, totalWidth: 50)),
    pw.Container(height: 10),
    pw.Align(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text("Name:", style: getNormalTextStyle())),
    pw.Container(height: 5),
    pw.Align(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text("Staff Id:", style: getNormalTextStyle())),
    pw.Container(height: 5),
    pw.Align(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text("Position:", style: getNormalTextStyle())),
    pw.Container(height: 5)
  ]);
}
