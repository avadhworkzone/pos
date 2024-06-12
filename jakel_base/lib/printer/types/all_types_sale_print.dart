import 'package:jakel_base/constants.dart';
import 'package:jakel_base/database/promoters/PromotersLocalApi.dart';
import 'package:jakel_base/jakel_base.dart';
import 'package:jakel_base/printer/printer_helper.dart';
import 'package:jakel_base/restapi/sales/model/history/SaveSaleResponse.dart';
import 'package:jakel_base/sale/sale_helper.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../database/companyconfig/CompanyConfigLocalApi.dart';
import '../../database/user/UserLocalApi.dart';
import '../../locator.dart';
import '../../restapi/counters/model/GetCountersResponse.dart';
import '../../restapi/me/model/CurrentUserResponse.dart';
import '../../restapi/promoters/model/PromotersResponse.dart';
import '../../restapi/sales/model/history/SalesResponse.dart';
import '../../utils/num_utils.dart';

Future<bool> printSaleData(
    String? title, Sale sale, bool duplicateCopy, bool voidSale) async {
  var promoterLocalApi = locator.get<PromotersLocalApi>();

  var companyConfigApi = locator.get<CompanyConfigLocalApi>();
  var userApi = locator.get<UserLocalApi>();

  var userResponse = await userApi.getCurrentUser();
  var companyConfig = await companyConfigApi.getConfig();

  sale.saleItems?.forEach((element) {
    if (element.promoters != null) {
      List<Promoters> promoters = List.empty(growable: true);
      element.promoters?.forEach((element) async {
        promoters.add(await promoterLocalApi.getById(element.id ?? 0));
      });
      element.setPromoters(promoters);
    }
  });

  var localUserApi = locator.get<UserLocalApi>();
  var user = await localUserApi.getCurrentUser();

  List<pw.Widget> widgets = List.empty(growable: true);

  widgets.addAll(getStoreDetails(user?.store, userResponse?.company?.name ?? '',
      companyConfig?.storeRegistrationNumber ?? '')); // Store details & header

  // If cashier & counter comes as part of sale that should be used to print.
  Counters? counter = user?.counter;
  if (sale.counterDetails != null) {
    counter = Counters.fromJson(sale.counterDetails?.toJson());
  }

  Cashier? cashier = user?.cashier;
  if (sale.cashierDetails != null) {
    cashier = Cashier.fromJson(sale.cashierDetails?.toJson());
  }
  widgets.addAll(getCashierDetails(counter, cashier)); // Cashier Details

  if (title != null && title.isNotEmpty) {
    widgets.add(mySeparator());
    widgets.add(pw.Container(height: 3));
    widgets.add(pw.Center(child: pw.Text(title, style: getNormalTextStyle())));
    widgets.add(pw.Container(height: 3));
    widgets.add(mySeparator());
  }

  if (isLayawaySaleType(sale.status)) {
    widgets.add(mySeparator());
    widgets.add(pw.Container(height: 3));
    widgets.add(
        pw.Center(child: pw.Text('LAYAWAY SALE', style: getNormalTextStyle())));
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

  widgets.addAll(getDateInfo(sale.happenedAt)); // Date

  widgets.addAll(getInvoice(sale)); // Invoice

  //  original Invoice Id Return
  if (sale.creditNote != null &&
      sale.creditNote!.originalSaleReceiptNumber != null) {
    widgets.addAll(getOriginalInvoice(sale));
  }

  widgets.addAll(getItemsWidget(sale)); // Item Details

  widgets.addAll(getItemsCount(sale)); // Item Count Details

  widgets.add(getItemsAmountWidget(sale, title)); // Amount information

  widgets.add(pw.Container(height: 5));

  widgets.add(mySeparator());

  widgets.add(pw.Container(height: 5));

  widgets.add(getPaymentTypes(sale)); // Payment types Details

  // Add Cashback in receipt
  if ((sale.cashback ?? []).isNotEmpty) {
    widgets.add(pw.Container(height: 5));
    widgets.add(mySeparator());
    widgets.add(pw.Container(height: 5));

    widgets.add(
        pw.Center(child: pw.Text('Cashback', style: getNormalTextStyle())));

    sale.cashback?.forEach((element) {
      widgets.add(getLeftRightText1(element.name ?? '',
          getReadableAmount(getCurrency(), element.amount)));
    });
    widgets.add(pw.Container(height: 5));
  }

  if (sale.extraDetails != null && sale.extraDetails!.isNotEmpty) {
    widgets.add(pw.Container(height: 5));

    // Extra details
    sale.extraDetails?.forEach((element) {
      widgets.add(pw.Align(
          alignment: pw.Alignment.centerLeft,
          child: pw.Text(element, style: getNormalTextStyle())));
    });
  }

  widgets.add(pw.Container(height: 5));

  widgets.add(mySeparator());

  widgets.add(pw.Container(height: 5));

  if (sale.creditNote != null ||
      (sale.creditNotes != null && sale.creditNotes!.isNotEmpty)) {
    widgets.add(
        pw.Center(child: pw.Text("Credit Note", style: getNormalTextStyle())));

    widgets.add(pw.Container(height: 5));

    widgets.add(getCreditNote(sale)); // Payment types Details

    widgets.add(pw.Container(height: 5));
  }

  if (sale.usedVoucher != null && !voidSale) {
    widgets.addAll(
        getVoucherUsed(sale.usedVoucher, sale.userDetails)); //  Voucher used
    widgets.add(pw.Container(height: 5));
  }

  if (sale.userDetails != null) {
    widgets.addAll(getCustomerDetails(sale.userDetails)); //  Customer Details
    widgets.add(pw.Container(height: 5));
  }

  if (sale.voidReason != null) {
    widgets.add(getLeftRightText1("Reason", sale.voidReason ?? noData));

    widgets.add(pw.Container(height: 5));
  }

  widgets.add(getLeftRightText1("Remarks", sale.saleNotes ?? noData));

  widgets.add(pw.Container(height: 5));

  widgets.add(
      getLeftRightText1("Bill Ref No", sale.billReferenceNumber ?? noData));

  widgets.add(pw.Container(height: 5));

  getOriginalInvoiceIdAndReturnReason(sale, widgets);

  if (!isMoreThanOnePromoter(sale)) {
    widgets.addAll(promotersWidget(sale));
    widgets.add(pw.Container(height: 10));
  }

  if (!voidSale) {
    widgets.addAll(getVouchers(sale)); // Vouchers
    widgets.add(pw.Container(height: 5));
  }

  widgets.addAll(await getFooter(user)); // Receipt Footer

  var openCashCounter = false;

  sale.payments?.forEach((element) {
    if (element.paymentType?.id == cashPaymentId) {
      openCashCounter = true;
    }
  });

  if (duplicateCopy) {
    openCashCounter = false;
  }

  return printWidgets(widgets, true, openCashCounter);
}

getOriginalInvoiceIdAndReturnReason(Sale sale, List<pw.Widget> widgets) {
  if (sale.creditNote != null &&
      sale.creditNote!.originalSaleReceiptNumber != null &&
      sale.saleReturnItems != null &&
      sale.saleReturnItems!.isNotEmpty) {
    if (!isMoreThanOnePromoter(sale)) {
      widgets.addAll(promotersWidget(sale));

      widgets.add(pw.Container(height: 10));
    }

    widgets.add(
        pw.Center(child: pw.Text("Return Items", style: getNormalTextStyle())));

    widgets.add(pw.Container(height: 5));

    for (int i = 0; i < sale.saleReturnItems!.length; i++) {
      widgets.add(getLeftRightText1(
          "${i + 1}. ${sale.saleReturnItems![i].product!.name ?? noData}",
          sale.saleReturnItems![i].saleReturnReason!.reason ?? noData));
      widgets.add(pw.Container(height: 5));
    }
  }
}

List<pw.Widget> getItemsCount(Sale sale) {
  List<pw.Widget> widgets = List.empty(growable: true);

  widgets.add(pw.Container(height: 3));

  widgets.add(mySeparator());

  widgets.add(pw.Container(height: 3));

  widgets.add(getLeftRightText1("Total Items", getTotalItems(sale)));

  widgets.add(getLeftRightText1("Total Quantity", getTotalQuantity(sale)));

  if (sale.saleReturnItems != null && sale.saleReturnItems!.isNotEmpty) {
    widgets.add(
        getLeftRightText1("Total Return Items", getTotalReturnItems(sale)));

    widgets.add(getLeftRightText1(
        "Total Return Quantity", getTotalReturnQuantity(sale)));
  }

  widgets.add(pw.Container(height: 3));

  widgets.add(mySeparator());

  widgets.add(pw.Container(height: 3));

  return widgets;
}

List<pw.Widget> promotersWidget(Sale sale) {
  List<pw.Widget> widgets = List.empty(growable: true);
  widgets.add(mySeparator());

  var index = 1;
  List<int> alreadyAdded = List.empty(growable: true);
  sale.saleItems?.forEach((element) {
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
  widgets.add(mySeparator());

  return widgets;
}

List<pw.Widget> getItemsWidget(Sale sale) {
  List<pw.Widget> itemsWidgets = List.empty(growable: true);
  itemsWidgets.add(pw.Container(height: 5));
  itemsWidgets.add(getItemRowHeader());
  itemsWidgets.add(pw.Container(height: 5));
  itemsWidgets.add(mySeparator());
  itemsWidgets.add(pw.Container(height: 5));
  int index = 1;

  List<SaleItems> items = groupSaleItemAsPerArticle(sale.saleItems ?? []);

  // Regular Sale Items
  for (var element in items) {
    itemsWidgets.add(getSingleLineWidget(
        '$index. ${element.product?.name ?? noData} (${element.product?.articleNumber ?? ''})'));

    // itemsWidgets.add(getSingleLineSmallNormalWidget(element.product?.upc ?? noData));
    itemsWidgets.add(getLeftRightText1(element.product?.upc ?? noData,
        element.complimentary != null ? '[FOC]' : ''));

    // grouped size & color
    if (getSaleItemSizeColor(element) != null) {
      itemsWidgets.add(getSingleLineSmallNormalWidget(
          getSaleItemSizeColor(element) ?? noData));
    }

    // Show Promoters against line item
    if (isMoreThanOnePromoter(sale)) {
      itemsWidgets
          .add(getSingleLineSmallNormalWidget(getPromotersForItems(element)));
    }

    double discountPercent = getDiscountPercentFromAmount(
        element.totalDiscountAmount ?? 0,
        (((element.originalPricePerUnit ?? 0) * (element.quantity ?? 1))));

    discountPercent = roundToNearestPossible(discountPercent);

    if (discountPercent > 0) {
      itemsWidgets.add(getSingleLineWidget(
          'DISCOUNT : ${getStringWithNoDecimal(getOnlyReadableAmount(discountPercent))} %'));
    }

    if ((element.totalTaxAmount ?? 0) > 0) {
      itemsWidgets.add(getSingleLineWidget(
          'TAX : ${getOnlyReadableAmount(element.totalTaxAmount)}'));
    }

    itemsWidgets.add(getItemRow(element));
    index += 1;
  }

  // Sale Return Items
  sale.saleReturnItems?.forEach((element) {
    itemsWidgets.add(getSingleLineWidget(
        '$index. ${element.product?.name ?? noData} (Returns)'));

    itemsWidgets.add(getSingleLineWidget(element.product?.upc ?? noData));

    itemsWidgets
        .add(getSingleLineWidget(element.product?.size?.name ?? noData));

    itemsWidgets
        .add(getSingleLineWidget(element.product?.color?.name ?? noData));

    itemsWidgets.add(getItemRow(element));
    index += 1;
  });

  return itemsWidgets;
}

pw.Widget getItemRowHeader() {
  return pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly, children: [
    pw.Expanded(
        flex: 1,
        child: pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Align(
            alignment: pw.Alignment.centerLeft,
            child: pw.Text("Item", style: getBoldTextStyle()),
          ),
        )),
    pw.Expanded(
        flex: 2,
        child: pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Align(
            alignment: pw.Alignment.center,
            child: pw.Text("Qty", style: getBoldTextStyle()),
          ),
        )),
    pw.Expanded(
        flex: 2,
        child: pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text("Price", style: getBoldTextStyle()),
          ),
        )),
    pw.Expanded(
        flex: 2,
        child: pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text("Discount", style: getBoldTextStyle()),
          ),
        )),
    pw.Expanded(
        flex: 2,
        child: pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text("Total", style: getBoldTextStyle()),
          ),
        )),
  ]);
}

pw.Widget getItemRow(SaleItems ordersItem) {
  return pw.Row(children: [
    pw.Expanded(
        flex: 1,
        child: pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Align(
            alignment: pw.Alignment.centerLeft,
            child: pw.Text("", style: getNormalTextStyle()),
          ),
        )),
    pw.Expanded(
        flex: 2,
        child: pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Align(
            alignment: pw.Alignment.center,
            child: pw.Text(
                ordersItem.quantity != null
                    ? 'x ${getStringWithNoDecimal(getSaleItemQty(ordersItem))}'
                    : "x 0",
                style: getNormalTextStyle()),
          ),
        )),
    pw.Expanded(
        flex: 2,
        child: pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(getOnlyReadableAmount(getPricePerUnit(ordersItem)),
                style: getNormalTextStyle()),
          ),
        )),
    pw.Expanded(
        flex: 2,
        child: pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                  '${(ordersItem.totalDiscountAmount ?? 0) > 0 ? '-' : ''}${getOnlyReadableAmount(ordersItem.totalDiscountAmount ?? 0)}',
                  style: getNormalTextStyle())),
        )),
    pw.Expanded(
        flex: 2,
        child: pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(getOnlyReadableAmount(getTotalPricePaid(ordersItem)),
                style: getNormalTextStyle()),
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

pw.Widget getSingleLineSmallBoldWidget(String value) {
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

pw.Widget getSingleLineSmallNormalWidget(String value) {
  return pw.Row(children: [
    pw.Expanded(
        flex: 1,
        child: pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Align(
            alignment: pw.Alignment.centerLeft,
            child: pw.Text(value, style: getSmallTextStyle()),
          ),
        )),
  ]);
}

pw.TableRow amountsRowWidget(String text, String amount) {
  return pw.TableRow(children: [
    pw.Container(
      padding: const pw.EdgeInsets.all(2.0),
      // color: PdfColor.fromHex("D6D6D6"),
      child: pw.Align(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(text, style: getNormalTextStyle()),
      ),
    ),
    pw.Container(
      padding: const pw.EdgeInsets.all(2.0),
      child: pw.Align(
        alignment: pw.Alignment.centerRight,
        child: pw.Text(amount, style: getNormalTextStyle()),
      ),
    ),
  ]);
}

pw.TableRow amountsRowBoldWidget(String text, String amount) {
  return pw.TableRow(children: [
    pw.Container(
      padding: const pw.EdgeInsets.all(2.0),
      // color: PdfColor.fromHex("D6D6D6"),
      child: pw.Align(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(text, style: getBoldTextStyle()),
      ),
    ),
    pw.Container(
      padding: const pw.EdgeInsets.all(2.0),
      child: pw.Align(
        alignment: pw.Alignment.centerRight,
        child: pw.Text(amount, style: getBoldTextStyle()),
      ),
    ),
  ]);
}

pw.TableRow amountsTaxWidget(String text, String taxPercentage) {
  return pw.TableRow(children: [
    pw.Container(
      padding: const pw.EdgeInsets.all(2.0),
      //color: PdfColor.fromHex("D6D6D6"),
      child: pw.Align(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(text, style: getNormalTextStyle()),
      ),
    ),
    pw.Container(
      padding: const pw.EdgeInsets.all(2.0),
      child: pw.Align(
        alignment: pw.Alignment.centerRight,
        child: pw.Text(taxPercentage, style: getNormalTextStyle()),
      ),
    ),
  ]);
}

pw.Widget getItemsAmountWidget(Sale sale, String? title) {
  return pw.Table(columnWidths: {
    0: const pw.FractionColumnWidth(.6),
    1: const pw.FractionColumnWidth(.4),
  }, children: amountsRows(sale, title));
}

List<pw.TableRow> amountsRows(Sale sale, String? title) {
  List<pw.TableRow> tableRows = List.empty(growable: true);

  if (getSubTotal(sale) > 0) {
    tableRows.add(amountsRowBoldWidget(
      "SUB TOTAL",
      ((title ?? "") == "Pending Layaway Sale")
          ? getOnlyReadableAmount(getPendingLayawaySalesHistorySubTotal(sale))
          : getOnlyReadableAmount(getSubTotal(sale)),
    ));
  }

  var discountPercent = getDiscountPercentFromAmount(
      (sale.totalDiscountAmount ?? 0),
      ((sale.totalAmountPaid ?? 0)) +
          (sale.totalDiscountAmount ?? 0) -
          (sale.totalTaxAmount ?? 0));

  discountPercent = roundToNearestPossible(discountPercent);

  tableRows.add(amountsRowBoldWidget(
      "DISCOUNT :",
      ((title ?? "") == "Pending Layaway Sale")
          ? getOnlyReadableAmount(
              getCalculatePendingLayawayTotalDiscountAmount(sale))
          : '${(sale.totalDiscountAmount ?? 0) > 0 ? '-' : ''}${getOnlyReadableAmount((sale.totalDiscountAmount ?? 0))}'));

  if ((sale.totalTaxAmount ?? 0) > 0) {
    tableRows.add(amountsRowBoldWidget(
      "TAX",
      getOnlyReadableAmount((sale.totalTaxAmount ?? 0)),
    ));
  }

  if (sale.saleRoundOffAmount != null) {
    tableRows.add(amountsRowBoldWidget(
      "ROUNDING ADJUSTMENT",
      getOnlyReadableAmount((sale.saleRoundOffAmount ?? 0)),
    ));
  }

  tableRows.add(amountsRowBoldWidget(
    "TOTAL",
    getOnlyReadableAmount(getTotalAmount(sale)),
  ));

  tableRows.add(amountsRowBoldWidget(
    "TOTAL PAID",
    getOnlyReadableAmount(getTotalPaid(sale)),
  ));

  if ((sale.layawayPendingAmount ?? 0) > 0) {
    tableRows.add(amountsRowBoldWidget(
        "------------------------", "------------------------"));
    tableRows.add(amountsRowBoldWidget(
      "BALANCE",
      getOnlyReadableAmount(sale.layawayPendingAmount ?? 0),
    ));
    tableRows.add(amountsRowBoldWidget(
        "------------------------", "------------------------"));
  }

  if (!isLayawaySaleType(sale.status)) {
    tableRows.add(amountsRowBoldWidget(
      "CHANGE DUE",
      getOnlyReadableAmount(sale.changeDue ?? 0),
    ));
  }

  return tableRows;
}

pw.Widget getPaymentTypes(Sale sale) {
  return pw.Table(
      // border: pw.TableBorder(color: PdfColor.fromHex("000000")),
      columnWidths: {
        0: const pw.FractionColumnWidth(.6),
        1: const pw.FractionColumnWidth(.4),
      },
      children: getPaymentTypesRow(sale));
}

List<pw.TableRow> getPaymentTypesRow(Sale sale) {
  List<pw.TableRow> tableRows = List.empty(growable: true);

  sale.payments?.forEach((element) {
    tableRows.add(amountsRowWidget(element.paymentType?.name ?? noData,
        getOnlyReadableAmount(element.amount ?? 0)));
    if (element.happenedAt != null) {
      tableRows.add(pw.TableRow(children: [
        pw.Text('at ${element.happenedAt ?? noData}',
            style: getNormalTextStyle())
      ]));
    }
  });

  return tableRows;
}

pw.Widget getCreditNote(Sale sale) {
  return pw.Table(
      // border: pw.TableBorder(color: PdfColor.fromHex("000000")),
      columnWidths: {
        0: const pw.FractionColumnWidth(.6),
        1: const pw.FractionColumnWidth(.4),
      },
      children: getCreditNotes(sale));
}

List<pw.TableRow> getCreditNotes(Sale sale) {
  List<pw.TableRow> tableRows = List.empty(growable: true);

  if (sale.creditNote != null) {
    tableRows.add(amountsRowWidget('Id', '${sale.creditNote?.id ?? noData}'));
    tableRows.add(amountsRowWidget('Amount',
        getReadableAmount(getCurrency(), sale.creditNote?.totalAmount)));
    tableRows.add(amountsRowWidget('Available Amount',
        getReadableAmount(getCurrency(), sale.creditNote?.availableAmount)));
    tableRows.add(amountsRowWidget('Status', '${sale.creditNote?.status}'));
  }

  sale.creditNotes?.forEach((element) {
    tableRows.add(amountsRowWidget('Id', '${element.id ?? noData}'));
    tableRows.add(amountsRowWidget(
        'Amount', getReadableAmount(getCurrency(), element.availableAmount)));
  });

  return tableRows;
}

List<pw.Widget> getCustomerDetails(UserDetails? user) {
  List<pw.Widget> pwWidgets = List.empty(growable: true);

  pwWidgets.add(pw.Container(height: 5));

  pwWidgets
      .add(pw.Center(child: pw.Text("Member", style: getNormalTextStyle())));

  pwWidgets.add(pw.Container(height: 5));

  pwWidgets.add(getLeftRightText1("Name", user?.firstName ?? noData));

  pwWidgets.add(getLeftRightText1(
      "Previous Points", '${getInValue(user?.previousPoints ?? 0)}'));

  pwWidgets.add(getLeftRightText1(
      "This Sale Points", '${getInValue(user?.currentSalePoints ?? 0)}'));

  pwWidgets.add(getLeftRightText1(
      "Accumulated Points", '${getInValue(user?.accumulatedPoints ?? 0)}'));

  pwWidgets.add(pw.Container(height: 5));

  pwWidgets.add(mySeparator());

  return pwWidgets;
}

List<pw.Widget> getVoucherUsed(
    UsedVoucherInSale? voucher, UserDetails? details) {
  List<pw.Widget> pwWidgets = List.empty(growable: true);

  pwWidgets.add(pw.Container(height: 5));

  String title = "Voucher";

  //Happy Birthday Message
  if (voucher?.voucherType != null &&
      voucher!.voucherType!.contains("BIRTHDAY")) {
    title = "Birthday Voucher";

    pwWidgets.add(pw.Center(
        child: pw.Text(
            "Happy Birthday ${details?.firstName ?? ''}".toUpperCase(),
            style: getBoldTextStyle())));
  }

  // Welcome Message
  if (voucher?.voucherType != null &&
      voucher!.voucherType!.contains("WELCOME")) {
    title = "Welcome Voucher";

    pwWidgets.add(pw.Center(
        child: pw.Text("Welcome ${details?.firstName ?? ''}".toUpperCase(),
            style: getBoldTextStyle())));
  }

  pwWidgets.add(pw.Container(height: 5));

  pwWidgets.add(getLeftRightText1(
      title, getReadableAmount(currency, voucher?.amount ?? 0)));

  pwWidgets.add(pw.Container(height: 5));

  pwWidgets.add(mySeparator());

  return pwWidgets;
}

List<pw.Widget> getVouchers(Sale sale) {
  List<pw.Widget> pwWidgets = List.empty(growable: true);

  if (sale.vouchers != null && sale.vouchers!.isNotEmpty) {
    pwWidgets
        .add(pw.Center(child: pw.Text("Vouchers", style: getBoldTextStyle())));

    pwWidgets.add(pw.Container(height: 5));

    sale.vouchers?.forEach((element) {
      pwWidgets.add(mySeparator());
      pwWidgets.add(pw.Container(height: 2));
      pwWidgets.add(mySeparator());

      pwWidgets.add(pw.Container(height: 5));

      pwWidgets.add(pw.Container(height: 5));

      pwWidgets.add(barCodeWidget(element.number ?? noData, drawText: true));

      pwWidgets.add(pw.Container(height: 5));

      pwWidgets.add(pw.Center(
          child: pw.Text(getVoucherDescription(element),
              style: getBoldTextStyle())));

      pwWidgets.add(getLeftRightTextBold("Expiry", '${element.expiryDate}'));

      pwWidgets.add(pw.Container(height: 5));
      pwWidgets.add(mySeparator());
      pwWidgets.add(pw.Container(height: 2));
      pwWidgets.add(mySeparator());
      pwWidgets.add(pw.Container(height: 5));
    });
  }
  return pwWidgets;
}
