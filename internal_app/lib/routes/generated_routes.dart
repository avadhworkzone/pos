import 'package:flutter/material.dart';
import 'package:internal_app/modules/splash/view/splash_screen.dart';
import 'package:internal_app/modules/walk_through/view/walk_through_screen.dart';
import 'package:internal_app_promoter/modules/login/view/promoter_login_screen.dart';
import 'package:internal_app_promoter/modules/promoter/commission/commission_list/view/promoter_commission_list_screen.dart';
import 'package:internal_app_promoter/modules/promoter/home/home_add_member/view/promoter_home_add_member_screen.dart';
import 'package:internal_app_promoter/modules/promoter/home/home_view/view/promoter_home_view_screen.dart';
import 'package:internal_app_promoter/modules/promoter/product/product_details/view/promoter_product_details_screen.dart';
import 'package:internal_app_promoter/modules/promoter/product/product_list/view/promoter_product_list_screen.dart';
import 'package:internal_app_promoter/modules/promoter/product/product_stock_details/view/promoter_product_stock_details_screen.dart';
import 'package:internal_app_promoter/modules/promoter/profile_settings/view/promoter_profile_settings_screen.dart';
import 'package:internal_app_promoter/modules/promoter/sales_returns/sales_returns_details/view/promoter_sales_returns_details_screen.dart';
import 'package:internal_app_promoter/modules/promoter/sales_returns/sales_returns_list/view/promoter_sales_returns_list_screen.dart';
import 'package:internal_app_store_manager/modules/login/view/store_manager_login_screen.dart';
import 'package:internal_app_store_manager/modules/store_manager/home/home_view/view/store_manager_home_view_screen.dart';
import 'package:internal_app_store_manager/modules/store_manager/product/product_details/view/store_manager_product_details_screen.dart';
import 'package:internal_app_store_manager/modules/store_manager/product/product_list/view/store_manager_product_list_screen.dart';
import 'package:internal_app_store_manager/modules/store_manager/promoters/promoter_list/view/store_manager_promoter_list_screen.dart';
import 'package:internal_app_store_manager/modules/store_manager/product/product_stock_details/view/store_manager_product_stock_details_screen.dart';
import 'package:internal_app_store_manager/modules/store_manager/profile_settings/view/store_manager_profile_settings_screen.dart';
import 'package:internal_app_store_manager/modules/store_manager/sale/sale_list/view/store_manager_sale_list_screen.dart';
import 'package:internal_app_warehose_manager/modules/login/view/warehouse_manager_login_screen.dart';
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

      case RouteConstants.rWalkThroughScreenWidget:
        return MaterialPageRoute(
            builder: (context) => const WalkThroughScreenWidget());

      ///  Promoter
      ///  PromoterLogin
      case RouteConstants.rPromoterLoginScreenWidget:
        return MaterialPageRoute(
            builder: (context) => const PromoterLoginScreenWidget());

      ///  PromoterDashboard
      case RouteConstants.rPromoterHomeViewScreenWidget:
        return MaterialPageRoute(
            builder: (context) => PromoterHomeViewScreenWidget(
                  mCallbackModel: args as CallbackModel,
                ));

      ///HomeAddMemberScreenWidget
      case RouteConstants.rPromoterHomeAddMemberScreenWidget:
        return MaterialPageRoute(
            builder: (context) => PromoterHomeAddMemberScreenWidget(
                  mCallbackModel: args as CallbackModel,
                ));

      ///ProfileSettings
      case RouteConstants.rPromoterProfileSettingsScreenWidget:
        return MaterialPageRoute(
            builder: (context) => PromoterProfileSettingsScreenWidget(
                  mCallbackModel: args as CallbackModel,
                ));

      ///ProductListScreenWidget
      case RouteConstants.rPromoterProductListScreenWidget:
        return MaterialPageRoute(
            builder: (context) => PromoterProductListScreenWidget(
                  mCallbackModel: args as CallbackModel,
                ));

      ///PromoterProductDetailsScreenWidget
      case RouteConstants.rPromoterProductDetailsScreenWidget:
        return MaterialPageRoute(
            builder: (context) => PromoterProductDetailsScreenWidget(
                  mCallbackModel: args as CallbackModel,
                ));

      ///PromoterProductStockDetailsScreenWidget
      case RouteConstants.rPromoterProductStockDetailsScreenWidget:
        return MaterialPageRoute(
            builder: (context) => PromoterProductStockDetailsScreenWidget(
                  mCallbackModel: args as CallbackModel,
                ));

      ///SalesReturns
      case RouteConstants.rPromoterSalesReturnsListScreenWidget:
        return MaterialPageRoute(
            builder: (context) => PromoterSalesReturnsListScreenWidget(
                  mCallbackModel: args as CallbackModel,
                ));

      ///SalesReturnsDetailsScreenWidget
      case RouteConstants.rPromoterSalesReturnsDetailsScreenWidget:
        return MaterialPageRoute(
            builder: (context) => PromoterSalesReturnsDetailsScreenWidget(
                  mCallbackModel: args as CallbackModel,
                ));

      ///SalesReturns
      case RouteConstants.rPromoterCommissionListScreenWidget:
        return MaterialPageRoute(
            builder: (context) => PromoterCommissionListScreenWidget(
                  mCallbackModel: args as CallbackModel,
                ));

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

      /// promoter list
      case RouteConstants.rStoreManagerPromoterScreenWidget:
        return MaterialPageRoute(
            builder: (context) => StoreManagerPromoterListScreen(
                  mCallbackModel: args as CallbackModel,
                ));

      ///  ProductDetail
      case RouteConstants.rStoreManagerProductDetailsScreenWidget:
        return MaterialPageRoute(
            builder: (context) => StoreManagerProductDetailsScreenWidget(
                  mCallbackModel: args as CallbackModel,
                ));

      ///  StockDetails
      case RouteConstants.rStoreManagerProductStockDetailsScreenWidget:
        return MaterialPageRoute(
            builder: (context) => StoreManagerProductStockDetailsScreenWidget(
                  mCallbackModel: args as CallbackModel,
                ));

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

      /// promoters
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
