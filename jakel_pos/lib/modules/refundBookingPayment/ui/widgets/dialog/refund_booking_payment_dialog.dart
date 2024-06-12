import 'package:flutter/material.dart';
import 'package:jakel_base/restapi/bookingpayment/model/BookingPaymentsRefundResponse.dart';
import 'package:jakel_base/restapi/bookingpayment/model/BookingPaymentsResponse.dart';
import 'package:jakel_base/restapi/bookingpayment/model/BookingRefundRequest.dart';
import 'package:jakel_base/restapi/managers/model/StoreManagersResponse.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/utils/my_date_utils.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';
import 'package:jakel_base/widgets/custom/MyDataContainerWidget.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';
import 'package:jakel_pos/modules/refundBookingPayment/RefundBookingPaymentViewModel.dart';
import 'package:jakel_pos/modules/refundBookingPayment/ui/widgets/refund_booking_widget.dart';
import 'package:jakel_pos/modules/refundCreditNote/ui/widgets/refund_manager_authorization_widget.dart';

class RefundBookingPaymentDialog extends StatefulWidget {
  final Function onSuccess;

  const RefundBookingPaymentDialog({Key? key, required this.onSuccess})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RefundBookingPaymentDialogState();
  }
}

class _RefundBookingPaymentDialogState
    extends State<RefundBookingPaymentDialog> {
  BookingPayments? selectedBookingPayments;
  RefundBookingPaymentViewModel mRefundViewModel =
      RefundBookingPaymentViewModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.all(10.0),
          width: 500,
          height: 400,
          child: MyDataContainerWidget(
            child: getNumbersWidget(),
          ),
        ));
  }

  Widget getNumbersWidget() {
    return Column(
      children: [
        getHeader(),
        const SizedBox(
          height: 10,
        ),
        const Divider(),
        const SizedBox(
          height: 10,
        ),
        Expanded(child: bookingPaymentView()),
      ],
    );
  }

  Widget getHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Refund Booking Payment in Cash',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        MyInkWellWidget(
            child: const Icon(Icons.close),
            onTap: () {
              Navigator.pop(context);
            })
      ],
    );
  }

  bookingPaymentView() {
    return RefundBookingWidget(
      refundBookingPayments: (BookingPayments selectedBookingPayments) {
        _refundApiCall(selectedBookingPayments);
      },
      mRefundViewModel: mRefundViewModel,
    );
  }

  _refundApiCall(BookingPayments mBookingPayments) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return RefundManagerAuthorizationWidget(
            onSuccess: (StoreManagers mStoreManagers) {
              showToast("Authorized to open cash drawer.", context);
              _refundBookingApiCall(mBookingPayments);
            },
          );
        });
  }

  _refundBookingApiCall(BookingPayments mBookingPayments) async {
    BookingPaymentsRefundResponse mBookingPaymentsRefundResponse =
        await mRefundViewModel.bookingPaymentsRefund(
            BookingRefundRequest(
              refundPaymentTypeId: cashPaymentId.toString(),
              paymentTypeId: mBookingPayments.id.toString(),
              amount: mBookingPayments.availableAmount.toString(),
              happenedAt: dateTimeYmdHis()
            ),
            context);
    if (mBookingPaymentsRefundResponse.bookingPaymentRefund != null &&
        mBookingPaymentsRefundResponse.bookingPaymentRefund!.id != null) {
      widget.onSuccess(mBookingPaymentsRefundResponse.bookingPaymentRefund);
    } else {
      Navigator.pop(context);
    }
  }
}
