import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:member_app/common/color_constants.dart';
import 'package:member_app/common/size_constants.dart';
import 'package:rxdart/rxdart.dart';

class WebControllerModel {

  var responseSubjectLoading = PublishSubject<bool>();

  Stream<bool?> get responseStreamLoading => responseSubjectLoading.stream;

  void closeObservableLoading() {
    responseSubjectLoading.close();
  }

  void setLoading(bool key) async {
    try {
      responseSubjectLoading.sink.add(key);
    } catch (e) {
      responseSubjectLoading.sink.addError(e);
    }
  }

  Widget showProgress() {
    return StreamBuilder<bool?>(
      stream: responseSubjectLoading,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          var empResponse = snapshot.data;
          if (empResponse != null && empResponse) {
            return _getLoadingView();
          } else {
            return const SizedBox();
          }
        }
        return _getLoadingView();
      },
    );
  }

  _getLoadingView() {
    return Center(
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        padding: EdgeInsets.all(SizeConstants.s_16),
        height: SizeConstants.s1 * 80,
        width: SizeConstants.s1 * 80,
        child: const CircularProgressIndicator(
          strokeWidth: 6.0,
          color: ColorConstants.kPrimaryColor,
        ),
      ),
    );
  }

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
          useShouldOverrideUrlLoading: true,
          javaScriptEnabled: true,
          clearCache: true,
          cacheEnabled: true,
          mediaPlaybackRequiresUserGesture: false),
      android: AndroidInAppWebViewOptions(
          useHybridComposition: true, clearSessionCache: true),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));
}
