import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:jakel_base/dataprovider/counter_data.dart';
import 'package:jakel_base/restapi/counters/model/GetCountersResponse.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/widgets/errorwidget/MyErrorWidget.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';
import 'package:jakel_base/widgets/loadingwidget/MyLoadingWidget.dart';
import 'package:jakel_pos/modules/opencounter/ui/open_counter_in_herited_widget.dart';
import 'package:jakel_pos/modules/opencounter/viewmodel/CountersViewModel.dart';

class SelectCountersWidget extends StatefulWidget {
  const SelectCountersWidget({Key? key, required this.onCounterChanged})
      : super(key: key);
  final Function onCounterChanged;

  @override
  State<StatefulWidget> createState() {
    return _SelectCountersWidgetState();
  }
}

class _SelectCountersWidgetState extends State<SelectCountersWidget> {
  final viewModel = CountersViewModel();
  late Counters? counter;
  final expandController = ExpandableController(initialExpanded: false);

  @override
  initState() {
    super.initState();
  }

  _initData() {
    if (OpenCounterInHeritedWidget.of(context).object.store != null) {
      viewModel.getCounters(
          OpenCounterInHeritedWidget.of(context).object.store!.id!);
      if (OpenCounterInHeritedWidget.of(context).object.counters == null) {
        expandController.toggle();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _initData();
    counter = OpenCounterInHeritedWidget.of(context).object.counters;
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
                                  color: viewModel.isCounterSelected(
                                          context, counter)
                                      ? Colors.green
                                      : Colors.grey.shade300),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                softWrap: true,
                                tr(viewModel.isCounterSelected(context, counter)
                                    ? 'counter_selected_counter'
                                    : 'counter_select_counter'),
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
                              getCounterName(counter),
                              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: getPrimaryColor(context)),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      expanded: apiWidget(),
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

  Widget apiWidget() {
    if (OpenCounterInHeritedWidget.of(context)
        .object
        .counterLockedToThisMachine) {
      return Text("This machine is locked to counter: ${counter?.name}.\n"
          "If you want to change counter,select Logout & clear configuration option in top right menu.");
    }

    if (OpenCounterInHeritedWidget.of(context).object.store == null) {
      return Container();
    }
    return StreamBuilder<List<Counters>>(
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
            return countersListWidget(responseData);
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

  Widget countersListWidget(List<Counters> data) {
    return ListView.separated(
      separatorBuilder: (context, index) => Container(
        height: 10,
      ),
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context, index) {
        return countersListRowWidget(data[index], index + 1);
      },
    );
  }

  Widget countersListRowWidget(Counters counter, int position) {
    var color = getWhiteColor(context);
    color = getWhiteColor(context);
    color = color.withOpacity(0.1);

    return MyInkWellWidget(
      onTap: () {
        if (isLocked(counter)) {
          showToast(
              "Sorry! This counter is locked by admin.Locked counters cannot be opened. Please contact your admin.",
              context);
          return;
        }

        if (isOpened(counter)) {
          showToast("Sorry! This counter is already opened.", context);
          return;
        }

        setState(() {
          if (OpenCounterInHeritedWidget.of(context).object.counters == null) {
            expandController.toggle();
          }
          OpenCounterInHeritedWidget.of(context).object.counters = counter;
          widget.onCounterChanged();
        });
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
                      child: Text(getCounterName(counter),
                          style: Theme.of(context).textTheme.bodySmall),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(isLocked(counter) ? "Locked" : "",
                          style: Theme.of(context).textTheme.bodySmall),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                            color: isOpened(counter)
                                ? Colors.red.shade200
                                : Colors.green.shade200,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20.0))),
                        padding: const EdgeInsets.all(8),
                        child: Text(
                            isOpened(counter) ? "Already Opened" : "Available",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12)),
                      ),
                    ),
                  ),
                  viewModel.isCounterSelected(context, counter)
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
}
