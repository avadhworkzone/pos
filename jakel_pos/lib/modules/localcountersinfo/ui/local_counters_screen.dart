import 'package:flutter/material.dart';
import 'package:jakel_base/restapi/counters/model/OpenCounterRequest.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';

import 'package:jakel_base/widgets/appbgwidget/MyBackgroundWidget.dart';
import 'package:jakel_base/widgets/errorwidget/MyErrorWidget.dart';
import 'package:jakel_pos/modules/localcountersinfo/ui/widget/local_counter_info_widget.dart';
import 'package:jakel_pos/modules/localcountersinfo/ui/widget/local_counters_app_bar.dart';
import 'package:jakel_pos/routing/route_names.dart';

import '../LocalCountersViewModel.dart';

class LocalCountersScreen extends StatefulWidget {
  final bool isAfterShiftClose;

  const LocalCountersScreen({super.key, required this.isAfterShiftClose});

  @override
  State<StatefulWidget> createState() {
    return _LocalCountersState();
  }
}

class _LocalCountersState extends State<LocalCountersScreen>
    with TickerProviderStateMixin {
  final viewModel = LocalCountersViewModel();
  late TabController _tabController;
  int count = 0;
  String titleInPrintReceipt = "";
  List<OpenCounterRequest> allOpenCounters = List.empty(growable: true);
  Map<OpenCounterRequest, Widget> tabChildrenWidgets = {};
  Map<OpenCounterRequest, Widget> tabWidgets = {};

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: LocalCountersAppBar(
            isAfterShiftClose: widget.isAfterShiftClose,
            refresh: () {
              if (widget.isAfterShiftClose) {
                setState(() {
                  allOpenCounters.clear();
                });
              }
            },
          )),
      body: MyBackgroundWidget(child: fetchDataWidget()),
    );
  }

  Widget fetchDataWidget() {
    if (allOpenCounters.isNotEmpty) {
      return getRootWidget();
    }

    allOpenCounters.clear();
    tabChildrenWidgets.clear();
    tabWidgets.clear();
    return FutureBuilder(
        future: viewModel.getLocalCounters(),
        builder: (BuildContext context,
            AsyncSnapshot<List<OpenCounterRequest>> snapshot) {
          MyLogUtils.logDebug(
              "fetchDataWidget getLocalCounters :${snapshot.hasError}");

          if (snapshot.hasError) {
            allOpenCounters = [];
            return MyErrorWidget(
                message: "Failed to fetch data. Please try again later!",
                tryAgain: () {
                  setState(() {});
                });
          }
          if (snapshot.hasData) {
            allOpenCounters = snapshot.data ?? [];
            MyLogUtils.logDebug(
                "local counter allOpenCounters :${allOpenCounters.isEmpty}");
            if (allOpenCounters.isEmpty) {
              // go to splash screen
              goToSplashScreen();
            }

            _populateTabChildren();
            return getRootWidget();
          }
          return const Text("Loading ...");
        });
  }

  void _populateTabChildren() {
    for (var element in allOpenCounters) {
      MyLogUtils.logDebug(
          "_populateTabChildren allOpenCounters : ${element.toJson()}");

      tabChildrenWidgets[element] =
          LocalCounterInfoWidget(counterRequest: element);
      tabWidgets[element] = Tab(
        text: 'Opened At ${element.openedByPosAt}',
      );
    }
    _tabController =
        TabController(length: tabChildrenWidgets.length, vsync: this);
  }

  Widget getRootWidget() {
    List<Widget> widgets = List.empty(growable: true);

    // Tab children view
    widgets.add(
      Expanded(flex: 5, child: mainWidget(context)),
    );

    //Sale Detail View
    widgets.add(
      Expanded(
          flex: 3,
          child: Card(
            child: Container(),
          )),
    );

    return Container(
        margin: const EdgeInsets.all(5.0),
        child: Row(
          children: widgets,
        ));
  }

  Widget mainWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        tabBarWidget(),
        const SizedBox(
          height: 10,
        ),
        Expanded(
            child: Container(
          margin: const EdgeInsets.only(left: 5, right: 5, top: 0),
          child: TabBarView(
            controller: _tabController,
            children: List.from(tabChildrenWidgets.values),
          ),
        ))
      ],
    );
  }

  Widget tabBarWidget() {
    return Container(
      color: getWhiteColor(context),
      margin: const EdgeInsets.only(left: 10, right: 10, top: 5),
      child: TabBar(
          isScrollable: true,
          // give the indicator a decoration (color and border radius)
          controller: _tabController,
          labelStyle: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor),
          unselectedLabelStyle: TextStyle(
              fontSize: 13,
              color: Theme.of(context).primaryColor.withOpacity(0.4)),
          indicator: ShapeDecoration(
            shape: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 1,
                    style: BorderStyle.solid)),
          ),
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Theme.of(context).primaryColor.withOpacity(0.6),
          tabs: List.from(tabWidgets.values)),
    );
  }

  void goToSplashScreen() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pop(context);
      Navigator.pushNamed(context, SplashRoute);
    });
  }
}
