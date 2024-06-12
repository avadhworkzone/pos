import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:member_app/common/app_constants.dart';
import 'package:member_app/common/color_constants.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

waterDropHeader() {
  return const WaterDropMaterialHeader(
    backgroundColor: Colors.white,
    color: ColorConstants.kPrimaryColor,
  );
}

 customFooter(LoadStatus? status) {
  Widget body;
  if (status == LoadStatus.idle) {
    body = Text(AppConstants.mWordConstants.wPullUpLoad);
  } else if (status == LoadStatus.loading) {
    body = const CupertinoActivityIndicator();
  } else if (status == LoadStatus.failed) {
    body = Text(AppConstants.mWordConstants.wLoadFailedClickRetry);
  } else if (status == LoadStatus.canLoading) {
    body = const CupertinoActivityIndicator();
  } else {
    body = Text(AppConstants.mWordConstants.wNoMoreData);
  }

  return SizedBox(
    height: 56.0,
    child: Center(
      child: body,
    ),
  );
}
