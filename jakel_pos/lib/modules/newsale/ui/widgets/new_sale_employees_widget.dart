import 'package:flutter/material.dart';
import 'package:jakel_base/constants.dart';
import 'package:jakel_base/restapi/employees/model/EmployeesResponse.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/widgets/custom/my_vertical_divider.dart';
import 'package:jakel_base/widgets/errorwidget/MyErrorWidget.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';
import 'package:jakel_base/widgets/loadingwidget/MyLoadingWidget.dart';
import 'package:jakel_base/widgets/nodatawidget/NoDataWidget.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_pos/modules/employees/EmployeesViewModel.dart';

class NewSaleEmployeesWidget extends StatefulWidget {
  final CartSummary cartSummary;
  final Function onSelected;
  final Function removeEmployees;
  final Function markAsLayawaySale;
  final Function markAsBookingSale;

  const NewSaleEmployeesWidget({
    Key? key,
    required this.onSelected,
    required this.cartSummary,
    required this.removeEmployees,
    required this.markAsLayawaySale,
    required this.markAsBookingSale,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NewSaleEmployeesWidgetState();
  }
}

class _NewSaleEmployeesWidgetState extends State<NewSaleEmployeesWidget> {
  final viewModel = EmployeesViewModel();

  final searchController = TextEditingController();
  final FocusNode searchNode = FocusNode();
  String? searchText;
  List<Employees>? employeesList;
  Employees? selectedEmployees;
  bool isClear = true;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
          margin: const EdgeInsets.all(4),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  width: 90,
                  height: double.infinity,
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  child: Center(
                    child: Text(
                      "Employee",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),

                Expanded(child: getRootWidget())
              ],
            ),
          )),
    );
  }

  Widget getRootWidget() {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(getMainWidget());

    if (!widget.cartSummary.isExchangeOrReturns()) {
      widgets.add(SizedBox(
        height: 20,
        child: getLayawayBooking(),
      ));
    } else {
      widgets.add(const SizedBox(
        height: 20,
      ));
    }
    widgets.add(const SizedBox(
      height: 10,
    ));

    return Column(
      children: widgets,
    );
  }

  Widget getMainWidget() {
    if (widget.cartSummary.employees == null) {
      return searchWidgetWithList();
    } else {
      return customerDetailsWidget(context);
    }
  }

  Widget customerDetailsWidget(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: Theme.of(context).dividerColor)),
        margin: const EdgeInsets.only(top: 15, bottom: 15, left: 5),
        child: IntrinsicHeight(
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 2,
                  ),
                  Expanded(
                      flex: 3,
                      child: customerNameMobileWidget(
                          viewModel.name(widget.cartSummary.employees!),
                          widget.cartSummary.employees?.mobileNumber ??
                              noData)),
                  const SizedBox(
                    width: 2,
                  ),
                  const MyVerticalDivider(
                    height: 45,
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  Expanded(
                      flex: 2,
                      child: customerPointsVouchers(
                          '${getInValue(widget.cartSummary.employees!.totalLoyaltyPoints)}',
                          0)),
                  deleteIconWidget(context)
                ],
              ),
            ],
          ),
        ));
  }

  Widget getLayawayBooking() {
    if (widget.cartSummary.employees == null) {
      return Container();
    }
    List<Widget> widgets = List.empty(growable: true);

    if (!widget.cartSummary.isBookingSale) {
      widgets.add(
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Layaway',
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Checkbox(
                  value: widget.cartSummary.isLayAwaySale,
                  onChanged: (value) {
                    setState(() {
                      if (value != null) {
                        widget.markAsLayawaySale(value);
                      }
                    });
                  })
            ],
          ),
        ),
      );
    } else {
      widgets.add(Expanded(child: Container()));
    }

    if (!widget.cartSummary.isLayAwaySale && widget.cartSummary.employees==null) {
      widgets.add(Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Booking',
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Checkbox(
                value: widget.cartSummary.isBookingSale,
                onChanged: (value) {
                  setState(() {
                    if (value != null) {
                      widget.markAsBookingSale(value);
                    }
                  });
                })
          ],
        ),
      ));
    } else {
      widgets.add(Expanded(child: Container()));
    }

    return Row(
      children: widgets,
    );
  }

  Widget deleteIconWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.removeEmployees();
      },
      child: Container(
        width: 50,
        height: 60,
        padding: const EdgeInsets.all(0.5),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
            border:
                Border.all(width: 0.1, color: Theme.of(context).dividerColor)),
        child: Icon(
          Icons.close,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }

  Widget searchWidget() {
    return Container(
      margin: const EdgeInsets.only(left: 5,right: 5,bottom: 5,top: 14),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Theme.of(context).dividerColor)),
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              focusNode: searchNode,
              onSubmitted: (value) {
                setState(() {
                  isClear = false;
                  searchText = value;
                  viewModel.getEmployees(1, 50, searchText!);
                });
              },
              style: Theme.of(context).textTheme.bodySmall,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                filled: true,
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 0.0, color: Colors.transparent),
                ),
                fillColor: getWhiteColor(context),
                hintText: 'Search employees & press enter',
                hintStyle: Theme.of(context).textTheme.caption,
              ),
            ),
          ),
          Container(
            width: 1,
            color: Theme.of(context).dividerColor,
          ),
          MyInkWellWidget(
              child: Container(
                width: 50,
                height: 50,
                padding: const EdgeInsets.all(0.5),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5)),
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                    border: Border.all(
                        width: 0.1, color: Theme.of(context).dividerColor)),
                child: Icon(
                  Icons.person_add_alt,
                  color: Theme.of(context).indicatorColor,
                ),
              ),
              onTap: () {
                //widget.addNewCustomer();
              })
        ],
      ),
    );
  }

  Widget searchWidgetWithList() {
    List<Widget> widgets = List.empty(growable: true);
    widgets.add(isClear?Container():getSearchedItemsHeaderWidget());
    widgets.add(isClear?Container():getSearchedItemsWidget());
    widgets.add(searchWidget());

    return IntrinsicHeight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );
  }

  Widget getSearchedItemsHeaderWidget() {
    //When no items are searched
    if (searchText == null || searchText!.isEmpty) {
      return const SizedBox();
    } else {
      return Container(
        margin: const EdgeInsets.only(left: 15, right: 18, top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Employee List",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            MyInkWellWidget(
                child: const Icon(Icons.close),
                onTap: () {
                  setState(() {
                    isClear = true;
                  });
                })
          ],
        ),
      );
    }
  }

  Widget getSearchedItemsWidget() {
    //When no items are searched
    if (searchText == null || searchText!.isEmpty) {
      return const SizedBox();
    }

    return AnimatedContainer(
        height: 200,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: Theme.of(context).dividerColor)),
        margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
        padding: const EdgeInsets.all(10.0),
        duration: const Duration(seconds: 1),
        child: searchingWidget());
  }

  Widget searchedItemsListWidget() {
    if (employeesList == null || employeesList!.isEmpty) {
      return const NoDataWidget();
    }

    return ListView.separated(
        separatorBuilder: (context, index) => Divider(
              color: Theme.of(context).dividerColor,
            ),
        shrinkWrap: true,
        itemCount: employeesList!.length,
        itemBuilder: (context, index) {
          return InkWell(
              onTap: () {
                _onCustomerSelected(employeesList![index]);
              },
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    border: Border.all(color: Theme.of(context).dividerColor)),
                child: customerNameMobileWidget(
                    viewModel.name(employeesList![index]),
                    employeesList![index].mobileNumber ?? noData),
              ));
        });
  }

  Widget searchingWidget() {
    return StreamBuilder<EmployeesResponse>(
      stream: viewModel.responseSubject,
      // ignore: missing_return, missing_return
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MyLoadingWidget();
        }
        if (snapshot.hasError) {
          return MyErrorWidget(message: "Error", tryAgain: () {});
        }
        if (snapshot.connectionState == ConnectionState.active) {
          var empResponse = snapshot.data;
          if (empResponse != null && empResponse.employees != null) {
            employeesList = empResponse.employees;
            return searchedItemsListWidget();
          } else {
            return const NoDataWidget();
          }
        }
        return Container();
      },
    );
  }

  Widget customerNameMobileWidget(String name, String mobile) {
    return IntrinsicHeight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Name',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const MyVerticalDivider(
                height: 15,
              ),
              Expanded(
                flex: 3,
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              )
            ],
          ),
          const Divider(),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Mobile',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const MyVerticalDivider(
                height: 15,
              ),
              Expanded(
                  flex: 3,
                  child: Text(
                    mobile,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ))
            ],
          ),
        ],
      ),
    );
  }

  Widget customerPointsVouchers(String points, int vouchers) {
    return IntrinsicHeight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Points',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const MyVerticalDivider(
                height: 15,
              ),
              Expanded(
                flex: 3,
                child: Text(
                  points,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              )
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }

  void _onCustomerSelected(Employees mEmployees) {
    FocusScope.of(context).requestFocus(searchNode);
    searchController.text = "";
    searchText = null;
    widget.onSelected(mEmployees);
  }
}
