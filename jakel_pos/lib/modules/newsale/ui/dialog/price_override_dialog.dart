import 'package:flutter/material.dart';
import 'package:jakel_base/database/sale/model/CartItem.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/restapi/directors/model/DirectorsResponse.dart';
import 'package:jakel_base/restapi/managers/model/StoreManagersResponse.dart';
import 'package:jakel_base/restapi/me/model/CurrentUserResponse.dart';
import 'package:jakel_base/restapi/priceoverridetypes/model/PriceOverrideTypesResponse.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/widgets/button/MyOutlineButton.dart';
import 'package:jakel_base/widgets/custom/MyDataContainerWidget.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';
import 'package:jakel_base/widgets/textfield/MyTextFieldWidget.dart';
import 'package:jakel_pos/modules/cashiers/CashiersViewModel.dart';
import 'package:jakel_pos/modules/directors/DirectorsViewModel.dart';
import 'package:jakel_pos/modules/newsale/NewSaleViewModel.dart';
import 'package:jakel_pos/modules/newsale/service/item_price_override_service.dart';
import 'package:jakel_pos/modules/priceoverridetypes/PriceOverrideTypesViewModel.dart';
import 'package:jakel_pos/modules/storemanagers/StoreManagersViewModel.dart';

import '../../../app_locator.dart';
import '../../../common/UserViewModel.dart';

class PriceOverrideDialog extends StatefulWidget {
  final CartSummary cartSummary;
  final CartItem cartItem;
  final Function onPriceUpdated;

  const PriceOverrideDialog(
      {Key? key,
      required this.cartItem,
      required this.onPriceUpdated,
      required this.cartSummary})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PriceOverrideDialogState();
  }
}

class _PriceOverrideDialogState extends State<PriceOverrideDialog>
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
  final priceOverrideTypesViewModel = PriceOverrideTypesViewModel();
  final newSaleViewModel = NewSaleViewModel();
  var priceOverriderService = appLocator.get<ItemPriceOverrideService>();
  List<PriceOverrideTypes> priceOverrideTypes = [];
  StoreManagers? storeManagers;
  Directors? directors;
  Cashier? selectedCashier;

  String? passCode;
  String? staffId;
  double? priceOverrideLimitPercentage;
  double? percentageToBeUsed;
  double? priceEntered;
  int? quantity;
  bool isThisPriceOverrideItem = false;
  double? allowedStaffPrice;
  double? allowedStaffPercentage;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    passCodeType = cashierType; //By default assssign to cashier
    super.initState();
    quantity = getInValue(widget.cartItem.qty);
    qtyController.text = '$quantity';

    if (widget.cartItem.cartItemPriceOverrideData != null &&
        widget.cartItem.cartItemPriceOverrideData?.priceOverrideAmount !=
            null &&
        widget.cartItem.cartItemPriceOverrideData!.priceOverrideAmount! > 0) {
      isThisPriceOverrideItem = true;
    }
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
    if (assignToAll) {
      qtyController.text = "1";
      quantity = 1;
    }
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.all(10.0),
          constraints: const BoxConstraints.expand(),
          child: MyDataContainerWidget(
            child: getPriceOverrideTypes(),
          ),
        ));
  }

  //Fetching the price override types from local.
  Widget getPriceOverrideTypes() {
    return FutureBuilder(
        future: priceOverrideTypesViewModel.getAllTypes(),
        builder: (BuildContext context,
            AsyncSnapshot<List<PriceOverrideTypes>> snapshot) {
          if (snapshot.hasData) {
            priceOverrideTypes = snapshot.data ?? [];
            return getRootWidget();
          }
          return const Text("Loading Widget");
        });
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

    //Product Name
    widgets.add(
      Text(widget.cartItem.getProductName(),
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.caption),
    );
    widgets.add(const SizedBox(
      height: 5,
    ));

    // Product Price that will be used to calculate the discount %
    widgets.add(
      Text(
          getReadableAmount("RM",
              widget.cartItem.cartItemPrice?.priceToBeUsedForManualDiscount),
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.caption),
    );
    widgets.add(const SizedBox(
      height: 5,
    ));

    // Max Allowed Qty
    widgets.add(
      Text('Max Allowed Quantity is : ${getInValue(widget.cartItem.qty)}',
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.caption),
    );

    widgets.add(const SizedBox(
      height: 10,
    ));

    // If this item has price override already, it should removed first in order to update new %

    if (isThisPriceOverrideItem) {
      widgets.add(
        Text(
            'Already manual discount is provided to this item. To change, please the remove manual discount.',
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.caption),
      );
      widgets.add(const SizedBox(
        height: 10,
      ));
    }

    if (!isThisPriceOverrideItem) {
      widgets.add(MyTextFieldWidget(
        controller: qtyController,
        node: qtyNode,
        hint: "Enter quantity",
        enabled: !assignToAll,
        onChanged: (value) {
          _onQtyUpdated(value);
        },
      ));

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
            },
          ));

          if (passCodeController.text.isEmpty) {
            FocusScope.of(context).requestFocus(passCodeNode);
          }

          widgets.add(const SizedBox(
            height: 5,
          ));
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
          hint: 'New price'));

      widgets.add(const SizedBox(
        height: 5,
      ));

      if (percentageToBeUsed != null) {
        widgets.add(const SizedBox(
          height: 5,
        ));

        widgets.add(Text("New price is "
            "${getReadableAmount("RM", priceEntered)}"));

        widgets.add(const SizedBox(
          height: 5,
        ));
      }
    }

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

    widgets.add(
      assignToAllWidget(),
    );
    widgets.add(const SizedBox(
      height: 5,
    ));

    if (widget.cartItem.cartItemPriceOverrideData != null &&
        widget.cartItem.cartItemPriceOverrideData?.priceOverrideAmount !=
            null &&
        widget.cartItem.cartItemPriceOverrideData!.priceOverrideAmount! > 0) {
      widgets.add(removeManualDiscount());

      widgets.add(const SizedBox(
        height: 5,
      ));
    }
    return widgets;
  }

  void _onQtyUpdated(String value) {
    setState(() {
      try {
        quantity = getInValue(value);
        if ((quantity ?? 0) > (widget.cartItem.qty ?? 0)) {
          _onQtyError("Quantity should be less than available qty in cart.");
        }
      } catch (e) {
        _onQtyError("Only numeric value is allowed in quantity");
      }
    });
  }

  void _onQtyError(String message) {
    quantity = null;
    qtyController.text = "";
    showToast(message, context);
  }

  void _savePriceOverride() {
    if (quantity == null) {
      showToast("Please enter quantity", context);
      return;
    }
    widget.cartItem.cartItemPriceOverrideData?.storeManagerId = null;
    widget.cartItem.cartItemPriceOverrideData?.storeManagerPasscode = null;
    widget.cartItem.cartItemPriceOverrideData?.directorId = null;
    widget.cartItem.cartItemPriceOverrideData?.directorPasscode = null;

    widget.cartItem.cartItemPriceOverrideData?.cashierId = null;

    if (selectedCashier != null) {
      widget.cartItem.cartItemPriceOverrideData?.cashierId =
          selectedCashier!.id;
    }

    if (storeManagers != null) {
      widget.cartItem.cartItemPriceOverrideData?.storeManagerId =
          storeManagers!.id!;
      widget.cartItem.cartItemPriceOverrideData?.storeManagerPasscode =
          storeManagers!.passcode!;
    }
    if (directors != null) {
      widget.cartItem.cartItemPriceOverrideData?.directorId = directors!.id!;
      widget.cartItem.cartItemPriceOverrideData?.directorPasscode =
          directors!.passcode!;
    }

    widget.cartItem.cartItemPriceOverrideData?.priceOverrideAmount =
        _getOverridePriceAmount();

    MyLogUtils.logDebug(
        " widget.cartItem.priceOverrideAmount  : ${widget.cartItem.cartItemPriceOverrideData?.priceOverrideAmount}");
    widget.cartItem.cartItemPriceOverrideData
            ?.priceOverrideAmountDiscountPercent =
        double.parse(percentController.text);
    widget.onPriceUpdated(
        widget.cartItem, assignToAll, percentageToBeUsed, quantity);
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

      if ((priceEntered ?? 0) > widget.cartItem.getOriginalProductPrice()) {
        percentageToBeUsed = null;
        showToast(
            "New price should be less than original product price.", context);
        amountController.text = "";
        percentController.text = "";
        return;
      }
      // widget.cartItem.priceOverrideAmount = null;
      percentageToBeUsed = _getPercentageFromPrice();

      MyLogUtils.logDebug(
          "percentageToBeUsed : $percentageToBeUsed for priceEntered : $priceEntered");

      percentController.text =
          getOnlyReadableAmount(100 - (percentageToBeUsed ?? 100));

      if (priceOverrideLimitPercentage != null &&
          (double.parse(percentController.text)) <=
              priceOverrideLimitPercentage!) {
        // widget.cartItem.priceOverrideAmount = priceEntered;
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
        amountController.text = "";
        percentController.text = "";
        return;
      }

      if (priceOverrideLimitPercentage == null) {
        percentageToBeUsed = null;
        amountController.text = "";
        percentController.text = "";
        showToast(
            "Please select cashier or store manager or director and enter correct passcode to proceed!",
            context);
        return;
      }

      // Get Discount Percent as double
      double discountPercent = getDoubleValue(value);

      MyLogUtils.logDebug(
          "Item price override dialog discountPercent : $discountPercent");
      MyLogUtils.logDebug(
          "Item price override dialog priceOverrideLimitPercentage : $priceOverrideLimitPercentage");

      if (priceOverrideLimitPercentage != null &&
          discountPercent <= priceOverrideLimitPercentage!) {
        percentageToBeUsed = 100 - discountPercent;
        priceEntered = _getOverridePriceAmount();
        amountController.text = getOnlyReadableAmount(priceEntered);

        MyLogUtils.logDebug("priceEntered : $priceEntered");

        // widget.cartItem.priceOverrideAmount = priceEntered;
        // amountController.text = getOnlyReadableAmount(priceEntered);

        // In case of dream price , already item is having some discount.
        // On top of that manual discount is provided.

        // This check is added, because as per backend more than
        // allowed discount is not allowed.So, if this any discount is allowed in top of dream price,
        // just comment this if & else
        // double overAllDiscountPercent = getDiscountPercentFromNewAmount(
        //     (priceEntered ?? 0), widget.cartItem.getOriginalProductPrice());

        // if (priceOverrideLimitPercentage != null &&
        //     overAllDiscountPercent <= priceOverrideLimitPercentage!) {
        //   // widget.cartItem.priceOverrideAmount = priceEntered;
        //   amountController.text = getOnlyReadableAmount(priceEntered);
        // } else {
        //   percentageToBeUsed = null;
        //   priceEntered = null;
        //   showToast("New discount percentage is invalid.", context);
        // }
      } else {
        percentageToBeUsed = null;
        showToast("New discount percentage is invalid.", context);
      }
    });
  }

  bool assignToAll = false;

  Widget assignToAllWidget() {
    if (isThisPriceOverrideItem) {
      return Container();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Assign same percentage to all items (Group Discount)\nIncase of group discount, quantity field will be ignored.',
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Checkbox(
            value: assignToAll,
            onChanged: (value) {
              setState(() {
                if (value != null) assignToAll = value;
              });
            })
      ],
    );
  }

  Widget removeManualDiscount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            widget.cartItem.cartItemPriceOverrideData
                ?.priceOverrideAmountDiscountPercent = null;
            widget.cartItem.cartItemPriceOverrideData?.priceOverrideAmount =
                null;
            widget.cartItem.cartItemPriceOverrideData?.storeManagerId = null;
            widget.cartItem.cartItemPriceOverrideData?.storeManagerPasscode =
                null;
            widget.cartItem.cartItemPriceOverrideData?.directorId = null;
            widget.cartItem.cartItemPriceOverrideData?.directorPasscode = null;
            widget.cartItem.cartItemPriceOverrideData?.cashierId = null;

            widget.onPriceUpdated(
                widget.cartItem, false, getDoubleValue(-1), 0);
            Navigator.of(context).pop();
          },
          child: const Text(
            'Remove manual discount for this item',
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
    return getDoubleValue(percentageToBeUsed! *
        (widget.cartItem.cartItemPrice?.priceToBeUsedForManualDiscount ?? 0) /
        100);
  }

  double _getPercentageFromPrice() {
    return ((priceEntered ?? 0) *
        100 /
        getDoubleValue(widget.cartItem.getProductPriceForPriceOverride()));
  }

  Widget getHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Manual & group discount",
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
                priceOverriderService.getPercentageAllowed(
                    priceOverrideTypes,
                    widget.cartItem,
                    widget.cartSummary,
                    selectedCashier,
                    null,
                    null);

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
                  priceOverriderService.getPercentageAllowed(
                      priceOverrideTypes,
                      widget.cartItem,
                      widget.cartSummary,
                      null,
                      storeManagers,
                      null);

              //FocusScope.of(context).requestFocus(percentNode);

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
                  priceOverriderService.getPercentageAllowed(
                      priceOverrideTypes,
                      widget.cartItem,
                      widget.cartSummary,
                      null,
                      null,
                      directors);
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
