import 'package:flutter/material.dart';
import 'package:jakel_base/restapi/giftcards/model/GiftCardsResponse.dart';
import 'package:jakel_base/widgets/appbgwidget/MyBackgroundWidget.dart';
import 'package:jakel_pos/modules/giftcard/ui/widgets/gift_card_detail_widget.dart';
import 'package:jakel_pos/modules/giftcard/ui/widgets/gift_card_list_widget.dart';

class GiftCardScreen extends StatefulWidget {
  const GiftCardScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GiftCardScreenState();
  }
}

class _GiftCardScreenState extends State<GiftCardScreen> {
  GiftCards? selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: MyBackgroundWidget(child: rootWidget()));
  }

  Widget rootWidget() {
    List<Widget> widgets = List.empty(growable: true);

    /// Tab children view
    widgets.add(
      Expanded(
          flex: 8,
          child: Card(
            child: GiftCardListWidget(
              onSelected: (product) {
                setState(() {
                  selected = product;
                });
              },
            ),
          )),
    );

    ///Detail View
    if (selected != null) {
      widgets.add(Expanded(
          flex: 5,
          child: Card(
            child: GiftCardDetailWidget(
              selectedGiftCards: selected!,
            ),
          )));
    } else {
      widgets.add(Expanded(
          flex: 5,
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
  }
}
