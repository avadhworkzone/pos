import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:jakel_base/dataprovider/store_data.dart';
import 'package:jakel_base/restapi/counters/model/GetStoresResponse.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/widgets/errorwidget/MyErrorWidget.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';
import 'package:jakel_base/widgets/loadingwidget/MyLoadingWidget.dart';
import 'package:jakel_pos/modules/opencounter/ui/open_counter_in_herited_widget.dart';
import 'package:jakel_pos/modules/opencounter/viewmodel/StoresViewModel.dart';

class SelectStoresWidget extends StatefulWidget {
  const SelectStoresWidget({Key? key, required this.onStoreChanged})
      : super(key: key);
  final Function onStoreChanged;

  @override
  State<StatefulWidget> createState() {
    return _SelectStoresWidgetState();
  }
}

class _SelectStoresWidgetState extends State<SelectStoresWidget> {
  final viewModel = StoresViewModel();
  late Stores? store;
  final expandController = ExpandableController(initialExpanded: true);

  @override
  initState() {
    super.initState();
  }

  _initData() {
    viewModel.getStores();
  }

  @override
  Widget build(BuildContext context) {
    store = OpenCounterInHeritedWidget.of(context).object.store;
    return Card(
        clipBehavior: Clip.antiAlias,
        child: ExpandableNotifier(
            controller: expandController,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  ScrollOnExpand(
                    scrollOnExpand: true,
                    scrollOnCollapse: false,
                    child: ExpandablePanel(
                      theme: const ExpandableThemeData(
                        headerAlignment: ExpandablePanelHeaderAlignment.center,
                        tapBodyToCollapse: true,
                      ),
                      header: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle_outline,
                                  color:
                                      viewModel.isStoreSelected(context, store)
                                          ? Colors.green
                                          : Colors.grey.shade300),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                softWrap: true,
                                tr(viewModel.isStoreSelected(context, store)
                                    ? 'counter_selected_store'
                                    : 'counter_select_store'),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          )),
                      collapsed: Padding(
                        padding: const EdgeInsets.only(left: 28),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getStoreName(store),
                              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: getPrimaryColor(context)),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              getStoreAddress(store),
                              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: getPrimaryColor(context),
                                  fontSize: 10),
                            )
                          ],
                        ),
                      ),
                      expanded: storeApiWidget(),
                      builder: (_, collapsed, expanded) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 10),
                          child: Expandable(
                            collapsed: collapsed,
                            expanded: expanded,
                            theme: const ExpandableThemeData(
                              crossFadePoint: 0,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )));
  }

  Widget storeApiWidget() {
    MyLogUtils.logDebug("storeApiWidget");
    if (OpenCounterInHeritedWidget.of(context)
        .object
        .counterLockedToThisMachine) {
      return Text("This machine is locked to :${store?.name}.\n"
          "If you want to change store, select Logout & clear configuration option in top right menu.");
    }
    _initData();
    return StreamBuilder<List<Stores>>(
      stream: viewModel.responseSubject,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MyLoadingWidget();
        }
        if (snapshot.hasError) {
          return MyErrorWidget(
              message: "Error",
              tryAgain: () {
                _initData();
                setState(() {});
              });
        }
        if (snapshot.connectionState == ConnectionState.active) {
          var responseData = snapshot.data;
          if (responseData != null) {
            return storeListWidget(responseData);
          } else {
            return MyErrorWidget(
                message: "Error",
                tryAgain: () {
                  _initData();
                  setState(() {});
                });
          }
        }
        return Container();
      },
    );
  }

  Widget storeListWidget(List<Stores> data) {
    return ListView.separated(
      separatorBuilder: (context, index) => Container(
        height: 10,
      ),
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context, index) {
        return storesListRowWidget(data[index], index + 1);
      },
    );
  }

  Widget storesListRowWidget(Stores store, int position) {
    var color = getWhiteColor(context);
    color = getWhiteColor(context);
    color = color.withOpacity(0.1);

    return MyInkWellWidget(
      onTap: () {
        selectStore(store);
      },
      child: Container(
          decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(const Radius.circular(10)),
              border: Border.all(color: Theme.of(context).dividerColor)),
          child: IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 20.0, bottom: 20.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("$position.",
                          style: Theme.of(context).textTheme.bodySmall),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(getStoreName(store),
                          style: Theme.of(context).textTheme.bodySmall),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(getStoreAddress(store),
                          style: Theme.of(context).textTheme.bodySmall),
                    ),
                  ),
                  viewModel.isStoreSelected(context, store)
                      ? const Icon(
                          Icons.check_circle_outline,
                          color: Colors.green,
                        )
                      : const SizedBox()
                ],
              ),
            ),
          )),
    );
  }

  void selectStore(Stores store) {
    setState(() {
      expandController.toggle();
      OpenCounterInHeritedWidget.of(context).object.store = store;
      widget.onStoreChanged();
    });
  }
}
