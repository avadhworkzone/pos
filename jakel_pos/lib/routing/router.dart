import 'package:jakel_base/restapi/customers/model/CustomersResponse.dart';
import 'package:jakel_pos/modules/configuration/widget/configuration_screen.dart';
import 'package:jakel_pos/modules/customers/ui/widget/add_edit_customer_widget.dart';
import 'package:jakel_pos/modules/home/ui/home_screen.dart';
import 'package:jakel_pos/modules/localcountersinfo/ui/local_counters_screen.dart';
import 'package:jakel_pos/modules/login/widget/login_screen.dart';
import 'package:jakel_pos/modules/shiftclose/ui/payment_declaration_attempts_screen.dart';
import 'package:jakel_pos/routing/route_names.dart';
import 'package:jakel_base/extension/StringExtension.dart';
import 'package:flutter/widgets.dart';
import '../modules/opencounter/ui/open_counter_screen.dart';
import '../modules/splash/widget/splash_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  var routingData = settings.name!.getRoutingData;
  String route = routingData.route;

  switch (route) {
    case SplashRoute:
      return _getPageRoute(SplashScreen(), settings);
    case ConfigSetUpRoute:
      return _getPageRoute(ConfigurationScreen(), settings);
    case LoginRoute:
      return _getPageRoute(LoginScreen(), settings);
    case OpenCounterRoute:
      return _getPageRoute(OpenCounterScreen(), settings);
    case HomeRoute:
      return _getPageRoute(HomeScreen(), settings);
    case AddCustomerRoute:
      return _getPageRoute(
          AddEditCustomerWidget(
            customers: settings.arguments != null
                ? settings.arguments as Customers
                : null,
          ),
          settings);
    case LocalCountersInfoRoute:
      return _getPageRoute(
          LocalCountersScreen(
            isAfterShiftClose:
                settings.arguments != null ? settings.arguments as bool : false,
          ),
          settings);
    case PaymentDeclarationAttemptsRoute:
      return _getPageRoute(PaymentDeclarationAttemptsScreen(), settings);
    default:
      return _getPageRoute(SplashScreen(), settings);
  }
}

PageRoute _getPageRoute(Widget child, RouteSettings settings) {
  return _FadeRoute(child: child, routeName: settings.name!);
}

class _FadeRoute extends PageRouteBuilder {
  final Widget child;
  final String routeName;

  _FadeRoute({required this.child, required this.routeName})
      : super(
          settings: RouteSettings(name: routeName),
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return child;
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: Duration(milliseconds: 100),
        );
}
