import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jakel_base/database/sale/model/sale_booking_returns_data.dart';
import 'package:jakel_base/database/sale/model/sale_returns_data.dart';
import 'package:jakel_base/restapi/bookingpayment/model/BookingPaymentsResponse.dart';
import 'package:jakel_base/restapi/bookingpayment/model/BookingPaymentsTopUpResponse.dart';
import 'package:jakel_base/restapi/bookingpayment/model/BookingTopUpRequest.dart';
import 'package:jakel_base/restapi/paymenttypes/model/PaymentTypesResponse.dart';
import 'package:jakel_base/restapi/sales/model/history/SalesResponse.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/my_date_utils.dart';
import 'package:jakel_base/widgets/button/MyOutlineButton.dart';
import 'package:jakel_base/widgets/custom/MyIconTextWidget.dart';
import 'package:jakel_base/widgets/custom/MyLeftRightWidget.dart';
import 'package:jakel_base/widgets/custom/my_small_box_widget.dart';
import 'package:jakel_pos/modules/saleshistory/BookingPaymentViewModel.dart';
import 'package:jakel_pos/modules/saleshistory/ui/widgets/bookingpayments/booking_payment_dialog.dart';
import 'package:jakel_pos/modules/saleshistory/ui/widgets/dialog/initiate_booking_return_dialog.dart';
import 'package:jakel_pos/modules/saleshistory/ui/widgets/dialog/initiate_sale_return_dialog.dart';

import '../history/manager_authorization_widget.dart';

class BookingPaymentDetailWidget extends StatefulWidget {
  final BookingPayments selectedBookingPayment;
  final Function refreshWidget;
  final Function resetProductsInBookingPayments;

  const BookingPaymentDetailWidget(
      {Key? key,
      required this.selectedBookingPayment,
      required this.resetProductsInBookingPayments,
      required this.refreshWidget})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BookingPaymentDetailWidgetState();
  }
}

class _BookingPaymentDetailWidgetState
    extends State<BookingPaymentDetailWidget> {
  final viewModel = BookingPaymentViewModel();
  late BookingPayments bookingPayment;
  late Sales sale;

  @override
  void dispose() {
    super.dispose();
    viewModel.closeObservable();
  }

  @override
  Widget build(BuildContext context) {
    bookingPayment = widget.selectedBookingPayment;
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        constraints: const BoxConstraints.expand(),
        child: _getRootWidget(),
      ),
    );
  }

  _getRootWidget() {
    return SingleChildScrollView(
      child: Column(
        children: _getChildrenWidgets(),
      ),
    );
  }

  List<Widget> _getChildrenWidgets() {
    List<Widget> widgets = List.empty(growable: true);
    widgets.add(const SizedBox(
      height: 10,
    ));
    widgets.add(getTopWidget());

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(const Divider());

    widgets.add(Row(
      children: [
        Expanded(
            child: MySmallBoxWidget(
                title: "Cashier", value: viewModel.getCashier(bookingPayment))),
        Expanded(
            child: MySmallBoxWidget(
                title: "Counter", value: viewModel.getCounter(bookingPayment))),
      ],
    ));

    widgets.add(const SizedBox(
      height: 10,
    ));
    widgets.add(SizedBox(
        width: double.infinity,
        child: MySmallBoxWidget(
            title: "Member",
            value: viewModel.getCustomerName(bookingPayment))));
    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(getItemsWidgets());

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(Padding(
      padding: const EdgeInsets.all(5),
      child: MyLeftRightWidget(
          rStyle: Theme.of(context).textTheme.bodyLarge,
          lText: "Total Amount",
          rText: viewModel.getTotalAmount(bookingPayment)),
    ));

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(Padding(
      padding: const EdgeInsets.all(5),
      child: MyLeftRightWidget(
          rStyle: Theme.of(context).textTheme.bodyLarge,
          lText: "Available Amount",
          rText: viewModel.getAvailableAmount(bookingPayment)),
    ));

    widgets.add(const SizedBox(
      height: 10,
    ));
    return widgets;
  }

  Widget getTopWidget() {
    return IntrinsicHeight(
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        const SizedBox(
          width: 10,
        ),
        (viewModel.getIsBookingPaymentProducts(bookingPayment) &&
            viewModel.getIsActive(bookingPayment))
            ? MyOutlineButton(
                text: "Reset Items",
                backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
                onClick: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return InitiateBookingReturnDialog(
                          returnType: ReturnType.bookingReturn,
                          sale: bookingPayment,
                          resetProductsInBookingPayments:
                              (BookingItemsResetData saleReturnData) {
                            if (saleReturnData.returnItems!.isNotEmpty) {
                              widget.resetProductsInBookingPayments(
                                  saleReturnData);
                            }
                          });
                    },
                  );
                })
            : const SizedBox(),
        SizedBox(
          width: (viewModel.getIsBookingPaymentProducts(bookingPayment) &&
                  viewModel.getIsActive(bookingPayment))
              ? 10
              : 0,
        ),
        viewModel.getIsActive(bookingPayment)
            ? MyOutlineButton(
                text: "Top-up",
                onClick: () {
                  showDialog(
                      context: context,
                      builder: (context) => BookingPaymentDialog(
                            selectedBookingPayment:
                                widget.selectedBookingPayment,
                            onBookingPaymentUpdated: (PaymentTypes selected,
                                double topUpAmount) async {
                              BookingTopUpRequest mBookingTopUpRequest =
                                  BookingTopUpRequest(
                                      selectedBookingPaymentId:
                                          widget.selectedBookingPayment.id,
                                      paymentTypeId: selected.id,
                                      amount: topUpAmount,
                                      happenedAt: dateTimeYmdHis24Hour());
                              MyLogUtils.logDebug(
                                  "onBookingPaymentUpdated exception ${jsonEncode(mBookingTopUpRequest)} ");
                              BookingPaymentsTopUpResponse
                                  bookingPaymentsTopUpResponse =
                                  await viewModel.bookingPaymentsRefund(
                                      mBookingTopUpRequest);
                              if (bookingPaymentsTopUpResponse
                                      .bookingPaymentTopUp !=
                                  null) {
                                bookingPayment.totalAmount =
                                    bookingPaymentsTopUpResponse
                                            .bookingPaymentTopUp?.totalAmount ??
                                        0.0;
                                bookingPayment.availableAmount =
                                    bookingPaymentsTopUpResponse
                                            .bookingPaymentTopUp
                                            ?.availableAmount ??
                                        0.0;
                                widget.refreshWidget();
                              }
                            },
                          ));
                })
            : SizedBox(),
        SizedBox(
          width: viewModel.getIsActive(bookingPayment) ? 10 : 0,
        ),
        MyIconTextWidget(
          iconData: Icons.local_print_shop_rounded,
          text: "Print",
          onTap: () async {
            await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return ManagerAuthorizationWidget(
                  onSuccess: () {
                    viewModel.printBookingPayment(
                        "Booking Payment", bookingPayment, true);
                    showToast("Authorized to re print receipt.", context);
                  },
                );
              },
            );
          },
          isRightAligned: false,
        ),
        const SizedBox(
          width: 20,
        ),
        MyIconTextWidget(
          iconData: Icons.mail_outlined,
          text: "Mail",
          onTap: () {},
          isRightAligned: false,
        ),
        const SizedBox(
          width: 20,
        ),
      ]),
    );
  }

  Widget getItemsWidgets() {
    List<Widget> widgets = List.empty(growable: true);

    if (bookingPayment.products != null) {
      int page = 1;
      for (BookingProducts saleItem in bookingPayment.products!) {
        widgets.add(Container(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
          child: getItemsRow(saleItem, page),
        ));
        widgets.add(const Divider());
        page = page + 1;
      }
    }
    return Card(
      elevation: 2,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5),
          child: ExpansionTile(
            backgroundColor: getWhiteColor(context),
            collapsedBackgroundColor: getWhiteColor(context),
            initiallyExpanded: true,
            iconColor: Theme.of(context).primaryColor,
            title: Text("Sales Summary",
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.subtitle2),
            children: widgets,
          ),
        ),
      ),
    );
  }

  Widget getItemsRow(BookingProducts saleItem, int page) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$page. ${viewModel.getSaleItemName(saleItem)}",
                style: Theme.of(context).textTheme.caption,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                maxLines: 1,
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 5.0,
        ),
        Center(
          child: Text(
            viewModel.getSaleItemQty(saleItem),
            style: Theme.of(context).textTheme.caption,
          ),
        ),
      ],
    );
  }

  Widget promoters(SaleItems item) {
    if (item.promoters == null || item.promoters!.isEmpty) {
      return Container();
    }

    List<InlineSpan> spanTexts = List.empty(growable: true);

    item.promoters?.forEach((element) {
      if (spanTexts.length == 1) {
        spanTexts.add(
          TextSpan(text: ',', style: Theme.of(context).textTheme.caption),
        );
        spanTexts.add(
          TextSpan(text: ' ', style: Theme.of(context).textTheme.caption),
        );
      }
      spanTexts.add(TextSpan(
          text: element.firstName ?? "",
          style: Theme.of(context).textTheme.caption));
    });

    return Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          border: Border.all(
              color: Theme.of(context).primaryColor.withOpacity(0.2)),
        ),
        child: Text.rich(TextSpan(text: '', children: spanTexts)));
  }
}
