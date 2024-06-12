import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:flutter/material.dart';
import 'package:member_app/common/alert/app_alert.dart';
import 'package:member_app/common/color_constants.dart';
import 'package:member_app/common/dotted_border/dotted_border.dart';
import 'package:member_app/common/image_assets.dart';
import 'package:member_app/common/size_constants.dart';
import 'package:member_app/common/text_styles_constants.dart';
import 'package:member_app/data/all_bloc/member_voucher_paginated_list_bloc/repo/member_voucher_paginated_list_response.dart';

class RewardItemVouchersView extends StatefulWidget {
  final int index;
  final Vouchers mVouchers;

  const RewardItemVouchersView(
      {super.key, required this.index, required this.mVouchers});

  @override
  State<RewardItemVouchersView> createState() => _RewardItemVouchersViewState();
}

class _RewardItemVouchersViewState extends State<RewardItemVouchersView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildRewardItemVouchersViewView();
  }

  _buildRewardItemVouchersViewView() {
    String sAmount =
        "RM${widget.mVouchers.flatAmount.toString() == "null" ? "0.0" : widget.mVouchers.flatAmount.toString()} OFF";
    if (widget.mVouchers.flatAmount.toString() == "null") {
      sAmount =
          "${widget.mVouchers.percentage.toString() == "null" ? "0.0" : widget.mVouchers.percentage.toString()}% OFF";
    }
    return GestureDetector(
      onTap: () {
        if (widget.mVouchers.usedAt.toString() == "null") {
          AppAlert.showDialogVouchersActive(
              context, SizeConstants.height, widget.mVouchers);
        } else {
          AppAlert.showDialogVouchersRedeemed(
              context, SizeConstants.height, widget.mVouchers);
        }
      },
      child: Container(
          padding: EdgeInsets.only(
            left: SizeConstants.s_10,
            right: SizeConstants.s_10,
            top: SizeConstants.s_6,
            bottom: SizeConstants.s_6,
          ),
          margin: EdgeInsets.only(
            left: SizeConstants.s_10,
            right: SizeConstants.s_10,
            top: SizeConstants.s_10,
            bottom: SizeConstants.s2,
          ),
          color: Colors.grey.shade50,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(SizeConstants.s_10),
                    decoration: BoxDecoration(
                        color: ColorConstants.kPrimaryColor.shade600,
                        borderRadius: const BorderRadius.all(Radius.circular(8))),
                    height: SizeConstants.s_18*3,
                    width: SizeConstants.s_18*3,
                    child: Image.asset(ImageAssets.imageVouchersList),
                  ),
                  SizedBox(width: SizeConstants.s_10,),
                  Expanded(
                      child: Container(
                        padding: EdgeInsets.all(SizeConstants.s_10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(sAmount,
                                style: getTextSemiBold(
                                    colors: ColorConstants.cBlack,
                                    size: SizeConstants.s_16)),
                            SizedBox(height: SizeConstants.s_8),
                            Text("Minimum Spend",
                                style: getTextLight(
                                    colors: ColorConstants.cBlack,
                                    size: SizeConstants.s_14,
                                letterSpacing: 0.5)),
                            Text("RM${widget.mVouchers.minimumSpendAmount}",
                                style: getTextBold(
                                    colors: ColorConstants.kPrimaryColor.shade600,
                                    size: SizeConstants.s_16)),
                            SizedBox(height: SizeConstants.s5),
                            Text(widget.mVouchers.usedAt.toString() == "null"?"Valid until ${widget.mVouchers.expiryDate.toString()}":"Redeemed on ${widget.mVouchers.usedAt.toString()}",
                                style: getTextLight(
                                    colors: ColorConstants.cDividerLightColor,
                                    size: SizeConstants.s1*13)),



                          ],
                        ),
                      )),
                  Text(
                      widget.mVouchers.usedAt.toString() == "null"
                          ? "Active"
                          : "Redeemed",
                      style: getTextMedium(
                          colors: widget.mVouchers.usedAt.toString() == "null"
                              ? ColorConstants.cGreenColor
                              : ColorConstants.cRedColor,
                          size: SizeConstants.s_14))
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: SizeConstants.s_15),
                width: SizeConstants.width,
                height: SizeConstants.s_05,
                color: Colors.grey,
              )
            ],
          )
          ),
    );
  }
}
