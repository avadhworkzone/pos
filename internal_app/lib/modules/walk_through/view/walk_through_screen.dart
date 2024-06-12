import 'package:flutter/material.dart';
import 'package:internal_app/constants/image_assets_constants.dart';
import 'package:internal_base/common/app_constants.dart';
import 'package:internal_base/common/button_constants.dart';
import 'package:internal_base/common/color_constants.dart';
import 'package:internal_base/common/size_constants.dart';
import 'package:internal_base/common/text_styles_constants.dart';
import '../model/walk_through_model.dart';
import 'package:url_launcher/url_launcher.dart';

class WalkThroughScreenWidget extends StatefulWidget {
  const WalkThroughScreenWidget({super.key});

  @override
  State<WalkThroughScreenWidget> createState() =>
      _WalkThroughScreenWidgetState();
}

class _WalkThroughScreenWidgetState extends State<WalkThroughScreenWidget> {
  late WalkThroughScreenModel mWalkThroughScreenModel;

  @override
  void initState() {
    mWalkThroughScreenModel = WalkThroughScreenModel(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
    },
    child: Scaffold(body: _buildSplashScreenWidgetView()));
  }

  _buildSplashScreenWidgetView() {
    return Scaffold(
      body: Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage(ImageAssetsConstants.walkThroughBackground),
            fit: BoxFit.cover,
          )),
      child: Container(
          color: ColorConstants.kPrimaryColor.withOpacity(0.75),
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppConstants.cWordConstants.wWalkThroughText,
                textAlign: TextAlign.center,
                style: getTextSemiBold(
                  size: SizeConstants.s1 * 20,
                ),
              ),
              Container(
                width: SizeConstants.width * 0.6,
                padding: EdgeInsets.only(
                    top: SizeConstants.s1 * 25,
                    bottom: SizeConstants.s1 * 25),
                child: const Divider(
                  thickness: 1.2,
                  color: Colors.white,
                ),
              ),
              rectangleRoundedCornerButtonImage(
                appbarActionInterface: (value) {
                  mWalkThroughScreenModel.showLoginPage(AppConstants.cWordConstants.wPromoterText);
                },
                sButtonTitle: AppConstants.cWordConstants.wPromoterText,
                iImageAssets: ImageAssetsConstants.walkThroughPromoter,
                dButtonWidth: SizeConstants.s1 * 220,
                cButtonTextColor: Colors.black,
                dButtonTextSize: SizeConstants.s1 * 15,
              ),
              SizedBox(
                height: SizeConstants.s1 * 20,
              ),
              rectangleRoundedCornerButtonImage(
                appbarActionInterface: (value) {
                  mWalkThroughScreenModel.showLoginPage(AppConstants.cWordConstants.wStoreManagerText);
                },
                sButtonTitle: AppConstants.cWordConstants.wStoreManagerText,
                iImageAssets: ImageAssetsConstants.walkThroughStoreManager,
                dButtonWidth: SizeConstants.s1 * 220,
                cButtonTextColor: Colors.black,
                dButtonTextSize: SizeConstants.s1 * 15,
              ),
              SizedBox(
                height: SizeConstants.s1 * 20,
              ),
              rectangleRoundedCornerButtonImage(
                appbarActionInterface: (value) {
                  mWalkThroughScreenModel.showLoginPage(AppConstants.cWordConstants.wWarehouseManagerText);
                },
                sButtonTitle: AppConstants.cWordConstants.wWarehouseManagerText,
                iImageAssets: ImageAssetsConstants.walkThroughWarehouseManager,
                dButtonWidth: SizeConstants.s1 * 220,
                cButtonTextColor: Colors.black,
                dButtonTextSize: SizeConstants.s1 * 15,
              ),
              SizedBox(
                height: SizeConstants.s1 * 40,
              ),
              GestureDetector(
                onTap: () async {
                  final Uri url = Uri.parse("https://www.arianionline.my/privacy-policy?tokenid=ebc8b3175065e9a76ca4e18aebd38b10");
                  if (await launchUrl(url)) {
                  throw Exception('Could not launch');
                  }
                },
                child: Text(
                  AppConstants.cWordConstants.wPrivacyPolicy,
                  textAlign: TextAlign.center,
                  style: getTextRegular(
                    size: SizeConstants.s1 * 14,
                  ),
                ),
              ),
              Container(
                height: 0.5,
                width: 100,
                color: Colors.white,
              ),
            ],
          ))),
    );
  }


}
