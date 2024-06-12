import 'package:flutter/material.dart';
import 'package:member_app/common/app_constants.dart';
import 'package:member_app/common/image_assets.dart';
import 'package:member_app/common/size_constants.dart';
import 'package:member_app/common/text_styles_constants.dart';

Widget noTransactionsFound() {
  return Container(
    width: SizeConstants.width,
    height: SizeConstants.s1*220,
    alignment: Alignment.center,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children:[
        Image.asset(ImageAssets.imageNoTransactionsFound,
            width: SizeConstants.width/2.2,
            fit: BoxFit.fitWidth),
        SizedBox(height: SizeConstants.s_15,),
        Text(
          AppConstants.mWordConstants.sNoTransactionsFound,
          style: getTextSemiBold(
              size: SizeConstants.s1 * 22, colors: Colors.black,letterSpacing: 0.5),
        )
      ],
    ),
  );
}

Widget noVoucherFound() {
  return Container(
    width: SizeConstants.width,
    height: SizeConstants.s1*220,
    alignment: Alignment.center,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children:[
        Image.asset(ImageAssets.imageNoTransactionsFound,
            width: SizeConstants.width/2.2,
            fit: BoxFit.fitWidth),
        SizedBox(height: SizeConstants.s_15,),
        Text(
          AppConstants.mWordConstants.sNoVoucherFound,
          style: getTextSemiBold(
              size: SizeConstants.s1 * 22, colors: Colors.black,letterSpacing: 0.5),
        )
      ],
    ),
  );
}
