import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:member_app/common/app_constants.dart';
import 'package:member_app/common/appbars_constants.dart';
import 'package:member_app/common/size_constants.dart';
import 'package:member_app/common/widget/app_bar_bottom_view.dart';
import 'package:member_app/modules/common/skill_selection/model/web_model.dart';

import '../repo/web_controller_model.dart';

class CommonWebView extends StatefulWidget {
  final WebModel sWebView;

  CommonWebView({Key? key, required this.sWebView}) : super(key: key);

  @override
  _CommonWebViewState createState() => _CommonWebViewState();
}

class _CommonWebViewState extends State<CommonWebView> {
  WebControllerModel skillSelectionModel = WebControllerModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold( appBar: AppBars.appBar(
            (value) {
        },
        widget.sWebView.appBarName
    ), body: _buildWebView());
  }

  _buildWebView() {
    return FocusDetector(
        child: SafeArea(
            child: webView()));
  }

  webView() {
    return Stack(children: [
      InAppWebView(
        onLoadStart: (webViewController, uri) {
        },
        onLoadStop: (webViewController, uri) {
          setState(() {
            skillSelectionModel.setLoading(false);
          });
        },
        androidOnPermissionRequest: (controller, origin, resources) async {
          return PermissionRequestResponse(
              resources: resources,
              action: PermissionRequestResponseAction.GRANT);
        },
        initialOptions: skillSelectionModel.options,
        initialUrlRequest: URLRequest(url: Uri.parse(widget.sWebView.webUrl)),
        onReceivedServerTrustAuthRequest: (controller, challenge) async {
          return ServerTrustAuthResponse(
              action: ServerTrustAuthResponseAction.PROCEED);
        },
      ),
      skillSelectionModel.showProgress()
    ]);
  }
}
