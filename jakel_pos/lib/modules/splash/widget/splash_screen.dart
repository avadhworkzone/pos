import 'package:flutter/material.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/my_assets.dart';
import 'package:jakel_base/widgets/errorwidget/MyErrorWidget.dart';
import 'package:jakel_base/widgets/loadingwidget/MyLoadingWidget.dart';
import 'package:jakel_base/widgets/nodatawidget/NoDataWidget.dart';
import 'package:jakel_base/widgets/text/HeaderTextWidget.dart';
import 'package:jakel_pos/modules/splash/SplashViewModel.dart';
import 'package:jakel_pos/routing/route_names.dart';
import 'package:window_manager/window_manager.dart';
import 'package:easy_localization/easy_localization.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SplashState();
  }
}

class _SplashState extends State<SplashScreen> with WindowListener {
  final viewKey = GlobalKey();
  final _viewModel = SplashViewModel();

  bool isConfigSuccess = false;
  bool isLoginSuccess = false;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _viewModel.downloadConfiguration();
  }

  @override
  void dispose() {
    super.dispose();
    windowManager.removeListener(this);
    _viewModel.closeObservable();
  }

  @override
  Widget build(BuildContext context) {
    MyLogUtils.logDebug("Splash screen build");
    return Scaffold(
        appBar: AppBar(
            title: Container(
          color: getPrimaryColor(context),
          height: 50,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              tr('open_counter'),
              style: TextStyle(color: getWhiteColor(context)),
            ),
          ),
        )),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: getPrimaryColor(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage(ariyaniLogo),
                height: 300,
                width: 300,
              ),
              HeaderTextWidget(
                text: tr('sub_title'),
              ),
              apiWidget()
            ],
          ),
        ));
  }

  //This is used for both download configuration & auto login using a flag
  Widget apiWidget() {
    return StreamBuilder<bool?>(
      stream: _viewModel.responseSubject,
      // ignore: missing_return, missing_return
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MyLoadingWidget();
        }
        if (snapshot.hasError) {
          MyLogUtils.logDebug(
              "downloadConfigApiWidget snapshot.hasError : ${snapshot.hasError}");
          if (isConfigSuccess) {
            goToLoginScreen();
          } else {
            goToConfigurationScreen();
          }
          return MyErrorWidget(message: "Error", tryAgain: () {});
        }
        if (snapshot.connectionState == ConnectionState.active) {
          var empResponse = snapshot.data;

          if (empResponse != null && empResponse) {
            if (isConfigSuccess) {
              isLoginSuccess = true;
              return getNextRouteWidget();
            } else {
              isConfigSuccess = true;
              _viewModel.autoLogin();
              return apiWidget();
            }
          } else {
            if (isConfigSuccess) {
              goToLoginScreen();
            } else {
              goToConfigurationScreen();
            }
            return const NoDataWidget();
          }
        }
        return Container();
      },
    );
  }

  Widget getNextRouteWidget() {
    return FutureBuilder(
        future: _viewModel.getNextRoute(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            goToNextScreen(snapshot.data ?? HomeRoute);
            return Container();
          }
          return Container();
        });
  }

  Future<void> goToLoginScreen() async {
    _viewModel.closeObservable();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pop(context);
      Navigator.pushNamed(
        context,
        LoginRoute,
      );
    });
  }

  Future<void> goToConfigurationScreen() async {
    _viewModel.closeObservable();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pop(context);
      Navigator.pushNamed(
        context,
        ConfigSetUpRoute,
      );
    });
  }

  void goToNextScreen(String route) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pop(context);
      MyLogUtils.logDebug("goToNextScreen route :  $route");
      if (route == LocalCountersInfoRoute) {
        Navigator.pushNamed(context, route, arguments: true);
      } else {
        Navigator.pushNamed(context, route);
      }
    });
    _viewModel.closeObservable();
  }
}
