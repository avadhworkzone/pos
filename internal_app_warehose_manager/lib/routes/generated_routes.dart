import 'package:flutter/material.dart';
import 'package:internal_app_warehose_manager/modules/login/view/warehouse_manager_login_screen.dart';
import 'package:internal_app_warehose_manager/modules/splash/view/splash_screen.dart';
import 'package:internal_app_warehose_manager/modules/warehouse_manager/home/home_view/view/warehouse_manager_home_view_screen.dart';
import 'package:internal_app_warehose_manager/modules/warehouse_manager/product/product_details/view/warehouse_manager_product_details_screen.dart';
import 'package:internal_app_warehose_manager/modules/warehouse_manager/product/product_list/view/warehouse_manager_product_list_screen.dart';
import 'package:internal_app_warehose_manager/modules/warehouse_manager/product/product_stock_details/view/warehouse_manager_product_stock_details_screen.dart';
import 'package:internal_app_warehose_manager/modules/warehouse_manager/profile_settings/view/warehouse_manager_profile_settings_screen.dart';
import 'package:internal_base/common/call_back.dart';
import 'route_constants.dart';

class GeneratedRoutes {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    final args = routeSettings.arguments;
    final String routeName = routeSettings.name.toString();

    switch (routeName) {
      /// Common
      case RouteConstants.rSplashScreenWidget:
        return MaterialPageRoute(
            builder: (context) => const SplashScreenWidget());

      /// Warehouse Manager
      /// LoginScreen
      case RouteConstants.rWarehouseManagerLoginScreenWidget:
        return MaterialPageRoute(
            builder: (context) => const WarehouseManagerLoginScreenWidget());

      /// HomeView
      case RouteConstants.rWarehouseManagerHomeViewScreenWidget:
        return MaterialPageRoute(
            builder: (context) => WarehouseManagerHomeViewScreenWidget(
                  mCallbackModel: args as CallbackModel,
                ));

      /// ProfileSettings
      case RouteConstants.rWarehouseManagerProfileSettingsScreenWidget:
        return MaterialPageRoute(
            builder: (context) => WarehouseManagerProfileSettingsScreenWidget(
                  mCallbackModel: args as CallbackModel,
                ));

      /// ProductList
      case RouteConstants.rWarehouseManagerProductListScreenWidget:
        return MaterialPageRoute(
            builder: (context) => WarehouseManagerProductListScreenWidget(
                  mCallbackModel: args as CallbackModel,
                ));

      /// ProductDetails
      case RouteConstants.rWarehouseManagerProductDetailsScreenWidget:
        return MaterialPageRoute(
            builder: (context) => WarehouseManagerProductDetailsScreenWidget(
                  mCallbackModel: args as CallbackModel,
                ));

      /// StockDetails
      case RouteConstants.rWarehouseManagerProductStockDetailsScreenWidget:
        return MaterialPageRoute(
            builder: (context) =>
                WarehouseManagerProductStockDetailsScreenWidget(
                  mCallbackModel: args as CallbackModel,
                ));

      default:
        return _routeNotFound(sRouteName: " - $routeName");
    }
  }

  static Route<dynamic> _routeNotFound({String sRouteName = ""}) {
    return MaterialPageRoute(builder: (context) {
      return Scaffold(
        body: Center(
          child: Text("Page not found!$sRouteName"),
        ),
      );
    });
  }
}
