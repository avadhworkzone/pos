import 'package:flutter/material.dart';
import 'package:jakel_base/restapi/products/model/ProductsResponse.dart';
import 'package:jakel_base/widgets/appbgwidget/MyBackgroundWidget.dart';
import 'package:jakel_pos/modules/products/ui/widgets/products_detail_widget.dart';
import 'package:jakel_pos/modules/products/ui/widgets/products_list_widget.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProductsScreenState();
  }
}

class _ProductsScreenState extends State<ProductsScreen> {
  Products? selected;

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
            child: ProductsListWidget(
              onSelected: (product) {
                setState(() {
                  selected = product;
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
            child: ProductsDetailWidget(
              selectedProduct: selected!,
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
  }
}
