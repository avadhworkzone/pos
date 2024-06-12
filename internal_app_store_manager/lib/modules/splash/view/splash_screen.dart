import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:internal_app_store_manager/constants/image_assets_constants.dart';
import 'package:internal_base/common/color_constants.dart';
import 'package:internal_base/common/size_constants.dart';
import 'package:internal_app_store_manager/modules/splash/model/splash_screen_model.dart';

class SplashScreenWidget extends StatefulWidget {
  const SplashScreenWidget({super.key});

  @override
  State<SplashScreenWidget> createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget> {
  late SplashScreenModel mSplashScreenModel;

  @override
  void initState() {
    mSplashScreenModel = SplashScreenModel(context);
    mSplashScreenModel.initSharedPreferencesInstance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildSplashScreenWidgetView());
  }

  _buildSplashScreenWidgetView() {
    SizeConstants(context);
    return FocusDetector(
        onVisibilityGained: () {
          Future.delayed(const Duration(microseconds: 2000), () {
            mSplashScreenModel.getOpenScreen();
          });
        },
        child: SafeArea(
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage(ImageAssetsConstants.splashBackground),
                    fit: BoxFit.cover,
                  )),
              child: Container(
                color: ColorConstants.kPrimaryColor.withOpacity(0.75),
                alignment: Alignment.center,
                child: SizedBox(
                  height: SizeConstants.width * 0.55,
                  width: SizeConstants.width * 0.55,
                  child: Image.asset(ImageAssetsConstants.splashLogo),
                ),
              )),
        ));
  }


}
