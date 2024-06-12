import 'package:flutter/material.dart';
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
import 'package:internal_app_promoter/modules/splash/view/splash_screen.dart';
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
