import 'package:flutter/material.dart';
import 'package:jakel_base/database/promoters/PromotersLocalApi.dart';
import 'package:jakel_base/locator.dart';
import 'package:jakel_base/restapi/promoters/model/PromotersResponse.dart';

import 'package:jakel_base/widgets/button/MyOutlineButton.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';
import 'package:jakel_base/widgets/loadingwidget/MyLoadingWidget.dart';
import 'package:jakel_base/widgets/multiselect/multi_select_widget.dart';
import 'package:jakel_base/widgets/nodatawidget/NoDataWidget.dart';

import 'package:jakel_base/database/sale/model/CartItem.dart';

class MultiSelectPromotersWidget extends StatefulWidget {
  final Function onPromotersAdded;
  final List<Promoters>? selectedPromoters;
  final bool showAssignToAll;

  const MultiSelectPromotersWidget(
      {Key? key,
      required this.onPromotersAdded,
      required this.selectedPromoters,
      required this.showAssignToAll})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MultiSelectPromotersWidgetState();
  }
}

class _MultiSelectPromotersWidgetState
    extends State<MultiSelectPromotersWidget> {
  List<Promoters>? promoters;
  var api = locator.get<PromotersLocalApi>();
  bool assignToAll = false;
  bool clearAll = false;
  List<Promoters>? selectedPromoters;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        height: 540,
        width: 450,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Promoters',
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
            ),
            const SizedBox(
              height: 15,
            ),
            getSelectedPromoters(),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: getPromotersData(),
            ),
            widget.showAssignToAll
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Assign to all items',
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
                  )
                : Container(),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MyOutlineButton(
                    text: 'Clear All',
                    onClick: () {
                      setState(() {
                        selectedPromoters = [];
                        clearAll = true;
                        _updatePromotersList();
                      });
                    }),
                const SizedBox(
                  width: 10,
                ),
                MyOutlineButton(text: 'Done', onClick: _updatePromotersList),
              ],
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }

  Widget getSelectedPromoters() {
    var existingPromoters = selectedPromoters ?? widget.selectedPromoters ?? [];

    if (existingPromoters.isEmpty) {
      return Container();
    }
    List<Widget> widgets = List.empty(growable: true);

    for (var element in existingPromoters) {
      widgets.add(Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(5),
        color: Theme.of(context).dividerColor,
        child: Text(
          '${element.firstName} ${element.lastName ?? ''}',
          style: Theme.of(context).textTheme.caption,
        ),
      ));
    }

    return SizedBox(
      height: 40,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: ScrollController(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgets,
        ),
      ),
    );
  }

  Widget getPromotersData() {
    return FutureBuilder(
        future: api.getAll(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Promoters>> snapshot) {
          if (snapshot.hasData) {
            promoters = snapshot.data;
            return getRoot();
          }
          return const MyLoadingWidget();
        });
  }

  Widget getRoot() {
    if (promoters == null || promoters!.isEmpty) {
      return const NoDataWidget();
    }

    return MultiSelectWidget(
      data: promoters!,
      getKey: (Promoters data) {
        return data.id;
      },
      getValue: (Promoters data) {
        return '${data.firstName} ${data.lastName ?? ''} (${data.staffId})';
      },
      selected: selectedPromoters ?? widget.selectedPromoters ?? [],
      onDataSelected: (List dataList) {
        setState(() {
          selectedPromoters = [];
          for (var element in dataList) {
            selectedPromoters?.add(element);
          }
        });
      },
    );
  }

  void _updatePromotersList() {
    widget.onPromotersAdded(selectedPromoters, assignToAll, clearAll);
    Navigator.pop(context);
  }
}
