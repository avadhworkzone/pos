import 'package:flutter/material.dart';
import 'package:jakel_base/database/sale/model/CartItem.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/extension/ProductsDataExtension.dart';
import 'package:jakel_base/jakel_base.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/widgets/incdecwidget/inc_dec_widget.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';
import 'package:jakel_pos/modules/newsale/CartViewModel.dart';
import 'package:jakel_pos/modules/newsale/NewSaleViewModel.dart';
import 'package:jakel_pos/modules/newsale/ui/dialog/complimentary_item_dialog.dart';
import 'package:jakel_pos/modules/newsale/ui/dialog/multi_select_promoters_widget.dart';
import 'package:jakel_pos/modules/newsale/ui/dialog/price_override_dialog.dart';

import '../../../keyboardshortcuts/cart_item_keyboard_shortcut.dart';

class NewSaleCartWidget extends StatefulWidget {
  final bool isEnableGroupPayment;
  final CartSummary cartSummary;
  final Function selectItem;
  final Function unSelectItem;
  final Function removeItem;
  final Function updateQty;
  final Function onPromotersAdded;
  final Function onPriceUpdated;
  final Function onComplimentaryItemAdded;
  final Function showOpenPriceDialog;
  final Function showOpenSplitDialog;

  NewSaleCartWidget({
    Key? key,
    required this.isEnableGroupPayment,
    required this.cartSummary,
    required this.selectItem,
    required this.unSelectItem,
    required this.removeItem,
    required this.onPromotersAdded,
    required this.onPriceUpdated,
    required this.onComplimentaryItemAdded,
    required this.updateQty,
    required this.showOpenPriceDialog,
    required this.showOpenSplitDialog,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NewSaleCartWidgetState();
  }
}

class _NewSaleCartWidgetState extends State<NewSaleCartWidget> {
  late CartSummary cartSummary;
  final viewModel = NewSaleViewModel();
  final cartViewModel = CartViewModel();
  ScrollController listViewScrollController = ScrollController();
  bool viewScroll = true;
  var length = 0;

  @override
  Widget build(BuildContext context) {
    cartSummary = widget.cartSummary;

    return Container(
        constraints: const BoxConstraints.expand(),
        child: Card(
          child: Column(
            children: [
              cartItemHeader(),
              Expanded(
                child: Container(
                  child: cartItemsListWidget(),
                ),
              ),
              const Divider(),
              cartItemFooter(),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ));
  }

  Widget cartItemHeader() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4), topRight: Radius.circular(4)),
          color: Theme.of(context).colorScheme.tertiaryContainer,
          border:
              Border.all(width: 0.5, color: Theme.of(context).indicatorColor)),
      height: 50,
      child: Row(
        children: [
          SizedBox(width: widget.isEnableGroupPayment ? 45 : 15),
          const SizedBox(width: 5),
          const Text('#'),
          const SizedBox(width: 10),
          const SizedBox(width: 20),
          const SizedBox(
              width: 60,
              child: Center(
                child: Text(""),
              )),
          const Expanded(flex: 4, child: Text("Item")),
          const Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.center,
                child: Text("Quantity"),
              )),
          const Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text("Price (RM)"),
              )),
          const Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text("Discount"),
              )),
          const Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text("Total (RM)"),
              )),
          const SizedBox(
            width: 10,
          )
        ],
      ),
    );
  }

  Widget cartItemFooter() {
    return SizedBox(
      height: 20,
      child: Row(
        children: [
          const SizedBox(width: 5),
          const Text(''),
          const SizedBox(width: 10),
          const SizedBox(width: 20),
          const SizedBox(
              width: 60,
              child: Center(
                child: Text(""),
              )),
          Expanded(
              flex: 4,
              child: Text(
                "Total Items : ${getStringWithNoDecimal(cartViewModel.getTotalItems(cartSummary))}",
              )),
          Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Total Quantity : ${getStringWithNoDecimal(cartViewModel.getTotalQuantity(cartSummary))}",
                ),
              )),
          const Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(""),
              )),
          const Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(""),
              )),
          const Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(""),
              )),
          const SizedBox(
            width: 10,
          )
        ],
      ),
    );
  }

  Widget cartItemsListWidget() {
    if (cartSummary.cartItems == null || cartSummary.cartItems!.isEmpty) {
      return const Center(
        child: Text("Search or scan item or enter upc ..."),
      );
    }
    if (cartSummary.cartItems != null) {
      cartSummary.cartItems!
          .sort((a, b) => (a.order ?? 0).compareTo((b.order ?? 0)));
    }
    if (length != cartSummary.cartItems!.length) {
      if (length < cartSummary.cartItems!.length) {
        viewScroll = true;
      }
      length = cartSummary.cartItems!.length;
    }
    try {
      if (length > 1 && viewScroll) {
        listViewScrollController.animateTo(
            listViewScrollController.position.maxScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300));
      }
    } catch (e) {}
    return ListView.separated(
        controller: listViewScrollController,
        separatorBuilder: (context, index) => Divider(
              color: Theme.of(context).indicatorColor,
            ),
        shrinkWrap: true,
        itemCount: length,
        itemBuilder: (context, index) {
          //Add all short cuts for last added item
          if (index == length - 1) {
            return CartItemKeyboardShortcut(
                child: cartItemRow(cartSummary.cartItems![index], index),
                onFoc: () {
                  showComplimentaryDialog(cartSummary.cartItems![index], index);
                },
                onAddPromoter: () {
                  showAssignExecutiveDialog(
                      cartSummary.cartItems![index], index);
                },
                onPriceOverride: () {
                  showPriceOverrideDialog(cartSummary.cartItems![index], index);
                });
          }

          //For all previous items no short cuts
          return cartItemRow(cartSummary.cartItems![index], index);
        });
  }

  Widget moreMenu(CartItem item, int index) {
    List<PopupMenuEntry<int>> menus = List.empty(growable: true);

    if (widget.cartSummary.isExchange != null &&
        widget.cartSummary.isExchange == true) {
      // Exchange items.
      menus.add(PopupMenuItem(
        value: 1,
        child: Text(
          "Assign Promoters",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ));
      menus.add(PopupMenuItem(
        value: 4,
        child: Text(
          "Open Price",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ));
    } else {
      // Normal Sales
      menus.add(PopupMenuItem(
        value: 1,
        child: Text(
          "Assign Promoters",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ));

      if (item.isOpenPriceItem()) {
        menus.add(PopupMenuItem(
          value: 4,
          child: Text(
            "Open Price",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ));
      } else {
        // Group discount is allowed only for item with price greater than 0.
        if ((item.cartItemPrice?.totalAmount ?? 0) > 0 &&
            !cartSummary.isBookingItemReset) {
          menus.add(PopupMenuItem(
            value: 2,
            child: Text(
              "Manual & Group Discount",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ));
        }
        if (!cartSummary.isBookingItemReset) {
          menus.add(PopupMenuItem(
              value: 3,
              child: Text(
                "FOC",
                style: Theme.of(context).textTheme.bodyLarge,
              )));
        }
      }
    }
    if (widget.isEnableGroupPayment && item.qty! > 1) {
      menus.add(PopupMenuItem(
        value: 5,
        child: Text(
          "Split",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ));
    }
    return PopupMenuButton<int>(
      itemBuilder: (context) => [...menus],
      icon: const Icon(
        Icons.more_horiz_outlined,
        size: 20.0,
        color: Colors.black87,
      ),
      offset: const Offset(10, 30),
      tooltip: "Item Menu",
      onSelected: (value) {
        setState(() {
          if (value == 1) {
            showAssignExecutiveDialog(item, index);
          } else if (value == 2) {
            showPriceOverrideDialog(item, index);
          } else if (value == 3) {
            showComplimentaryDialog(item, index);
          } else if (value == 5) {
            widget.showOpenSplitDialog(item, index);
          } else {
            widget.showOpenPriceDialog(item, index);
          }
        });
      },
    );
  }

  Widget cartItemRow(CartItem cartItem, int index) {
    return Container(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Row(
        children: [
          getEnableGroupWidget(cartItem, index),
          const SizedBox(width: 5),
          Text('${index + 1}.'),
          const SizedBox(width: 5),
          getGiftIconWidget(cartItem),
          getDreamPriceWidget(cartItem),
          SizedBox(
            width: 60,
            child: Center(
              child: moreMenu(cartItem, index),
            ),
          ),
          Expanded(flex: 4, child: cartItemDetails(cartItem, index)),
          Expanded(
              flex: 3,
              child: IncDecWidget(
                showOnlyQty: cartItem.saleReturnsItemData != null,
                count: cartItem.qty ?? 0.0,
                allowDecimal: cartItem.allowDecimalQty(),
                onCountUpdated: (count) {
                  // In terms of exchange, we should not allow to add more items than request.
                  if (count > (cartItem.qty ?? 0.0) &&
                      cartSummary.isExchange != null &&
                      cartSummary.isExchange == true) {
                    if (cartSummary.getDueAmount() >= 0) {
                      showToast(
                          "In exchange total amount cannot exceed more than amount paid for exchange item",
                          context);
                      return;
                    }
                  }

                  if (count <= 0) {
                    widget.removeItem(cartItem, index);
                    viewScroll = false;
                  } else {
                    cartItem.qty = count;
                    if ((cartItem.batchDetails != null) &&
                        (cartItem.batchDetails!.isNotEmpty)) {
                      cartItem.batchDetails![0]
                          .setQuantity(cartItem.qty!.toInt());
                    }
                    widget.updateQty(cartItem, index);
                    viewScroll = false;
                  }
                },
              )),
          Expanded(flex: 2, child: getSingleProductPrice(cartItem)),
          Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    getReadableAmount(
                        getCurrency(), cartItem.getDiscountAmount()),
                    textAlign: TextAlign.end,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    getPercentageAmount(cartItem.getTotalDiscountPercent()),
                    style: Theme.of(context).textTheme.caption,
                    textAlign: TextAlign.end,
                  )
                ],
              )),
          Expanded(
              flex: 2,
              child: Text(
                getOnlyReadableAmount(cartItem.cartItemPrice?.totalAmount),
                textAlign: TextAlign.end,
              )),
          const SizedBox(
            width: 10,
          )
        ],
      ),
    );
  }

  Widget getDreamPriceWidget(CartItem cartItem) {
    return (cartItem.cartItemDreamPriceData != null &&
            (cartItem.cartItemDreamPriceData?.dreamPrice ?? 0) > 0)
        ? const Icon(
            Icons.monetization_on_outlined,
            size: 10,
          )
        : const SizedBox(width: 10);
  }

  Widget getEnableGroupWidget(CartItem cartItem, int index) {
    return Column(
      children: [
        SizedBox(
            width: widget.isEnableGroupPayment ? 45 : 15,
            child: widget.isEnableGroupPayment
                ? Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: Checkbox(
                      checkColor: Colors.white,
                      value: cartItem.getIsSelectItem(),
                      onChanged: (bool? value) {
                        if (cartItem.getIsSelectItem()) {
                          widget.unSelectItem(cartItem, index);
                        } else {
                          widget.selectItem(cartItem, index);
                        }
                      },
                    ),
                  )
                : SizedBox()),
      ],
    );
  }

  Widget getGiftIconWidget(CartItem cartItem) {
    return (cartItem.makeItGiftWithPurchase != null &&
            cartItem.makeItGiftWithPurchase == true)
        ? const Icon(
            Icons.card_giftcard,
            size: 10,
          )
        : const SizedBox(width: 10);
  }

  Widget getSingleProductPrice(CartItem cartItem) {
    return IntrinsicHeight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            getOnlyReadableAmount(cartItem.cartItemPrice?.originalPrice),
            textAlign: TextAlign.end,
            style: const TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }

  Widget cartItemDetails(CartItem cartItem, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        cartItem.saleReturnsItemData == null
            ? Container()
            : Text(
                (cartSummary.isExchange != null &&
                        cartSummary.isExchange == true)
                    ? "(Exchange) ${cartItem.saleReturnsItemData?.reason?.reason ?? ''}"
                    : "(Returns) ${cartItem.saleReturnsItemData?.reason?.reason ?? ''}",
                style: Theme.of(context).textTheme.caption,
              ),
        Text(
          cartItem.getProductName(),
          style: const TextStyle(fontSize: 12),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          "${cartItem.product?.upc ?? ''} (${cartItem.product?.articleNumber ?? ''})",
          style: const TextStyle(fontSize: 12),
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            cartItem.product!.color == null
                ? Container()
                : Text(
                    cartItem.product!.getProductColor(),
                    style: Theme.of(context).textTheme.caption,
                  ),
            SizedBox(
              width: cartItem.product!.color == null ? 1 : 10,
            ),
            cartItem.product!.size == null
                ? Container()
                : Text(
                    cartItem.product!.getProductSize(),
                    style: Theme.of(context).textTheme.caption,
                  ),
            SizedBox(
              width: cartItem.product!.size == null ? 1 : 10,
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        promoters(cartItem, index),
        cartItem.isComplementaryItem()
            ? Text(
                "FOC",
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).primaryColor,
                  decoration: TextDecoration.underline,
                ),
              )
            : Container()
      ],
    );
  }

  void showAssignExecutiveDialog(CartItem item, int cartItemPosition) {
    showDialog(
        context: context,
        builder: (context) {
          return MultiSelectPromotersWidget(
            showAssignToAll: true,
            selectedPromoters: item.promoters,
            onPromotersAdded: (items, assignToAll, clearAll) {
              widget.onPromotersAdded(
                  items, item.product?.id, assignToAll, clearAll);
            },
          );
        });
  }

  void showComplimentaryDialog(CartItem item, int cartItemPosition) {
    showDialog(
        context: context,
        builder: (context) {
          return ComplimentaryItemDialog(
            cartItem: item,
            addAsComplimentaryItem: (data) {
              widget.onComplimentaryItemAdded(item, cartItemPosition, data);
            },
          );
        });
  }

  void showPriceOverrideDialog(CartItem item, int cartItemPosition) {
    showDialog(
        context: context,
        builder: (context) {
          return PriceOverrideDialog(
            cartSummary: cartSummary,
            cartItem: item,
            onPriceUpdated:
                (cartItem, assignToAll, percentageToBeUsed, quantity) {
              widget.onPriceUpdated(cartItem, cartItemPosition, assignToAll,
                  percentageToBeUsed, quantity);
            },
          );
        });
  }

  Widget promoters(CartItem item, int cartItemPosition) {
    if (item.promoters == null || item.promoters!.isEmpty) {
      if (item.saleReturnsItemData == null ||
          item.saleReturnsItemData?.saleItem == null ||
          item.saleReturnsItemData?.saleItem?.promoters == null) {
        return Container();
      }
    }

    List<InlineSpan> spanTexts = List.empty(growable: true);

    item.promoters?.forEach((element) {
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
    });

    item.saleReturnsItemData?.saleItem?.promoters?.forEach((element) {
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
    });

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
          showAssignExecutiveDialog(item, cartItemPosition);
        });
  }
}
