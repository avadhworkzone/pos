import 'package:flutter/material.dart';
import 'package:jakel_base/database/sale/model/sale_booking_returns_data.dart';
import 'package:jakel_base/database/sale/model/sale_returns_data.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/appinfo/get_app_info.dart';
import 'package:jakel_base/utils/appinfo/model/AppInfoModel.dart';
import 'package:jakel_base/widgets/appbgwidget/MyBackgroundWidget.dart';
import 'package:jakel_pos/modules/customers/ui/customers_screen.dart';
import 'package:jakel_pos/modules/downloaddata/ui/download_data_widget.dart';
import 'package:jakel_pos/modules/employees/ui/employees_screen.dart';
import 'package:jakel_pos/modules/giftcard/ui/gift_card_screen.dart';
import 'package:jakel_pos/modules/home/model/HomeMenuItem.dart';
import 'package:jakel_pos/modules/home/model/HomeScreenViewModel.dart';
import 'package:jakel_pos/modules/home/ui/home_inherited_widget.dart';
import 'package:jakel_pos/modules/home/ui/widgets/home_app_bar.dart';
import 'package:jakel_pos/modules/keyboardshortcuts/home_screen_keyboard_shortcut.dart';
import 'package:jakel_pos/modules/newsale/ui/new_sale_widget.dart';
import 'package:jakel_pos/modules/promotions/ui/promotions_screen.dart';
import 'package:jakel_pos/modules/saleshistory/ui/sales_history_screen.dart';
import 'package:jakel_pos/modules/shiftclose/ui/shift_close_screen.dart';
import 'package:jakel_pos/modules/vouchers/ui/vouchers_screen.dart';
import 'package:window_manager/window_manager.dart';

import '../../products/ui/products_screen.dart';
import '../../report/closed_counter_report_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> with WindowListener {
  bool value = false;
  int index = 0;
  final settingsController = ScrollController();
  final viewKey = GlobalKey();
  late HomeMenuItem currentMenu;
  double appBarHeight = 70;
  SaleReturnsData? saleReturnsData;
  BookingItemsResetData? saleBookingReturnsData;
  final viewModel = HomeScreenViewModel();

  @override
  initState() {
    super.initState();
    currentMenu = getHomeMenuItem();
  }

  @override
  Widget build(BuildContext context) {
    return HomeInheritedWidget(
        object: HomeDataModel(currentMenu),
        child: Scaffold(
          body: MyBackgroundWidget(
              child: HomeScreenKeyboardShortcut(
                  onMembers: () {
                    setState(() {
                      currentMenu = getMembersItem();
                    });
                  },
                  onHome: () {
                    setState(() {
                      currentMenu = getHomeMenuItem();
                    });
                  },
                  onShiftClose: () {
                    setState(() {
                      currentMenu = getShitCloseItem();
                    });
                  },
                  child: Row(children: [
                    sideMenuWidget(),
                    Expanded(child: bodyWidget())
                  ]))),
        ));
  }

  Future<void> _downloadProductsDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return DownloadDataWidget(
          onCompleted: () {
            setState(() {});
          },
        );
      },
    );
  }

  Widget sideMenuWidget() {
    List<Widget> widgets = List.empty(growable: true);
    List<Widget> menuListWidgets = List.empty(growable: true);

    List<HomeMenuItem> menuList = getMenuList();

    widgets.add(const SizedBox(
      height: 20,
    ));
    widgets.add(
        SizedBox(height: appBarHeight - 20, child: const Icon(Icons.menu)));

    widgets.add(Container(
      height: 0.1,
      color: getWhiteColor(context),
    ));

    for (var value in menuList) {
      widgets.add(const SizedBox(
        height: 20,
      ));
      widgets.add(InkWell(
        onTap: () {
          setState(() {
            currentMenu = value;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(10.0),
          width: double.infinity,
          color: currentMenu.key == value.key
              ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
              : Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                value.icon,
                size: 30,
                color: currentMenu.key == value.key
                    ? Colors.white54
                    : Colors.white24,
              ),
              Text(value.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: currentMenu.key == value.key
                          ? Colors.white54
                          : Colors.white24,
                      fontSize: 10)),
            ],
          ),
        ),
      ));
    }

    widgets.add(const Divider());

    widgets.add(const Text(
      "Version",
      style: TextStyle(fontSize: 12, color: Colors.white30),
    ));

    widgets.add(getPackageInfo());

    widgets.add(getPackageName());

    widgets.add(const Divider());

    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.8),
      width: 90,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: widgets,
        ),
      ),
    );
  }

  Widget bodyWidget() {
    return Column(
      children: [
        SizedBox(
          height: appBarHeight,
          child: HomeAppBar(downloadData: () {
            _downloadProductsDialog();
          }),
        ),
        Expanded(
          child: bodyContentWidget(),
        ),
      ],
    );
  }

  Widget bodyContentWidget() {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: currentMenu.child,
    );
  }

  Widget getPackageInfo() {
    return FutureBuilder(
        future: getAppInformation(),
        builder: (BuildContext context, AsyncSnapshot<AppInfoModel> snapshot) {
          if (snapshot.hasError) {
            MyLogUtils.logDebug("snapshot.hasError : ${snapshot.hasError}");
            return Container();
          }
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              return Text(
                snapshot.data?.version ?? '',
                style: const TextStyle(fontSize: 12, color: Colors.white60),
              );
            }
            return Container();
          }
          return const Text("Loading ...");
        });
  }

  Widget getPackageName() {
    return FutureBuilder(
        future: viewModel.packageName(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasError) {
            MyLogUtils.logDebug("snapshot.hasError : ${snapshot.hasError}");
            return Container();
          }
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              return Container(
                margin: const EdgeInsets.only(left: 7, right: 7),
                child: Text(
                  snapshot.data?.toString() ?? '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Colors.white60),
                ),
              );
            }
            return Container();
          }
          return const Text("Loading ...");
        });
  }

  List<HomeMenuItem> getMenuList() {
    List<HomeMenuItem> menuList = List.empty(growable: true);
    menuList.add(getHomeMenuItem());
    menuList.add(HomeMenuItem(
        'sales',
        Icons.card_travel_outlined,
        SalesHistoryScreen(
          proceedToSaleReturns: _proceedToSaleReturns,
          resetProductsInBookingPayments: _resetProductsInBookingPayments,
        ),
        "Sales"));

    menuList.add(HomeMenuItem('products', Icons.production_quantity_limits,
        const ProductsScreen(), "Products"));

    menuList.add(HomeMenuItem(
        'promotions', Icons.discount, const PromotionsScreen(), "Promotions"));

    menuList.add(getShitCloseItem());

    menuList.add(getMembersItem());

    menuList.add(HomeMenuItem('employees', Icons.accessibility_rounded,
        const EmployeesScreen(), "Employees"));

    menuList.add(HomeMenuItem('vouchers', Icons.discount_outlined,
        const VouchersScreen(), "Vouchers"));

    menuList.add(HomeMenuItem('gift_card', Icons.card_giftcard_rounded,
        const GiftCardScreen(), "Gift Card's"));

    menuList.add(HomeMenuItem('report', Icons.auto_graph_outlined,
        const ClosedCounterReportScreen(), "Report"));

    return menuList;
  }

  HomeMenuItem getMembersItem() {
    return HomeMenuItem('customers', Icons.person_outline_outlined,
        const CustomersScreen(), "Members");
  }

  HomeMenuItem getHomeMenuItem() {
    return HomeMenuItem(
        'home', Icons.home_outlined, const NewSaleWidget(), "Home");
  }

  void _proceedToSaleReturns(SaleReturnsData returnsData) {
    setState(() {
      saleReturnsData = returnsData;
      currentMenu = HomeMenuItem(
          'home',
          Icons.home_outlined,
          NewSaleWidget(
            returnsData: saleReturnsData,
          ),
          "Home");
    });
  }

  void _resetProductsInBookingPayments(BookingItemsResetData returnsData) {
    setState(() {
      saleBookingReturnsData = returnsData;
      currentMenu = HomeMenuItem(
          'home',
          Icons.home_outlined,
          NewSaleWidget(
            returnsBookingData: saleBookingReturnsData,
          ),
          "Home");
    });
  }

  HomeMenuItem getShitCloseItem() {
    return HomeMenuItem('shift', Icons.access_alarms_outlined,
        const ShiftCloseScreen(), "Shift Details");
  }
}
