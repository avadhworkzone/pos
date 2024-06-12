import 'package:flutter/material.dart';
import 'package:internal_app_store_manager/modules/login/view/store_manager_login_screen.dart';
import 'package:internal_app_store_manager/modules/splash/view/splash_screen.dart';
import 'package:internal_app_store_manager/modules/store_manager/home/home_view/view/store_manager_home_view_screen.dart';
import 'package:internal_app_store_manager/modules/store_manager/product/product_details/view/store_manager_product_details_screen.dart';
import 'package:internal_app_store_manager/modules/store_manager/product/product_list/view/store_manager_product_list_screen.dart';
import 'package:internal_app_store_manager/modules/store_manager/product/product_stock_details/view/store_manager_product_stock_details_screen.dart';
import 'package:internal_app_store_manager/modules/store_manager/profile_settings/view/store_manager_profile_settings_screen.dart';
import 'package:internal_app_store_manager/modules/store_manager/sale/sale_list/view/store_manager_sale_list_screen.dart';
import 'package:internal_base/common/call_back.dart';
import '../modules/store_manager/promoters/promoter_list/view/store_manager_promoter_list_screen.dart';
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

      ///  Store Manager
      ///  LoginScreen
      case RouteConstants.rStoreManagerLoginScreenWidget:
        return MaterialPageRoute(
            builder: (context) => const StoreManagerLoginScreenWidget());

      ///  Home view
      case RouteConstants.rStoreManagerHomeScreenWidget:
        return MaterialPageRoute(
            builder: (context) => StoreManagerHomeViewScreenWidget(
                  mCallbackModel: args as CallbackModel,
                ));

      ///  ProfileSettings
      case RouteConstants.rStoreManagerProfileSettingsScreenWidget:
        return MaterialPageRoute(
            builder: (context) => StoreManagerProfileSettingsScreenWidget(
                  mCallbackModel: args as CallbackModel,
                ));

      ///  SaleList
      case RouteConstants.rStoreManagerSaleListScreenWidget:
        return MaterialPageRoute(
            builder: (context) => StoreManagerSaleListScreenWidget(
                  mCallbackModel: args as CallbackModel,
                ));

      ///  ProductList
      case RouteConstants.rStoreManagerProductListScreenWidget:
        return MaterialPageRoute(
            builder: (context) => StoreManagerProductListScreenWidget(
                  mCallbackModel: args as CallbackModel,
                ));

      ///  ProductDetail
      case RouteConstants.rStoreManagerProductDetailsScreenWidget:
        return MaterialPageRoute(
            builder: (context) => StoreManagerProductDetailsScreenWidget(
                  mCallbackModel: args as CallbackModel,
                ));

      /// promoters
      case RouteConstants.rStoreManagerPromotersScreenWidget:
        return MaterialPageRoute(
            builder: (context) => StoreManagerPromoterListScreen(
                  mCallbackModel: args as CallbackModel,
                ));

      ///  StockDetails
      case RouteConstants.rStoreManagerProductStockDetailsScreenWidget:
        return MaterialPageRoute(
            builder: (context) => StoreManagerProductStockDetailsScreenWidget(
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
