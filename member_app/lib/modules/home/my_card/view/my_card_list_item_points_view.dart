import 'package:flutter/material.dart';
import 'package:member_app/common/color_constants.dart';
import 'package:member_app/common/image_assets.dart';
import 'package:member_app/common/size_constants.dart';
import 'package:member_app/common/text_styles_constants.dart';
import 'package:member_app/data/all_bloc/get_members_details_bloc/repo/get_members_details_response.dart';

class MyCardItemPointsView extends StatefulWidget {
  final int index;
  final LastTransactionsDetails mLoyaltyPoints;
  const MyCardItemPointsView({super.key,required this.index,required this.mLoyaltyPoints});

  @override
  State<MyCardItemPointsView> createState() => _MyCardItemPointsViewState();
}

class _MyCardItemPointsViewState extends State<MyCardItemPointsView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildMyCardItemPointsViewView();
  }

  _buildMyCardItemPointsViewView() {

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
                padding: EdgeInsets.all(
                   SizeConstants.s_12,
                ),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset:
                      const Offset(0, 1), // changes position of shadow
                    ),
                  ],
                  color:
                  widget.mLoyaltyPoints.type.toString().toUpperCase() != "REDEEMED"
                      ? ColorConstants.cLightGreenColor
                      : ColorConstants.cLightRedColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(SizeConstants.s1 * 8),
                  ),
                ),
                child: Image.asset(widget.mLoyaltyPoints.type.toString().toUpperCase() != "REDEEMED"?ImageAssets.imageTopGreenArrow:ImageAssets.imageBottomRedArrow,
                    height: SizeConstants.s_14,
                    width: SizeConstants.s_14),
              ),
              SizedBox(width: SizeConstants.s_10,),
              Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Loyalty Points",
                          style: getTextSemiBold(
                              colors: ColorConstants.cBlack,
                              size: SizeConstants.s_16)),
                      SizedBox(
                        height: SizeConstants.s5,
                      ),
                      Text(widget.mLoyaltyPoints.happenedAt.toString(),
                          style: getTextRegular(
                              colors: Colors.grey.shade500,
                              size: SizeConstants.s_14))
                    ],
                  )),

              Column(
                children: [
                  Text("${widget.mLoyaltyPoints.points} points",
                      style: getTextRegular(
                          colors: Colors.grey.shade500,
                          size: SizeConstants.s_14)),
                  widget.mLoyaltyPoints.type.toString().toUpperCase() != "REDEEMED"?
                  Text("Rewarded",
                      style: getTextMedium(
                          colors: ColorConstants.cGreenColor,
                          size: SizeConstants.s_14,letterSpacing: 0.5)):
                  Text("Redeemed",
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
