import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:jakel_base/restapi/counters/model/GetCountersResponse.dart';
import 'package:jakel_base/restapi/counters/model/GetStoresResponse.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/widgets/textfield/MyTextFieldWidget.dart';
import 'package:jakel_pos/modules/opencounter/ui/open_counter_in_herited_widget.dart';
import 'package:jakel_pos/modules/opencounter/viewmodel/CountersViewModel.dart';

class OpeningBalanceWidget extends StatefulWidget {
  const OpeningBalanceWidget({Key? key, required this.onOpeningBalanceChanged})
      : super(key: key);
  final Function onOpeningBalanceChanged;

  @override
  State<StatefulWidget> createState() {
    return _OpeningBalanceWidgetState();
  }
}

class _OpeningBalanceWidgetState extends State<OpeningBalanceWidget> {
  final viewModel = CountersViewModel();
  late Stores? store;
  late Counters? counter;
  final expandController = ExpandableController(initialExpanded: true);
  final openingBalanceCounter = TextEditingController();

  @override
  Widget build(BuildContext context) {
    store = OpenCounterInHeritedWidget.of(context).object.store;
    counter = OpenCounterInHeritedWidget.of(context).object.counters;
    openingBalanceCounter.text = viewModel.getOpeningBalanceNoCurrency(context);
    return Card(
        clipBehavior: Clip.antiAlias,
        child: ExpandableNotifier(
            controller: expandController,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                                      viewModel.isOpeningBalancedAdded(context)
                                          ? Colors.green
                                          : Colors.grey.shade300),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                softWrap: true,
                                tr('counter_opening_balance'),
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
                              viewModel.getOpeningBalance(context),
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
                      expanded: openingBalanceWidget(),
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

  Widget openingBalanceWidget() {
    if (store != null && counter != null) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: MediaQuery.of(context).size.width / 3),
            child: MyTextFieldWidget(
              controller: openingBalanceCounter,
              node: FocusNode(),
              hint: tr('counter_enter_opening_balance'),
              onChanged: (value) {
                if (!isNumeric(value)) {
                  openingBalanceCounter.text = '';
                  showToast("Only numeric value is allowed", context);
                  return;
                }
              },
              onSubmitted: (value) {
                setState(() {
                  try {
                    OpenCounterInHeritedWidget.of(context)
                        .object
                        .openingBalance = getDoubleValue(value);
                    expandController.toggle();
                    widget.onOpeningBalanceChanged();
                  } catch (e) {
                    showToast("Invalid opening balance.", context);
                  }
                });
              },
            )),
      );
    }
    return Container();
  }
}
