import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jakel_base/constants.dart';
import 'package:jakel_base/jakel_base.dart';
import 'package:jakel_base/restapi/bookingpayment/model/BookingPaymentsResponse.dart';
import 'package:jakel_base/restapi/creditnotedetailsbyid/model/CreditNotesApiResponse.dart';
import 'package:jakel_base/restapi/customers/model/CustomersResponse.dart';
import 'package:jakel_base/restapi/giftcards/model/GiftCardsResponse.dart';
import 'package:jakel_base/restapi/paymenttypes/model/PaymentTypesResponse.dart';
import 'package:jakel_base/restapi/sales/model/UpdateLayawayAmountRequest.dart';
import 'package:jakel_base/restapi/sales/model/UpdateLayawayLoyaltyPointsRequest.dart';
import 'package:jakel_base/restapi/sales/model/history/SalesResponse.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';
import 'package:jakel_base/widgets/button/MyOutlineButton.dart';
import 'package:jakel_base/widgets/custom/MyDataContainerWidget.dart';
import 'package:jakel_base/widgets/custom/MyLeftRightWidget.dart';
import 'package:jakel_base/widgets/custom/MyNumbersWidget.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';
import 'package:jakel_base/widgets/keyboard/KeyboardWidget.dart';
import 'package:jakel_base/widgets/loadingwidget/MyLoadingWidget.dart';
import 'package:jakel_pos/modules/newsale/ui/widgets/select_gift_card_widget.dart';
import 'package:jakel_pos/modules/refundBookingPayment/RefundBookingPaymentViewModel.dart';
import 'package:jakel_pos/modules/refundCreditNote/RefundCreditNoteViewModel.dart';
import 'package:jakel_pos/modules/saleshistory/ui/widgets/dialog/LayawayPaymentLoyaltyPointRequest.dart';
import 'package:jakel_pos/modules/saleshistory/ui/widgets/gif_card_layaway_payment_widget.dart';
import 'package:jakel_pos/modules/saleshistory/ui/widgets/layaway_credit_note_widget.dart';
import '../../../../newsale/CartViewModel.dart';
import '../../../../newsale/NewSaleViewModel.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../../../newsale/PaymentTypeViewModel.dart';
import '../../../SalesHistoryViewModel.dart';

class LayawayPaymentDialog extends StatefulWidget {
  final double pendingAmount;
  final Function onLayawayAmountUpdated;
  final Sales sale;

  const LayawayPaymentDialog(
      {Key? key,
      required this.pendingAmount,
      required this.onLayawayAmountUpdated,
      required this.sale})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LayawayPaymentDialogState();
  }
}

class _LayawayPaymentDialogState extends State<LayawayPaymentDialog> {
  final double numbersPadding = 20.0;
  final viewModel = CartViewModel();
  double paidAmount = 0.0;
  double totalAmount = 0.0;
  String enteredAmountAsString = "";
  double enteredAmount = 0.0;

  // double balanceChangeDue = 0.0;
  final newSaleViewModel = NewSaleViewModel();
  PaymentTypes? selected;
  final salesViewModel = SalesHistoryViewModel();
  var callApi = false;
  var paymentViewModel = PaymentTypeViewModel();

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
          height: 500,
          child: MyDataContainerWidget(
            child: buildKeyboardWidget(),
          ),
        ));
  }

  Widget buildKeyboardWidget() {
    if (callApi) {
      return updateLayawayAmountApi();
    }
    return getWidget();
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
      Expanded(
          child: selected == null ? const SizedBox() : getSelected(selected!)),
      getBottom()
    ]);
  }

  Widget getHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Update layaway amount',
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

  Widget paymentWidget() {
    Customers? customers = widget.sale.userDetails != null
        ? Customers.fromJson(widget.sale.userDetails?.toJson())
        : null;

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
            paymentViewModel.getAllFilteredPaymentTypes(customers),
        onChanged: (value) {
          setState(() {
            selected = value;
            salesViewModel.setEnteredAmount(0.0, widget.pendingAmount);
            salesViewModel.setBalanceChangeDue(0.0);
            if (selected!.id == loyaltyPointPaymentId) {
              salesViewModel.getCustomerDetails(widget.sale.userId ?? 0,
                  widget.pendingAmount, context, selected!.id ?? 0);
            } else if (selected!.id == bookingPaymentId) {
              salesViewModel.getCustomerDetails(widget.sale.userId ?? 0,
                  widget.pendingAmount, context, selected!.id ?? 0);
            }
          });
        },
        itemAsString: (item) {
          return item.name ?? noData;
        },
        selectedItem: selected,
      ),
    );
  }

  ///PaymentTypes view
  Widget getPaymentDropDown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Update layaway amount',
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

  ///select PaymentTypes
  getSelected(PaymentTypes selected) {
    switch (selected.id) {
      // case cashPaymentId:
      //   return KeyboardWidget(
      //       requestFocus: true,
      //       onEsc: () {
      //         Navigator.pop(context);
      //       },
      //       child: IntrinsicHeight(
      //         child: getNumbersWidget(),
      //       ),
      //       onNumber: (value) {
      //         appendAmountFromCalc("$value");
      //       },
      //       onDecimal: () {
      //         appendAmountFromCalc(".");
      //       },
      //       onEnter: () {
      //         addAmountFromAmountCalc("DONE");
      //       });

      case creditNotePaymentId:
        return creditNoteView();
      case bookingPaymentId:
        return bookingPaymentView();
      case loyaltyPointPaymentId:
        return loyaltyPointPaymentView();
       case giftCardPaymentId:
        return giftCard();
      default:
        return KeyboardWidget(
            requestFocus: true,
            onEsc: () {
              Navigator.pop(context);
            },
            child: IntrinsicHeight(
              child: getNumbersWidget(),
            ),
            onNumber: (value) {
              appendAmountFromCalc("$value");
            },
            onDecimal: () {
              appendAmountFromCalc(".");
            },
            onEnter: () {
              addAmountFromAmountCalc("DONE");
            });
    }
  }

  ///bottom view

  Widget getBottom() {
    return Column(
      children: [
        const Divider(
          height: 10,
          thickness: 2,
        ),
        enteredAmountView(),
        const Divider(
          thickness: 2,
          height: 10,
        ),
        balanceChangeDueView(),
        MyLeftRightWidget(
            lText: "Total",
            lStyle: const TextStyle(
              fontSize: 20,
            ),
            rStyle: const TextStyle(
              fontSize: 20,
            ),
            rText: getReadableAmount("RM", widget.pendingAmount)),
        const Divider(
          height: 10,
        ),
      ],
    );
  }

  enteredAmountView() {
    return StreamBuilder<double>(
      stream: salesViewModel.responseSubjectEnteredAmount,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          enteredAmount = snapshot.data as double;
          return MyLeftRightWidget(
              lText: "Entered Amount",
              lStyle: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
              rStyle: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
              rText: getReadableAmount("RM", enteredAmount));
        }
        return MyLeftRightWidget(
            lText: "Entered Amount",
            lStyle: TextStyle(
                fontSize: 20,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
            rStyle: TextStyle(
                fontSize: 20,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
            rText: getReadableAmount("RM", 0.0));
      },
    );
  }

  balanceChangeDueView() {
    return StreamBuilder<double>(
      stream: salesViewModel.responseSubjectBalanceChangeDue,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          var balanceChangeDue = snapshot.data as double;
          return Column(
            children: [
              balanceChangeDue > 0
                  ? MyLeftRightWidget(
                      lText: "Change Due",
                      lStyle: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold),
                      rStyle: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold),
                      rText: getReadableAmount("RM", balanceChangeDue))
                  : Container(),
              balanceChangeDue > 0
                  ? const Divider(
                      thickness: 2,
                      height: 10,
                    )
                  : Container(),
            ],
          );
        }
        return Container();
      },
    );
  }

  ///cash view
  Widget getNumbersWidget() {
    return Column(
      children: [
        Expanded(
            child: Row(
          children: [
            Expanded(
                child: MyNumbersWidget(
                    onCLick: () {
                      appendAmountFromCalc("1");
                    },
                    text: "1")),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: MyNumbersWidget(
                  onCLick: () {
                    appendAmountFromCalc("2");
                  },
                  text: "2"),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: MyNumbersWidget(
                  onCLick: () {
                    appendAmountFromCalc("3");
                  },
                  text: "3"),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: MyNumbersWidget(
                  onCLick: () {
                    appendAmountFromCalc("4");
                  },
                  text: "4"),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: MyNumbersWidget(
                  onCLick: () {
                    appendAmountFromCalc("5");
                  },
                  text: "5"),
            ),
          ],
        )),
        Expanded(
            child: Row(
          children: [
            Expanded(
              child: MyNumbersWidget(
                  onCLick: () {
                    appendAmountFromCalc("6");
                  },
                  text: "6"),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: MyNumbersWidget(
                  onCLick: () {
                    appendAmountFromCalc("7");
                  },
                  text: "7"),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: MyNumbersWidget(
                  onCLick: () {
                    appendAmountFromCalc("8");
                  },
                  text: "8"),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: MyNumbersWidget(
                  onCLick: () {
                    appendAmountFromCalc("9");
                  },
                  text: "9"),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: MyNumbersWidget(
                  onCLick: () {
                    appendAmountFromCalc("0");
                  },
                  text: "0"),
            ),
          ],
        )),
        Expanded(
            child: Row(
          children: [
            Expanded(
                child: MyNumbersWidget(
                    onCLick: () {
                      appendAmountFromCalc(".");
                    },
                    text: ".")),
            const SizedBox(
              width: 15,
            ),
            Expanded(
                child: MyNumbersWidget(
                    onCLick: () {
                      addAmountFromAmountCalc("EXACT");
                    },
                    text: "EXACT")),
            const SizedBox(
              width: 15,
            ),
            Expanded(
                child: MyNumbersWidget(
                    onCLick: () {
                      appendAmountFromCalc("DELETE");
                    },
                    text: "DELETE")),
            const SizedBox(
              width: 15,
            ),
            Expanded(
                child: MyNumbersWidget(
                    onCLick: () {
                      appendAmountFromCalc("CLEAR");
                    },
                    text: "CLEAR"))
          ],
        )),
        const SizedBox(
          height: 20,
        ),
        Expanded(
            child: MyNumbersWidget(
                onCLick: () {
                  addAmountFromAmountCalc("DONE");
                },
                text: "DONE")),
      ],
    );
  }

  void appendAmountFromCalc(String amount) {
    setState(() {
      if (amount == "CLEAR") {
        enteredAmountAsString = "";
        salesViewModel.setEnteredAmount(0.0, widget.pendingAmount);
        return;
      }

      if (amount == "DELETE" &&
          (enteredAmountAsString.isEmpty ||
              enteredAmountAsString == "0.0" ||
              enteredAmountAsString == "0")) {
        enteredAmountAsString = "";
        salesViewModel.setEnteredAmount(0.0, widget.pendingAmount);
        return;
      }

      if (amount == "DELETE") {
        enteredAmountAsString = enteredAmountAsString.substring(
            0, enteredAmountAsString.length - 1);

        // MyLogUtils.logDebug(
        //     "appendAmountFromCalc : $amount & enteredAmountAsString"
        //     " : $enteredAmountAsString & enteredAmount : $enteredAmount");

        if (enteredAmountAsString.isEmpty) {
          enteredAmountAsString = "";
          salesViewModel.setEnteredAmount(0.0, widget.pendingAmount);
        } else {
          salesViewModel.setEnteredAmount(
              getDoubleValue(enteredAmountAsString), widget.pendingAmount);
        }
        return;
      }

      if (widget.pendingAmount <= 0) {
        showToast("Expected amount should be greater than 0", context);
        return;
      }

      if (enteredAmountAsString.contains(".") && amount == ".") {
        return;
      }

      enteredAmountAsString = enteredAmountAsString + amount;
      salesViewModel.setEnteredAmount(
          getDoubleValue(enteredAmountAsString), widget.pendingAmount);
    });
  }

  void addAmountFromAmountCalc(String amount) {
    MyLogUtils.logDebug("addAmountFromAmountCalc : $amount");

    if (amount == "EXACT") {
      setState(() {
        salesViewModel.setEnteredAmount(
            widget.pendingAmount, widget.pendingAmount);
        enteredAmountAsString = '$enteredAmount';
      });
    }

    if (amount == "DONE") {
      //Check if the paid amount will be more than entered amount.
      if (selected == null) {
        showToast("Select payment", context);
        return;
      }
      double alreadyPaidAmount = 0;
      double totalPaidWillBe = alreadyPaidAmount + enteredAmount;

      double payableAmount = 0;
      if (totalPaidWillBe > widget.pendingAmount) {
        payableAmount = widget.pendingAmount;
      } else {
        payableAmount = enteredAmount;
      }

      var paymentTypeData =
          LayawayPayments(typeId: selected!.id, amount: payableAmount);
      _processLayawayAmount(paymentTypeData);
    }
  }

  void _processLayawayAmount(LayawayPayments payment) {
    setState(() {
      callApi = true;
      List<LayawayPayments> payments = List.empty(growable: true);
      payments.add(payment);
      salesViewModel.updateLayawayAmount(
          widget.sale.id ?? 0, UpdateLayawayAmountRequest(payments: payments));
    });
  }

  Widget updateLayawayAmountApi() {
    return StreamBuilder<SalesResponse>(
      stream: salesViewModel.responseSubject,
      // ignore: missing_return, missing_return
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MyLoadingWidget();
        }
        if (snapshot.hasError) {
          callApi = false;
          return buildKeyboardWidget();
        }
        if (snapshot.connectionState == ConnectionState.active) {
          var response = snapshot.data;
          if (response != null && response.sale != null) {
            showToast('Success!', context);
            goBack(response.sale!);
            return buildKeyboardWidget();
          } else {
            showToast('Failed.Please try again', context);
            callApi = false;
            return buildKeyboardWidget();
          }
        }
        return Container();
      },
    );
  }

  Future<void> goBack(Sales sale) async {
    salesViewModel.closeObservable();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onLayawayAmountUpdated(sale);
      Navigator.pop(context);
    });
  }

  creditNoteView() {
    return LayawayCreditNoteWidget(
      refundCreditNote: (CreditNote creditNote,double sentAmount) {
        var paymentTypeData = LayawayPayments(
            typeId: creditNotePaymentId,
            amount: sentAmount,
            creditNoteId: creditNote.id);

        _processLayawayAmount(paymentTypeData);
      },
      mRefundViewModel: RefundCreditNoteViewModel(),
      salesViewModel: salesViewModel,
      pendingAmount: widget.pendingAmount,
    );
  }

  bookingPaymentView() {
    return StreamBuilder<BookingPayments>(
        stream: salesViewModel.responseSubjectBookingPaymentDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            var sentAmount = widget.pendingAmount;
            if (widget.pendingAmount > snapshot.data!.availableAmount!) {
              sentAmount = snapshot.data!.availableAmount!;
            }
            if (RefundBookingPaymentViewModel()
                .isActiveBookingPayments(snapshot.data!)) {
              salesViewModel.setEnteredAmount(sentAmount, widget.pendingAmount);
            } else {
              sentAmount = 0.0;
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Status :"),
                        Text(snapshot.data!.status.toString()),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Booking Payment total amount :"),
                        Text(getReadableAmount(
                            getCurrency(), snapshot.data!.totalAmount)),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Booking Payment available amount :"),
                        Text(getReadableAmount(
                            getCurrency(), snapshot.data!.availableAmount)),
                      ],
                    ),
                    RefundBookingPaymentViewModel()
                            .isActiveBookingPayments(snapshot.data!)
                        ? const SizedBox(
                            height: 10,
                          )
                        : const SizedBox(),
                    RefundBookingPaymentViewModel()
                            .isActiveBookingPayments(snapshot.data!)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Booking Payment use amount :"),
                              Text(
                                  getReadableAmount(getCurrency(), sentAmount)),
                            ],
                          )
                        : const SizedBox(),
                  ],
                ),
                RefundBookingPaymentViewModel()
                        .isActiveBookingPayments(snapshot.data!)
                    ? SizedBox(
                        width: 100,
                        height: 40,
                        child: MyOutlineButton(
                          text: 'Done',
                          onClick: () {
                            var paymentTypeData = LayawayPayments(
                                typeId: bookingPaymentId,
                                amount: sentAmount,
                                bookingPaymentId: snapshot.data!.id);
                            _processLayawayAmount(paymentTypeData);
                          },
                        ),
                      )
                    : const SizedBox()
              ],
            );
          } else if (snapshot.hasError) {
            callApi = false;
            showToast('Error updating.Please try again later!', context);
            return Container(
              width: 100,
              height: 40,
              alignment: Alignment.center,
              child: SizedBox(
                height: 40,
                child: MyOutlineButton(
                  text: 'Try Again',
                  onClick: () {
                    salesViewModel.getCustomerDetails(widget.sale.userId ?? 0,
                        widget.pendingAmount, context, selected!.id ?? 0);
                  },
                ),
              ),
            );
          }

          return Container(
            width: 100,
            height: 40,
            alignment: Alignment.center,
            child: SizedBox(
              height: 40,
              child: MyOutlineButton(
                text: 'Try Again',
                onClick: () {
                  salesViewModel.getCustomerDetails(widget.sale.userId ?? 0,
                      widget.pendingAmount, context, selected!.id ?? 0);
                },
              ),
            ),
          );
        });
  }

  loyaltyPointPaymentView() {
    return StreamBuilder<LayawayPaymentLoyaltyPointRequest>(
      stream: salesViewModel.responseSubjectLoyaltyPaymentDetails,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          callApi = false;
          showToast('Error updating.Please try again later!', context);
          return Container(
            width: 100,
            height: 40,
            alignment: Alignment.center,
            child: SizedBox(
              height: 40,
              child: MyOutlineButton(
                text: 'Try Again',
                onClick: () {
                  salesViewModel.getCustomerDetails(widget.sale.userId ?? 0,
                      widget.pendingAmount, context, selected!.id ?? 0);
                },
              ),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.active) {
          LayawayPaymentLoyaltyPointRequest response =
              snapshot.data as LayawayPaymentLoyaltyPointRequest;
          if (response != null) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total Point :"),
                        Text(response.totalPoint.toString()),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Use Point :"),
                        Text(response.usePoint.toString()),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Use Amount :"),
                        Text(getReadableAmount(
                            getCurrency(), response.useAmount)),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  width: 100,
                  height: 40,
                  child: MyOutlineButton(
                    text: 'DONE',
                    onClick: () {

                      var paymentTypeData = LayawayPayments(
                          typeId: loyaltyPointPaymentId,
                          amount: double.parse(response.useAmount),
                          loyaltyPoints: int.parse(response.usePoint));
                      _processLayawayAmount(paymentTypeData);
                    },
                  ),
                )
              ],
            );
          }
        }
        return Container(
          width: 100,
          height: 40,
          alignment: Alignment.center,
          child: SizedBox(
            height: 40,
            child: MyOutlineButton(
              text: 'Try Again',
              onClick: () {
                salesViewModel.getCustomerDetails(widget.sale.userId ?? 0,
                    widget.pendingAmount, context, selected!.id ?? 0);
              },
            ),
          ),
        );
      },
    );
  }

  giftCard(){
    return GiftCardLayawayPaymentWidget(
        pendingAmount: widget.pendingAmount,
        saveGiftCard: (GiftCards card, double amount) {
          MyLogUtils.logDebug(
              "saveGiftCard : ${card.toJson()} & amount : $amount  & id ${card.id}");
          var paymentTypeData = LayawayPayments(
              typeId: giftCardPaymentId,
              amount: amount,
              giftCardId: card.id);
          _processLayawayAmount(paymentTypeData);

        },
    );
  }
}
