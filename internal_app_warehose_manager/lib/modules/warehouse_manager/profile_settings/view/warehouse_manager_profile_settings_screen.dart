import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:internal_app_warehose_manager/constants/image_assets_constants.dart';
import 'package:internal_app_warehose_manager/modules/common/custom_navigation_drawer/custom_navigation_drawer_screen.dart';
import 'package:internal_app_warehose_manager/modules/warehouse_manager/profile_settings/model/warehouse_manager_profile_settings_model.dart';
import 'package:internal_base/common/app_constants.dart';
import 'package:internal_base/common/appbars_constants.dart';
import 'package:internal_base/common/button_constants.dart';
import 'package:internal_base/common/call_back.dart';
import 'package:internal_base/common/color_constants.dart';
import 'package:internal_base/common/size_constants.dart';
import 'package:internal_base/common/widget/edit_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_profile_details/bloc/warehouse_manager_profile_details_bloc.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_profile_details/bloc/warehouse_manager_profile_details_state.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_profile_details/repo/warehouse_manager_profile_details_response.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_profile_update/bloc/warehouse_manager_profile_update_bloc.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_profile_update/bloc/warehouse_manager_profile_update_state.dart';

class WarehouseManagerProfileSettingsScreenWidget extends StatefulWidget {
  final CallbackModel mCallbackModel;

  const WarehouseManagerProfileSettingsScreenWidget(
      {super.key, required this.mCallbackModel});

  @override
  State<WarehouseManagerProfileSettingsScreenWidget> createState() =>
      _WarehouseManagerProfileSettingsScreenWidgetState();
}

class _WarehouseManagerProfileSettingsScreenWidgetState
    extends State<WarehouseManagerProfileSettingsScreenWidget> {
  late WarehouseManagerProfileSettingsScreenModel
      mWarehouseManagerProfileSettingsScreenModel;
  bool fieldValidation = false;

  @override
  void initState() {
    mWarehouseManagerProfileSettingsScreenModel =
        WarehouseManagerProfileSettingsScreenModel(
            context, widget.mCallbackModel);
    mWarehouseManagerProfileSettingsScreenModel
        .setPostWarehouseManagerProfileUpdateBloc();
    mWarehouseManagerProfileSettingsScreenModel
        .setWarehouseManagerProfileDetailsBloc();
    mWarehouseManagerProfileSettingsScreenModel
        .fetchGetWarehouseManagerProfileDetailsUrl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            key: mWarehouseManagerProfileSettingsScreenModel.scaffoldKey,
            appBar: AppBars.appBar((value) {
              if (value == "Menu") {
                mWarehouseManagerProfileSettingsScreenModel
                    .scaffoldKey.currentState!
                    .openDrawer();
              }
            }, AppConstants.cWordConstants.wProfileSettingsText,
                sMenu: AppConstants.cWordConstants.wMenuText),
            drawer: CustomNavigationDrawer(
                mCallbackModel:
                    mWarehouseManagerProfileSettingsScreenModel.mCallbackModel),
            body: _buildProfileWidgetView()));
  }

  _buildProfileWidgetView() {
    return FocusDetector(
        child: SafeArea(
            child:
                MultiBlocListener(child: _profileStreamBuilder(), listeners: [
      BlocListener<GetWarehouseManagerProfileDetailsBloc,
          GetWarehouseManagerProfileDetailsState>(
        bloc: mWarehouseManagerProfileSettingsScreenModel
            .getWarehouseManagerProfileDetailsBloc(),
        listener: (context, state) {
          mWarehouseManagerProfileSettingsScreenModel
              .blocGetWarehouseManagerProfileDetailsListener(context, state);
        },
      ),
      BlocListener<PostWarehouseManagerProfileUpdateBloc,
          PostWarehouseManagerProfileUpdateState>(
        bloc: mWarehouseManagerProfileSettingsScreenModel
            .getPostWarehouseManagerProfileUpdateBloc(),
        listener: (context, state) {
          mWarehouseManagerProfileSettingsScreenModel
              .blocPostWarehouseManagerProfileUpdateListener(context, state);
        },
      ),
    ])));
  }

  _profileStreamBuilder() {
    return StreamBuilder<WarehouseManagerDetails?>(
      stream: mWarehouseManagerProfileSettingsScreenModel
          .responseSubjectProfileDetails,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          WarehouseManagerDetails mWarehouseManagerDetails =
              snapshot.data as WarehouseManagerDetails;

          mWarehouseManagerProfileSettingsScreenModel
              .mUsernameTextEditingController
              .text = mWarehouseManagerDetails.username ?? "";

          mWarehouseManagerProfileSettingsScreenModel
              .mFirstNameTextEditingController
              .text = mWarehouseManagerDetails.firstName ?? "";

          mWarehouseManagerProfileSettingsScreenModel
              .mEmailIdTextEditingController
              .text = mWarehouseManagerDetails.email ?? "";

          mWarehouseManagerProfileSettingsScreenModel
              .mPhoneNumberTextEditingController
              .text = mWarehouseManagerDetails.mobileNumber ?? "";

          // mWarehouseManagerProfileSettingsScreenModel
          //     .mStaffIdTextEditingController
          //     .text = (mWarehouseManagerDetails.username ?? "").toString();

          mWarehouseManagerProfileSettingsScreenModel
              .mAddressLine1TextEditingController
              .text = mWarehouseManagerDetails.addressLine1 ?? "";

          mWarehouseManagerProfileSettingsScreenModel
              .mAddressLine2TextEditingController
              .text = mWarehouseManagerDetails.addressLine2 ?? "";

          mWarehouseManagerProfileSettingsScreenModel.mCityTextEditingController
              .text = mWarehouseManagerDetails.city ?? "";

          mWarehouseManagerProfileSettingsScreenModel
              .mAreaCodeTextEditingController
              .text = mWarehouseManagerDetails.areaCode ?? "";

          // mWarehouseManagerProfileSettingsScreenModel
          //     .mDateofJoiningTextEditingController
          //     .text = "---";

          mWarehouseManagerProfileSettingsScreenModel
              .mPrimaryContactNameTextEditingController
              .text = mWarehouseManagerDetails.primaryContactName ?? "";

          mWarehouseManagerProfileSettingsScreenModel
              .mPrimaryContactNumberTextEditingController
              .text = mWarehouseManagerDetails.primaryContactPhone ?? "";

          // mWarehouseManagerProfileSettingsScreenModel.mICNumberTextEditingController
          //     .text = "---";
          return _profileView();
        }

        return const SizedBox();
      },
    );
  }

  _profileView() {
    return Listener(
      onPointerDown: (PointerDownEvent event) => FocusManager.instance.primaryFocus?.unfocus(),
      child: Stack(
        children: [
          Container(
              height: SizeConstants.height,
              width: SizeConstants.width,
              margin: EdgeInsets.only(top: SizeConstants.s1 * 55),
              padding: EdgeInsets.only(
                  top: SizeConstants.s1 * 70,
                  left: SizeConstants.s1 * 15,
                  right: SizeConstants.s1 * 15),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(SizeConstants.s1 * 20),
                    topLeft: Radius.circular(SizeConstants.s1 * 20),
                  )),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    ///Username
                    editTextFiled(
                      mWarehouseManagerProfileSettingsScreenModel
                          .mFirstNameTextEditingController,
                      // () {},
                      labelText: AppConstants.cWordConstants.wFirstNameText,
                      hintText:
                          AppConstants.cWordConstants.wPleaseEnterFirstNameText,
                      cursorColor: Colors.black,
                      labelColor: Colors.grey,
                      mandatoryField: true,
                      validate: (mWarehouseManagerProfileSettingsScreenModel.mFirstNameTextEditingController.text.isEmpty) ? fieldValidation : false,
                    ),
                    SizedBox(
                      height: SizeConstants.s1 * 15,
                    ),

                    ///EmailId
                    editTextFiled(
                      mWarehouseManagerProfileSettingsScreenModel
                          .mEmailIdTextEditingController,
                      // () {},
                      labelText: AppConstants.cWordConstants.wEmailIdText,
                      hintText:
                          AppConstants.cWordConstants.wPleaseEnterEmailIdText,
                      cursorColor: Colors.black,
                      labelColor: Colors.grey,
                      textInputType: TextInputType.emailAddress
                    ),
                    SizedBox(
                      height: SizeConstants.s1 * 15,
                    ),

                    ///PhoneNumber
                    editTextFiled(
                      mWarehouseManagerProfileSettingsScreenModel
                          .mPhoneNumberTextEditingController,
                      // () {},
                      labelText: AppConstants.cWordConstants.wPhoneNumberText,
                      hintText:
                          AppConstants.cWordConstants.wPleaseEnterPhoneNumberText,
                      cursorColor: Colors.black,
                      labelColor: Colors.grey,
                      textInputType: TextInputType.number,
                      mandatoryField: true,
                      validate: (mWarehouseManagerProfileSettingsScreenModel.mPhoneNumberTextEditingController.text.isEmpty) ? fieldValidation : false,
                    ),
                    SizedBox(
                      height: SizeConstants.s1 * 15,
                    ),

                    // ///StaffId
                    // editTextFiled(
                    //   mWarehouseManagerProfileSettingsScreenModel
                    //       .mStaffIdTextEditingController,
                    //   // () {},
                    //   labelText: AppConstants.cWordConstants.wUsernameText,
                    //   hintText:
                    //   AppConstants.cWordConstants.wPleaseEnterUsernameText,
                    //   cursorColor: Colors.black,
                    //   labelColor: Colors.grey,
                    // ),
                    // SizedBox(
                    //   height: SizeConstants.s1 * 15,
                    // ),

                    ///AddressLine1
                    editTextFiled(
                      mWarehouseManagerProfileSettingsScreenModel
                          .mAddressLine1TextEditingController,
                      // () {},
                      labelText: AppConstants.cWordConstants.wAddressLine1Text,
                      hintText: AppConstants
                          .cWordConstants.wPleaseEnterAddressLine1Text,
                      cursorColor: Colors.black,
                      labelColor: Colors.grey,
                      mandatoryField: true,
                      validate: (mWarehouseManagerProfileSettingsScreenModel.mAddressLine1TextEditingController.text.isEmpty) ? fieldValidation : false,
                    ),
                    SizedBox(
                      height: SizeConstants.s1 * 15,
                    ),

                    ///AddressLine2
                    editTextFiled(
                      mWarehouseManagerProfileSettingsScreenModel
                          .mAddressLine2TextEditingController,
                      // () {},
                      labelText: AppConstants.cWordConstants.wAddressLine2Text,
                      hintText: AppConstants
                          .cWordConstants.wPleaseEnterAddressLine2Text,
                      cursorColor: Colors.black,
                      labelColor: Colors.grey,
                    ),
                    SizedBox(
                      height: SizeConstants.s1 * 15,
                    ),

                    Row(
                      children: [
                        ///City
                        Expanded(
                            child: editTextFiled(
                          mWarehouseManagerProfileSettingsScreenModel
                              .mCityTextEditingController,
                          // () {},
                          labelText: AppConstants.cWordConstants.wCityText,
                          hintText:
                              AppConstants.cWordConstants.wPleaseEnterCityText,
                          cursorColor: Colors.black,
                          labelColor: Colors.grey,
                        )),
                        SizedBox(
                          width: SizeConstants.s1 * 10,
                        ),

                        ///AreaCode
                        Expanded(
                          child: editTextFiled(
                            mWarehouseManagerProfileSettingsScreenModel
                                .mAreaCodeTextEditingController,
                            // () {},
                            labelText: AppConstants.cWordConstants.wAreaCodeText,
                            hintText: AppConstants
                                .cWordConstants.wPleaseEnterAreaCodeText,
                            cursorColor: Colors.black,
                            labelColor: Colors.grey,
                          ),
                        )
                      ],
                    ),

                    SizedBox(
                      height: SizeConstants.s1 * 15,
                    ),

                    // ///DateofJoining
                    // editTextFiled(
                    //   mWarehouseManagerProfileSettingsScreenModel
                    //       .mDateofJoiningTextEditingController,
                    //   // () {},
                    //   labelText: AppConstants.cWordConstants.wDateofJoiningText,
                    //   hintText: AppConstants
                    //       .cWordConstants.wPleaseEnterDateofJoiningText,
                    //   cursorColor: Colors.black,
                    //   labelColor: Colors.grey,
                    // ),
                    // SizedBox(
                    //   height: SizeConstants.s1 * 15,
                    // ),

                    ///PrimaryContactName
                    editTextFiled(
                      mWarehouseManagerProfileSettingsScreenModel
                          .mPrimaryContactNameTextEditingController,
                      // () {},
                      labelText:
                          AppConstants.cWordConstants.wPrimaryContactNameText,
                      hintText: AppConstants
                          .cWordConstants.wPleaseEnterPrimaryContactNameText,
                      cursorColor: Colors.black,
                      labelColor: Colors.grey,
                    ),
                    SizedBox(
                      height: SizeConstants.s1 * 15,
                    ),

                    ///PrimaryContactNumber
                    editTextFiled(
                      mWarehouseManagerProfileSettingsScreenModel
                          .mPrimaryContactNumberTextEditingController,
                      // () {},
                      labelText:
                          AppConstants.cWordConstants.wPrimaryContactNumberText,
                      hintText: AppConstants
                          .cWordConstants.wPleaseEnterPrimaryContactNumberText,
                      cursorColor: Colors.black,
                      labelColor: Colors.grey,
                      textInputType: TextInputType.number
                    ),
                    SizedBox(
                      height: SizeConstants.s1 * 15,
                    ),

                    // ///ICNumber
                    // editTextFiled(
                    //   mWarehouseManagerProfileSettingsScreenModel
                    //       .mICNumberTextEditingController,
                    //   // () {},
                    //   labelText: AppConstants.cWordConstants.wICNumberText,
                    //   hintText:
                    //       AppConstants.cWordConstants.wPleaseEnterICNumberText,
                    //   cursorColor: Colors.black,
                    //   labelColor: Colors.grey,
                    // ),
                    // SizedBox(
                    //   height: SizeConstants.s1 * 15,
                    // ),

                    ///Save Changes
                    mediumRoundedCornerButton(
                      appbarActionInterface: (value) {
                        if (mWarehouseManagerProfileSettingsScreenModel
                            .mFirstNameTextEditingController.text.isNotEmpty && mWarehouseManagerProfileSettingsScreenModel
                            .mAddressLine1TextEditingController.text.isNotEmpty && mWarehouseManagerProfileSettingsScreenModel
                            .mPhoneNumberTextEditingController.text.isNotEmpty) {
                          mWarehouseManagerProfileSettingsScreenModel
                              .fetchPostWarehouseManagerProfileUpdateUrl();
                          FocusScope.of(context).requestFocus(FocusNode());
                          setState(() {
                            fieldValidation = false;
                          });
                        } else {
                          setState(() {
                            fieldValidation = true;
                          });
                        }

                      },
                      sButtonTitle: AppConstants.cWordConstants.wSaveChangesText,
                      dButtonWidth: SizeConstants.s1 * 220,
                      cButtonTextColor: Colors.white,
                      cButtonBackGroundColor: ColorConstants.kPrimaryColor,
                      dButtonTextSize: SizeConstants.s1 * 15,
                    ),
                    SizedBox(
                      height: SizeConstants.s1 * 15,
                    ),
                  ],
                ),
              )),

          ///profile Image
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: SizeConstants.s1 * 110,
              width: SizeConstants.s1 * 110,
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(SizeConstants.s1 * 10),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset:
                              const Offset(0, 1), // changes position of shadow
                        ),
                      ],
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      ImageAssetsConstants.imageAppBarLogo,
                    ),
                  ),
                  // Align(
                  //   alignment: Alignment.bottomRight,
                  //   child: Container(
                  //     height: SizeConstants.s1 * 32,
                  //     width: SizeConstants.s1 * 32,
                  //     decoration: const BoxDecoration(
                  //       color: Colors.white,
                  //       shape: BoxShape.circle,
                  //     ),
                  //     child: Image.asset(
                  //       ImageAssetsConstants.profileEdit,
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
