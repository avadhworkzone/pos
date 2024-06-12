import 'package:flutter/material.dart';
import 'package:jakel_base/restapi/vouchers/model/VouchersListResponse.dart';
import 'package:jakel_base/widgets/appbgwidget/MyBackgroundWidget.dart';
import 'package:jakel_pos/modules/vouchers/ui/widgets/vouchers_detail_widget.dart';
import 'package:jakel_pos/modules/vouchers/ui/widgets/vouchers_list_widget.dart';

class VouchersScreen extends StatefulWidget {
  const VouchersScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _VouchersScreenState();
  }
}

class _VouchersScreenState extends State<VouchersScreen> {
  Vouchers? selected;

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
            child: VouchersListWidget(
              onSelected: (vouchers) {
                setState(() {
                  selected = vouchers;
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
            child: VouchersDetailWidget(
              selectedVouchers: selected!,
            ),
          )));
    } else {
      widgets.add(Expanded(
          flex: 5,
          child: Card(
              child: Center(
            child: Text(
              "Select a vouchers to view in detail",
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
