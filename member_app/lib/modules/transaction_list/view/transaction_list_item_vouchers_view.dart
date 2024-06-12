import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:member_app/common/app_constants.dart';
import 'package:member_app/common/color_constants.dart';
import 'package:member_app/common/dotted_border/dotted_border.dart';
import 'package:member_app/common/image_assets.dart';
import 'package:member_app/common/size_constants.dart';
import 'package:member_app/common/text_styles_constants.dart';
import 'package:member_app/modules/home/home_screen/home_screen_model.dart';

class TransactionItemVouchersView extends StatefulWidget {
  final int index;

  const TransactionItemVouchersView({super.key, required this.index});

  @override
  State<TransactionItemVouchersView> createState() =>
      _TransactionItemVouchersViewState();
}

class _TransactionItemVouchersViewState
    extends State<TransactionItemVouchersView> {
  List<String> mListVoucherName = [
    "EMMA BLOUSE",
    "ARIANI FREE GIFT",
    "BOX ARIANI ONLINE 2021"
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildTransactionItemVouchersViewView();
  }

  static int countVouchers = 1;

  _buildTransactionItemVouchersViewView() {
    countVouchers++;
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
                  color: countVouchers % 2 ==0? ColorConstants.cLightGreenColor: ColorConstants.cLightRedColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(SizeConstants.s1 * 8),
                  ),
                ),
                child: Image.asset(countVouchers % 2 ==0?ImageAssets.imageTopGreenArrow:ImageAssets.imageBottomRedArrow,
                    height: SizeConstants.s_14,
                    width: SizeConstants.s_14),
              ),
              SizedBox(width: SizeConstants.s_10,),
              Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(mListVoucherName[countVouchers % 3],
                          style: getTextMedium(
                              colors: ColorConstants.cBlack,
                              size: SizeConstants.s_15)),
                      SizedBox(
                        height: SizeConstants.s5,
                      ),
                      Text("12345678",
                          style: getTextRegular(
                              colors: Colors.grey.shade500,
                              size: SizeConstants.s_12))
                    ],
                  )),
              Column(
                children: [
                  Text("RM 25.00",
                      style: getTextRegular(
                          colors: Colors.grey.shade500,
                          size: SizeConstants.s_12)),
                  countVouchers % 2 == 0?
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
