import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:member_app/common/app_constants.dart';
import 'package:member_app/common/appbars_constants.dart';
import 'package:member_app/common/color_constants.dart';
import 'package:member_app/common/image_assets.dart';
import 'package:member_app/common/size_constants.dart';
import 'package:member_app/common/text_styles_constants.dart';
import 'package:member_app/common/utils/device_utils.dart';
import 'package:member_app/modules/transaction_list/view/transaction_list_item_points_view.dart';
import 'package:member_app/routes/route_constants.dart';

import 'transaction_list_item_vouchers_view.dart';

class TransactionScreenWidget extends StatefulWidget {
  const TransactionScreenWidget({super.key});

  @override
  State<TransactionScreenWidget> createState() =>
      _TransactionScreenWidgetState();
}

class _TransactionScreenWidgetState extends State<TransactionScreenWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildTransactionScreenWidgetView());
  }

  _buildTransactionScreenWidgetView() {
    return FocusDetector(
        child: SafeArea(
            child: Column(
      children: [
        Container(
          alignment: Alignment.topLeft,
          height: SizeConstants.s_20,
          margin: EdgeInsets.only(
              top: SizeConstants.s_14, left: SizeConstants.s_15),
          child: Image.asset(
            ImageAssets.imageBlackLogo,
            height: SizeConstants.s_18,
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            margin: EdgeInsets.only(
                top: SizeConstants.s_16, left: SizeConstants.s_16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(SizeConstants.s_10),
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
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(SizeConstants.s1 * 8),
                      ),
                    ),
                    child: Image.asset(ImageAssets.imageArrowBack,
                        height: SizeConstants.s_20, width: SizeConstants.s_20),
                  ),
                ),
                SizedBox(
                  width: SizeConstants.s_15,
                ),
                Text(
                  AppConstants.mWordConstants.sTransactions,
                  style: getTextSemiBold(
                      size: SizeConstants.s1 * 19, colors: Colors.black),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: SizeConstants.s_15,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(SizeConstants.s1 * 20),
                topRight: Radius.circular(SizeConstants.s1 * 20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: ListView.builder(
                itemCount: 26,
                itemBuilder: (BuildContext context, int index) {
                  return index % 2 == 0
                      ? TransactionItemPointsView(index: index)
                      : TransactionItemVouchersView(index: index);
                }),
          ),
        ),
      ],
    )));
  }
}
