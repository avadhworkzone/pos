import 'package:flutter/material.dart';
import 'package:jakel_base/restapi/promotions/model/PromotionsResponse.dart';
import 'package:jakel_base/widgets/appbgwidget/MyBackgroundWidget.dart';
import 'package:jakel_pos/modules/products/ui/widgets/products_list_widget.dart';
import 'package:jakel_pos/modules/promotions/ui/widgets/promotions_list_widget.dart';

import 'widgets/promotions_detail_widget.dart';

class PromotionsScreen extends StatefulWidget {
  const PromotionsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PromotionsScreenState();
  }
}

class _PromotionsScreenState extends State<PromotionsScreen> {
  Promotions? selected;


  @override
  Widget build(BuildContext context) {
    return Scaffold(body: MyBackgroundWidget(child: rootWidget()));
  }

  Widget rootWidget() {
    List<Widget> widgets = List.empty(growable: true);

    // Tab children view
    widgets.add(
      Expanded(
          flex: 5,
          child: Card(
            child: PromotionsListWidget(
              onSelected: (promotions) {
                setState(() {
                  selected = promotions;
                });
              },
            ),
          )),
    );

    //Detail View
    if (selected != null) {
      widgets.add(Expanded(
          flex: 3,
          child: Card(
            child: PromotionsDetailWidget(
              selectedPromotion: selected!,
            ),
          )));
    } else {
      widgets.add(Expanded(
          flex: 3,
          child: Card(
              child: Center(
                child: Text(
                  "Select a product to view in detail",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ))));
    }

    return Container(
        margin: const EdgeInsets.all(5.0),
        child: Row(
          children: widgets,
        ));

    return PromotionsListWidget(
      onSelected: (promotion) {},
    );
  }
}
