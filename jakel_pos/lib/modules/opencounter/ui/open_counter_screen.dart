import 'package:flutter/material.dart';
import 'package:jakel_base/restapi/counters/model/GetCountersResponse.dart';
import 'package:jakel_base/restapi/counters/model/GetStoresResponse.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/widgets/appbgwidget/MyBackgroundWidget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expandable/expandable.dart';
import 'package:jakel_base/widgets/button/MyPrimaryButton.dart';
import 'package:jakel_base/widgets/loadingwidget/MyLoadingWidget.dart';

import 'package:jakel_pos/modules/opencounter/ui/widgets/open_counter_app_bar.dart';
import 'package:jakel_pos/modules/opencounter/ui/widgets/select_stores_widget.dart';
import 'package:jakel_pos/modules/opencounter/viewmodel/CountersViewModel.dart';
import 'package:jakel_pos/routing/route_names.dart';
import '../ui/widgets/select_counters_widget.dart';
import '../ui/widgets/opening_balance_widget.dart';
import 'open_counter_in_herited_widget.dart';

class OpenCounterScreen extends StatefulWidget {
  const OpenCounterScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _OpenCounterScreenState();
  }
}

class _OpenCounterScreenState extends State<OpenCounterScreen> {
  final viewKey = GlobalKey();
  int currentIndex = 0;
  int tabs = 3;
  final openCounterModel = OpenCounterModel(null, null, null, false);
  final _viewModel = CountersViewModel();
  var callApi = false;

  @override
  void dispose() {
    super.dispose();
    _viewModel.closeObservable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
            color: getPrimaryColor(context),
            height: 50,
            child: OpenCounterAppBar()),
      ),
      body: MyBackgroundWidget(
          child: OpenCounterInHeritedWidget(
              key: viewKey,
              object: openCounterModel,
              child: Container(
                margin: const EdgeInsets.all(20.0),
                child: getLastSelectedStore(),
              ))),
    );
  }

  Widget getLastSelectedStore() {
    return FutureBuilder(
        future: _viewModel.getLastSelectedStores(),
        builder: (BuildContext context, AsyncSnapshot<Stores?> snapshot) {
          if (snapshot.hasError) {
            return getLastSelectCounter();
          }

          if (snapshot.hasData) {
            if (snapshot.data != null) {
              openCounterModel.store = snapshot.data!;
            } else {
              openCounterModel.store = null;
            }
            return getLastSelectCounter();
          } else {
            return getLastSelectCounter();
          }
          return const Text("Loading store...");
        });
  }

  Widget getLastSelectCounter() {
    return FutureBuilder(
        future: _viewModel.getLastSelectedCounter(),
        builder: (BuildContext context, AsyncSnapshot<Counters?> snapshot) {
          if (snapshot.hasError) {
            return getStepperWidget();
          }
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              openCounterModel.counterLockedToThisMachine = true;
              openCounterModel.counters = snapshot.data!;
            }
            return getStepperWidget();
          } else {
            return getStepperWidget();
          }
          return const Text("Loading counter...");
        });
  }

  Widget getStepperWidget() {
    return ExpandableTheme(
      data: ExpandableThemeData(
        iconColor: getPrimaryColor(context),
        useInkWell: true,
      ),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          SelectStoresWidget(
            onStoreChanged: _onStoreChanged,
          ),
          SelectCountersWidget(
            onCounterChanged: _onCounterChanged,
          ),
          OpeningBalanceWidget(
              onOpeningBalanceChanged: _onOpeningBalanceChanged),
          const SizedBox(
            height: 20,
          ),
          showOpenCounterButton(),
        ],
      ),
    );
  }

  _onStoreChanged() {
    setState(() {});
  }

  _onCounterChanged() {
    setState(() {});
  }

  _onOpeningBalanceChanged() {
    setState(() {});
  }

  Widget showOpenCounterButton() {
    if (callApi) {
      return apiWidget();
    }

    if (openCounterModel.store != null &&
        openCounterModel.counters != null &&
        openCounterModel.openingBalance != null) {
      return Padding(
          padding: EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: MediaQuery.of(context).size.width / 3),
          child: MyPrimaryButton(
            text: tr('open_counter'),
            disable: false,
            padding: const EdgeInsets.all(10.0),
            type: PrimaryButtonType.NORMAL,
            onClick: () {
              _openCounter();
            },
          ));
    }
    return Container();
  }

  _openCounter() {
    if (openCounterModel.counters == null) {
      showToast(tr('open_counter_validate_counters'), context);
      return;
    }

    if (openCounterModel.openingBalance == null) {
      showToast(tr('open_counter_validate_opening_balance'), context);
      return;
    }

    setState(() {
      callApi = true;
    });
  }

  var openCounterCalledOnce = false;

  Widget apiWidget() {
    MyLogUtils.logDebug("open counter apiWidget callApi =>: $callApi");
    if (!openCounterCalledOnce) {
      openCounterCalledOnce = true;
      _viewModel.openCounter(openCounterModel.counters!.id!,
          openCounterModel.openingBalance!, openCounterModel);
    }

    return StreamBuilder<String>(
      stream: _viewModel.boolResponseSubject,
      // ignore: missing_return, missing_return
      builder: (context, snapshot) {
        MyLogUtils.logDebug(
            "open counter apiWidget snapshot.connectionState : ${snapshot.connectionState}");
        MyLogUtils.logDebug(
            "open counter apiWidget snapshot.hasError : ${snapshot.hasError}");

        MyLogUtils.logDebug("apiWidget snapshot.hasData : ${snapshot.hasData}");

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MyLoadingWidget();
        }
        if (snapshot.hasError) {
          return showOpenCounterButton();
        }
        if (snapshot.connectionState == ConnectionState.active) {
          callApi = false;
          var empResponse = snapshot.data;
          if (empResponse != null) {
            if (empResponse == "true") {
              goToHomeScreen();
              return const SizedBox();
            } else {
              showToast(empResponse ?? "", context);
              return showOpenCounterButton();
            }
          } else {
            showToast('open_counter_failed', context);

            return showOpenCounterButton();
          }
        }
        return Container();
      },
    );
  }

  Future<void> goToHomeScreen() async {
    _viewModel.closeObservable();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pop(context);
      Navigator.pushNamed(
        context,
        SplashRoute,
      );
    });
  }
}
