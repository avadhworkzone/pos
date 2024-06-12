import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:internal_app_promoter/constants/image_assets_constants.dart';
import 'package:internal_app_promoter/modules/common/custom_navigation_drawer/custom_navigation_drawer_screen.dart';
import 'package:internal_app_promoter/modules/promoter/profile_settings/model/promoter_profile_settings_model.dart';
import 'package:internal_base/common/app_constants.dart';
import 'package:internal_base/common/appbars_constants.dart';
import 'package:internal_base/common/button_constants.dart';
import 'package:internal_base/common/call_back.dart';
import 'package:internal_base/common/color_constants.dart';
import 'package:internal_base/common/size_constants.dart';
import 'package:internal_base/common/widget/edit_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_profile_details/bloc/get_promoter_profile_details_bloc.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_profile_details/bloc/get_promoter_profile_details_state.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_profile_details/repo/get_promoter_profile_details_response.dart';
import 'package:internal_base/data/all_bloc/promoter/post_promoter_profile_update/bloc/post_promoter_profile_update_bloc.dart';
import 'package:internal_base/data/all_bloc/promoter/post_promoter_profile_update/bloc/post_promoter_profile_update_state.dart';

class PromoterProfileSettingsScreenWidget extends StatefulWidget {
  final CallbackModel mCallbackModel;

  const PromoterProfileSettingsScreenWidget(
      {super.key, required this.mCallbackModel});

  @override
  State<PromoterProfileSettingsScreenWidget> createState() =>
      _PromoterProfileSettingsScreenWidgetState();
}

class _PromoterProfileSettingsScreenWidgetState
    extends State<PromoterProfileSettingsScreenWidget> {
  late PromoterProfileSettingsScreenModel mPromoterProfileSettingsScreenModel;
  bool fieldValidation = false;

  @override
  void initState() {
    mPromoterProfileSettingsScreenModel =
        PromoterProfileSettingsScreenModel(context, widget.mCallbackModel);
    mPromoterProfileSettingsScreenModel.setPostPromoterProfileUpdateBloc();
    mPromoterProfileSettingsScreenModel.setPromoteProfileDetailsBloc();
    mPromoterProfileSettingsScreenModel.fetchGetPromoteProfileDetailsUrl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            key: mPromoterProfileSettingsScreenModel.scaffoldKey,
            appBar: AppBars.appBar((value) {
              if (value == "Menu") {
                mPromoterProfileSettingsScreenModel.scaffoldKey.currentState!
                    .openDrawer();
              }
            }, AppConstants.cWordConstants.wProfileSettingsText,
                sMenu: AppConstants.cWordConstants.wMenuText),
            drawer: CustomNavigationDrawer(
                mCallbackModel:
                    mPromoterProfileSettingsScreenModel.mCallbackModel),
            body: _buildProfileWidgetView()));
  }

  _buildProfileWidgetView() {
    return FocusDetector(
        child: SafeArea(
            child:
                MultiBlocListener(child: _profileStreamBuilder(), listeners: [
      BlocListener<GetPromoteProfileDetailsBloc, GetPromoteProfileDetailsState>(
        bloc:
            mPromoterProfileSettingsScreenModel.getPromoteProfileDetailsBloc(),
        listener: (context, state) {
          mPromoterProfileSettingsScreenModel
              .blocGetPromoteProfileDetailsListener(context, state);
        },
      ),
      BlocListener<PostPromoterProfileUpdateBloc,
          PostPromoterProfileUpdateState>(
        bloc: mPromoterProfileSettingsScreenModel
            .getPostPromoterProfileUpdateBloc(),
        listener: (context, state) {
          mPromoterProfileSettingsScreenModel
              .blocPostPromoterProfileUpdateListener(context, state);
        },
      ),
    ])));
  }

  _profileStreamBuilder() {
    return StreamBuilder<PromoterDetails?>(
      stream: mPromoterProfileSettingsScreenModel.responseSubjectProfileDetails,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          PromoterDetails mPromoterDetails = snapshot.data as PromoterDetails;

          mPromoterProfileSettingsScreenModel.mUsernameTextEditingController
              .text = mPromoterDetails.username ?? "";

          mPromoterProfileSettingsScreenModel.mFirstNameTextEditingController
              .text = mPromoterDetails.firstName ?? "";

          mPromoterProfileSettingsScreenModel.mEmailIdTextEditingController
              .text = mPromoterDetails.email ?? "";

          mPromoterProfileSettingsScreenModel.mPhoneNumberTextEditingController
              .text = mPromoterDetails.mobileNumber ?? "";

          // mPromoterProfileSettingsScreenModel.mStaffIdTextEditingController
          //     .text = (mPromoterDetails.username ?? "").toString();

          mPromoterProfileSettingsScreenModel.mAddressLine1TextEditingController
              .text = mPromoterDetails.addressLine1 ?? "";

          mPromoterProfileSettingsScreenModel.mAddressLine2TextEditingController
              .text = mPromoterDetails.addressLine2 ?? "";

          mPromoterProfileSettingsScreenModel.mCityTextEditingController.text =
              mPromoterDetails.city ?? "";

          mPromoterProfileSettingsScreenModel.mAreaCodeTextEditingController
              .text = mPromoterDetails.areaCode ?? "";

          // mPromoterProfileSettingsScreenModel
          //     .mDateofJoiningTextEditingController
          //     .text = "---";

          mPromoterProfileSettingsScreenModel
              .mPrimaryContactNameTextEditingController
              .text = mPromoterDetails.primaryContactName ?? "";

          mPromoterProfileSettingsScreenModel
              .mPrimaryContactNumberTextEditingController
              .text = mPromoterDetails.primaryContactPhone ?? "";

          // mPromoterProfileSettingsScreenModel.mICNumberTextEditingController
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
                      mPromoterProfileSettingsScreenModel
                          .mFirstNameTextEditingController,
                      // () {},
                      labelText: AppConstants.cWordConstants.wFirstNameText,
                      hintText:
                          AppConstants.cWordConstants.wPleaseEnterFirstNameText,
                      cursorColor: Colors.black,
                      labelColor: Colors.grey,
                      mandatoryField: true,
                      validate: (mPromoterProfileSettingsScreenModel
                              .mFirstNameTextEditingController.text.isEmpty)
                          ? fieldValidation
                          : false,
                    ),

                    SizedBox(
                      height: SizeConstants.s1 * 15,
                    ),

                    ///EmailId
                    editTextFiled(
                      mPromoterProfileSettingsScreenModel
                          .mEmailIdTextEditingController,
                      // () {},
                      labelText: AppConstants.cWordConstants.wEmailIdText,
                      hintText:
                          AppConstants.cWordConstants.wPleaseEnterEmailIdText,
                      cursorColor: Colors.black,
                      textInputType: TextInputType.emailAddress,
                      labelColor: Colors.grey,
                    ),

                    SizedBox(
                      height: SizeConstants.s1 * 15,
                    ),

                    ///PhoneNumber
                    editTextFiled(
                      mPromoterProfileSettingsScreenModel
                          .mPhoneNumberTextEditingController,
                      // () {},
                      labelText: AppConstants.cWordConstants.wPhoneNumberText,
                      hintText: AppConstants
                          .cWordConstants.wPleaseEnterPhoneNumberText,
                      cursorColor: Colors.black,
                      labelColor: Colors.grey,
                      textInputType: TextInputType.number,
                      mandatoryField: true,
                      validate: (mPromoterProfileSettingsScreenModel
                              .mPhoneNumberTextEditingController.text.isEmpty)
                          ? fieldValidation
                          : false,
                    ),
                    SizedBox(
                      height: SizeConstants.s1 * 15,
                    ),

                    ///StaffId
                    // editTextFiled(
                    //   mPromoterProfileSettingsScreenModel
                    //       .mStaffIdTextEditingController,
                    //   // () {},
                    //   labelText: AppConstants.cWordConstants.wUsernameText,
                    //   hintText:
                    //       AppConstants.cWordConstants.wPleaseEnterUsernameText,
                    //   cursorColor: Colors.black,
                    //   labelColor: Colors.grey,
                    // ),
                    // SizedBox(
                    //   height: SizeConstants.s1 * 15,
                    // ),

                    ///AddressLine1
                    editTextFiled(
                      mPromoterProfileSettingsScreenModel
                          .mAddressLine1TextEditingController,
                      // () {},
                      labelText: AppConstants.cWordConstants.wAddressLine1Text,
                      hintText: AppConstants
                          .cWordConstants.wPleaseEnterAddressLine1Text,
                      cursorColor: Colors.black,
                      labelColor: Colors.grey,
                      mandatoryField: true,
                      validate: (mPromoterProfileSettingsScreenModel
                              .mAddressLine1TextEditingController.text.isEmpty)
                          ? fieldValidation
                          : false,
                    ),
                    SizedBox(
                      height: SizeConstants.s1 * 15,
                    ),

                    ///AddressLine2
                    editTextFiled(
                      mPromoterProfileSettingsScreenModel
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
                          mPromoterProfileSettingsScreenModel
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
                            mPromoterProfileSettingsScreenModel
                                .mAreaCodeTextEditingController,
                            // () {},
                            labelText:
                                AppConstants.cWordConstants.wAreaCodeText,
                            hintText: AppConstants
                                .cWordConstants.wPleaseEnterAreaCodeText,
                            cursorColor: Colors.black,
                            textInputType: TextInputType.multiline,
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
                    //   mPromoterProfileSettingsScreenModel
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
                      mPromoterProfileSettingsScreenModel
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
                      mPromoterProfileSettingsScreenModel
                          .mPrimaryContactNumberTextEditingController,
                      // () {},
                      labelText:
                          AppConstants.cWordConstants.wPrimaryContactNumberText,
                      hintText: AppConstants
                          .cWordConstants.wPleaseEnterPrimaryContactNumberText,
                      textInputType: TextInputType.number,
                      cursorColor: Colors.black,
                      labelColor: Colors.grey,
                    ),
                    SizedBox(
                      height: SizeConstants.s1 * 15,
                    ),

                    // ///ICNumber
                    // editTextFiled(
                    //   mPromoterProfileSettingsScreenModel
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
                        if (mPromoterProfileSettingsScreenModel
                                .mFirstNameTextEditingController
                                .text
                                .isNotEmpty &&
                            mPromoterProfileSettingsScreenModel
                                .mAddressLine1TextEditingController
                                .text
                                .isNotEmpty &&
                            mPromoterProfileSettingsScreenModel
                                .mPhoneNumberTextEditingController
                                .text
                                .isNotEmpty) {
                          mPromoterProfileSettingsScreenModel
                              .fetchPostPromoterProfileUpdateUrl();
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
