import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:internal_app_promoter/constants/image_assets_constants.dart';
import 'package:internal_app_promoter/modules/login/model/promoter_login_model.dart';
import 'package:internal_base/common/alert/app_alert.dart';
import 'package:internal_base/common/app_constants.dart';
import 'package:internal_base/common/button_constants.dart';
import 'package:internal_base/common/color_constants.dart';
import 'package:internal_base/common/size_constants.dart';
import 'package:internal_base/common/text_styles_constants.dart';
import 'package:internal_base/common/utils/app_valid_utils.dart';
import 'package:internal_base/common/widget/edit_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_base/data/all_bloc/promoter/promoter_login/bloc/promoter_login_screen_bloc.dart';
import 'package:internal_base/data/all_bloc/promoter/promoter_login/bloc/promoter_login_screen_state.dart';

class PromoterLoginScreenWidget extends StatefulWidget {
  const PromoterLoginScreenWidget({super.key});

  @override
  State<PromoterLoginScreenWidget> createState() =>
      _PromoterLoginScreenWidgetState();
}

class _PromoterLoginScreenWidgetState extends State<PromoterLoginScreenWidget> {
  late PromoterLoginScreenModel mPromoterLoginScreenModel;

  @override
  void initState() {
    mPromoterLoginScreenModel = PromoterLoginScreenModel(context);
    mPromoterLoginScreenModel.setPromoterLoginScreenBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildPromoterLoginScreenView());
  }

  _buildPromoterLoginScreenView() {
    return MultiBlocListener(child: promoterLoginScreenView(), listeners: [
      BlocListener<PromoterLoginScreenBloc, PromoterLoginScreenState>(
        bloc: mPromoterLoginScreenModel.getPromoterLoginScreenBloc(),
        listener: (context, state) {
          mPromoterLoginScreenModel.blocPromoterLoginScreenListener(
              context, state);
        },
      ),
    ]);
  }

  promoterLoginScreenView() {
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: SizeConstants.width * 0.75,
                      width: SizeConstants.width * 0.75,
                      child: Image.asset(ImageAssetsConstants.splashLogo),
                    ),
                    editTextFiled(
                      mPromoterLoginScreenModel.mUserNameTextEditingController,
                      labelText: AppConstants.cWordConstants.wUsernameText,
                      hintText:
                          AppConstants.cWordConstants.wPleaseEnterUsernameText,
                    ),
                    SizedBox(
                      height: SizeConstants.s1 * 15,
                    ),
                    editTextFiled(
                        mPromoterLoginScreenModel
                            .mPasswordTextEditingController,
                        labelText: AppConstants.cWordConstants.wPasswordText,
                        hintText: AppConstants
                            .cWordConstants.wPleaseEnterPasswordText,
                        obscureText: true),
                    SizedBox(
                      height: SizeConstants.s1 * 30,
                    ),
                    mediumRoundedCornerButton(
                      appbarActionInterface: (value) {
                        if (mPromoterLoginScreenModel
                                .mUserNameTextEditingController
                                .text
                                .isNotEmpty &&
                            mPromoterLoginScreenModel
                                .mPasswordTextEditingController
                                .text
                                .isNotEmpty) {
                          AppValidUtils.hideKeyboard(context);
                          mPromoterLoginScreenModel
                              .fetchPromoterLoginScreenUrl();
                        } else if (mPromoterLoginScreenModel
                            .mUserNameTextEditingController.text.isEmpty) {
                          AppAlert.showSnackBar(
                              context,
                              AppConstants
                                  .cWordConstants.wPleaseEnterUsernameText);
                        } else if (mPromoterLoginScreenModel
                            .mPasswordTextEditingController.text.isEmpty) {
                          AppAlert.showSnackBar(
                              context,
                              AppConstants
                                  .cWordConstants.wPleaseEnterPasswordText);
                        }
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
                ),
              ))),
    ));
  }
}
