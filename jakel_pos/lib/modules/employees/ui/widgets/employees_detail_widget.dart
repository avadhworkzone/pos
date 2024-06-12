import 'package:flutter/material.dart';
import 'package:jakel_base/constants.dart';
import 'package:jakel_base/restapi/employees/model/EmployeesResponse.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/widgets/custom/MyDataContainerWidget.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';
import 'package:jakel_pos/modules/employees/EmployeesViewModel.dart';

class EmployeesDetailWidget extends StatefulWidget {
  final Employees employees;
  final Function close;

  const EmployeesDetailWidget(
      {Key? key, required this.employees, required this.close})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EmployeesDetailWidgetState();
  }
}

class _EmployeesDetailWidgetState extends State<EmployeesDetailWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final viewModel = EmployeesViewModel();

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    viewModel.closeObservable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        constraints: const BoxConstraints.expand(),
        child: _getRootWidget(),
      ),
    );
  }

  _getRootWidget() {
    return SingleChildScrollView(
      child: Column(
        children: _getChildrenWidgets(),
      ),
    );
  }

  List<Widget> _getChildrenWidgets() {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(getHeader());

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(getPersonalInfoCard());

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(membershipInfoCard());

    widgets.add(const SizedBox(
      height: 10,
    ));

    return widgets;
  }

  Widget getHeader() {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Employee information",
              style: Theme.of(context).textTheme.bodyLarge),
          MyInkWellWidget(
              child: const Icon(Icons.close),
              onTap: () {
                widget.close();
              })
        ],
      ),
    );
  }

  Widget getPersonalInfoCard() {
    return MyDataContainerWidget(child: getPersonalInfoWidget());
  }

  Widget getPersonalInfoWidget() {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(SizedBox(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Personal information",
              style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    ));

    widgets.add(const Divider());

    widgets.add(keyRowPair(
      "Name",
      viewModel.name(widget.employees),
      "Staff Id",
      widget.employees.staffId ?? noData,
      "IC Number",
      widget.employees.icNumber ?? noData,
    ));

    widgets.add(const Divider(
      height: 40,
    ));

    widgets.add(keyRowPair(
      "Membership Id",
      '${widget.employees.membershipId ?? noData}',
      "Email Id",
      widget.employees.email ?? noData,
      "Mobile No.",
      widget.employees.primaryContactPhone ?? noData,
    ));

    widgets.add(const Divider(
      height: 40,
    ));

    widgets.add(
      Text(
        "Address",
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.caption,
      ),
    );

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(
      Text(
        viewModel.address(widget.employees),
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );

    return IntrinsicHeight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );
  }

  Widget membershipInfoCard() {
    return MyDataContainerWidget(child: membershipInfoWidget());
  }

  Widget membershipInfoWidget() {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(SizedBox(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Membership", style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    ));

    widgets.add(const Divider());

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(keyRowPair(
      "Job Type",
      widget.employees.jobType == 1 ? "Full Time" : "Part Time",
      "Total Points Earned",
      getOnlyReadableAmount(widget.employees.totalLoyaltyPoints),
      "Total Spent Till Now ",
      viewModel.spentTillNow(widget.employees),
    ));

    return IntrinsicHeight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );
  }

  Widget keyRowPair(String key1, String value1, String key2, String value2,
      String key3, String value3) {
    return Row(
      children: [
        Expanded(
          child: keyColumnPair(key1, value1),
        ),
        const SizedBox(
          width: 5,
        ),
        Expanded(
          child: keyColumnPair(key2, value2),
        ),
        const SizedBox(
          width: 5,
        ),
        Expanded(
          child: keyColumnPair(key3, value3),
        ),
      ],
    );
  }

  Widget keyColumnPair(String key1, String value1) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          key1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.caption,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          value1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
