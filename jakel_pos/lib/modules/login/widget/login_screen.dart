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
import 'package:jakel_pos/modules/login/LoginViewModel.dart';
import 'package:jakel_pos/modules/utils/focus_scope.dart';
import 'package:window_manager/window_manager.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../routing/route_names.dart';
import 'login_app_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginScreen> with WindowListener {
  final viewKey = GlobalKey();
  final _viewModel = LoginViewModel();

  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  var callApi = false;

  final userNameNode = FocusNode();
  final passwordNode = FocusNode();

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
    MyLogUtils.logDebug("Login build");
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50.0), // here the desired height
        child: LoginAppBar(),
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
            text: tr('login_sign_in'),
            color: getPrimaryColor(context),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 4,
            child: MyTextFieldWidget(
              controller: userNameController,
              node: userNameNode,
              onSubmitted: (value) {
                _login();
                focusSocpeNext(context,passwordNode);
              },
              hint: tr('enter_username'),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 4,
            child: MyTextFieldWidget(
                controller: passwordController,
                obscureText: true,
                node: passwordNode,
                onSubmitted: (value) {
                  _login();
                },
                hint: tr('enter_pin')),
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
    MyLogUtils.logDebug("Login buttonWidget");
    if (callApi) {
      return apiWidget();
    }
    return MyOutlineButton(text: 'login_sign_in', onClick: () => {_login()});
  }

  void _login() {
    if (userNameController.text.isEmpty) {
      showToast('invalid_username', context);
      return;
    }

    if (passwordController.text.isEmpty) {
      showToast('invalid_pin', context);
      return;
    }

    setState(() {
      callApi = true;
    });
  }

  Widget apiWidget() {
    MyLogUtils.logDebug("Login apiWidget");

    _viewModel.login(userNameController.text, passwordController.text);

    return StreamBuilder<String?>(
      stream: _viewModel.responseSubject,
      // ignore: missing_return, missing_return
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MyLoadingWidget();
        }
        if (snapshot.hasError) {
          callApi = false;
          showToast("Server error.Please try again later!", context);
          return buttonWidget();
        }
        if (snapshot.connectionState == ConnectionState.active) {
          var empResponse = snapshot.data;

          MyLogUtils.logDebug("Login apiWidget response:$empResponse");

          if (empResponse != null && empResponse == "true") {
            goToSplashScreen();
            return const SizedBox();
          } else {
            showToast(empResponse ?? 'login_failed', context);
            callApi = false;
            return buttonWidget();
          }
        }
        return Container();
      },
    );
  }

  Future<void> goToSplashScreen() async {
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
