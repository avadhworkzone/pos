import 'package:jakel_base/constants.dart';

import 'package:jakel_base/printer/printer_helper.dart';
import 'package:jakel_base/restapi/customers/model/CustomersResponse.dart';
import 'package:jakel_base/restapi/vouchers/model/VouchersListResponse.dart';

import '../../database/companyconfig/CompanyConfigLocalApi.dart';
import '../../database/user/UserLocalApi.dart';
import '../../locator.dart';

import 'package:pdf/widgets.dart' as pw;

Future<bool> birthdayVoucherPrint(
    String? title, Customers customers, Vouchers vouchers) async {
  var localUserApi = locator.get<UserLocalApi>();
  var user = await localUserApi.getCurrentUser();

  var companyConfigApi = locator.get<CompanyConfigLocalApi>();
  var companyConfig = await companyConfigApi.getConfig();

  List<pw.Widget> widgets = List.empty(growable: true);

  widgets.addAll(getStoreDetails(user?.store, user?.company?.name ?? '',
      companyConfig?.storeRegistrationNumber ?? '')); // Store details & header

  widgets.add(pw.Container(height: 5));

  widgets.addAll(
      getCashierDetails(user?.counter, user?.cashier)); // Cashier Details

  if (title != null && title.isNotEmpty) {
    widgets.add(pw.Container(height: 3));
    widgets.add(mySeparator());
    widgets.add(pw.Container(height: 3));
    widgets.add(pw.Center(child: pw.Text(title, style: getNormalTextStyle())));
    widgets.add(pw.Container(height: 3));
    widgets.add(mySeparator());
  }

  widgets.add(pw.Container(height: 3));

  widgets.addAll(getDateInfo(null)); // Date

  widgets.add(pw.Container(height: 5));

  widgets.add(pw.Center(child: pw.Text("Member", style: getNormalTextStyle())));

  widgets.add(pw.Container(height: 5));

  widgets.add(getLeftRightText1("Name", customers.firstName ?? noData));

  widgets.add(pw.Container(height: 5));

  widgets.add(pw.Center(
      child: pw.Text(
          "HAPPY BIRTHDAY ${(customers.firstName ?? noData).toUpperCase()}",
          style: getBoldTextStyle())));

  widgets.add(pw.Container(height: 5));

  widgets.add(mySeparator());
  widgets.add(pw.Container(height: 2));
  widgets.add(mySeparator());

  widgets.add(pw.Container(height: 5));

  widgets.add(barCodeWidget(vouchers.number ?? noData, drawText: true));

  widgets.add(pw.Container(height: 5));

  widgets.add(pw.Center(
      child:
          pw.Text(getVoucherDescription(vouchers), style: getBoldTextStyle())));

  widgets.add(pw.Container(height: 5));

  widgets.add(getLeftRightTextBold("Expiry", '${vouchers.expiryDate}'));

  widgets.add(pw.Container(height: 5));
  widgets.add(mySeparator());
  widgets.add(pw.Container(height: 2));
  widgets.add(mySeparator());
  widgets.add(pw.Container(height: 5));

  widgets.addAll(await getFooter(user)); // Receipt Footer

  return printWidgets(widgets, false, false);
}
