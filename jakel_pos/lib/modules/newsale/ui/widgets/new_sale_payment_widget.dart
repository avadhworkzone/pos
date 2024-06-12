import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jakel_base/database/sale/model/CartItem.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/database/sale/model/PaymentTypeData.dart';
import 'package:jakel_base/jakel_base.dart';
import 'package:jakel_base/restapi/bookingpayment/model/BookingPaymentsResponse.dart';
import 'package:jakel_base/restapi/creditnotedetailsbyid/model/CreditNotesApiResponse.dart';
import 'package:jakel_base/restapi/giftcards/model/GiftCardsResponse.dart';
import 'package:jakel_base/restapi/managers/model/StoreManagersResponse.dart';
import 'package:jakel_base/restapi/paymenttypes/model/PaymentTypesResponse.dart';
import 'package:jakel_base/restapi/promoters/model/PromotersResponse.dart';
import 'package:jakel_base/restapi/sales/model/history/SaveSaleResponse.dart';
import 'package:jakel_base/serialportdevices/model/MayBankPaymentDetails.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/my_configuration_helper.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';
import 'package:jakel_base/widgets/custom/MyLeftRightWidget.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';
import 'package:jakel_base/widgets/loadingwidget/MyLoadingWidget.dart';
import 'package:jakel_base/widgets/networkimage/MyNetworkImage.dart';
import 'package:jakel_base/widgets/nodatawidget/NoDataWidget.dart';
import 'package:jakel_base/widgets/textfield/MyTextFieldWidget.dart';
import 'package:jakel_pos/modules/keyboardshortcuts/cash_in_keyboard_shortcuts.dart';
import 'package:jakel_pos/modules/newsale/CartViewModel.dart';
import 'package:jakel_pos/modules/newsale/ui/widgets/enter_amount_widget.dart';
import 'package:jakel_pos/modules/newsale/ui/widgets/select_credit_note_widget.dart';
import 'package:jakel_pos/modules/newsale/ui/widgets/select_gift_card_widget.dart';
import 'package:jakel_pos/modules/newsale/ui/widgets/select_loyalty_points_widget.dart';
import 'package:jakel_pos/modules/refundCreditNote/ui/widgets/refund_manager_authorization_widget.dart';

import '../../../saleshistory/ui/widgets/bookingpayments/booking_payments_widget.dart';
import '../../NewSaleViewModel.dart';
import '../../PaymentTypeViewModel.dart';
import '../dialog/multi_select_promoters_widget.dart';

class NewSalePaymentWidget extends StatefulWidget {
  final CartSummary cartSummary;
  final Function onPaymentSelected;
  final Function completeSale;
  final Function onRemarksEntered;
  final Function onBillRefEntered;
  final Function triggerCustomerPopUp;
  final Function onLoyaltyPaymentSelected;
  final Function removeLoyaltyPayment;
  final Function onPromotersAddedToCart;
  final Function onCreditNoteSelected;
  final Function onCreditNoteRemove;
  final Function onBookingPaymentSelected;
  final Function onBookingPaymentRemove;
  final Function onGiftCardSelected;
  final Function onGiftCardRemoved;
  final Function onAddCustomCartManualDiscount;

  NewSalePaymentWidget(
      {Key? key,
      required this.cartSummary,
      required this.onPaymentSelected,
      required this.completeSale,
      required this.onRemarksEntered,
      required this.onBillRefEntered,
      required this.triggerCustomerPopUp,
      required this.onLoyaltyPaymentSelected,
      required this.removeLoyaltyPayment,
      required this.onPromotersAddedToCart,
      required this.onCreditNoteSelected,
      required this.onCreditNoteRemove,
      required this.onBookingPaymentSelected,
      required this.onBookingPaymentRemove,
      required this.onGiftCardSelected,
      required this.onGiftCardRemoved,
      required this.onAddCustomCartManualDiscount})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NewSalePaymentWidgetState();
  }
}

class _NewSalePaymentWidgetState extends State<NewSalePaymentWidget> {
  final notesController = TextEditingController();
  final billRefController = TextEditingController();
  final notesNode = FocusNode();
  final billRefNode = FocusNode();
  var viewModel = NewSaleViewModel();
  var paymentViewModel = PaymentTypeViewModel();
  var cartViewModel = CartViewModel();
  List<PaymentTypes>? filteredLists;

  late CartSummary cartSummary;
  late List<CartItem> cartItems = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    notesNode.dispose();
    viewModel.closeObservable();
  }

  @override
  Widget build(BuildContext context) {
    cartSummary = widget.cartSummary;

    if (!cartSummary.isBookingSale &&
        (cartSummary.cartItems == null || cartSummary.cartItems!.isEmpty)) {
      notesController.text = "";
      billRefController.text = "";
    }

    ///billReferenceNumber
    if ((cartSummary.billReferenceNumber ?? "").isNotEmpty) {
      billRefController.text = cartSummary.billReferenceNumber ?? "";
    }

    //Place the cursor after actual text.
    billRefController.selection = TextSelection.fromPosition(
        TextPosition(offset: billRefController.text.length));

    notesController.selection = TextSelection.fromPosition(
        TextPosition(offset: notesController.text.length));

    return SizedBox(
      height: double.infinity,
      child: Card(
        child: getPaymentWidgets(),
      ),
    );
  }

  Widget getPaymentWidgets() {
    List<Widget> widgets = List.empty(growable: true);

    if (cartSummary.companyConfiguration?.allowPriceOverrideCartLevel == true) {
      widgets.add(getManualDiscountWidget());
      widgets.add(const SizedBox(
        height: 10,
      ));
    }

    widgets.add(MyLeftRightWidget(
      lText: "SubTotal",
      rText: getReadableAmount("RM", cartSummary.cartPrice?.subTotal),
    ));

    widgets.add(const Divider(
      height: 10,
    ));

    widgets.add(MyLeftRightWidget(
      lText: "Discount",
      rText: getReadableAmount("RM", cartSummary.cartPrice?.discount),
    ));

    widgets.add(const Divider(
      height: 10,
    ));

    widgets.add(MyLeftRightWidget(
      lText: "Tax",
      rText: getReadableAmount("RM", cartSummary.cartPrice?.tax),
    ));

    widgets.add(const Divider(
      height: 10,
    ));

    widgets.add(MyLeftRightWidget(
      lText: "Rounding",
      rText: getReadableAmount("RM", cartSummary.cartPrice?.roundOff),
    ));

    widgets.add(const Divider(
      height: 10,
    ));

    widgets.add(MyLeftRightWidget(
        lText: "Total",
        rText: getReadableAmount("RM", cartSummary.cartPrice?.total),
        lStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 20,
            fontWeight: FontWeight.bold),
        rStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 20,
            fontWeight: FontWeight.bold)));

    widgets.add(const Divider(
      height: 10,
    ));

    widgets.add(SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          getVerticalKeyValue(
              "Paid",
              getReadableAmount("RM",
                  cartSummary.getPaidAmount() + (cartSummary.changeDue ?? 0)),
              null),
          Container(
            width: 0.5,
            height: double.infinity,
            color: Theme.of(context).dividerColor,
          ),
          getVerticalKeyValue(
              "Due",
              getReadableAmount("RM", checkDue()),
              cartSummary.getDueAmount() > 0
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.green),
          Container(
            width: 0.5,
            height: double.infinity,
            color: Theme.of(context).dividerColor,
          ),
          getVerticalKeyValue(
              "Change Due",
              getChangeDueValue(),
              (cartSummary.changeDue ?? 0) > 0
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.green)
        ],
      ),
    ));

    widgets.add(const Divider(
      height: 10,
    ));

    widgets.add(Expanded(
      child: cartSummary.isBookingItemReset
          ? const SizedBox()
          : Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(
                left: 0.0, right: 0.0, top: 10, bottom: 10),
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Payment',
                  style: Theme.of(context).textTheme.caption,
                  textAlign: TextAlign.left,
                ),
                Container(
                    alignment: Alignment.centerRight,
                    child: CashInKeyboardShortcuts(
                        child: MyInkWellWidget(
                          child: Text(
                            "Show Total",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColor),
                          ),
                          onTap: () {
                            cartViewModel.createMessageForCustomerDisplay(
                                "Total amount",
                                getReadableAmount(
                                    getCurrency(), cartSummary.getDueAmount()));
                          },
                        ),
                        onAction: () {
                          cartViewModel.createMessageForCustomerDisplay(
                              "Total amount",
                              getReadableAmount(
                                  getCurrency(), cartSummary.getDueAmount()));
                        }))
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Expanded(child: paymentWidget())
        ],
      ),
    ));

    widgets.add(const Divider(
      height: 10,
    ));

    if (cartSummary.vouchers != null) {
      widgets.add(SelectableText(
        "Applied voucher: ${cartSummary.vouchers!.number}",
        style: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
      ));
      widgets.add(const Divider(
        height: 10,
      ));
    }

    if (cartSummary.selectedVoucherConfigs != null &&
        cartSummary.selectedVoucherConfigs!.isNotEmpty) {
      widgets.add(getVoucherConfigWidget());
      widgets.add(const Divider(
        height: 10,
      ));
    }

    if (cartSummary.cashBackAmount != null && cartSummary.cashBackAmount! > 0) {
      widgets.add(getCashbackMessage());
      widgets.add(const SizedBox(
        height: 10,
      ));
    }

    if (cartSummary.isBookingSale) {
      widgets.add(promoters(cartSummary.promoters));
      widgets.add(const SizedBox(
        height: 10,
      ));
    }

    widgets.add(SizedBox(
      height: 35,
      child: MyTextFieldWidget(
          controller: billRefController,
          node: billRefNode,
          onChanged: (value) {
            setState(() {
              widget.onBillRefEntered(value);
            });
          },
          hint: 'Bill Reference Number'),
    ));

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(SizedBox(
      height: 35,
      child: MyTextFieldWidget(
        controller: notesController,
        node: notesNode,
        hint: 'Remarks',
        onChanged: (value) {
          setState(() {
            widget.onRemarksEntered(value);
          });
        },
      ),
    ));

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(SizedBox(
      height: 40,
      width: double.infinity,
      child: completeSaleButtonWidget(),
    ));

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );
  }

  checkDue() {
    double dueAmount = cartSummary.getDueAmount();
    if (dueAmount >= 0.0 || cartSummary.isBookingSale) {
      return dueAmount;
    } else {
      setState(() {
        cartSummary.resetPaymentType();
      });
      return dueAmount;
    }
  }

  Widget getManualDiscountWidget() {
    return Container(
      color: (getPrimaryColor(context) as Color).withOpacity(0.2),
      padding: const EdgeInsets.all(4),
      child: MyInkWellWidget(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Add Cart Manual Discount',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
              )
            ],
          ),
          onTap: () {
            if (cartSummary.isExchange == true) {
              showToast(
                  "Cart manual discount is disabled with exchange.\nUse item wise manual discount.",
                  context);
              return;
            }
            if ((cartSummary.cartPrice?.total ?? 0) > 0) {
              widget.onAddCustomCartManualDiscount();
            } else {
              showToast("Total amount should be greater than 0.", context);
            }
          }),
    );
  }

  Widget getCashbackMessage() {
    return Text(
      "Cashback RM ${cartSummary.cashBackAmount} is applied for this sale.",
      textAlign: TextAlign.start,
      style: Theme.of(context).textTheme.caption,
    );
  }

  Widget getVoucherConfigWidget() {
    int voucherConfigLength = cartSummary.selectedVoucherConfigs!.length;

    return Text(
      "$voucherConfigLength ${voucherConfigLength <= 1 ? 'Voucher' : 'Vouchers'} will be created for this sale",
      style: Theme.of(context).textTheme.caption,
    );
  }

  Widget getVerticalKeyValue(String key, String value, Color? rColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          key,
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 15,
          ),
        ),
        Text(value,
            style: TextStyle(
                color: rColor ?? Theme.of(context).colorScheme.primary,
                fontSize: 20,
                fontWeight: FontWeight.bold))
      ],
    );
  }

  Widget paymentWidget() {
    return FutureBuilder(
        future: paymentViewModel.getFilteredPaymentTypes(
            cartSummary, filteredLists),
        builder: (BuildContext context,
            AsyncSnapshot<List<PaymentTypes>?> snapshot) {
          if (snapshot.hasData) {
            filteredLists = snapshot.data;
            return paymentListWidget();
          }
          return const Text("Loading ...");
        });
  }

  Widget paymentListWidget() {
    if (filteredLists == null || filteredLists!.isEmpty) {
      return const NoDataWidget();
    }

    paymentViewModel.sortPaymentTypes(filteredLists!);

    return ListView.separated(
        separatorBuilder: (context, index) => Divider(
              color: Theme.of(context).dividerColor,
            ),
        shrinkWrap: true,
        itemCount: filteredLists!.length,
        itemBuilder: (context, index) {
          return paymentListRowWidget(filteredLists![index]);
        });
  }

  Widget paymentListRowWidget(PaymentTypes paymentTypes) {
    double addedAmount =
        paymentViewModel.checkAndGetExistingPayment(cartSummary, paymentTypes);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: Row(
          children: [
            MyNetworkImage(
              imageUrl: paymentTypes.image ?? "",
              height: 20,
              width: 20,
            ),
            const SizedBox(
              width: 10,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: addedAmount > 0
                      ? Colors.green
                      : Theme.of(context).colorScheme.tertiary),
              onPressed: () {
                if (cartSummary.isExchange != null && cartSummary.isExchange!) {
                  showToast(
                      "You can't able to select the payment type", context);
                } else if (paymentTypes.id == bookingPaymentId) {
                  if (cartSummary.isBookingSale) {
                    showToast(
                        "You can't able to select the payment type", context);
                  } else {
                    _showBookingPaymentsDialog(addedAmount, paymentTypes);
                  }
                } else if (paymentTypes.id == loyaltyPointPaymentId) {
                  if (cartSummary.isBookingSale) {
                    showToast(
                        "You can't able to select the payment type", context);
                  } else {
                    _showLoyaltyPaymentDialog(paymentTypes);
                  }
                } else if (paymentTypes.id == giftCardPaymentId) {
                  if (cartSummary.isBookingSale) {
                    showToast(
                        "You can't able to select the payment type", context);
                  } else {
                    _showGiftCard(addedAmount, paymentTypes);
                  }
                } else if (paymentTypes.id == creditNotePaymentId) {
                  if (cartSummary.isBookingSale) {
                    showToast(
                        "You can't able to select the payment type", context);
                  } else {
                    _showCreditNote(addedAmount, paymentTypes);
                  }
                } else {
                  if (cartSummary.isBookingSale &&
                      cartSummary.payments != null &&
                      cartSummary.payments!.isNotEmpty &&
                      addedAmount == 0.0 &&
                      cartSummary.getDueAmount() != 0.0) {
                    showToast(
                        "You can't able to select the payment type", context);
                  } else {
                    String cardNo = paymentViewModel.checkAndGetExistingCardNo(
                        cartSummary, paymentTypes);
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) => EnterAmountWidget(
                            paymentTypeData: PaymentTypeData(
                                paymentType: paymentTypes,
                                amount: addedAmount,
                                cardNo: cardNo),
                            cartSummary: widget.cartSummary,
                            onPaymentSelected: (PaymentTypeData paymentTypeData,
                                double balanceChangeDue,
                                MayBankPaymentDetails? details,
                                bool completeSale) {
                              _onPaymentUpdated(
                                completeSale,
                                details,
                                paymentTypeData,
                                this.context,
                                balanceChangeDue,
                              );
                            }));
                  }
                }
              },
              child: Text(
                paymentTypes.name!,
              ),
            ),
            paymentViewModel.showAddIcon(cartSummary, paymentTypes)
                ? MyInkWellWidget(
                    child: const Icon(Icons.add),
                    onTap: () {
                      setState(() {
                        filteredLists?.add(paymentViewModel
                            .getPaymentTypeWithLocalId(paymentTypes));
                      });
                    })
                : Container()
          ],
        )),
        const SizedBox(
          width: 10,
        ),
        addedAmount > 0
            ? const Icon(
                Icons.check_circle,
                size: 15,
                color: Colors.green,
              )
            : const SizedBox(
                width: 15,
              ),
        const SizedBox(
          width: 10,
        ),
        Text(getReadableAmount("RM", addedAmount)),
      ],
    );
  }

  void _onPaymentUpdated(
      bool completeSale,
      MayBankPaymentDetails? details,
      PaymentTypeData paymentTypeData,
      BuildContext context,
      double balanceChangeDue) {
    MyLogUtils.logDebug("onPaymentSelected completeSale :$completeSale "
        "& MayBankPaymentDetails => ${details?.toJson()}");

    // If May Bank terminal gives response,
    // then check for its card type.
    if (details != null) {
      PaymentTypes? type = paymentTypeData.paymentType;
      bool foundMatchingPaymentType = false;
      filteredLists?.forEach((element) {
        MyLogUtils.logDebug(
            "onPaymentSelected with mbb cardType => ${details.cardType} "
            "for ${element.name}"
            "& paymentTerminalKey => ${element.paymentTerminalKey}");
        if (details.cardType != null &&
            details.cardType == element.paymentTerminalKey) {
          type = element;
          foundMatchingPaymentType = true;
        }
      });

      MyLogUtils.logDebug(
          "onPaymentSelected mbb foundMatchingPaymentType : $foundMatchingPaymentType");

      if (!foundMatchingPaymentType) {
        String errorMessage =
            "Card type from MBB : ${details.cardType} not matched with any our payment type terminal key configured in backend."
            "So, MBB will be used as the payment type. Please contact admin to update this card type in admin panel against the respective payment type";
        showWarning(errorMessage, context);
        MyLogUtils.logDebug(
            "Payment terminal key error message: $errorMessage");
      }
      MyLogUtils.logDebug("onPaymentSelected type :${type?.toJson()}");

      if (foundMatchingPaymentType && type != null) {
        // If there is match, add one more payment type to be used for next payment if added.
        // This is only to handle the case where same card is used for making payment multiple time in mbb.
        // If duplicate payment type issue is reported then we need to add filter here to add only if already exists in cartsummary payment type.
        filteredLists?.add(paymentViewModel.getPaymentTypeWithLocalId(type!));
      }

      var newPaymentTypeData = PaymentTypeData(
          cardNo: paymentTypeData.cardNo,
          amount: paymentTypeData.amount,
          bookingPayments: paymentTypeData.bookingPayments,
          paymentType: type);

      widget.onPaymentSelected(
          newPaymentTypeData,
          paymentTypeData.paymentType?.localId,
          balanceChangeDue,
          details,
          completeSale);
    } else {
      widget.onPaymentSelected(
          paymentTypeData, null, balanceChangeDue, details, completeSale);
    }

    if (completeSale) {
      _completeSale();
    }
  }

  void _showLoyaltyPaymentDialog(PaymentTypes paymentTypes) {
    int sLoyaltyPaymentId =
        paymentViewModel.getLoyaltyPaymentId(cartSummary, paymentTypes);

    if (cartSummary.getDueAmount() > 0.0 || sLoyaltyPaymentId != -1) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => SelectLoyaltyPointsWidget(
              usesLoyaltyPaymentPoints: sLoyaltyPaymentId,
              customers: cartSummary.customers!,
              totalPayableAmount: cartSummary.getDueAmount(),
              savePoints: (points, amount) {
                MyLogUtils.logDebug("savePoints : $points & amount : $amount");
                widget.onLoyaltyPaymentSelected(
                    PaymentTypeData(paymentType: paymentTypes, amount: amount),
                    points,
                    amount);
              },
              removePoints: () {
                widget.removeLoyaltyPayment(
                    PaymentTypeData(paymentType: paymentTypes, amount: 0.0));
              }));
    } else {
      showToast("Please use cart items to check this condition.", context);
    }
  }

  void _showGiftCard(double addedAmount, PaymentTypes paymentTypes) {
    if (addedAmount > 0) {
      int sGiftCardId =
          paymentViewModel.getGiftCardId(cartSummary, paymentTypes);
      double sAmount =
          paymentViewModel.getGiftCardAmount(cartSummary, paymentTypes);
      _showGiftCardPaymentDialog(paymentTypes, sGiftCardId, sAmount);
    } else {
      _showGiftCardPaymentDialog(paymentTypes, -1, 0.0);
    }
  }

  void _showGiftCardPaymentDialog(
      PaymentTypes paymentTypes, int sGiftCardId, double sAmount) {
    if ((cartSummary.getDueAmount() > 0.0) || (sGiftCardId != -1)) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => SelectGiftCardWidget(
              sGiftCardId: sGiftCardId,
              totalPayableAmount: cartSummary.getDueAmount(),
              removeAmount: sAmount,
              saveGiftCard: (GiftCards card, double amount) {
                MyLogUtils.logDebug(
                    "saveGiftCard : ${card.toJson()} & amount : $amount");
                widget.onGiftCardSelected(
                    PaymentTypeData(paymentType: paymentTypes, amount: amount),
                    card,
                    amount);
              },
              removeGiftCard: (GiftCards card, double amount) {
                widget.onGiftCardRemoved(
                    PaymentTypeData(
                      paymentType: paymentTypes,
                      amount: amount,
                    ),
                    card,
                    amount);
              }));
    } else {
      showToast("Please use cartItems to check this condition.", context);
    }
  }

  void _showCreditNote(double addedAmount, PaymentTypes paymentTypes) {
    if (addedAmount > 0) {
      int sCreditNoteId =
          paymentViewModel.getCreditNoteId(cartSummary, paymentTypes);
      double sAmount =
          paymentViewModel.getCreditNoteAmount(cartSummary, paymentTypes);
      _showCreditNotePayment(paymentTypes, sCreditNoteId, sAmount);
    } else {
      _showCreditNotePayment(paymentTypes, -1, 0.0);
    }
  }

  void _showCreditNotePayment(
      PaymentTypes paymentTypes, int sCreditNoteId, double sAmount) {
    if ((cartSummary.getDueAmount() > 0.0) || (sCreditNoteId != -1)) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => SelectCreditNoteWidget(
                sCreditNoteId: sCreditNoteId,
                totalPayableAmount: cartSummary.getDueAmount(),
                removeAmount: sAmount,
                saveCreditNote:
                    (CreditNote creditNote, double amount, double dueAmount) {
                  MyLogUtils.logDebug(
                      "CreditNote : ${creditNote.toJson()} & amount : $amount");
                  widget.onCreditNoteSelected(
                      PaymentTypeData(
                          paymentType: paymentTypes, amount: amount),
                      creditNote,
                      amount,
                      dueAmount);
                },
                removeCreditNote: (CreditNote creditNote, double amount) {
                  MyLogUtils.logDebug(
                      "CreditNote : ${creditNote.toJson()} & amount : $amount");
                  widget.onCreditNoteRemove(
                      PaymentTypeData(
                          paymentType: paymentTypes,
                          amount: amount,
                          creditNoteId: creditNote.id),
                      creditNote,
                      amount);
                },
              ));
    } else {
      showToast("Please use cart items to check this condition.", context);
    }
  }

  Future<void> _showBookingPaymentsDialog(
      double addedAmount, PaymentTypes paymentTypes) async {
    bool sBookingPaymentId = false;
    if (addedAmount > 0) {
      sBookingPaymentId =
          paymentViewModel.getBookingPaymentsId(cartSummary, paymentTypes);
    }
    if ((cartSummary.getDueAmount() > 0.0) || sBookingPaymentId) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              child: Container(
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.all(10.0),
                width: 800,
                height: 700,
                child: Column(
                  children: [
                    getTopWidget(),
                    Expanded(
                        child: BookingPaymentWidget(
                      mCompanyConfigurationResponse:
                          cartSummary.companyConfiguration,
                      dueAmount: cartSummary.getDueAmount(),
                      sBookingPaymentId: sBookingPaymentId,
                      customerId: cartSummary.customers?.id,
                      onBookingPaymentSelected:
                          (BookingPayments? bookingPayments) {
                        MyLogUtils.logDebug(
                            "bookingPayments : ${bookingPayments?.toJson()}");

                        double getAmount = cartSummary.getDueAmount();

                        getAmount = (getAmount >
                                (bookingPayments?.availableAmount ?? 0.0))
                            ? (bookingPayments?.availableAmount ?? 0.0)
                            : getAmount;
                        var data = PaymentTypeData(
                            paymentType: paymentTypes,
                            amount: getAmount,
                            bookingPayments: bookingPayments);

                        widget.onBookingPaymentSelected(
                            data, null, 0.0, null, false);
                        Navigator.pop(context);
                      },
                      onBookingPaymentRemove: () {
                        widget.onBookingPaymentRemove(PaymentTypeData(
                          paymentType: paymentTypes,
                        ));
                        Navigator.pop(context);
                      },
                    ))
                  ],
                ),
              ));
        },
      );
    } else {
      showToast("Please use cart items to check this condition.", context);
    }
  }

  Widget completeSaleButtonWidget() {
    if (callApi) {
      return apiWidget();
    }

    if (cartSummary.isBookingSale) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Theme.of(context).colorScheme.tertiary),
        onPressed: () {
          _completeSale();
        },
        child: cartSummary.isBookingItemReset
            ? const Text("Reset Booking Payment")
            : const Text("Add Booking Payment"),
      );
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Theme.of(context).colorScheme.tertiary),
      onPressed: () {
        if (cartSummary.isLayAwaySale) {
          _completeSale();
        } else if (cartSummary.cartItems == null ||
            cartSummary.cartItems!.isEmpty) {
          showToast("Please enter at least one item", context);
        } else if (cartSummary.isExchange == true) {
          if ((cartSummary.cartPrice?.total ?? 0) == 0) {
            _completeSale();
          } else {
            showToast("In case of exchange total price should be 0", context);
          }
        } else if (cartSummary.isReturns == true) {
          _completeSale();
        } else {
          _completeSale();
        }
      },
      child: Text(cartSummary.isLayAwaySale ? "Layaway Sale" : "Complete Sale"),
    );
  }

  bool callApi = false;

  void _completeSale() {
    MyLogUtils.logDebug(
        "cartSummary companyConfiguration : ${cartSummary.companyConfiguration?.toJson()}");
    MyLogUtils.logDebug(
        "cartSummary getDueAmount : ${cartSummary.getDueAmount()}");

    if (cartSummary.isReturns == true &&
        cartSummary.companyConfiguration?.allowNegativePayment == false &&
        cartSummary.getDueAmount() < 0) {
      showToast(
          "Negative payment is not allowed as per the configuration in super admin.",
          context);
      return;
    }

    if (!cartSummary.isBookingSale && cartSummary.saleTye == SaleTye.REGULAR) {
      if (cartSummary.customers == null &&
          cartSummary.employees == null &&
          (cartSummary.triggerCustomerPopUpAtLeastOnce == null ||
              cartSummary.triggerCustomerPopUpAtLeastOnce == false)) {
        showToast(
            "Would you like you to add new member or try search for existing member using phone number in member section ?",
            context);
        // Trigger Customer pop up
        widget.triggerCustomerPopUp();

        return;
      }

      if (!cartViewModel.isExchangeItemsValid(cartSummary)) {
        showToast(
            "Mismatch in exchange items. Exchange items should match with products & quantities.",
            context);
        return;
      }

      if (cartSummary.getDueAmount() > 0) {
        showToast("Paid amount is less that expected amount!", context);
        return;
      }
    }

    if (cartSummary.selectedVoucherConfigs != null &&
        cartSummary.selectedVoucherConfigs!.isNotEmpty &&
        !cartSummary.isBookingItemReset) {
      showToast("New Voucher is created for this sale.", context);
    }

    if (isPromoterMandatory(cartSummary.companyConfiguration) &&
        !viewModel.isPromotersAttachedToAllItems(cartSummary,
            (cartSummary.companyConfiguration?.minPromotersPerItem ?? 1))) {
      showToast(
          "Promoter is missing in one of the item. Minimum "
          "${(cartSummary.companyConfiguration?.minPromotersPerItem ?? 1)} promoter is required",
          context);
      return;
    }

    if (isBillReferenceMandatory(cartSummary.companyConfiguration) &&
        (cartSummary.billReferenceNumber == null ||
            cartSummary.billReferenceNumber!.isEmpty) &&
        !cartSummary.isBookingItemReset) {
      // Check for bill reference
      showToast("Please Fill Bill Reference.", context);
      return;
    }

    if (cartSummary.isBookingSale &&
        !cartSummary.isBookingItemReset) {
      if (cartSummary.getPaidAmount() <= 0) {
        showToast("Please enter amount to proceed", context);
        return;
      }
    }

    setState(() {
      if (cartSummary.isBookingItemReset) {
        callApi = true;
        viewModel.resetBookingPayment(cartSummary);
      }else if (cartSummary.isBookingSale) {
        _refundManagerAuthorizationBookingSaleDialog();
      } else if (cartSummary.isLayAwaySale) {
        _refundManagerAuthorizationLayAwaySaleDialog();
      } else {
        callApi = true;
        addBckUp();
        viewModel.saveNewSale(cartSummary, null);
      }
    });
  }

  Future<void> _refundManagerAuthorizationBookingSaleDialog() async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return RefundManagerAuthorizationWidget(
            onSuccess: (StoreManagers mStoreManagers) {
              MyLogUtils.logDebug(
                  "mStoreManagers cartSummary: ${jsonEncode(mStoreManagers)}");
              setState(() {
                callApi = true;
                addBckUp();
                viewModel.saveNewBookingPayment(cartSummary, mStoreManagers);
              });
            },
          );
        });
  }

  Future<void> _refundManagerAuthorizationLayAwaySaleDialog() async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return RefundManagerAuthorizationWidget(
            onSuccess: (StoreManagers mStoreManagers) {
              MyLogUtils.logDebug(
                  "mStoreManagers cartSummary: ${jsonEncode(mStoreManagers)}");
              setState(() {
                callApi = true;
                addBckUp();
                viewModel.saveNewSale(cartSummary, mStoreManagers);
              });
            },
          );
        });
  }

  addBckUp() {
    cartItems.clear();
    cartItems.addAll(List.from(cartSummary.cartItems!.toList()));
    cartSummary.cartItems!
        .removeWhere((item) => item.getIsSelectItem() == false);
  }

  Widget apiWidget() {
    if (cartSummary.isBookingSale) {
      return bookingApiWidget();
    }

    return StreamBuilder<SaveSaleResponse>(
      stream: viewModel.responseSubject,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          MyLogUtils.logDebug("apiWidget waiting");
          return const MyLoadingWidget();
        }
        if (snapshot.hasError) {
          MyLogUtils.logDebug("apiWidget hasError");
          callApi = false;
          return completeSaleButtonWidget();
        }
        if (snapshot.connectionState == ConnectionState.active) {
          var responseData = snapshot.data;
          if (responseData != null &&
              (responseData.sale != null || responseData.saleReturn != null)) {
            goToHomeScreen();
            callApi = false;
            return completeSaleButtonWidget();
          } else {
            showToast('Failed to complete sale.Please try again!', context);
            callApi = false;
            return completeSaleButtonWidget();
          }
        }
        return Container();
      },
    );
  }

  Widget bookingApiWidget() {
    return StreamBuilder<bool>(
      stream: viewModel.boolResponseSubject,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          MyLogUtils.logDebug("apiWidget waiting");
          return const MyLoadingWidget();
        }
        if (snapshot.hasError) {
          MyLogUtils.logDebug("apiWidget hasError");
          callApi = false;
          return completeSaleButtonWidget();
        }
        if (snapshot.connectionState == ConnectionState.active) {
          var responseData = snapshot.data;
          if (responseData != null && responseData == true) {
            goToHomeScreen();
            callApi = false;
            return completeSaleButtonWidget();
          } else {
            showToast(
                'Failed to make booking payment.Please try again!', context);
            callApi = false;
            return completeSaleButtonWidget();
          }
        }
        return Container();
      },
    );
  }

  Future<void> goToHomeScreen() async {
    MyLogUtils.logDebug("goToHomeScreen");
    showToast('Sale Completed!', context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //Show dialog
      billRefController.text = "";
      widget.completeSale(cartItems);
      viewModel.closeObservable();
      viewModel = NewSaleViewModel();
    });
  }

  Widget getTopWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Booking Payments",
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

  Widget promoters(List<Promoters>? promoters) {
    if (promoters == null || promoters.isEmpty) {
      return MyInkWellWidget(
        onTap: () {
          showAssignExecutiveDialog();
        },
        child: Container(
          color: (getPrimaryColor(context) as Color).withOpacity(0.2),
          padding: const EdgeInsets.fromLTRB(4, 5, 4, 6),
          alignment: Alignment.centerLeft,
          child: Text(
            'Add Promoter',
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
      );
    }

    List<InlineSpan> spanTexts = List.empty(growable: true);

    for (var element in promoters) {
      if (spanTexts.isNotEmpty) {
        spanTexts.add(
          TextSpan(text: ',', style: Theme.of(context).textTheme.caption),
        );
        spanTexts.add(
          TextSpan(text: ' ', style: Theme.of(context).textTheme.caption),
        );
      }
      spanTexts.add(TextSpan(
          text: '${element.firstName ?? ""}(${element.staffId})',
          style: Theme.of(context).textTheme.caption));
    }

    return MyInkWellWidget(
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(
                color: Theme.of(context).primaryColor.withOpacity(0.2)),
          ),
          child: Text.rich(TextSpan(text: '', children: spanTexts)),
        ),
        onTap: () {
          showAssignExecutiveDialog();
        });
  }

  void showAssignExecutiveDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return MultiSelectPromotersWidget(
            showAssignToAll: false,
            selectedPromoters: cartSummary.promoters,
            onPromotersAdded: (promoters, assignToAll, clearAll) {
              widget.onPromotersAddedToCart(promoters);
            },
          );
        });
  }

  String getChangeDueValue() {
    double? amountChangeDue =
        ((cartSummary.changeDue ?? 0) > 0) ? cartSummary.changeDue : 0.0;

    if ((cartSummary.cartItems == null || cartSummary.cartItems!.isEmpty) &&
        cartSummary.customers == null) {
      amountChangeDue = BaseViewModel.getAmountChangeDue;
    } else {
      BaseViewModel.getAmountChangeDue = amountChangeDue ?? 0.00;
    }
    if (amountChangeDue != null &&
        amountChangeDue > 0 &&
        amountChangeDue > 0.0 &&
        amountChangeDue > 0.00 &&
        cartSummary.cartItems != null &&
        cartSummary.cartItems!.isNotEmpty) {
      cartViewModel.createMessageForCustomerDisplay("Change due amount",
          getReadableAmount(getCurrency(), amountChangeDue));
    }
    return getReadableAmount("RM", amountChangeDue);
  }
}
