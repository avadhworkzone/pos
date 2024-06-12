import 'package:flutter/material.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/my_assets.dart';
import 'package:jakel_base/widgets/appbgwidget/MyBackgroundWidget.dart';
import 'package:jakel_base/widgets/button/MyOutlineButton.dart';
import 'package:jakel_base/widgets/loadingwidget/MyLoadingWidget.dart';
import 'package:jakel_base/widgets/text/HeaderTextWidget.dart';
import 'package:jakel_base/widgets/textfield/MyTextFieldWidget.dart';
import 'package:jakel_pos/modules/configuration/ConfigurationViewModel.dart';

import 'package:window_manager/window_manager.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../routing/route_names.dart';

class ConfigurationScreen extends StatefulWidget {
  const ConfigurationScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ConfigurationState();
  }
}

class _ConfigurationState extends State<ConfigurationScreen>
    with WindowListener {
  final viewKey = GlobalKey();
  final _viewModel = ConfigurationViewModel();

  final configurationKeyController = TextEditingController();

  var callApi = false;

  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    windowManager.removeListener(this);
    _viewModel.closeObservable();
  }

  @override
  void onWindowClose() {
    //TODO: Ask for confirmation dialog
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('title')),
      ),
      body: MyBackgroundWidget(
        child: Row(
          children: [
            Expanded(flex: 2, child: leftLogoWidget(context)),
            Expanded(flex: 3, child: rightLoginWidgets(context))
          ],
        ),
      ),
      key: viewKey,
    );
  }

  Widget leftLogoWidget(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 3,
            height: double.infinity,
            color: getPrimaryColor(context),
          ),
          ClipOval(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: double.infinity,
              color: getPrimaryColor(context),
            ),
          ),
          const Align(
            alignment: Alignment.center,
            child: Image(
              image: AssetImage(ariyaniLogo),
              height: 300,
              width: 400,
            ),
          )
        ],
      ),
    );
  }

  Widget rightLoginWidgets(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderTextWidget(
            text: 'Set Up',
            color: getPrimaryColor(context),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 4,
            child: MyTextFieldWidget(
              obscureText: true,
              onSubmitted: (key) {
                _login();
              },
              controller: configurationKeyController,
              node: FocusNode(),
              hint: 'Enter Configuration Key',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            height: 20,
          ),
          buttonWidget()
        ],
      ),
    );
  }

  Widget buttonWidget() {
    if (callApi) {
      return apiWidget();
    }
    return MyOutlineButton(text: 'done', onClick: () => {_login()});
  }

  void _login() {
    if (configurationKeyController.text.isEmpty) {
      showToast('invalid_config_key', context);
      return;
    }

    setState(() {
      callApi = true;
    });
  }

  var apiRequested = false;

  Widget apiWidget() {
    if (!apiRequested) {
      apiRequested = true;
      _viewModel.downloadConfiguration(
        configurationKeyController.text,
      );
    }
    return StreamBuilder<bool?>(
      stream: _viewModel.responseSubject,
      // ignore: missing_return, missing_return
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MyLoadingWidget();
        }
        if (snapshot.hasError) {
          callApi = false;
          showToast(
              "Invalid configuration setup key.Please check your key! ${snapshot.error}",
              context);
          return buttonWidget();
        }
        if (snapshot.connectionState == ConnectionState.active) {
          var empResponse = snapshot.data;
          if (empResponse != null && empResponse) {
            goToHomeScreen();
            return const SizedBox();
          } else {
            showToast('Invalid configuration setup key.Please check your key!',
                context);
            callApi = false;
            return buttonWidget();
          }
        }
        return Container();
      },
    );
  }

  Future<void> goToHomeScreen() async {
    _viewModel.closeObservable();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pop(context);
      Navigator.pushNamed(
        context,
        SplashRoute,
      );
    });
  }
}
