import 'package:flutter/material.dart';
import 'package:internal_base/common/call_back.dart';
import 'package:internal_base/common/color_constants.dart';
import 'package:internal_base/common/size_constants.dart';
import 'package:internal_base/common/text_styles_constants.dart';

class HomePageItemView extends StatelessWidget {
  final CallbackModel mCallbackModel;
  final String imageAssets;
  final String sTitle;
  final String sSubTitle;
  final String sIcon;

  const HomePageItemView(
      {super.key,
      required this.mCallbackModel,
      required this.imageAssets,
      required this.sTitle,
      required this.sSubTitle,
      required this.sIcon});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return getHomeItemView();
  }

  getHomeItemView() {
    return Container(
      padding: EdgeInsets.all(
        SizeConstants.s1 * 15,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border.all(
            color: Colors.grey.shade200, width: SizeConstants.s1 * 1.25),
        borderRadius: BorderRadius.all(Radius.circular(SizeConstants.s1 * 15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              height: SizeConstants.s1 * 35,
              width: SizeConstants.s1 * 35,
              padding: EdgeInsets.all(SizeConstants.s1 * 6),
              decoration: BoxDecoration(
                color: ColorConstants.kPrimaryColor,
                borderRadius:
                    BorderRadius.all(Radius.circular(SizeConstants.s1 * 8)),
              ),
              child: Image(image: AssetImage(imageAssets))),
          SizedBox(height: SizeConstants.s1 * 12),
          Text(sTitle,
              style: getTextRegular(
                  size: SizeConstants.s1 * 14, colors: Colors.grey.shade700)),
          SizedBox(height: SizeConstants.s1 * 5),
          Row(
            children: [
              sIcon.isNotEmpty
                  ? Icon(
                      Icons.timer_outlined,
                      color: Colors.grey,
                      size: SizeConstants.s1 * 20,
                    )
                  : SizedBox(),
              SizedBox(
                width: sIcon.isNotEmpty ? SizeConstants.s1 * 5 : 0.0,
              ),
              Text(sSubTitle,
                  style: getTextSemiBold(
                      size: SizeConstants.s1 * 14, colors: Colors.black)),
            ],
          )
        ],
      ),
    );
  }
}
