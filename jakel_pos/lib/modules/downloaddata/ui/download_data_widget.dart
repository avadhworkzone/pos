import 'package:flutter/material.dart';
import 'package:jakel_base/widgets/button/MyPrimaryButton.dart';
import 'package:jakel_base/widgets/text/HeaderTextWidget.dart';
import 'package:jakel_pos/modules/downloaddata/DownloadDataViewModel.dart';

import '../../../AppPreference.dart';

class DownloadDataWidget extends StatefulWidget {
  final Function onCompleted;

  const DownloadDataWidget({Key? key, required this.onCompleted})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DownloadDataWidgetState();
  }
}

class _DownloadDataWidgetState extends State<DownloadDataWidget> {
  var message = "Downloading products ...";
  String? errorMessage;
  var isCompleted = false;
  final viewModel = DownloadDataViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.startDownloading(_updateMessage, _onCompleted, _onError);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).primaryColor,
      child: SizedBox(
        height: 300,
        width: 300,
        child: Card(child: getWidgets()),
      ),
    );
  }

  Widget getWidgets() {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(HeaderTextWidget(
      text: "Syncing data from cloud",
      color: Theme.of(context).colorScheme.primary,
    ));

    widgets.add(const SizedBox(
      height: 20,
    ));

    if (!isCompleted) {
      widgets.add(
        const SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      );

      widgets.add(const SizedBox(
        height: 20,
      ));
    }

    widgets.add(Text(message));

    widgets.add(const SizedBox(
      height: 10,
    ));

    if (errorMessage != null) {
      widgets.add(Text(errorMessage!));

      widgets.add(const SizedBox(
        height: 10,
      ));
    }

    widgets.add(MyPrimaryButton(
        text: "Cancel",
        onClick: () {
          _onCompleted();
        }));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: widgets,
    );
  }

  void _updateMessage(String mes) {
    setState(() {
      message = mes;
    });
  }

  void _onCompleted() {
    Navigator.pop(context);
    widget.onCompleted();
    AppPreference().refreshProductsData = true;
  }

  void _onError(String mes) {
    setState(() {
      message = mes;
    });
  }
}
