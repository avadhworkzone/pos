import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:member_app/common/app_constants.dart';
import 'package:member_app/common/button_constants.dart';
import 'package:member_app/common/color_constants.dart';
import 'package:member_app/common/size_constants.dart';
import 'package:member_app/modules/home/home_screen/home_screen_model.dart';
import 'package:member_app/modules/home/reward/loyalty_points/reward_show_loyalty_points_view.dart';
import 'package:member_app/modules/home/reward/vouchers_view/reward_show_vouchers_view.dart';

class RewardScreenWidget extends StatefulWidget {
  final HomeScreenModel mHomeScreenModel;

  const RewardScreenWidget({super.key, required this.mHomeScreenModel});

  @override
  State<RewardScreenWidget> createState() => _RewardScreenWidgetState();
}

class _RewardScreenWidgetState extends State<RewardScreenWidget> {
  // Initial Selected Value
  String selectedTabValue = AppConstants.mWordConstants.sVouchers;

  @override
  void initState() {
    if (widget.mHomeScreenModel.sValue.toString().isEmpty ||
        widget.mHomeScreenModel.sValue.toString() ==
            AppConstants.mWordConstants.sVouchers) {
      selectedTabValue = AppConstants.mWordConstants.sVouchers;
    } else {
      selectedTabValue = AppConstants.mWordConstants.sLoyaltyPoints;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildRewardScreenWidgetView());
  }

  _buildRewardScreenWidgetView() {
    return FocusDetector(
        child: SafeArea(
      child: Column(
        children: [

          SizedBox(
            height: SizeConstants.s_15,
          ),
          Container(
            padding: EdgeInsets.only(
                left: SizeConstants.s_15,
                right: SizeConstants.s_15,),
            width: SizeConstants.width,
            child: _showTopBarView(),
          ),
          SizedBox(
            height: SizeConstants.s_15,
          ),
          Flexible(
              child: Container(

            child: selectedTabValue == AppConstants.mWordConstants.sVouchers
                ? const RewardShowVouchersViewWidget()
                : const RewardShowLoyaltyPointsViewWidget(),
          )),
        ],
      ),
    ));
  }

  _showTopBarView() {
    return Container(
      decoration: BoxDecoration(
        color: ColorConstants.cBlack,
        borderRadius: BorderRadius.all(
          Radius.circular(SizeConstants.s1 * 15),
        ),

      ),
      padding: EdgeInsets.all(SizeConstants.s_8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: SizeConstants.width * 0.15,
            child: mediumRoundedCornerButton(
                appbarActionInterface: (value) async{
                  setState(() {
                    selectedTabValue =
                        AppConstants.mWordConstants.sLoyaltyPoints;
                  });
                },
                sButtonTitle: AppConstants.mWordConstants.sLoyaltyPoints,
                cButtonBackGroundColor: selectedTabValue !=
                    AppConstants.mWordConstants.sVouchers
                    ? ColorConstants.cWhite
                    : ColorConstants.cBlack,
                cButtonTextColor: selectedTabValue !=
                    AppConstants.mWordConstants.sVouchers
                    ? ColorConstants.cBlack
                    : ColorConstants.cWhite,
                dButtonTextSize: SizeConstants.s_16,
                cButtonBorderColor: selectedTabValue !=
                    AppConstants.mWordConstants.sVouchers
                    ? ColorConstants.cWhite
                    : ColorConstants.cBlack,
                dButtonRadius: SizeConstants.s1 * 15,
                dButtonWidth: SizeConstants.width * 0.42,
                cBoxShadow: selectedTabValue != AppConstants.mWordConstants.sVouchers),

          ),
          SizedBox(
            height: SizeConstants.width * 0.15,
            child: mediumRoundedCornerButton(
                appbarActionInterface: (value) {
                  setState(() {
                    selectedTabValue =
                        AppConstants.mWordConstants.sVouchers;
                  });
                },
                sButtonTitle:
                AppConstants.mWordConstants.sVouchers,
                cButtonBackGroundColor: selectedTabValue ==
                    AppConstants.mWordConstants.sVouchers
                    ? ColorConstants.cWhite
                    : ColorConstants.cBlack,
                cButtonTextColor: selectedTabValue ==
                    AppConstants.mWordConstants.sVouchers
                    ? ColorConstants.cBlack
                    : ColorConstants.cWhite,
                dButtonTextSize: SizeConstants.s_16,
                cButtonBorderColor: selectedTabValue ==
                    AppConstants.mWordConstants.sVouchers
                    ? ColorConstants.cWhite
                    : ColorConstants.cBlack,
                dButtonRadius: SizeConstants.s1 * 15,
                dButtonWidth: SizeConstants.width * 0.42,
                cBoxShadow: selectedTabValue == AppConstants.mWordConstants.sVouchers),
          ),
        ],
      ),
    );
  }


}
