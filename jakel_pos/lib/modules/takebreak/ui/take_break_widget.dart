import 'package:flutter/material.dart';
import 'package:jakel_base/locator.dart';
import 'package:jakel_base/restapi/me/model/CurrentUserResponse.dart';
import 'package:jakel_base/restapi/takebreak/TakeBreakApi.dart';
import 'package:jakel_base/restapi/takebreak/model/TakeBreakRequest.dart';
import 'package:jakel_base/utils/my_date_utils.dart';
import 'package:jakel_base/utils/my_unique_id.dart';
import 'package:jakel_base/widgets/appbgwidget/MyBackgroundWidget.dart';

import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/utils/my_assets.dart';
import 'package:jakel_base/widgets/button/MyOutlineButton.dart';
import 'package:jakel_base/widgets/button/MyPrimaryButton.dart';

import 'package:jakel_base/widgets/textfield/MyTextFieldWidget.dart';
import 'package:jakel_pos/modules/login/LoginViewModel.dart';

import 'package:easy_localization/easy_localization.dart';

import '../../common/UserViewModel.dart';
import '../../utils/logout_utils.dart';

class TakeBreakWidget extends StatefulWidget {
  const TakeBreakWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TakeBreakWidgetState();
  }
}

class _TakeBreakWidgetState extends State<TakeBreakWidget> {
  final viewKey = GlobalKey();
  final _viewModel = LoginViewModel();
  var userViewModel = UserViewModel();
  CurrentUserResponse? currentUser;
  String? password;

  final passwordController = TextEditingController();
  var callApi = false;

  @override
  void initState() {
    super.initState();
    userViewModel.takeBreak();
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.closeObservable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyBackgroundWidget(
        child: Row(
          children: [
            Expanded(flex: 2, child: leftLogoWidget(context)),
            Expanded(flex: 3, child: getCurrentUser())
          ],
        ),
      ),
      key: viewKey,
    );
  }

  Widget getCurrentUser() {
    return FutureBuilder(
        future: userViewModel.getCurrentUser(),
        builder: (BuildContext context,
            AsyncSnapshot<CurrentUserResponse?> snapshot) {
          if (snapshot.hasData) {
            currentUser = snapshot.data;
            return getPassword();
          }
          return const Text("Loading Widget");
        });
  }

  Widget getPassword() {
    return FutureBuilder(
        future: _viewModel.getPasswordForSleepValidation(),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.hasData) {
            password = snapshot.data;
            return rightLoginWidgets(context);
          }
          return const Text("Loading Widget");
        });
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
          Row(
            children: [
              CircleAvatar(
                maxRadius: 35,
                backgroundImage: NetworkImage(
                  userViewModel.getProfilePic(currentUser),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                userViewModel.getDisplayName(currentUser),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Done with your break ?",
            style: Theme.of(context).textTheme.caption,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Enter your pin & press enter to resume your work.",
            style: Theme.of(context).textTheme.caption,
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 4,
            child: MyTextFieldWidget(
                controller: passwordController,
                obscureText: true,
                node: FocusNode(),
                onSubmitted: (value) {
                  _login();
                },
                hint: tr('enter_pin')),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Would you like to logout of the system ?",
            style: Theme.of(context).textTheme.caption,
          ),
          const SizedBox(
            height: 20,
          ),
          MyOutlineButton(
              text: "Logout",
              onClick: () {
                setState(() async {
                  await logout(false, context);
                  if (!mounted) return;
                  await routeToSplash(context);
                });
              }),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget buttonWidget() {
    return MyOutlineButton(text: 'Login Back', onClick: () => {_login()});
  }

  void _login() {
    if (passwordController.text.isEmpty) {
      showToast('invalid_pin', context);
      return;
    }

    if (password == passwordController.text) {
      userViewModel.resumeWorkFromBreak();
      Navigator.pop(context);
    } else {
      showToast('invalid_pin', context);
    }
  }
}
