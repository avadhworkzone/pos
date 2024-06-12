import 'package:flutter/material.dart';
import 'package:member_app/common/call_back.dart';
import 'package:member_app/modules/common/skill_selection/model/web_model.dart';
import 'package:member_app/modules/common/skill_selection/view/common_web_view.dart';
import 'package:member_app/modules/edit_profile/view/edit_profile_screen.dart';
import 'package:member_app/modules/home/home_screen/view/home_screen.dart';
import 'package:member_app/modules/login_mobile_number/view/login_mobile_number_screen.dart';
import 'package:member_app/modules/login_mobile_number_otp/view/login_mobile_number_otp_screen.dart';
import 'package:member_app/modules/splash/view/splash_screen.dart';
import 'package:member_app/modules/transaction_list/view/transaction_list_screen.dart';
import 'package:member_app/modules/welcome_screen/view/welcome_screen.dart';
import 'route_constants.dart';

class GeneratedRoutes {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    final args = routeSettings.arguments;
    final String routeName = routeSettings.name.toString();

    switch (routeName) {
      // Common
      case RouteConstants.rSplashScreenWidget:
        return MaterialPageRoute(
            builder: (context) => const SplashScreenWidget());

        case RouteConstants.rCommonWebView:
        return MaterialPageRoute(
            builder: (context) =>  CommonWebView(sWebView: args as WebModel,));

      case RouteConstants.rWelcomeScreenWidget:
        return MaterialPageRoute(
            builder: (context) => const WelcomeScreenWidget());
      case RouteConstants.rLoginMobileNumberScreenWidget:
        return MaterialPageRoute(
            builder: (context) => const LoginMobileNumberScreenWidget());

      case RouteConstants.rLoginMobileNumberOtpScreenWidget:
        return MaterialPageRoute(
            builder: (context) => LoginMobileNumberOtpScreenWidget(
                  sMobileNumber: args.toString(),
                ));
      case RouteConstants.rHomeScreenWidget:
        return MaterialPageRoute(
            builder: (context) => const HomeScreenWidget());

      case RouteConstants.rTransactionScreenWidget:
        return MaterialPageRoute(
            builder: (context) => const TransactionScreenWidget());

      case RouteConstants.rEditProfileScreenWidget:
        return MaterialPageRoute(
            builder: (context) => EditProfileScreenWidget(
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
