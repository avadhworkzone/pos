import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:member_app/common/app_constants.dart';
import 'package:member_app/common/color_constants.dart';
import 'package:member_app/common/dotted_border/dotted_border.dart';
import 'package:member_app/common/image_assets.dart';
import 'package:member_app/common/size_constants.dart';
import 'package:member_app/common/text_styles_constants.dart';
import 'package:member_app/modules/home/home_screen/home_screen_model.dart';

class TransactionItemPointsView extends StatefulWidget {
  final int index;

  const TransactionItemPointsView({super.key, required this.index});

  @override
  State<TransactionItemPointsView> createState() =>
      _TransactionItemPointsViewState();
}

class _TransactionItemPointsViewState extends State<TransactionItemPointsView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildTransactionItemPointsViewView();
  }

  static int countPoints = 1;

  _buildTransactionItemPointsViewView() {
    countPoints++;
    return Container(
      margin: EdgeInsets.only(bottom: SizeConstants.s_14),
      padding: EdgeInsets.all(SizeConstants.s_14),
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
                      offset:
                      const Offset(0, 1), // changes position of shadow
                    ),
                  ],
                  color: countPoints % 2 ==0? ColorConstants.cLightGreenColor: ColorConstants.cLightRedColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(SizeConstants.s1 * 8),
                  ),
                ),
                child: Image.asset(countPoints % 2 ==0?ImageAssets.imageTopGreenArrow:ImageAssets.imageBottomRedArrow,
                    height: SizeConstants.s_14,
                    width: SizeConstants.s_14),
              ),
              SizedBox(width: SizeConstants.s_10,),
              Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Loyalty points",
                          style: getTextMedium(
                              colors: ColorConstants.cBlack,
                              size: SizeConstants.s_15)),
                      SizedBox(
                        height: SizeConstants.s5,
                      ),
                      Text("21 May 2023 , 3.10 am",
                          style: getTextRegular(
                              colors: Colors.grey.shade500,
                              size: SizeConstants.s_12))
                    ],
                  )),

              Column(
                children: [
                  Text("${7 * (widget.index + 1)} points",
                      style: getTextRegular(
                          colors: Colors.grey.shade500,
                          size: SizeConstants.s_12)),
                  countPoints % 2 == 0?
                  Text("Rewarded",
                      style: getTextRegular(
                          colors: ColorConstants.cGreenColor,
                          size: SizeConstants.s_12)):
                  Text("Redeemed",
                      style: getTextRegular(
                          colors: ColorConstants.cRedColor,
                          size: SizeConstants.s_12)),
                ],
              )

            ],
          )
        ],
      ),
    );
  }
}
