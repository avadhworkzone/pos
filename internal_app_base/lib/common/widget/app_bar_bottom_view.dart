import 'package:flutter/material.dart';
import 'package:internal_base/common/image_assets.dart';
import 'package:internal_base/common/size_constants.dart';
import 'package:internal_base/common/text_styles_constants.dart';

appBarBottomViewWithText(String sTitle,
    {Alignment mAlignment = Alignment.topLeft}) {
  return Column(children: [
    Row(
      children: [
        Container(
          alignment: mAlignment,
          height: SizeConstants.s1 * 36,
          margin:
          EdgeInsets.only(
              top: SizeConstants.s1 * 14, left: SizeConstants.s1 * 15),
          child: Image.asset(
            ImageAssets.imageAppBarLogo,
            height: SizeConstants.s1 * 36,
          ),
        ),


      ],
    ),

    sTitle.isNotEmpty
        ? Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: EdgeInsets.only(
            top: SizeConstants.s1 * 16, left: SizeConstants.s1 * 16),
        child: Text(
          sTitle,
          style: getTextSemiBold(
              size: SizeConstants.s1 * 19, colors: Colors.black),
        ),
      ),
    )
        : SizedBox(),
  ]);
}

appBarBottomViewWithTextBack(String sTitle, BuildContext context) {
  return Column(children: [
    Container(
      alignment: Alignment.topLeft,
      height: SizeConstants.s1 * 36,
      margin:
      EdgeInsets.only(top: SizeConstants.s1 * 14, left: SizeConstants.s1 * 15),
      child: Image.asset(
        ImageAssets.imageAppBarLogo,
        height: SizeConstants.s1 * 36,
      ),
    ),
    sTitle.isNotEmpty
        ? Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: EdgeInsets.only(
            top: SizeConstants.s1 * 16, left: SizeConstants.s1 * 16),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.all(SizeConstants.s1 * 10),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(
                          0, 1), // changes position of shadow
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(SizeConstants.s1 * 8),
                  ),
                ),
                child: Image.asset(ImageAssets.imageArrowBack,
                    height: SizeConstants.s1 * 20,
                    width: SizeConstants.s1 * 20),
              ),
            ),
            SizedBox(
              width: SizeConstants.s1 * 15,
            ),
            Text(
              sTitle,
              style: getTextSemiBold(
                  size: SizeConstants.s1 * 19, colors: Colors.black),
            ),
          ],
        ),
      ),
    )
        : SizedBox(),
  ]);
}
