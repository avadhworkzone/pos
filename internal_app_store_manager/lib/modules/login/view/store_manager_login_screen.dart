import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:internal_app_store_manager/constants/image_assets_constants.dart';
import 'package:internal_app_store_manager/modules/login/model/store_manager_login_model.dart';
import 'package:internal_base/common/app_constants.dart';
import 'package:internal_base/common/button_constants.dart';
import 'package:internal_base/common/color_constants.dart';
import 'package:internal_base/common/size_constants.dart';
import 'package:internal_base/common/widget/edit_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_login/bloc/store_manager_login_screen_bloc.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_login/bloc/store_manager_login_screen_state.dart';

class StoreManagerLoginScreenWidget extends StatefulWidget {
  const StoreManagerLoginScreenWidget({super.key});

  @override
  State<StoreManagerLoginScreenWidget> createState() =>
      _StoreManagerLoginScreenWidgetState();
}

class _StoreManagerLoginScreenWidgetState
    extends State<StoreManagerLoginScreenWidget> {
  late StoreManagerLoginScreenModel mStoreManagerLoginScreenModel;

  @override
  void initState() {
    mStoreManagerLoginScreenModel = StoreManagerLoginScreenModel(context);
    mStoreManagerLoginScreenModel.setStoreManagerLoginScreenBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildStoreManagerLoginScreenView());
  }

  _buildStoreManagerLoginScreenView() {
    return MultiBlocListener(child: storeManagerLoginScreenView(), listeners: [
      BlocListener<StoreManagerLoginScreenBloc, StoreManagerLoginScreenState>(
        bloc: mStoreManagerLoginScreenModel.getStoreManagerLoginScreenBloc(),
        listener: (context, state) {
          mStoreManagerLoginScreenModel.blocStoreManagerLoginScreenListener(
              context, state);
        },
      ),
    ]);
  }

  storeManagerLoginScreenView() {
    return FocusDetector(
        child: Scaffold(
      body: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage(ImageAssetsConstants.loginBackground),
                fit: BoxFit.cover,
              )),
          child: Container(
              padding: EdgeInsets.only(
                  left: SizeConstants.s1 * 30, right: SizeConstants.s1 * 30),
              color: ColorConstants.kPrimaryColor.withOpacity(0.75),
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: SizeConstants.width * 0.50,
                    width: SizeConstants.width * 0.50,
                    child: Image.asset(ImageAssetsConstants.splashLogo),
                  ),

                  editTextFiled(
                    mStoreManagerLoginScreenModel
                        .mUserNameTextEditingController,
                    labelText: AppConstants.cWordConstants.wUsernameText,
                    hintText:
                        AppConstants.cWordConstants.wPleaseEnterUsernameText,
                  ),
                  SizedBox(
                    height: SizeConstants.s1 * 15,
                  ),
                  editTextFiled(
                      mStoreManagerLoginScreenModel
                          .mPasswordTextEditingController,
                      labelText: AppConstants.cWordConstants.wPasswordText,
                      hintText:
                          AppConstants.cWordConstants.wPleaseEnterPasswordText,
                      obscureText: true),
                  SizedBox(
                    height: SizeConstants.s1 * 20,
                  ),
                  mediumRoundedCornerButton(
                    appbarActionInterface: (value) {
                      mStoreManagerLoginScreenModel
                          .fetchStoreManagerLoginScreenUrl();
                    },
                    sButtonTitle: AppConstants.cWordConstants.wLoginText,
                    dButtonWidth: SizeConstants.s1 * 150,
                    cButtonTextColor: Colors.black,
                    dButtonTextSize: SizeConstants.s1 * 15,
                  ),
                  SizedBox(
                    height: SizeConstants.s1 * 20,
                  ),
                  // Text(
                  //   AppConstants.cWordConstants.wForgotPasswordText,
                  //   textAlign: TextAlign.center,
                  //   style: getTextRegular(
                  //     size: SizeConstants.s1 * 15,
                  //   ),
                  // ),
                ],
              ))),
    ));
  }
}
