import 'package:flutter/material.dart';
import 'package:jakel_base/restapi/customers/model/CustomersResponse.dart';
import 'package:jakel_base/widgets/appbgwidget/MyBackgroundWidget.dart';
import 'package:jakel_pos/modules/customers/ui/widget/customer_detail_widget.dart';
import 'package:jakel_pos/modules/customers/ui/widget/customers_list_widget.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CustomersScreenState();
  }
}

class _CustomersScreenState extends State<CustomersScreen> {
  Customers? selected;

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
            child: CustomersListWidget(
              onSelected: (element) {
                setState(() {
                  selected = element;
                });
              },
            ),
          )),
    );

    /// Detail View
    if (selected != null) {
      widgets.add(Expanded(
          flex: 5,
          child: CustomerDetailWidget(
            customers: selected!,
            close: () {
              setState(() {
                selected = null;
              });
            },
          )));
    } else {
      widgets.add(Expanded(
          flex: 5,
          child: Card(
              child: Center(
            child: Text(
              "Select a customer to view in detail",
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
