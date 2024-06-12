import 'package:flutter/material.dart';
import 'package:jakel_base/restapi/employees/model/EmployeesResponse.dart';
import 'package:jakel_base/widgets/appbgwidget/MyBackgroundWidget.dart';
import 'package:jakel_pos/modules/employees/ui/widgets/employees_detail_widget.dart';
import 'package:jakel_pos/modules/employees/ui/widgets/employees_list_widget.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EmployeesScreenState();
  }
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  Employees? selected;

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
            child: EmployeesListWidget(
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
          child: EmployeesDetailWidget(
            employees: selected!,
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
              "Select an employee to view in detail",
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
