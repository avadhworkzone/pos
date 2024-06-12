import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jakel_base/database/sale/model/CartCustomDiscount.dart';
import 'package:jakel_base/database/sale/model/CartItem.dart';
import 'package:jakel_base/database/sale/model/CartItemFocData.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/database/sale/model/PaymentTypeData.dart';
import 'package:jakel_base/database/sale/model/PromotionData.dart';
import 'package:jakel_base/database/sale/model/sale_booking_returns_data.dart';
import 'package:jakel_base/database/sale/model/sale_returns_data.dart';
import 'package:jakel_base/jakel_base.dart';
import 'package:jakel_base/restapi/cashbacks/model/CashbacksResponse.dart';
import 'package:jakel_base/restapi/companyconfiguration/model/CompanyConfigurationResponse.dart';
import 'package:jakel_base/restapi/creditnotedetailsbyid/model/CreditNotesApiResponse.dart';
import 'package:jakel_base/restapi/customers/model/CustomersResponse.dart';
import 'package:jakel_base/restapi/dreamprice/model/DreamPriceResponse.dart';
import 'package:jakel_base/restapi/employees/model/EmployeesResponse.dart';
import 'package:jakel_base/restapi/giftcards/model/GiftCardsResponse.dart';
import 'package:jakel_base/restapi/promoters/model/PromotersResponse.dart';
import 'package:jakel_base/restapi/promotions/model/PromotionsResponse.dart';
import 'package:jakel_base/restapi/vouchers/model/VoucherConfigurationResponse.dart';
import 'package:jakel_base/restapi/vouchers/model/VouchersListResponse.dart';
import 'package:jakel_base/serialportdevices/model/MayBankPaymentDetails.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';
import 'package:jakel_pos/modules/cashbacks/CashBacksViewModel.dart';
import 'package:jakel_pos/modules/customers/CustomersViewModel.dart';
import 'package:jakel_pos/modules/dreamprices/DreamPricesViewModel.dart';
import 'package:jakel_pos/modules/keyboardshortcuts/hold_sale_keyboard_shortcut.dart';
import 'package:jakel_pos/modules/keyboardshortcuts/resume_hold_sale_keyboard_shortcut.dart';
import 'package:jakel_pos/modules/newsale/CartViewModel.dart';
import 'package:jakel_pos/modules/newsale/NewSaleViewModel.dart';
import 'package:jakel_pos/modules/newsale/helper/booking_item_reset_helper.dart';
import 'package:jakel_pos/modules/newsale/ui/dialog/add_open_price_dialog.dart';
import 'package:jakel_pos/modules/newsale/ui/dialog/cart_custom_discount_dialog.dart';
import 'package:jakel_pos/modules/newsale/ui/dialog/delete_hold_sale_dialog.dart';
import 'package:jakel_pos/modules/newsale/ui/dialog/on_hold_sales_dialog.dart';
import 'package:jakel_pos/modules/newsale/ui/widgets/new_sale_cart_widget.dart';
import 'package:jakel_pos/modules/newsale/ui/widgets/new_sale_customer_widget.dart';
import 'package:jakel_pos/modules/newsale/ui/widgets/new_sale_discount_widget.dart';
import 'package:jakel_pos/modules/newsale/ui/widgets/new_sale_employees_widget.dart';
import 'package:jakel_pos/modules/newsale/ui/widgets/new_sale_inherited_widget.dart';
import 'package:jakel_pos/modules/newsale/ui/widgets/new_sale_payment_widget.dart';
import 'package:jakel_pos/modules/newsale/ui/widgets/new_sale_search_widget.dart';
import 'package:jakel_pos/modules/promotions/PromotionsViewModel.dart';
import 'package:jakel_pos/modules/promotions/ui/widgets/valid_promotions_widget.dart';
import 'package:jakel_pos/modules/vouchers/VouchersViewModel.dart';

import '../../customers/ui/widget/add_quick_customer.dart';
import '../helper/new_sale_returns_helper.dart';

class NewSaleWidget extends StatefulWidget {
  final SaleReturnsData? returnsData;
  final BookingItemsResetData? returnsBookingData;

  const NewSaleWidget({Key? key, this.returnsData, this.returnsBookingData})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NewSaleWidgetState();
  }
}

class _NewSaleWidgetState extends State<NewSaleWidget> {
  bool _isEnableGroupPayment = false;
  var cartSummary = CartSummary(
      saleTye: SaleTye.REGULAR,
      cartItems: List.empty(growable: true),
      payments: List.empty(growable: true));

  final cartViewModel = CartViewModel();
  final saleViewModel = NewSaleViewModel();
  final promotionsViewModel = PromotionsViewModel();
  final dreamPriceViewModel = DreamPricesViewModel();
  final cashBacksViewModel = CashBacksViewModel();
  final vouchersViewModel = VouchersViewModel();
  final customerViewModel = CustomersViewModel();

  List<Promotions> allPromotions = List.empty(growable: true);
  List<DreamPrices> allDreamPrices = List.empty(growable: true);
  List<VoucherConfiguration> allVoucherConfigurations =
      List.empty(growable: true);
  List<Cashbacks> allCashBacks = List.empty(growable: true);

  bool attachCustomerToSale = true;
  String attachCustomerEmployeeText = "Member";

  @override
  void initState() {
    super.initState();
    _addReturnsData();
    _addReturnsBookingData();
  }

  @override
  void dispose() {
    super.dispose();
    if (cartSummary.cartItems != null && cartSummary.cartItems!.isNotEmpty) {
      _onSaleHold();
    }
  }

  void _addReturnsData() {
    if (widget.returnsData != null) {
      cartSummary = addReturnItemsToCart(cartSummary, widget.returnsData);
      if (widget.returnsData?.employees != null) {
        _attachCustomerOrEmployee(false);
      }
    }
  }

  void _addReturnsBookingData() {
    if (widget.returnsBookingData != null) {
      cartSummary = addResetBookingItemsToCart(cartSummary,widget.returnsBookingData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return getCompanyConfiguration();
  }

  Widget getCompanyConfiguration() {
    return FutureBuilder(
        future: saleViewModel.getCompanyConfig(),
        builder: (BuildContext context,
            AsyncSnapshot<CompanyConfigurationResponse?> snapshot) {
          if (snapshot.hasError) {
            MyLogUtils.logDebug("snapshot.hasError : ${snapshot.hasError}");
            return getRootWidget();
          }
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              cartSummary.roundingOffConfigurations =
                  snapshot.data!.roundOffConfiguration;
              cartSummary.companyConfiguration = snapshot.data;
            }
            return getPromotionsWidget();
          }
          return const Text("Loading ...");
        });
  }

  Widget getPromotionsWidget() {
    return FutureBuilder(
        future: promotionsViewModel.getPromotions(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Promotions>> snapshot) {
          if (snapshot.hasError) {
            MyLogUtils.logDebug("snapshot.hasError : ${snapshot.hasError}");
            return getRootWidget();
          }
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              allPromotions = snapshot.data!;
            }
            return getDreamPriceWidget();
          }
          return const Text("Loading ...");
        });
  }

  Widget getDreamPriceWidget() {
    return FutureBuilder(
        future: dreamPriceViewModel.getDreamPrices(),
        builder:
            (BuildContext context, AsyncSnapshot<List<DreamPrices>> snapshot) {
          if (snapshot.hasError) {
            return getRootWidget();
          }
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              allDreamPrices = snapshot.data!;
            }
            return getVoucherConfigurations();
          }
          return const Text("Loading ...");
        });
  }

  Widget getVoucherConfigurations() {
    return FutureBuilder(
        future: vouchersViewModel.getVoucherConfigs(),
        builder: (BuildContext context,
            AsyncSnapshot<List<VoucherConfiguration>> snapshot) {
          if (snapshot.hasError) {
            return getRootWidget();
          }
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              allVoucherConfigurations = snapshot.data!;
            }
            return getCashBacksWidget();
          }
          return const Text("Loading ...");
        });
  }

  Widget getCashBacksWidget() {
    return FutureBuilder(
        future: cashBacksViewModel.getAllCashBacks(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Cashbacks>> snapshot) {
          if (snapshot.hasError) {
            return getRootWidget();
          }
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              allCashBacks = snapshot.data!;
            }
            return getDreamPrices();
          }
          return const Text("Loading ...");
        });
  }

  Widget getDreamPrices() {
    return FutureBuilder(
        future: dreamPriceViewModel.getDreamPrices(),
        builder:
            (BuildContext context, AsyncSnapshot<List<DreamPrices>> snapshot) {
          if (snapshot.hasError) {
            return getRootWidget();
          }
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              allDreamPrices = snapshot.data!;
            }
            return getRootWidget();
          }
          return const Text("Loading ...");
        });
  }

  Widget getRootWidget() {
    cartSummary = cartViewModel.getCartSummary(cartSummary, allDreamPrices,
        allPromotions, allVoucherConfigurations, allCashBacks);

    _recheckVoucherApplied();
    cartViewModel.onCartUpdated(cartSummary);
    return NewSaleInheritedWidget(
        cartSummary: cartSummary,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              Expanded(flex: 2, child: getCartAndSearchWidget()),
              Expanded(
                  flex: 1,
                  child: NewSalePaymentWidget(
                    onAddCustomCartManualDiscount:
                        _showCartLevelPriceOverrideDialog,
                    triggerCustomerPopUp: _triggerCustomerPopup,
                    cartSummary: cartSummary,
                    onPaymentSelected: _onPaymentSelected,
                    completeSale: _completeSale,
                    onRemarksEntered: _onRemarksEntered,
                    onPromotersAddedToCart: (promoters) {
                      setState(() {
                        cartSummary.promoters = promoters;
                      });
                    },
                    onBillRefEntered: _onBillRefEntered,
                    removeLoyaltyPayment: _onLoyaltyPaymentRemoved,
                    onLoyaltyPaymentSelected: _onLoyaltyPaymentSelected,
                    onGiftCardRemoved: _onGiftCardRemoved,
                    onGiftCardSelected: _onGiftCardSelected,
                    onCreditNoteSelected: _onCreditNoteSelected,
                    onCreditNoteRemove: _onCreditNoteRemove,
                    onBookingPaymentSelected: _onBookingPaymentSelected,
                    onBookingPaymentRemove: _onBookingPaymentRemove,
                  ))
            ],
          ),
        ));
  }

  void _onCreditNoteSelected(PaymentTypeData paymentTypeData,
      CreditNote creditNote, double amount, double dueAmount) {
    var add = true;

    cartSummary.payments?.forEach((element) {
      if (element.paymentType?.id == creditNotePaymentId &&
          element.creditNoteId == creditNote.id) {
        add = false;
      }
    });

    setState(() {
      if (add) {
        paymentTypeData.creditNoteId = creditNote.id;
        paymentTypeData.amount = amount;
        cartSummary.payments?.add(paymentTypeData);
      } else {
        showToast("Already add this credit note", context);
      }
    });
  }

  void _onCreditNoteRemove(
      PaymentTypeData paymentTypeData, CreditNote creditNote, double amount) {
    setState(() {
      for (var element in cartSummary.payments!) {
        if (element.paymentType?.id == creditNotePaymentId &&
            element.creditNoteId == paymentTypeData.creditNoteId) {
          cartSummary.payments?.remove(element);
          break;
        }
      }
    });
  }

  _onBookingPaymentSelected(
      PaymentTypeData paymentTypeData,
      String? localIdToBeRemoved,
      double balanceChangeDue,
      MayBankPaymentDetails? details,
      bool completeSale) {
    setState(() {
      var add = true;
      cartSummary.payments?.forEach((element) {
        if (localIdToBeRemoved != null &&
            element.paymentType?.localId == localIdToBeRemoved) {
          element.amount = 0;
        }

        MyLogUtils.logDebug(
            "_onPaymentSelected paymentTypeData : ${paymentTypeData.toJson()} && element : ${element.toJson()}");

        if (element.paymentType?.localId ==
            paymentTypeData.paymentType?.localId) {
          add = false;
          element.amount = paymentTypeData.amount;
          element.cardNo = paymentTypeData.cardNo;
        }
      });

      if (add) {
        cartSummary.payments?.add(paymentTypeData);
      }

      cartSummary.changeDue = balanceChangeDue > 0 ? balanceChangeDue : 0;

      if (details != null) {
        List<MayBankPaymentDetails> list =
            cartSummary.mayBankPaymentDetailList ?? List.empty(growable: true);
        list.add(details);

        MyLogUtils.logDebug("mayBankPaymentDetailList : ${list.length}");
        cartSummary.mayBankPaymentDetailList = list;
      }

      cartViewModel.createMessageForCustomerDisplay(
          '${getDoubleValue(paymentTypeData.amount)} of ${paymentTypeData.paymentType?.name} for',
          getReadableAmount(getCurrency(), cartSummary.getTotalAmount()));
    });
  }

  void _onBookingPaymentRemove(PaymentTypeData paymentTypeData) {
    setState(() {
      for (PaymentTypeData element in cartSummary.payments ?? []) {
        if (element.paymentType?.localId ==
            paymentTypeData.paymentType?.localId) {
          cartSummary.payments?.remove(element);
          break;
        }
      }
    });
  }

  void _onGiftCardSelected(
      PaymentTypeData paymentTypeData, GiftCards giftCard, double amount) {
    var add = true;

    cartSummary.payments?.forEach((element) {
      if (element.paymentType?.id == giftCardPaymentId &&
          element.giftCardId == giftCard.id) {
        add = false;
      }
    });

    setState(() {
      if (add) {
        paymentTypeData.giftCardId = giftCard.id;
        paymentTypeData.giftCardNumber = giftCard.number;
        paymentTypeData.amount = amount;
        cartSummary.payments?.add(paymentTypeData);
      } else {
        showToast("This Gift Card already apply", context);
      }
    });
  }

  void _onGiftCardRemoved(
      PaymentTypeData paymentTypeData, GiftCards giftCard, double amount) {
    setState(() {
      for (var element in cartSummary.payments!) {
        if (element.paymentType?.id == giftCardPaymentId &&
            element.giftCardId == giftCard.id) {
          cartSummary.payments?.remove(element);
          break;
        }
      }
    });
  }

  void _onLoyaltyPaymentSelected(
      PaymentTypeData paymentTypeData, int points, double amount) {
    MyLogUtils.logDebug(
        "_onLoyaltyPaymentSelected  paymentTypeData : ${paymentTypeData.toJson()}  & points : $points && amount : $amount");

    var add = true;

    cartSummary.payments?.forEach((element) {
      if (element.paymentType?.id == loyaltyPointPaymentId) {
        add = false;
      }
    });

    MyLogUtils.logDebug("_onLoyaltyPaymentSelected add : $add");

    setState(() {
      // If not exists, add the loyalty payment.
      if (add) {
        if (points > 0) {
          paymentTypeData.loyaltyPoints = points;
          paymentTypeData.amount = amount;
          cartSummary.payments?.add(paymentTypeData);
        } else {
          showToast("Member don't have enough loyalty points", context);
        }
      }
    });
  }

  void _onLoyaltyPaymentRemoved(PaymentTypeData paymentTypeData) {
    setState(() {
      for (var element in cartSummary.payments!) {
        if (element.paymentType?.id == loyaltyPointPaymentId) {
          cartSummary.payments?.remove(element);
          break;
        }
      }
    });
  }

  Widget getCartAndSearchWidget() {
    return Stack(
      children: [
        Container(
            constraints: const BoxConstraints.expand(),
            margin: EdgeInsets.only(
                top: 98,
                bottom: cartSummary.isBookingItemReset
                    ? 135
                    : (cartSummary.customers == null &&
                            cartSummary.employees == null)
                        ? (cartSummary.isExchange != null &&
                                cartSummary.isExchange == true)
                            ? 247
                            : 227
                        : 262),
            child: Column(
              children: [
                (cartSummary.isExchange != null &&
                        cartSummary.isExchange == true)
                    ? const Text(
                        "In case of exchange items, you can add only item that can be exchanged. No other items will be allowed to add.",
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      )
                    : Container(),

                ///Enable Group Payment
                cartSummary.isBookingItemReset
                    ? const SizedBox()
                    : Container(
                        width: double.infinity,
                        margin:
                            const EdgeInsets.only(top: 5, bottom: 5, left: 10),
                        alignment: Alignment.topLeft,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).colorScheme.tertiary),
                          onPressed: () {
                            _enableGroupPayment();
                          },
                          child: Text(
                              _isEnableGroupPayment
                                  ? "Disable Group Payment"
                                  : "Enable Group Payment",
                              style: TextStyle(fontSize: 10)),
                        ),
                      ),
                Expanded(
                    child: NewSaleCartWidget(
                  isEnableGroupPayment: _isEnableGroupPayment,
                  updateQty: _updateQty,
                  cartSummary: cartSummary,
                  selectItem: _selectItem,
                  unSelectItem: _unSelectItem,
                  removeItem: _removeProduct,
                  onPromotersAdded: _onPromotersAdded,
                  onPriceUpdated: _onPriceUpdated,
                  showOpenPriceDialog: _showOpenPriceDialog,
                  onComplimentaryItemAdded: _onComplimentaryItemAdded,
                  showOpenSplitDialog: _showOpenSplitDialog,
                )),
                const SizedBox(
                  height: 5,
                ),
              ],
            )),
        Positioned(
            //Search item widget
            top: 2.0,
            left: 0.0,
            right: 0.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: NewSaleSearchWidget(
                  onProductSelected: _onProductSelected,
                )),
                cancelHoldActionWidget()
              ],
            )),
        Positioned(
            //Search customer widget
            bottom: cartSummary.isBookingItemReset ? 5.0 : 120.0,
            left: 0.0,
            right: 0.0,
            child: Row(
              children: [
                Expanded(child: _getMemberOrEmployeeWidget()),
                SizedBox(
                  width: 100,
                  child: Column(
                    children: [
                      Switch(
                        onChanged: _attachCustomerOrEmployee,
                        value: attachCustomerToSale,
                        activeColor: Colors.blue,
                        activeTrackColor: Colors.yellow,
                        inactiveThumbColor: Colors.redAccent,
                        inactiveTrackColor: Colors.orange,
                      ),
                      Text(attachCustomerEmployeeText)
                    ],
                  ),
                )
              ],
            )),
        cartSummary.isBookingItemReset
            ? const SizedBox()
            : Positioned(
                //Search customer widget
                bottom: 5.0,
                left: 0.0,
                right: 0.0,
                child: NewSaleDiscountWidget(
                  cartSummary: cartSummary,
                  viewAllDiscount: _showValidDiscountDialog,
                  onVoucherEntered: _onVoucherEntered,
                )),
      ],
    );
  }

  _enableGroupPayment() {
    if (cartSummary.cartItems!.isNotEmpty) {
      setState(() {
        _isEnableGroupPayment = !_isEnableGroupPayment;
        if (!_isEnableGroupPayment && cartSummary.cartItems!.isNotEmpty) {
          for (CartItem element in cartSummary.cartItems!) {
            element.setIsSelectItem(true);
          }
          cartSummary.cartItems = cartViewModel.mergeItem(cartSummary);
        }
      });
    }
  }

  Widget _getMemberOrEmployeeWidget() {
    if (attachCustomerToSale) {
      return NewSaleCustomerWidget(
        allVoucherConfigurations: allVoucherConfigurations,
        onSelected: _onCustomerSelected,
        markAsBookingSale: _markAsBookingSale,
        markAsLayawaySale: _markAsLayAwaySale,
        cartSummary: cartSummary,
        addNewCustomer: _addNewCustomer,
        removeCustomer: () {
          setState(() {
            cartSummary.resetPaymentType();
            cartSummary.customers = null;
            cartSummary.saleTye = SaleTye.REGULAR;
            cartSummary.isLayAwaySale = false;
            cartSummary.isBookingSale = false;
            _updateDreamPriceInAllItems();
            _resetVoucherData("Removing member will reset applied voucher.");
          });
        },
        onVoucherSelected: (Vouchers voucher) {
          _onVoucherEntered(voucher.number ?? '');
          // setState(() {
          //   _onVoucherSelected(voucher);
          // });
        },
      );
    }

    return NewSaleEmployeesWidget(
      onSelected: _onEmployeesSelected,
      markAsBookingSale: _markAsBookingSale,
      markAsLayawaySale: _markAsLayAwaySale,
      cartSummary: cartSummary,
      removeEmployees: () {
        setState(() {
          cartSummary.resetPaymentType();
          cartSummary.employees = null;
          cartSummary.saleTye = SaleTye.REGULAR;
          cartSummary.isLayAwaySale = false;
          cartSummary.isBookingSale = false;
          _updateDreamPriceInAllItems();
          _resetVoucherData("Removing employee will reset voucher.");
        });
      },
    );
  }

  void _attachCustomerOrEmployee(bool attachCustomer) {
    if (!cartSummary.isBookingItemReset) {
      setState(() {
        if (cartSummary.customers != null || cartSummary.employees != null) {
          cartSummary.changeDue = 0.0;
          cartSummary.payments = [];
        }
        if (attachCustomer == true) {
          attachCustomerToSale = true;
          attachCustomerEmployeeText = "Member";
        } else {
          attachCustomerToSale = false;
          attachCustomerEmployeeText = "Employee";
        }
        cartSummary.employees = null;
        cartSummary.customers = null;
        _updateDreamPriceInAllItems();

        _resetVoucherData(
            "Switching between employees & members will remove applied voucher. "
            "Please enter voucher again to validate the same");
      });
    }
  }

  Widget cancelHoldActionWidget() {
    return IntrinsicWidth(
      child: Container(
        margin: const EdgeInsets.all(3.0),
        height: 89,
        child: Column(
          children: [
            Expanded(
                child: ElevatedButton.icon(
                    onPressed: () {
                      _isEnableGroupPayment = false;
                      _clearCart([]);
                    },
                    icon: const Icon(
                      Icons.clear,
                      size: 15,
                    ),
                    label: Text(tr('cancel')))),
            const SizedBox(
              height: 3,
            ),
            (cartSummary.cartItems != null &&
                    cartSummary.cartItems!.isNotEmpty &&
                    !cartSummary.isBookingItemReset)
                ? Expanded(
                    child: HoldSaleKeyboardShortcut(
                    onAction: () {
                      _onSaleHold();
                    },
                    child: OutlinedButton.icon(
                        onPressed: () {
                          _onSaleHold();
                        },
                        icon: const Icon(
                          Icons.pause,
                          size: 15,
                        ),
                        label: const Text(
                          " Hold ",
                        )),
                  ))
                : Container(
                    height: 40,
                  ),
            const SizedBox(
              height: 3,
            ),
            getOnHoldSales(),
          ],
        ),
      ),
    );
  }

  Widget getOnHoldSales() {
    return FutureBuilder(
        future: saleViewModel.getAllOnHoldSales(),
        builder:
            (BuildContext context, AsyncSnapshot<List<CartSummary>> snapshot) {
          if (snapshot.hasError) {
            MyLogUtils.logDebug("snapshot.hasError : ${snapshot.hasError}");
            return Container();
          }
          if (snapshot.hasData) {
            if (snapshot.data != null && snapshot.data!.isNotEmpty) {
              return ResumeHoldSaleKeyboardShortcut(
                  child: InkWell(
                    onTap: () {
                      _showOnHoldSalesDialog();
                    },
                    child: Text("${snapshot.data!.length} Hold sales",
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).primaryColor,
                          decoration: TextDecoration.underline,
                        )),
                  ),
                  onAction: () {
                    _showOnHoldSalesDialog();
                  });
            }
            return Container();
          }
          return Container();
        });
  }

  _showOnHoldSalesDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return OnHoldSalesDialog(
          onSaleSelected: (selected) {
            setState(() {
              if (selected.isExchange == true) {
                selected.isExchange = false;
              }
              cartSummary = selected;
              if (cartSummary.employees != null) {
                attachCustomerToSale = false;
                attachCustomerEmployeeText = "Employee";
              }
            });
          },
          onDeleted: (selected) {
            showOnDeleteHoldSalesDialog(selected);
          },
        );
      },
    );
  }

  ///Show delete hold sale dialog to verify manager & enter reason (mandatory fields)
  void showOnDeleteHoldSalesDialog(CartSummary cartSummary) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return DeleteHoldSaleDialog(
          cartSummary: cartSummary,
          onDone: (selected) {
            setState(() {
              cartSummary = selected;
            });
          },
        );
      },
    );
  }

  _onSaleHold() async {
    if (cartSummary.cartItems != null &&
        cartSummary.cartItems!.isNotEmpty &&
        !cartSummary.isBookingItemReset) {
      await saleViewModel.saveToOnHoldSale(cartSummary);
      _clearCart([]);
      if (mounted) {
        showToast('Sale Put on Hold', context);
      }
    }
  }

  _onProductSelected(CartItem cartItem) async {

    ///clear previous configs and fetching latest dream prices configs
    allDreamPrices.clear();
    allDreamPrices = await dreamPriceViewModel.getDreamPrices();
    // In Case of exchange, same item same qty is only allowed to add.
    // Same qty check is added before making sale.
    if (cartSummary.isExchange != null && cartSummary.isExchange == true) {
      // To allow exchange of FOC, getDueAMount >= 0 is removed and used only >
      if (cartSummary.getDueAmount() > 0) {
        showToast(
            "In exchange total amount cannot exceed more than amount paid for exchange item",
            context);
        return;
      }
      bool isSameAsExchangeItem = false;

      cartSummary.cartItems?.forEach((element) {
        if (!_isEnableGroupPayment &&
            element.product?.articleNumber == cartItem.product?.articleNumber &&
            element.saleReturnsItemData != null) {
          isSameAsExchangeItem = true;
          cartItem.isNewItemForExchange = true;
          double qty = element.saleReturnsItemData?.qty ?? 0;
          cartItem.exchangePricePerUnit =
              (element.saleReturnsItemData?.saleItem?.pricePaidPerUnit ?? 0.0) -
                  ((element.saleReturnsItemData?.saleItem?.totalTaxAmount ??
                          0) /
                      (element.saleReturnsItemData?.saleItem?.quantity ?? 0.0));
          cartItem.qty = 1;
          //cartItem.cartItemPrice =element.cartItemPrice;
          cartItem.cartItemPrice =
              getCartItemPriceForGivenQtyInReturnsOrExchange(
                  element.cartItemPrice, qty, 1);
        }
      });

      if (!isSameAsExchangeItem) {
        showToast("Only exchange item is allowed to add.", context);
        return;
      }
    }

    final isValid = await validateEmployeeForCart(cartItem);
    if (!isValid) {
      showToast("Employee limit shouldn't exceed", context);
      return;
    }

    setState(() {
      // Get Dream price
      // cartItem = dreamPriceViewModel.getDreamPriceForCartItem(
      //     cartSummary, cartItem, allDreamPrices);

      if (!_isEnableGroupPayment) {
        cartSummary.cartItems =
            cartViewModel.removeAllDiscountsAndGroupItCorrectly(cartSummary);
      }
      _addCartItem(cartItem);

      if (cartItem.isOpenPriceItem()) {
        _showOpenPriceDialog(
            cartItem, ((cartSummary.cartItems?.length ?? 1) - 1));
      }
    });
  }

  _showCartLevelPriceOverrideDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CartCustomDiscountDialog(
          cartSummary: cartSummary,
          onUpdated: _onCartLevelPriceOverride,
        );
      },
    );
  }

  _onCartLevelPriceOverride(CartCustomDiscount? cartCustomDiscount) {
    setState(() {
      MyLogUtils.logDebug(
          "_onCartLevelPriceOverride cartCustomDiscount : ${cartCustomDiscount?.toJson()}");
      cartSummary.cartCustomDiscount = cartCustomDiscount;
    });
  }

  _addCartItem(CartItem cartItem) {
    var addItem = true;
    cartSummary.cartItems?.forEach((element) {
      MyLogUtils.logDebug(
          "_addCartItem existing Item: ${element.saleReturnsItemData} for ${element.getProductName()}");
      MyLogUtils.logDebug(
          "_addCartItem existing addItem: $addItem is same ${cartItem.checkIsSame(element)} & qty : ${cartItem.qty}");
      if (!_isEnableGroupPayment &&
          addItem &&
          cartItem.checkIsSame(element) &&
          (cartSummary.isExchange == null || cartSummary.isExchange == false)) {
        element.qty = element.qty! + 1;
        addItem = false;
        cartViewModel.createMessageForCustomerDisplay(element.getProductName(),
            getReadableAmount(getCurrency(), element.getPerUnitPrice()));
      }
    });

    int cartLength = cartSummary.cartItems?.length ?? 0;
    if (addItem) {
      cartItem.order = cartLength;
      cartSummary.cartItems?.add(cartItem);
      cartViewModel.createMessageForCustomerDisplay(cartItem.getProductName(),
          getReadableAmount(getCurrency(), cartItem.getPerUnitPrice()));
    }
  }

  _onCustomerSelected(Customers customers) {
    setState(() {
      cartSummary.isBookingSale = false;
      cartSummary.isLayAwaySale = false;
      cartSummary.customers = customers;
      cartSummary.employees = null;
      _updateDreamPriceInAllItems();
    });
  }

  _onEmployeesSelected(Employees selectedEmployee) {
    setState(() {
      cartSummary.isBookingSale = false;
      cartSummary.isLayAwaySale = false;
      cartSummary.customers = null;
      cartSummary.employees = selectedEmployee;
      _updateDreamPriceInAllItems();
    });
  }

  // Should be called when add is added or
  // employee is added/removed or when member is added/removed
  void _updateDreamPriceInAllItems() {
    // cartSummary.cartItems = dreamPriceViewModel.updateDreamPriceForAllItems(
    //     cartSummary, allDreamPrices);
    // validateEmployeeForCart();
  }

  Future<bool> validateEmployeeForCart([CartItem? cartItem]) async {
    if (cartSummary.employees != null &&
        cartSummary.employees!.employeeGroup != null) {
      try {
        bool isValidConfiguration = await saleViewModel
            .validEmployeeGroupConfiguration(cartSummary, cartItem);

        if (!isValidConfiguration) {
          if (cartItem == null) {
            setState(() {
              cartSummary.employees = null;
              cartSummary.saleTye = SaleTye.REGULAR;
              cartSummary.isLayAwaySale = false;
              cartSummary.isBookingSale = false;
            });
          }
          showToast("Employee limit shouldn't exceed", context);
        }
        return isValidConfiguration;
      } catch (e) {
        MyLogUtils.logDebug("mEmployeeGroup ${e.toString()}");
      }
    }
    return true;
  }

  _selectItem(CartItem cartItem, int cartItemPosition) {
    cartViewModel.resetDisplayDevice();
    setState(() {
      cartSummary.cartItems?[cartItemPosition].setIsSelectItem(true);
    });
  }

  _unSelectItem(CartItem cartItem, int cartItemPosition) {
    cartViewModel.resetDisplayDevice();
    setState(() {
      cartSummary.cartItems?[cartItemPosition].setIsSelectItem(false);
    });
  }

  _removeProduct(CartItem cartItem, int cartItemPosition) {
    cartViewModel.resetDisplayDevice();
    setState(() {
      cartSummary.cartItems?.removeAt(cartItemPosition);
      if (cartSummary.getTotalAmount() <= 0) {
        cartSummary.cartCustomDiscount = null;
      }
      if (_isEnableGroupPayment) {
        _isEnableGroupPayment = cartSummary.cartItems!.isNotEmpty;
      }
    });
  }

  _updateQty(CartItem cartItem, int cartItemPosition) async {
    final isValid = await validateEmployeeForCart(cartItem);
    setState(() {
      int index = 0;
      cartSummary.cartItems?.forEach((element) {
        if (cartItemPosition == index) {
          element.itemWisePromotionData = null;
          element.qty = cartItem.qty;
          if (cartItem.checkIsSame(element) &&
              (!isValid) &&
              (cartItem.qty ?? 1) > 1) {
            element.qty = ((cartItem.qty ?? 1) - 1);
          }

          cartViewModel.createMessageForCustomerDisplay(
              element.getProductName(),
              getReadableAmount(getCurrency(),
                  (element.product?.price ?? 0) * (element.qty ?? 1)));
        }
        index = index + 1;
      });

      if (cartSummary.getTotalAmount() <= 0) {
        cartSummary.cartCustomDiscount = null;
      }
    });
  }

  /// localIdToBeRemoved - this is added to handle maybank terminal.
  /// If payment success in mbb, then payment ytpe selected is gettng updated with amount & new payment
  /// type selected based on card type is also getting updated
  _onPaymentSelected(
      PaymentTypeData paymentTypeData,
      String? localIdToBeRemoved,
      double balanceChangeDue,
      MayBankPaymentDetails? details,
      bool completeSale) {
    setState(() {
      var add = true;
      cartSummary.payments?.forEach((element) {
        if (localIdToBeRemoved != null &&
            element.paymentType?.localId == localIdToBeRemoved) {
          element.amount = 0;
        }

        MyLogUtils.logDebug(
            "_onPaymentSelected paymentTypeData : ${paymentTypeData.toJson()} && element : ${element.toJson()}");

        if (element.paymentType?.localId ==
            paymentTypeData.paymentType?.localId) {
          add = false;
          element.amount = paymentTypeData.amount;
          element.cardNo = paymentTypeData.cardNo;
        }
      });

      if (add) {
        cartSummary.payments?.add(paymentTypeData);
      }

      cartSummary.changeDue = balanceChangeDue > 0 ? balanceChangeDue : 0;

      if (details != null) {
        List<MayBankPaymentDetails> list =
            cartSummary.mayBankPaymentDetailList ?? List.empty(growable: true);
        list.add(details);

        MyLogUtils.logDebug("mayBankPaymentDetailList : ${list.length}");
        cartSummary.mayBankPaymentDetailList = list;
      }

      cartViewModel.createMessageForCustomerDisplay(
          '${getDoubleValue(paymentTypeData.amount)} of ${paymentTypeData.paymentType?.name} for',
          getReadableAmount(getCurrency(), cartSummary.getTotalAmount()));
    });
  }

  _onPromotersAdded(List<Promoters> promoters, int productId, bool assignToAll,
      bool clearAll) {
    setState(() {
      _updatePromotersToCartItems(productId, assignToAll, promoters, clearAll);
    });
  }

  _onPriceUpdated(CartItem cartItem, int index, bool assignToAll,
      double percentageToBeUsed, int quantity) {
    MyLogUtils.logDebug(
        "_onPriceUpdated : $cartSummary and index : $index & quantity:$quantity");
    MyLogUtils.logDebug("cartItems length : ${cartSummary.cartItems?.length} ");

    MyLogUtils.logDebug(
        "cartSummary.cartItems :\n ${jsonEncode(cartSummary.cartItems)} \n...");

    setState(() {
      cartSummary.cartItems = cartViewModel.onPriceUpdated(
          cartSummary.cartItems ?? [],
          cartItem,
          index,
          assignToAll,
          percentageToBeUsed,
          quantity);
    });
  }

  _onComplimentaryItemAdded(
    CartItem cartItem,
    int index,
    CartItemFocData focData,
  ) {
    setState(() {
      cartSummary.cartItems = cartViewModel.onComplimentaryItemUpdated(
          cartSummary.cartItems ?? [], cartItem, index, focData);
    });
  }

  void _updatePromotersToCartItems(int productId, bool assignToAll,
      List<Promoters> promoters, bool clearAll) {
    cartSummary.cartItems?.forEach((element) {
      if (clearAll) {
        element.promoters = promoters;
      } else {
        if (element.product?.id == productId && !assignToAll) {
          element.promoters = promoters;
        }

        if (assignToAll &&
            (element.promoters == null || element.promoters!.isEmpty)) {
          element.promoters = promoters;
        }
      }
    });
  }

  _completeSale(List<CartItem> cartItems) {
    _clearCart(cartItems);
  }

  void _clearCart(List<CartItem> cartItems) {
    cartViewModel.resetDisplayDevice();
    setState(() {
      attachCustomerToSale = true;
      attachCustomerEmployeeText = "Member";
      //cartSummary.cartCustomDiscount = null;
      cartSummary = CartSummary(
          cartItems: List.empty(growable: true),
          payments: List.empty(growable: true));
      cartSummary.offlineSaleId = null;
      cartSummary.triggerCustomerPopUpAtLeastOnce = null;
      if (cartItems.isNotEmpty) {
        cartItems.removeWhere((item) => item.getIsSelectItem() == true);
        cartSummary.cartItems!.addAll(cartItems);
        if (cartSummary.cartItems!.isEmpty) {
          _isEnableGroupPayment = false;
        }
      }
    });
  }

  _onRemarksEntered(String remarks) {
    setState(() {
      cartSummary.remarks = remarks;
    });
  }

  _onBillRefEntered(String billRefNumber) {
    setState(() {
      cartSummary.billReferenceNumber = billRefNumber;
    });
  }

  _markAsLayAwaySale(bool value) {
    setState(() {
      cartSummary.isLayAwaySale = value;
      if (value) {
        cartSummary.isBookingSale = false;
        cartSummary.saleTye = SaleTye.LAYAWYAY;
      } else {
        cartSummary.isBookingSale = false;
        cartSummary.saleTye = SaleTye.REGULAR;
      }
    });
  }

  _markAsBookingSale(bool value) {
    setState(() {
      cartSummary.isBookingSale = value;
      if (value) {
        cartSummary.isLayAwaySale = false;
        cartSummary.saleTye = SaleTye.BOOKING;
      } else {
        cartSummary.isLayAwaySale = false;
        cartSummary.saleTye = SaleTye.REGULAR;
      }
    });
  }

  _onVoucherEntered(String voucherCode) async {
    MyLogUtils.logDebug("voucherCode : $voucherCode");
    Vouchers? voucher = await vouchersViewModel.searchVoucher(voucherCode);

    MyLogUtils.logDebug("voucher : $voucher");

    if (voucher == null) {
      setState(() {
        _resetVoucherData("Invalid voucher code.");
      });
      return;
    }
    setState(() {
      _onVoucherSelected(voucher);
    });
  }

  void _recheckVoucherApplied() {
    if (cartSummary.vouchers != null) {
      _onVoucherSelected(cartSummary.vouchers!);
    }
  }

  void _onVoucherSelected(Vouchers voucher) {
    //Check if voucher is valid for this cart
    String? errorMessage =
        vouchersViewModel.isValidVoucherForThisCart(voucher, cartSummary);

    MyLogUtils.logDebug(
        "_onVoucherSelected ${voucher.toJson()}  & error Message: $errorMessage");

    if (errorMessage != null) {
      _resetVoucherData(errorMessage);
      return;
    }

    cartSummary.voucherErrorMessage = null;
    cartSummary.vouchers = voucher;
    cartSummary.voucherCode = voucher.number;
  }

  void _resetVoucherData(String message) {
    cartSummary.voucherErrorMessage = message;
    cartSummary.vouchers = null;
    cartSummary.voucherCode = null;
    cartSummary.voucherDiscountAmount = null;
    showToast(message, context);
  }

  _showValidDiscountDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return ValidPromotionsWidget(
          cartSummary: cartSummary,
          pickBestPromotions: (pickBestPromotion) {
            Navigator.pop(context);
            setState(() {
              cartSummary.cartItems = cartViewModel
                  .removeAllDiscountsAndGroupItCorrectly(cartSummary);
              cartSummary.autoPickPromotions = pickBestPromotion;
            });
          },
          onPromotionSelected: (itemPromotions, cartPromotion) {
            setState(() {
              cartSummary.cartItems = cartViewModel
                  .removeAllDiscountsAndGroupItCorrectly(cartSummary);
              cartSummary.autoPickPromotions = false;
              cartSummary.promotionData ??= PromotionData();
              cartSummary.promotionData!.appliedItemDiscounts = itemPromotions;
              cartSummary.promotionData!.cartWideDiscount = cartPromotion;
            });
          },
        );
      },
    );
  }

  void _triggerCustomerPopup() {
    setState(() {
      cartSummary.triggerCustomerPopUpAtLeastOnce = true;
      _addNewCustomer();
    });
  }

  void _addNewCustomer() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AddQuickCustomer(
          onCustomerAdded: (customer) {
            setState(() {
              _onCustomerSelected(customer);
            });
          },
        );
      },
    );
  }

  void _showOpenPriceDialog(CartItem cartItem, int cartItemPosition) {
    showDialog(
        context: context,
        builder: (context) {
          return AddOpenPriceDialog(
            cartItem: cartItem,
            onPriceUpdated: (item, price) {
              _onOpenPriceUpdated(item, cartItemPosition, price);
            },
          );
        });
  }

  void _showOpenSplitDialog(CartItem cartItem, int cartItemPosition) {
    setState(() {
      try {
        int qty = cartItem.qty!.toInt() - 1;
        cartItem.qty = 1;
        for (int i = 0; i < qty; i++) {
          CartItem setCartItem = CartItem();
          setCartItem = CartItem.fromJson(cartItem.toJson());
          cartSummary.cartItems?.add(setCartItem);
        }
      } catch (e) {}

      if (cartSummary.getTotalAmount() <= 0) {
        cartSummary.cartCustomDiscount = null;
      }
    });
  }

  void _onOpenPriceUpdated(
      CartItem item, int cartItemPosition, double openPrice) {
    setState(() {
      cartSummary.cartItems = cartViewModel.onOpenPriceAdded(
          cartSummary.cartItems ?? [], item, cartItemPosition, openPrice);
    });
  }
}
