import 'package:flutter/material.dart';
import 'package:jakel_base/database/sale/model/CartCustomDiscount.dart';
import 'package:jakel_base/database/sale/model/CartItem.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/restapi/directors/model/DirectorsResponse.dart';
import 'package:jakel_base/restapi/managers/model/StoreManagersResponse.dart';
import 'package:jakel_base/restapi/me/model/CurrentUserResponse.dart';
import 'package:jakel_base/sale/sale_helper.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/widgets/button/MyOutlineButton.dart';
import 'package:jakel_base/widgets/custom/MyDataContainerWidget.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';
import 'package:jakel_base/widgets/textfield/MyTextFieldWidget.dart';
import 'package:jakel_pos/modules/cashiers/CashiersViewModel.dart';
import 'package:jakel_pos/modules/directors/DirectorsViewModel.dart';
import 'package:jakel_pos/modules/storemanagers/StoreManagersViewModel.dart';
import 'package:jakel_pos/modules/utils/focus_scope.dart';

import '../../../common/UserViewModel.dart';
import '../../helper/cart_summary_utils.dart';

class CartCustomDiscountDialog extends StatefulWidget {
  final CartSummary cartSummary;
  final Function onUpdated;

  const CartCustomDiscountDialog(
      {Key? key, required this.cartSummary, required this.onUpdated})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CartCustomDiscountState();
  }
}

class _CartCustomDiscountState extends State<CartCustomDiscountDialog>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  final int storeManagerType = 1, directorType = 2, cashierType = 3;
  var userViewModel = UserViewModel();

  final passCodeController = TextEditingController();
  final employeeIdController = TextEditingController();
  final percentController = TextEditingController();
  final amountController = TextEditingController();
  final qtyController = TextEditingController();

  final passCodeNode = FocusNode();
  final percentNode = FocusNode();
  final amountNode = FocusNode();
  final staffIdNode = FocusNode();
  final qtyNode = FocusNode();

  int passCodeType = -1; // Store managers;
  final storeManagerViewModel = StoreManagersViewModel();
  final directorViewModel = DirectorsViewModel();
  final cashiersViewModel = CashiersViewModel();

  StoreManagers? storeManagers;
  Directors? directors;
  Cashier? selectedCashier;

  String? passCode;
  String? staffId;
  double? priceOverrideLimitPercentage;
  double? percentageToBeUsed;
  double? _cartItemDiscount;

  double? priceEntered;
  int? quantity;
  bool alreadyCartCustomDiscountIsEnabled = false;
  late CartCustomDiscount cartCustomDiscount;

  double payableCartAmount = 0.0;
  double? payablePriceOverrideToBeUsed;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    passCodeType = cashierType; //By default
    super.initState();

    MyLogUtils.logDebug("CartCustomDiscountDialog cartSummary "
        ": ${widget.cartSummary.toJson()}");
    payableCartAmount =
        getTotalPayableAmountForManualCartDiscount(widget.cartSummary);
    cartCustomDiscount =
        widget.cartSummary.cartCustomDiscount ?? CartCustomDiscount();

    if ((cartCustomDiscount.discountPercentage ?? 0) > 0) {
      alreadyCartCustomDiscountIsEnabled = true;
    }

    MyLogUtils.logDebug("CartCustomDiscountDialog "
        "  cartCustomDiscount:${cartCustomDiscount.toJson()}"
        "& getPayableCartAmount : $payableCartAmount "
        "& alreadyCartCustomDiscountIsEnabled: $alreadyCartCustomDiscountIsEnabled");
  }

  @override
  void dispose() {
    _controller?.dispose();
    passCodeNode.dispose();
    percentNode.dispose();
    amountNode.dispose();
    staffIdNode.dispose();
    qtyNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.all(10.0),
          constraints: const BoxConstraints.expand(),
          child: MyDataContainerWidget(
            child: getRootWidget(),
          ),
        ));
  }

  Widget getRootWidget() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: getChildren(),
      ),
    );
  }

  List<Widget> getChildren() {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(getHeader());

    widgets.add(const SizedBox(
      height: 5,
    ));
    widgets.add(const Divider());

    widgets.add(const SizedBox(
      height: 5,
    ));

    widgets.add(
      Text(
          getReadableAmount("RM",
              getTotalPayableAmountForManualCartDiscount(widget.cartSummary)),
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.caption),
    );
    widgets.add(const SizedBox(
      height: 5,
    ));

    // If this item has price override already, it should removed first in order to update new %
    if (alreadyCartCustomDiscountIsEnabled) {
      widgets.add(
        Text(
            'Already custom manual discount :${getRoundedDoubleValue(widget.cartSummary.cartCustomDiscount?.discountPercentage)} %'
            ' is provided to this cart. To change, please the remove manual discount.',
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.caption),
      );
      widgets.add(const SizedBox(
        height: 10,
      ));
      widgets.add(removeManualDiscount());

      widgets.add(const SizedBox(
        height: 5,
      ));
    } else {
      widgets.add(const Divider());

      widgets.add(getEmployeeTypeWidget());

      widgets.add(const Divider());

      if (passCodeType == -1) {
        return widgets;
      }
      widgets.add(const SizedBox(
        height: 5,
      ));

      if (passCodeType == cashierType) {
        widgets.add(getCurrentCashier());
        widgets.add(const SizedBox(
          height: 5,
        ));
      }

      if (passCodeType != cashierType) {
        widgets.add(MyTextFieldWidget(
          controller: employeeIdController,
          node: staffIdNode,
          hint: 'Enter employee id & press enter for selection',
          onSubmitted: (value) {
            setState(() {
              staffId = value;
              focusSocpeNext(context,passCodeNode);
            });
          },
        ));

        widgets.add(const SizedBox(
          height: 5,
        ));

        if (staffId != null) {
          widgets.add(MyTextFieldWidget(
              controller: passCodeController,
              node: passCodeNode,
              obscureText: true,
              hint: 'Enter passcode & press enter for selection',
              onSubmitted: (value) {
                setState(() {
                  passCode = value;
                });
              }));
          widgets.add(const SizedBox(
            height: 5,
          ));
          FocusScope.of(context).requestFocus(passCodeNode);
        }
      }

      if (passCodeType == storeManagerType &&
          passCode != null &&
          staffId != null) {
        widgets.add(const SizedBox(
          height: 5,
        ));
        widgets.add(getStoreManager());
        widgets.add(const SizedBox(
          height: 5,
        ));
      }

      if (passCodeType == directorType && passCode != null && staffId != null) {
        widgets.add(const SizedBox(
          height: 5,
        ));
        widgets.add(getDirectors());
        widgets.add(const SizedBox(
          height: 5,
        ));
      }

      widgets.add(MyTextFieldWidget(
          controller: percentController,
          node: percentNode,
          onSubmitted: (value) {
            _onPercentageEntered(value);
          },
          onChanged: (value) {
            _onPercentageEntered(value);
          },
          hint: 'Discount in percentage'));

      widgets.add(const SizedBox(
        height: 5,
      ));

      widgets.add(Text(
        'or',
        style: Theme.of(context).textTheme.caption,
      ));

      widgets.add(const SizedBox(
        height: 5,
      ));

      widgets.add(MyTextFieldWidget(
          controller: amountController,
          node: amountNode,
          onChanged: (value) {
            _onAmountEntered(value);
          },
          onSubmitted: (value) {
            _onAmountEntered(value);
          },
          hint: 'New Cart Amount'));

      widgets.add(const SizedBox(
        height: 5,
      ));

      if (percentageToBeUsed != null) {
        widgets.add(const SizedBox(
          height: 5,
        ));

        widgets.add(MyOutlineButton(
            text: "Done",
            onClick: () {
              _savePriceOverride();
            }));

        widgets.add(const SizedBox(
          height: 5,
        ));
      }

      widgets.add(const SizedBox(
        height: 5,
      ));
    }
    return widgets;
  }

  void _savePriceOverride() {
    cartCustomDiscount.cashier = null;
    cartCustomDiscount.manager = null;
    cartCustomDiscount.directors = null;

    if (selectedCashier != null) {
      cartCustomDiscount.cashier = selectedCashier;
    }

    if (storeManagers != null) {
      cartCustomDiscount.manager = storeManagers;
    }
    if (directors != null) {
      cartCustomDiscount.directors = directors;
    }

    cartCustomDiscount.discountPercentage = 100 - (percentageToBeUsed ?? 0);

    double totalAmount =
        getTotalPayableAmountForManualCartDiscount(widget.cartSummary);

    cartCustomDiscount.priceOverrideAmount = getRoundedValueForCalculations(
        totalAmount -
            (totalAmount * (cartCustomDiscount.discountPercentage ?? 1) / 100));

    MyLogUtils.logDebug(
        "cartCustomDiscount  json : ${cartCustomDiscount.toJson()}");

    widget.onUpdated(cartCustomDiscount);
    Navigator.of(context).pop();
  }

  void _onAmountEntered(String value) {
    return setState(() {
      if (!isNumeric(value)) {
        amountController.text = "";
        percentController.text = "";
        showToast("Only numeric is allowed.", context);
        return;
      }

      if (priceOverrideLimitPercentage == null) {
        percentageToBeUsed = null;
        showToast(
            "Please select cashier or store manager or director and enter correct passcode to proceed!",
            context);
        amountController.text = "";
        percentController.text = "";
        return;
      }

      priceEntered = getDoubleValue(value);

      if ((priceEntered ?? 0) > payableCartAmount) {
        percentageToBeUsed = null;
        showToast("New price should be less than payable cart price.", context);
        amountController.text = "";
        percentController.text = "";
        return;
      }

      percentageToBeUsed = _getPercentageFromPrice();

      MyLogUtils.logDebug(
          "percentageToBeUsed : $percentageToBeUsed for priceEntered : $priceEntered");

      percentController.text =
          getOnlyReadableAmount(100 - (percentageToBeUsed ?? 100));

      if (priceOverrideLimitPercentage != null &&
          (double.parse(percentController.text)) <=
              priceOverrideLimitPercentage!) {
        payablePriceOverrideToBeUsed = priceEntered;
        _cartItemDiscount =
            getTotalPayableAmountForManualCartDiscount(widget.cartSummary) -
                (payablePriceOverrideToBeUsed ?? 0.0);

        MyLogUtils.logDebug("_cartItemDiscount : $_cartItemDiscount");
      } else {
        percentageToBeUsed = null;
        showToast("New Price is invalid", context);
      }
    });
  }

  void _onPercentageEntered(String value) {
    setState(() {
      if (!isNumeric(value)) {
        showToast("Only numeric is allowed.", context);
        priceEntered = null;
        percentageToBeUsed = null;
        amountController.text = "";
        percentController.text = "";
        return;
      }

      if (priceOverrideLimitPercentage == null) {
        priceEntered = null;
        percentageToBeUsed = null;
        amountController.text = "";
        percentController.text = "";
        showToast(
            "Please select cashier or store manager or director and enter correct passcode to proceed!",
            context);
        return;
      }

      double discountPercent = getDoubleValue(value);

      if (priceOverrideLimitPercentage != null &&
          discountPercent <= priceOverrideLimitPercentage!) {
        _cartItemDiscount = cartItemDiscount(
            widget.cartSummary.cartItems!, getDoubleValue(value));

        percentageToBeUsed = 100 - getDoubleValue(value);
        priceEntered = _getOverridePriceAmount();

        double overAllDiscountPercent = getDiscountPercentFromNewAmount(
            (priceEntered ?? 0), payableCartAmount);

        if (priceOverrideLimitPercentage != null &&
            overAllDiscountPercent <= priceOverrideLimitPercentage!) {
          payablePriceOverrideToBeUsed = priceEntered;
          amountController.text = getOnlyReadableAmount(priceEntered);
        } else {
          percentageToBeUsed = null;
          priceEntered = null;
          showToast("New discount percentage is invalid.", context);
        }
      } else {
        percentageToBeUsed = null;
        showToast("New discount percentage is invalid.", context);
      }
    });
  }

  double newPrice(double cartItemDiscount) {
    return getRoundedDoubleValue(
        getTotalPayableAmountForManualCartDiscount(widget.cartSummary) -
            cartItemDiscount);
  }

  double cartItemDiscount(List<CartItem> cartItems, double discount) {
    double allTotal = 0.0;
    for (CartItem element in cartItems) {
      if (element.getIsSelectItem()) {
        allTotal = allTotal + element.getProductSubTotal() * (discount / 100);
      }
    }
    return getRoundedDoubleValue(allTotal);
  }

  Widget removeManualDiscount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            widget.onUpdated(null);
            Navigator.of(context).pop();
          },
          child: const Text(
            'Remove manual discount for this cart',
            style: TextStyle(
              fontSize: 14,
              decoration: TextDecoration.underline,
              color: Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
        )
      ],
    );
  }

  double _getOverridePriceAmount() {
    return getDoubleValue(percentageToBeUsed! * payableCartAmount / 100);
  }

  double _getPercentageFromPrice() {
    return ((priceEntered ?? 0) * 100 / getDoubleValue(payableCartAmount));
  }

  Widget getHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Cart Manual discount",
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

  Widget getCurrentCashier() {
    return FutureBuilder(
        future: userViewModel.getCurrentUser(),
        builder: (BuildContext context,
            AsyncSnapshot<CurrentUserResponse?> snapshot) {
          if (snapshot.hasData) {
            selectedCashier = snapshot.data?.cashier!;
            priceOverrideLimitPercentage =
                selectedCashier?.priceOverrideLimitPercentageCart ?? 0.0;
            return getMessageWidget("${selectedCashier?.firstName}");
          }
          return const Text("Loading Widget");
        });
  }

  Widget getStoreManager() {
    return FutureBuilder(
        future: storeManagerViewModel.getStoreManager(
            passCodeController.text, staffId ?? ""),
        builder:
            (BuildContext context, AsyncSnapshot<StoreManagers?> snapshot) {
          if (snapshot.hasError) {
            storeManagers = null;
            return const Text("Invalid Passcode or Employee Id!");
          }

          if (snapshot.hasData) {
            storeManagers = snapshot.data;
            if (storeManagers != null) {
              priceOverrideLimitPercentage =
                  storeManagers!.priceOverrideLimitPercentageCart;
              FocusScope.of(context).requestFocus(percentNode);
              return getMessageWidget(storeManagers!.firstName!);
            }
            return const Text("Invalid passcode!");
          }
          return const Text("Loading ...");
        });
  }

  Widget getDirectors() {
    return FutureBuilder(
        future: directorViewModel.getDirector(
            passCodeController.text, staffId ?? ""),
        builder: (BuildContext context, AsyncSnapshot<Directors?> snapshot) {
          if (snapshot.hasError) {
            storeManagers = null;
            return const Text("Invalid passcode!");
          }
          if (snapshot.hasData) {
            directors = snapshot.data;
            if (directors != null) {
              priceOverrideLimitPercentage =
                  directors!.priceOverrideLimitPercentageCart;
              return getMessageWidget(directors!.firstName!);
            }
            return const Text("Invalid passcode!");
          }
          return const Text("Loading ...");
        });
  }

  Widget getMessageWidget(String name) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        "Up to ${(priceOverrideLimitPercentage ?? 0.0)}"
        "% discount of current price is allowed \nBy $name ",
        style: Theme.of(context).textTheme.caption,
      ),
    );
  }

  Widget getEmployeeTypeWidget() {
    return IntrinsicHeight(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            child: RadioListTile(
          title: const Text("Cashier"),
          value: cashierType,
          groupValue: passCodeType,
          controlAffinity: ListTileControlAffinity.trailing,
          onChanged: (value) {
            setState(() {
              resetData();
              passCodeType = cashierType;
            });
          },
        )),
        const VerticalDivider(
          thickness: 1,
        ),
        Expanded(
            child: RadioListTile(
          title: const Text("Manager"),
          value: storeManagerType,
          groupValue: passCodeType,
          controlAffinity: ListTileControlAffinity.trailing,
          onChanged: (value) {
            setState(() {
              resetData();
              passCodeType = storeManagerType;
            });
          },
        )),
        const VerticalDivider(
          thickness: 1,
        ),
        Expanded(
            child: RadioListTile(
          title: const Text("Director"),
          value: directorType,
          groupValue: passCodeType,
          controlAffinity: ListTileControlAffinity.trailing,
          onChanged: (value) {
            setState(() {
              resetData();
              passCodeType = directorType;
            });
          },
        ))
      ],
    ));
  }

  void resetData() {
    staffId = null;
    selectedCashier = null;
    directors = null;
    storeManagers = null;
    passCode = null;
    passCodeController.text = "";
    percentageToBeUsed = null;
    priceOverrideLimitPercentage = null;
  }
}
