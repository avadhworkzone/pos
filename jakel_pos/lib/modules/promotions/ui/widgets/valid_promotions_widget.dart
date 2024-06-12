import 'package:flutter/material.dart';
import 'package:jakel_base/restapi/promotions/model/PromotionsResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/widgets/button/MyOutlineButton.dart';
import 'package:jakel_base/widgets/custom/MyDataContainerWidget.dart';
import 'package:jakel_base/widgets/custom/my_vertical_divider.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';
import 'package:jakel_base/widgets/nodatawidget/NoDataWidget.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_pos/modules/promotions/PromotionsViewModel.dart';

class ValidPromotionsWidget extends StatefulWidget {
  final CartSummary cartSummary;
  final Function pickBestPromotions;
  final Function onPromotionSelected;

  const ValidPromotionsWidget(
      {Key? key,
      required this.cartSummary,
      required this.pickBestPromotions,
      required this.onPromotionSelected})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ValidPromotionsWidgetState();
  }
}

class _ValidPromotionsWidgetState extends State<ValidPromotionsWidget>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  final viewModel = PromotionsViewModel();

  List<Promotions> itemWisePromotion = List.empty(growable: true);
  List<Promotions> cartWidePromotion = List.empty(growable: true);
  List<Promotions> allPromotionsForCart = List.empty(growable: true);

  List<Promotions> selectedItemWisePromotion = List.empty(growable: true);
  Promotions? selectedCartWidePromotion;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    widget.cartSummary.promotionData?.appliedItemDiscounts?.forEach((element) {
      selectedItemWisePromotion.add(element);
    });
    selectedCartWidePromotion =
        widget.cartSummary.promotionData?.cartWideDiscount;
  }

  @override
  void dispose() {
    _controller?.dispose();
    viewModel.closeObservable();
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
          width: 800,
          height: 600,
          child: MyDataContainerWidget(
            child: getDoubleDiscountsWidget(),
          ),
        ));
  }

  Widget getDoubleDiscountsWidget() {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(getHeader());

    widgets.add(const Divider());

    widgets.add(Row(
      children: [
        Text(
          "Pick best Promotion",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(
          width: 20,
        ),
        Checkbox(
            value: widget.cartSummary.autoPickPromotions,
            activeColor: Theme.of(context).primaryColor,
            onChanged: (value) {
              setState(() {
                if (value != null) {
                  widget.cartSummary.autoPickPromotions = value;
                  widget.pickBestPromotions(value);
                }
              });
            })
      ],
    ));
    widgets.add(const Divider());
    widgets.add(Row(
      children: [
        Expanded(
            child: Text(
          "Item Wise",
          style: Theme.of(context).textTheme.bodyLarge,
        )),
        Expanded(
            child: Text(
          "Cart Wide",
          style: Theme.of(context).textTheme.bodyLarge,
        )),
      ],
    ));
    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(
        Expanded(child: MyDataContainerWidget(child: getPromotionsWidget())));

    widgets.add(MyOutlineButton(
        text: "Done",
        onClick: () {
          widget.onPromotionSelected(
              selectedItemWisePromotion, selectedCartWidePromotion);
          Navigator.pop(context);
        }));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget getPromotionsWidget() {
    return FutureBuilder(
        future: viewModel.getPromotions(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Promotions>> snapshot) {
          if (snapshot.hasError) {
            MyLogUtils.logDebug("snapshot.hasError : ${snapshot.hasError}");
            return const NoDataWidget();
          }
          if (snapshot.hasData) {
            allPromotionsForCart = snapshot.data!;
            itemWisePromotion = viewModel.filterItemWise(allPromotionsForCart);
            cartWidePromotion = viewModel.filterCartWide(allPromotionsForCart);
            return Row(
              children: [
                Expanded(child: getItemWisePromotion(itemWisePromotion)),
                const MyVerticalDivider(
                  height: double.infinity,
                ),
                Expanded(child: getCartWidgetPromotions(cartWidePromotion))
              ],
            );
          }
          return const Text("Loading ...");
        });
  }

  Widget getHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Valid Promotions",
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

  Widget getItemWisePromotion(List<Promotions> promotions) {
    if (promotions.isEmpty) {
      return const NoDataWidget();
    }
    return ListView.separated(
        separatorBuilder: (context, index) => Divider(
              color: Theme.of(context).indicatorColor,
            ),
        shrinkWrap: false,
        itemCount: promotions.length,
        itemBuilder: (context, index) {
          return getPromotionsRowWidget(true, promotions[index], index);
        });
  }

  Widget getCartWidgetPromotions(List<Promotions> promotions) {
    if (promotions.isEmpty) {
      return const NoDataWidget();
    }
    return ListView.separated(
        separatorBuilder: (context, index) => Divider(
              color: Theme.of(context).indicatorColor,
            ),
        shrinkWrap: false,
        itemCount: promotions.length,
        itemBuilder: (context, index) {
          return getPromotionsRowWidget(false, promotions[index], index);
        });
  }

  Widget getPromotionsRowWidget(
      bool isItemWise, Promotions promotion, int index) {
    bool alreadySelected = false;
    if (isItemWise) {
      for (var element in selectedItemWisePromotion) {
        if (element.id == promotion.id) {
          alreadySelected = true;
        }
      }
    }

    if (!isItemWise &&
        selectedCartWidePromotion != null &&
        selectedCartWidePromotion!.id == promotion.id) {
      alreadySelected = true;
    }

    return Row(children: [
      Text(
        '${index + 1}.',
        style: Theme.of(context).textTheme.caption,
      ),
      const SizedBox(
        width: 20,
      ),
      Expanded(
          child: Text(
        viewModel.getName(promotion),
        style: Theme.of(context).textTheme.caption,
      )),
      Checkbox(
          value: alreadySelected,
          activeColor: Theme.of(context).primaryColor,
          onChanged: (value) {
            setState(() {
              _onPromotionSelected(isItemWise, value, promotion);
            });
          })
    ]);
  }

  void _onPromotionSelected(
      bool isItemWise, bool? value, Promotions promotion) {
    if (isItemWise) {
      // Add promotion to selected
      if (value != null && value == true) {
        bool alreadyAdded = false;
        for (var element in selectedItemWisePromotion) {
          if (element.id == promotion.id) {
            alreadyAdded = true;
          }
        }
        if (!alreadyAdded) {
          selectedItemWisePromotion.add(promotion);
        }
      } else {
        //Removed selected promotion
        for (var element in selectedItemWisePromotion) {
          if (element.id == promotion.id) {
            selectedItemWisePromotion.remove(element);
            break;
          }
        }
      }
    } else {
      if (value != null && value == true) {
        selectedCartWidePromotion = promotion;
      } else {
        selectedCartWidePromotion = null;
      }
    }
  }
}
