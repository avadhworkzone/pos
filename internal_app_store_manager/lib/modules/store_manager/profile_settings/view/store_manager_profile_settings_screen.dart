import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_app_store_manager/constants/image_assets_constants.dart';
import 'package:internal_app_store_manager/modules/common/custom_navigation_drawer/custom_navigation_drawer_screen.dart';
import 'package:internal_app_store_manager/modules/store_manager/profile_settings/model/store_manager_profile_settings_model.dart';
import 'package:internal_base/common/app_constants.dart';
import 'package:internal_base/common/appbars_constants.dart';
import 'package:internal_base/common/button_constants.dart';
import 'package:internal_base/common/call_back.dart';
import 'package:internal_base/common/color_constants.dart';
import 'package:internal_base/common/size_constants.dart';
import 'package:internal_base/common/widget/edit_text_field.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_profile_details/bloc/store_manager_profile_details_bloc.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_profile_details/bloc/store_manager_profile_details_state.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_profile_details/repo/store_manager_profile_details_response.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_profile_update/bloc/store_manager_profile_update_bloc.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_profile_update/bloc/store_manager_profile_update_state.dart';

class StoreManagerProfileSettingsScreenWidget extends StatefulWidget {
  final CallbackModel mCallbackModel;

  const StoreManagerProfileSettingsScreenWidget(
      {super.key, required this.mCallbackModel});

  @override
  State<StoreManagerProfileSettingsScreenWidget> createState() =>
      _StoreManagerProfileSettingsScreenWidgetState();
}

class _StoreManagerProfileSettingsScreenWidgetState
    extends State<StoreManagerProfileSettingsScreenWidget> {
  late StoreManagerProfileSettingsScreenModel
      mStoreManagerProfileSettingsScreenModel;
  bool fieldValidation = false;
  bool isTestFieldInit = false;

  @override
  void initState() {
    mStoreManagerProfileSettingsScreenModel =
        StoreManagerProfileSettingsScreenModel(context, widget.mCallbackModel);
    mStoreManagerProfileSettingsScreenModel
        .setPostStoreManagerProfileUpdateBloc();
    mStoreManagerProfileSettingsScreenModel.setStoreManagerProfileDetailsBloc();
    mStoreManagerProfileSettingsScreenModel
        .fetchGetStoreManagerProfileDetailsUrl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            key: mStoreManagerProfileSettingsScreenModel.scaffoldKey,
            appBar: AppBars.appBar((value) {
              if (value == "Menu") {
                mStoreManagerProfileSettingsScreenModel
                    .scaffoldKey.currentState!
                    .openDrawer();
              }
            }, AppConstants.cWordConstants.wProfileSettingsText,
                sMenu: AppConstants.cWordConstants.wMenuText),
            drawer: CustomNavigationDrawer(
                mCallbackModel:
                    mStoreManagerProfileSettingsScreenModel.mCallbackModel),
            body: _buildProfileWidgetView()));
  }

  _buildProfileWidgetView() {
    return FocusDetector(
        child: SafeArea(
            child:
                MultiBlocListener(child: _profileStreamBuilder(), listeners: [
      BlocListener<GetStoreManagerProfileDetailsBloc,
          GetStoreManagerProfileDetailsState>(
        bloc: mStoreManagerProfileSettingsScreenModel
            .getStoreManagerProfileDetailsBloc(),
        listener: (context, state) {
          mStoreManagerProfileSettingsScreenModel
              .blocGetStoreManagerProfileDetailsListener(context, state);
        },
      ),
      BlocListener<PostStoreManagerProfileUpdateBloc,
          PostStoreManagerProfileUpdateState>(
        bloc: mStoreManagerProfileSettingsScreenModel
            .getPostStoreManagerProfileUpdateBloc(),
        listener: (context, state) {
          mStoreManagerProfileSettingsScreenModel
              .blocPostStoreManagerProfileUpdateListener(context, state);
        },
      ),
    ])));
  }

  _profileStreamBuilder() {
    return StreamBuilder<StoreManagerDetails?>(
      stream:
          mStoreManagerProfileSettingsScreenModel.responseSubjectProfileDetails,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          // if (!snapshot.hasData) {
          StoreManagerDetails mStoreManagerDetails =
              snapshot.data as StoreManagerDetails;

          if (!isTestFieldInit) {
            isTestFieldInit = true;

            if (mStoreManagerProfileSettingsScreenModel
                .mUsernameTextEditingController.text.isEmpty) {
              mStoreManagerProfileSettingsScreenModel
                  .mUsernameTextEditingController
                  .text = mStoreManagerDetails.username ?? "";
            }

            if (mStoreManagerProfileSettingsScreenModel
                .mFirstNameTextEditingController.text.isEmpty) {
              mStoreManagerProfileSettingsScreenModel
                  .mFirstNameTextEditingController
                  .text = mStoreManagerDetails.firstName ?? "";
            }

            if (mStoreManagerProfileSettingsScreenModel
                .mEmailIdTextEditingController.text.isEmpty) {
              mStoreManagerProfileSettingsScreenModel
                  .mEmailIdTextEditingController
                  .text = mStoreManagerDetails.email ?? "";
            }

            if (mStoreManagerProfileSettingsScreenModel
                .mPhoneNumberTextEditingController.text.isEmpty) {
              mStoreManagerProfileSettingsScreenModel
                  .mPhoneNumberTextEditingController
                  .text = mStoreManagerDetails.mobileNumber ?? "";
            }

            if (mStoreManagerProfileSettingsScreenModel
                .mStaffIdTextEditingController.text.isEmpty) {
              mStoreManagerProfileSettingsScreenModel
                  .mStaffIdTextEditingController
                  .text = (mStoreManagerDetails.username ?? "").toString();
            }

            if (mStoreManagerProfileSettingsScreenModel
                .mAddressLine1TextEditingController.text.isEmpty) {
              mStoreManagerProfileSettingsScreenModel
                  .mAddressLine1TextEditingController
                  .text = mStoreManagerDetails.addressLine1 ?? "";
            }

            if (mStoreManagerProfileSettingsScreenModel
                .mAddressLine2TextEditingController.text.isEmpty) {
              mStoreManagerProfileSettingsScreenModel
                  .mAddressLine2TextEditingController
                  .text = mStoreManagerDetails.addressLine2 ?? "";
            }

            if (mStoreManagerProfileSettingsScreenModel
                .mCityTextEditingController.text.isEmpty) {
              mStoreManagerProfileSettingsScreenModel.mCityTextEditingController
                  .text = mStoreManagerDetails.city ?? "";
            }

            if (mStoreManagerProfileSettingsScreenModel
                .mAreaCodeTextEditingController.text.isEmpty) {
              mStoreManagerProfileSettingsScreenModel
                  .mAreaCodeTextEditingController
                  .text = mStoreManagerDetails.areaCode ?? "";
            }

            if (mStoreManagerProfileSettingsScreenModel
                .mPrimaryContactNameTextEditingController.text.isEmpty) {
              mStoreManagerProfileSettingsScreenModel
                  .mPrimaryContactNameTextEditingController
                  .text = mStoreManagerDetails.primaryContactName ?? "";
            }

            if (mStoreManagerProfileSettingsScreenModel
                .mPrimaryContactNumberTextEditingController.text.isEmpty) {
              mStoreManagerProfileSettingsScreenModel
                  .mPrimaryContactNumberTextEditingController
                  .text = mStoreManagerDetails.primaryContactPhone ?? "";
            }
          }

          // }
          // mStoreManagerProfileSettingsScreenModel
          //     .mDateofJoiningTextEditingController
          //     .text = "---";

          // mStoreManagerProfileSettingsScreenModel.mICNumberTextEditingController
          //     .text = "---";

          return _profileView();
        }

        return const SizedBox();
      },
    );
  }

  _profileView() {
    return Listener(
      onPointerDown: (PointerDownEvent event) =>
          FocusManager.instance.primaryFocus?.unfocus(),
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
                      mStoreManagerProfileSettingsScreenModel
                          .mFirstNameTextEditingController,
                      labelText: AppConstants.cWordConstants.wFirstNameText,
                      hintText:
                          AppConstants.cWordConstants.wPleaseEnterFirstNameText,
                      cursorColor: Colors.black,
                      labelColor: Colors.grey,
                      mandatoryField: true,
                      validate: (mStoreManagerProfileSettingsScreenModel
                              .mFirstNameTextEditingController.text.isEmpty)
                          ? fieldValidation
                          : false,
                    ),

                    SizedBox(
                      height: SizeConstants.s1 * 15,
                    ),

                    ///EmailId
                    editTextFiled(
                      mStoreManagerProfileSettingsScreenModel
                          .mEmailIdTextEditingController,
                      // () {},
                      labelText: AppConstants.cWordConstants.wEmailIdText,
                      hintText:
                          AppConstants.cWordConstants.wPleaseEnterEmailIdText,
                      cursorColor: Colors.black,
                      labelColor: Colors.grey,
                      mandatoryField: true,
                      textInputType: TextInputType.emailAddress,
                      validate: (mStoreManagerProfileSettingsScreenModel
                              .mEmailIdTextEditingController.text.isEmpty)
                          ? fieldValidation
                          : false,
                    ),

                    SizedBox(
                      height: SizeConstants.s1 * 15,
                    ),

                    ///PhoneNumber
                    editTextFiled(
                      mStoreManagerProfileSettingsScreenModel
                          .mPhoneNumberTextEditingController,
                      // () {},
                      labelText: AppConstants.cWordConstants.wPhoneNumberText,
                      hintText: AppConstants
                          .cWordConstants.wPleaseEnterPhoneNumberText,
                      cursorColor: Colors.black,
                      labelColor: Colors.grey,
                      textInputType: TextInputType.number,
                      mandatoryField: true,
                      validate: (mStoreManagerProfileSettingsScreenModel
                              .mPhoneNumberTextEditingController.text.isEmpty)
                          ? fieldValidation
                          : false,
                    ),

                    SizedBox(
                      height: SizeConstants.s1 * 15,
                    ),

                    // ///StaffId
                    // editTextFiled(
                    //   mStoreManagerProfileSettingsScreenModel
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
                      mStoreManagerProfileSettingsScreenModel
                          .mAddressLine1TextEditingController,
                      // () {},
                      labelText: AppConstants.cWordConstants.wAddressLine1Text,
                      hintText: AppConstants
                          .cWordConstants.wPleaseEnterAddressLine1Text,
                      cursorColor: Colors.black,
                      labelColor: Colors.grey,
                      mandatoryField: true,
                      validate: (mStoreManagerProfileSettingsScreenModel
                              .mAddressLine1TextEditingController.text.isEmpty)
                          ? fieldValidation
                          : false,
                    ),

                    SizedBox(
                      height: SizeConstants.s1 * 15,
                    ),

                    ///AddressLine2
                    editTextFiled(
                      mStoreManagerProfileSettingsScreenModel
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
                          mStoreManagerProfileSettingsScreenModel
                              .mCityTextEditingController,
                          // () {},
                          labelText: AppConstants.cWordConstants.wCityText,
                          mandatoryField: true,
                          hintText:
                              AppConstants.cWordConstants.wPleaseEnterCityText,
                          cursorColor: Colors.black,
                          labelColor: Colors.grey,
                          validate: (mStoreManagerProfileSettingsScreenModel
                                  .mCityTextEditingController.text.isEmpty)
                              ? fieldValidation
                              : false,
                        )),

                        SizedBox(
                          width: SizeConstants.s1 * 10,
                        ),

                        ///AreaCode
                        Expanded(
                          child: editTextFiled(
                            mStoreManagerProfileSettingsScreenModel
                                .mAreaCodeTextEditingController,
                            mandatoryField: true,
                            // () {},
                            labelText:
                                AppConstants.cWordConstants.wAreaCodeText,
                            hintText: AppConstants
                                .cWordConstants.wPleaseEnterAreaCodeText,
                            cursorColor: Colors.black,
                            labelColor: Colors.grey,
                            validate: (mStoreManagerProfileSettingsScreenModel
                                    .mAreaCodeTextEditingController
                                    .text
                                    .isEmpty)
                                ? fieldValidation
                                : false,
                          ),
                        )
                      ],
                    ),

                    SizedBox(
                      height: SizeConstants.s1 * 15,
                    ),

                    // ///DateofJoining
                    // editTextFiled(
                    //   mStoreManagerProfileSettingsScreenModel
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
                      mStoreManagerProfileSettingsScreenModel
                          .mPrimaryContactNameTextEditingController,
                      mandatoryField: true,
                      // () {},
                      labelText:
                          AppConstants.cWordConstants.wPrimaryContactNameText,
                      hintText: AppConstants
                          .cWordConstants.wPleaseEnterPrimaryContactNameText,
                      cursorColor: Colors.black,
                      labelColor: Colors.grey,
                      validate: (mStoreManagerProfileSettingsScreenModel
                              .mPrimaryContactNameTextEditingController
                              .text
                              .isEmpty)
                          ? fieldValidation
                          : false,
                    ),
                    SizedBox(
                      height: SizeConstants.s1 * 15,
                    ),

                    ///PrimaryContactNumber
                    editTextFiled(
                      mStoreManagerProfileSettingsScreenModel
                          .mPrimaryContactNumberTextEditingController,
                      mandatoryField: true,
                      // () {},
                      labelText:
                          AppConstants.cWordConstants.wPrimaryContactNumberText,
                      hintText: AppConstants
                          .cWordConstants.wPleaseEnterPrimaryContactNumberText,
                      cursorColor: Colors.black,
                      labelColor: Colors.grey,
                      textInputType: TextInputType.number,
                      validate: (mStoreManagerProfileSettingsScreenModel
                              .mPrimaryContactNumberTextEditingController
                              .text
                              .isEmpty)
                          ? fieldValidation
                          : false,
                    ),
                    SizedBox(
                      height: SizeConstants.s1 * 15,
                    ),

                    // ///ICNumber
                    // editTextFiled(
                    //   mStoreManagerProfileSettingsScreenModel
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
                        if (mStoreManagerProfileSettingsScreenModel.mFirstNameTextEditingController.text.isNotEmpty &&
                            mStoreManagerProfileSettingsScreenModel
                                .mAddressLine1TextEditingController
                                .text
                                .isNotEmpty &&
                            mStoreManagerProfileSettingsScreenModel
                                .mPhoneNumberTextEditingController
                                .text
                                .isNotEmpty &&
                            mStoreManagerProfileSettingsScreenModel
                                .mEmailIdTextEditingController
                                .text
                                .isNotEmpty &&
                            mStoreManagerProfileSettingsScreenModel
                                .mCityTextEditingController.text.isNotEmpty &&
                            mStoreManagerProfileSettingsScreenModel
                                .mAreaCodeTextEditingController
                                .text
                                .isNotEmpty &&
                            mStoreManagerProfileSettingsScreenModel
                                .mPrimaryContactNameTextEditingController
                                .text
                                .isNotEmpty &&
                            mStoreManagerProfileSettingsScreenModel
                                .mPrimaryContactNumberTextEditingController
                                .text
                                .isNotEmpty) {
                          mStoreManagerProfileSettingsScreenModel
                              .fetchPostStoreManagerProfileUpdateUrl();
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
                      sButtonTitle:
                          AppConstants.cWordConstants.wSaveChangesText,
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
