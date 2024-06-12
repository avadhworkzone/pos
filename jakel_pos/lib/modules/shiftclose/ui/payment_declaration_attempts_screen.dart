import 'package:flutter/material.dart';
import 'package:jakel_base/restapi/counters/model/PaymentDeclarationAttemptsResponse.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_base/widgets/appbgwidget/MyBackgroundWidget.dart';
import 'package:jakel_base/widgets/custom/my_title_back_arrow_widget.dart';
import 'package:jakel_pos/modules/shiftclose/ui/widgets/payment_declaration_attempt_detail_widget.dart';
import 'package:jakel_pos/modules/shiftclose/ui/widgets/payment_declaration_attempts_list_widget.dart';

class PaymentDeclarationAttemptsScreen extends StatefulWidget {
  const PaymentDeclarationAttemptsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PaymentDeclarationAttemptsState();
  }
}

class _PaymentDeclarationAttemptsState
    extends State<PaymentDeclarationAttemptsScreen> {
  CounterUpdateDeclarationAttempts? _selected;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyBackgroundWidget(child: rootWidget()),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          height: 80,
          padding: const EdgeInsets.all(20),
          child: const MyTitleBackArrowWidget(
            title: 'Close Counter Attempts',
          ),
        ),
      ),
    );
  }

  Widget rootWidget() {
    List<Widget> widgets = List.empty(growable: true);

    // Tab children view
    widgets.add(
      Expanded(
          flex: 4,
          child: PaymentDeclarationAttemptsListWidget(
            onSelected: (closedCounterData) {
              setState(() {
                _selected = closedCounterData;
              });
            },
          )),
    );

    if (_selected != null) {
      widgets.add(Expanded(
          flex: 4,
          child: PaymentDeclarationAttemptDetailWidget(
            attempts: _selected!,
          )));
    } else {
      widgets.add(const Expanded(
          flex: 4,
          child: Center(
            child: Text("Please select"),
          )));
    }

    return Container(
        margin: const EdgeInsets.all(5.0),
        child: Row(
          children: widgets,
        ));
  }
}
