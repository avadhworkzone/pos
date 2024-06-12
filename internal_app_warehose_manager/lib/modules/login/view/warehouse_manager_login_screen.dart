import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:internal_app_warehose_manager/constants/image_assets_constants.dart';
import 'package:internal_app_warehose_manager/modules/login/model/warehouse_manager_login_model.dart';
import 'package:internal_base/common/app_constants.dart';
import 'package:internal_base/common/button_constants.dart';
import 'package:internal_base/common/color_constants.dart';
import 'package:internal_base/common/size_constants.dart';
import 'package:internal_base/common/text_styles_constants.dart';
import 'package:internal_base/common/widget/edit_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_login/bloc/warehouse_manager_login_screen_bloc.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_login/bloc/warehouse_manager_login_screen_state.dart';

class WarehouseManagerLoginScreenWidget extends StatefulWidget {
  const WarehouseManagerLoginScreenWidget({super.key});

  @override
  State<WarehouseManagerLoginScreenWidget> createState() => _WarehouseManagerLoginScreenWidgetState();
}

class _WarehouseManagerLoginScreenWidgetState extends State<WarehouseManagerLoginScreenWidget> {
  late WarehouseManagerLoginScreenModel mWarehouseManagerLoginScreenModel;

  @override
  void initState() {
    mWarehouseManagerLoginScreenModel = WarehouseManagerLoginScreenModel(context);
    mWarehouseManagerLoginScreenModel.setWarehouseManagerLoginScreenBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildWarehouseManagerLoginScreenView());
  }

  _buildWarehouseManagerLoginScreenView() {
    return MultiBlocListener(child: warehouseManagerLoginScreenView(), listeners: [
      BlocListener<WarehouseManagerLoginScreenBloc, WarehouseManagerLoginScreenState>(
        bloc: mWarehouseManagerLoginScreenModel.getWarehouseManagerLoginScreenBloc(),
        listener: (context, state) {
          mWarehouseManagerLoginScreenModel.blocWarehouseManagerLoginScreenListener(
              context, state);
        },
      ),
    ]);
  }

  warehouseManagerLoginScreenView() {
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
                  padding: EdgeInsets.only(left: SizeConstants.s1*30,right: SizeConstants.s1*30),
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
                        mWarehouseManagerLoginScreenModel.mUserNameTextEditingController,
                        labelText: AppConstants.cWordConstants.wUsernameText,
                        hintText: AppConstants.cWordConstants.wPleaseEnterUsernameText,
                      ),
                      SizedBox(
                        height: SizeConstants.s1 * 15,
                      ),
                      editTextFiled(
                          mWarehouseManagerLoginScreenModel.mPasswordTextEditingController,
                          labelText: AppConstants.cWordConstants.wPasswordText,
                          hintText: AppConstants.cWordConstants.wPleaseEnterPasswordText,
                          obscureText: true
                      ),
                      SizedBox(
                        height: SizeConstants.s1 * 20,
                      ),
                      mediumRoundedCornerButton(
                        appbarActionInterface: (value) {
                          mWarehouseManagerLoginScreenModel.fetchWarehouseManagerLoginScreenUrl();
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
