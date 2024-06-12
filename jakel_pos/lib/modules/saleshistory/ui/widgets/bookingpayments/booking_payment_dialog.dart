import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jakel_base/constants.dart';
import 'package:jakel_base/database/sale/model/PaymentTypeData.dart';
import 'package:jakel_base/restapi/bookingpayment/model/BookingPaymentsResponse.dart';
import 'package:jakel_base/restapi/creditnotedetailsbyid/model/CreditNotesApiResponse.dart';
import 'package:jakel_base/restapi/giftcards/model/GiftCardsResponse.dart';
import 'package:jakel_base/restapi/paymenttypes/model/PaymentTypesResponse.dart';
import 'package:jakel_base/restapi/sales/model/UpdateLayawayAmountRequest.dart';
import 'package:jakel_base/serialportdevices/model/MayBankPaymentDetails.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';
import 'package:jakel_base/widgets/custom/MyDataContainerWidget.dart';
import 'package:jakel_base/widgets/custom/MyLeftRightWidget.dart';
import 'package:jakel_base/widgets/custom/MyNumbersWidget.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';
import 'package:jakel_base/widgets/keyboard/KeyboardWidget.dart';
import 'package:jakel_pos/modules/refundCreditNote/RefundCreditNoteViewModel.dart';
import 'package:jakel_pos/modules/saleshistory/ui/widgets/bookingpayments/booking_credit_note_widget.dart';
import 'package:jakel_pos/modules/saleshistory/ui/widgets/bookingpayments/booking_enter_amount_widget.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:jakel_pos/modules/saleshistory/ui/widgets/bookingpayments/booking_gif_card_payment_widget.dart';
import 'package:jakel_pos/modules/saleshistory/ui/widgets/layaway_credit_note_widget.dart';

import '../../../../newsale/PaymentTypeViewModel.dart';
import '../../../SalesHistoryViewModel.dart';

class BookingPaymentDialog extends StatefulWidget {
  final BookingPayments selectedBookingPayment;
  final Function onBookingPaymentUpdated;

  const BookingPaymentDialog({
    Key? key,
    required this.selectedBookingPayment,
    required this.onBookingPaymentUpdated,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BookingPaymentDialogState();
  }
}

class _BookingPaymentDialogState extends State<BookingPaymentDialog> {
  late BookingPayments selectedBookingPayment;
  var paymentViewModel = PaymentTypeViewModel();
  PaymentTypes? selected;

  @override
  void initState() {
    selectedBookingPayment = widget.selectedBookingPayment;
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
          width: 600,
          height: 750,
          child: MyDataContainerWidget(
            child: getWidget(),
          ),
        ));
  }

  Widget getWidget() {
    return Column(children: [
      getHeader(),
      const SizedBox(
        height: 10,
      ),
      const Divider(),
      const SizedBox(
        height: 10,
      ),
      paymentWidget(),
      const SizedBox(
        height: 10,
      ),
      const Divider(),
      const SizedBox(
        height: 10,
      ),
      Container(
          child: selected == null ? const SizedBox() : getSelected(selected!)),
    ]);
  }

  ///Header view
  Widget getHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Update Booking Payment Amount',
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

  ///payment view
  Widget paymentWidget() {
    return SizedBox(
      height: 50,
      child: DropdownSearch<PaymentTypes>(
        compareFn: (item1, item2) {
          return false;
        },
        popupProps: const PopupProps.menu(
          showSelectedItems: true,
        ),
        dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
                labelText: "Payment Type",
                hintText: "Select payment",
                hintStyle: Theme.of(context).textTheme.caption,
                labelStyle: Theme.of(context).textTheme.caption,
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor.withOpacity(0.6),
                      width: 1),
                ))),
        asyncItems: (String filter) =>
            paymentViewModel.getAllFilteredBookingPaymentTypes(),
        onChanged: (value) {
          setState(() {
            selected = value;
          });
        },
        itemAsString: (item) {
          return item.name ?? noData;
        },
        selectedItem: selected,
      ),
    );
  }

  ///select PaymentTypes
  getSelected(PaymentTypes selected) {
    switch (selected.id) {
      case creditNotePaymentId:
        return Container();
      case bookingPaymentId:
        return Container();
      case loyaltyPointPaymentId:
        return Container();
      case giftCardPaymentId:
        return Container();
      default:
        return defaultWidget(selected);
    }
  }

// creditNoteView() {
//   return BookingCreditNoteWidget(
//     refundCreditNote: (CreditNote creditNote,double sentAmount) {
//       if (sentAmount > 0) {
//         ///widget.onBookingPaymentUpdated(selected, sentAmount);
//         Navigator.pop(context);
//       }
//     },
//     mRefundViewModel: RefundCreditNoteViewModel(),
//   );
// }
//
// giftCard(){
//   return BookingGiftCardPaymentWidget(
//       saveGiftCard: (GiftCards card, double amount) {
//
//       },
//   );
// }

  defaultWidget(PaymentTypes selected) {
    return BookingEnterAmountWidget(
        paymentTypeData:
            PaymentTypeData(paymentType: selected, amount: 0.0, cardNo: ""),
        onPaymentSelected: (
          double topUpAmount,
        ) {
          MyLogUtils.logDebug(
              "onPaymentSelected exception ${jsonEncode(selected)}  \n topUpAmount $topUpAmount");
          if (topUpAmount > 0) {
            widget.onBookingPaymentUpdated(selected, topUpAmount);
            Navigator.pop(context);
          }
        });
  }
}
