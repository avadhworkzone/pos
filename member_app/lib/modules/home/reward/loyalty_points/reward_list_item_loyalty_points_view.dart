import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:flutter/material.dart';
import 'package:member_app/common/alert/app_alert.dart';
import 'package:member_app/common/color_constants.dart';
import 'package:member_app/common/dotted_border/dotted_border.dart';
import 'package:member_app/common/image_assets.dart';
import 'package:member_app/common/size_constants.dart';
import 'package:member_app/common/text_styles_constants.dart';
import 'package:member_app/data/all_bloc/transactions_list_bloc/repo/transactions_list_response.dart';

class RewardItemLoyaltyPointsView extends StatefulWidget {
  final int index;
  final LoyaltyPoints mLoyaltyPoints;

  const RewardItemLoyaltyPointsView(
      {super.key, required this.index, required this.mLoyaltyPoints});

  @override
  State<RewardItemLoyaltyPointsView> createState() =>
      _RewardItemLoyaltyPointsViewState();
}

class _RewardItemLoyaltyPointsViewState
    extends State<RewardItemLoyaltyPointsView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildRewardItemLoyaltyPointsViewView();
  }

  _buildRewardItemLoyaltyPointsViewView() {
    return Container(
      margin: EdgeInsets.only(bottom: SizeConstants.s_14),
      padding: EdgeInsets.only(
        left:SizeConstants.s_14,
        right:SizeConstants.s_14,
        top:SizeConstants.s_6,),
      width: SizeConstants.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(SizeConstants.s_12),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1), // changes position of shadow
                    ),
                  ],
                  color: widget.mLoyaltyPoints.type.toString().toUpperCase() != "REDEEMED"
                      ? ColorConstants.cLightGreenColor
                      : ColorConstants.cLightRedColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(SizeConstants.s1 * 8),
                  ),
                ),
                child: Image.asset(
                    widget.mLoyaltyPoints.type.toString().toUpperCase() != "REDEEMED"
                        ? ImageAssets.imageTopGreenArrow
                        : ImageAssets.imageBottomRedArrow,
                    height: SizeConstants.s_14,
                    width: SizeConstants.s_14),
              ),
              SizedBox(
                width: SizeConstants.s_10,
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.mLoyaltyPoints.happenedAt.toString(),
                      style: getTextRegular(
                          colors: Colors.grey.shade500,
                          size: SizeConstants.s_16))
                ],
              )),
              Column(
                children: [
                  Text("${widget.mLoyaltyPoints.points} points",
                      style: getTextRegular(
                          colors: Colors.grey.shade500,
                          size: SizeConstants.s_14)),
                  widget.mLoyaltyPoints.type.toString().toUpperCase() != "REDEEMED"
                      ? Text("Rewarded",
                          style: getTextMedium(
                              colors: ColorConstants.cGreenColor,
                              size: SizeConstants.s_14,
                          letterSpacing: 0.5))
                      : Text("Redeemed",
                          style: getTextMedium(
                              colors: ColorConstants.cRedColor,
                              size: SizeConstants.s_14,
                              letterSpacing: 0.5)),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
