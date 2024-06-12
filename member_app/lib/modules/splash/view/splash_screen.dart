import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:member_app/common/app_constants.dart';
import 'package:member_app/common/color_constants.dart';
import 'package:member_app/common/image_assets.dart';
import 'package:member_app/common/size_constants.dart';
import 'package:member_app/common/utils/device_utils.dart';
import 'package:member_app/data/local/shared_prefs/shared_prefs.dart';
import 'package:member_app/routes/route_constants.dart';

class SplashScreenWidget extends StatefulWidget {
  const SplashScreenWidget({super.key});

  @override
  State<SplashScreenWidget> createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSharedPreferencesInstance();
  }

  initSharedPreferencesInstance() async {
    await SharedPrefs().sharedPreferencesInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildSplashScreenWidgetView());
  }

  getToken() async {
    await SharedPrefs().getUserToken().then((sToken) {
      if (sToken.isEmpty) {
        Navigator.pushNamedAndRemoveUntil(
            context, RouteConstants.rWelcomeScreenWidget, (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteConstants.rHomeScreenWidget,
          (route) => false,
        );
      }
    });
  }

  _buildSplashScreenWidgetView() {
    SizeConstants(context);
    return FocusDetector(
        onVisibilityGained: () {
          Future.delayed(Duration(microseconds: 2000), () {
            getToken();
          });
        },
        child: SafeArea(
          child: Container(
              alignment: Alignment.center,
              color: Colors.white,
              // decoration: BoxDecoration(
              //     gradient: LinearGradient(
              //   begin: Alignment.topRight,
              //   end: Alignment.bottomLeft,
              //   colors: [
              //     ColorConstants.kPrimaryColor,
              //     ColorConstants.kPrimaryColor.shade400,
              //     ColorConstants.kPrimaryColor.shade800,
              //   ],
              // )
              // ),
              child: SizedBox(
                height: SizeConstants.width *0.25,
                width: SizeConstants.width *0.25,
                child: Image.asset(ImageAssets.imageAppBarLogo),
              )),
        ));
  }
}
