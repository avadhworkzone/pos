import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:member_app/common/alert/alert_action.dart';
import 'package:member_app/common/alert/app_alert.dart';
import 'package:member_app/common/app_constants.dart';
import 'package:member_app/common/appbars_constants.dart';
import 'package:member_app/common/button_constants.dart';
import 'package:member_app/common/call_back.dart';
import 'package:member_app/common/color_constants.dart';
import 'package:member_app/common/image_assets.dart';
import 'package:member_app/common/message_constants.dart';
import 'package:member_app/common/size_constants.dart';
import 'package:member_app/common/utils/network_utils.dart';
import 'package:member_app/common/widget/edit_text_field.dart';
import 'package:member_app/common/widget/gender_popup.dart';
import 'package:member_app/common/widget/race_popup.dart';
import 'package:member_app/common/widget/titles_popup.dart';
import 'package:member_app/data/all_bloc/get_genders_bloc/bloc/get_genders_bloc.dart';
import 'package:member_app/data/all_bloc/get_genders_bloc/bloc/get_genders_state.dart';
import 'package:member_app/data/all_bloc/get_members_details_bloc/bloc/get_members_details_bloc.dart';
import 'package:member_app/data/all_bloc/get_members_details_bloc/bloc/get_members_details_event.dart';
import 'package:member_app/data/all_bloc/get_members_details_bloc/bloc/get_members_details_state.dart';
import 'package:member_app/data/all_bloc/get_races_bloc/bloc/get_races_bloc.dart';
import 'package:member_app/data/all_bloc/get_races_bloc/bloc/get_races_state.dart';
import 'package:member_app/data/all_bloc/get_titles_bloc/bloc/get_titles_bloc.dart';
import 'package:member_app/data/all_bloc/get_titles_bloc/bloc/get_titles_state.dart';
import 'package:member_app/data/all_bloc/profile_delete_bloc/bloc/profile_delete_bloc.dart';
import 'package:member_app/data/all_bloc/profile_delete_bloc/bloc/profile_delete_state.dart';
import 'package:member_app/data/all_bloc/profile_pic_upload/bloc/profile_pic_update_bloc.dart';
import 'package:member_app/data/all_bloc/profile_pic_upload/bloc/profile_pic_update_state.dart';
import 'package:member_app/data/all_bloc/profile_update_bloc/bloc/profile_update_bloc.dart';
import 'package:member_app/data/all_bloc/profile_update_bloc/bloc/profile_update_event.dart';
import 'package:member_app/data/all_bloc/profile_update_bloc/bloc/profile_update_state.dart';
import 'package:member_app/data/all_bloc/profile_update_bloc/repo/profile_update_request.dart';
import 'package:member_app/modules/edit_profile/edit_profile_model_controller.dart';
import 'package:member_app/modules/home/my_profile/view/my_profile_model.dart';

import '../../../common/text_styles_constants.dart';

class EditProfileScreenWidget extends StatefulWidget {
  final CallbackModel mCallbackModel;

  const EditProfileScreenWidget({super.key, required this.mCallbackModel});

  @override
  State<EditProfileScreenWidget> createState() =>
      _EditProfileScreenWidgetState();
}

class _EditProfileScreenWidgetState extends State<EditProfileScreenWidget> {
  late ProfileUpdateBloc _mProfileUpdateBloc;
  late GetMemberDetailsBloc _mGetMemberDetailsBloc;
  late ProfilePicUpdateBloc mProfilePicUpdateBloc;
  late GetGendersBloc mGetGendersBloc;
  late GetRacesBloc mGetRacesBloc;
  late GetTitlesBloc mGetTitlesBloc;

  final TextEditingController _firstNameController = TextEditingController();

  // final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _racesController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressOneController = TextEditingController();
  final TextEditingController _addressTwoController = TextEditingController();
  final TextEditingController _titlesController = TextEditingController();

  GlobalKey keyRaces = GlobalKey();
  GlobalKey keyGender = GlobalKey();
  GlobalKey keyTitles = GlobalKey();

  DateTime selectedDate = DateTime(2014, 12, 30);
  late MyProfileModel mMyProfileModel;
  late EditProfileModelController mEditProfileModelController;

  String imageFile = "";

  @override
  void initState() {
    mEditProfileModelController = EditProfileModelController(context);
    mEditProfileModelController.setProfileDeleteBloc();

    ///

    mMyProfileModel = widget.mCallbackModel.sValue as MyProfileModel;
    _firstNameController.text = mMyProfileModel.sFirstName;
    // _lastNameController.text = mMyProfileModel.sLastName;
    _dobController.text = mMyProfileModel.sDob;
    _emailController.text = mMyProfileModel.sEmail;
    _phoneNumberController.text = mMyProfileModel.sPhone;
    _racesController.text = mMyProfileModel.sRacesName;
    _genderController.text = mMyProfileModel.sGenderName;
    _cityController.text = mMyProfileModel.sCity;
    _postalCodeController.text = mMyProfileModel.sAreaCode;
    _addressOneController.text = mMyProfileModel.sAddress1;
    _addressTwoController.text = mMyProfileModel.sAddress2;
    _titlesController.text = mMyProfileModel.sTitlesName;

    super.initState();

    _mProfileUpdateBloc = ProfileUpdateBloc();
    _mGetMemberDetailsBloc = GetMemberDetailsBloc();
    mProfilePicUpdateBloc = ProfilePicUpdateBloc();
    mGetGendersBloc = GetGendersBloc();
    mGetRacesBloc = GetRacesBloc();
    mGetTitlesBloc = GetTitlesBloc();
  }

  Future<void> _initGetMemberDetails() async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        _mGetMemberDetailsBloc.add(const GetMemberDetailsClickEvent());
      } else {
        AppAlert.showSnackBar(context, MessageConstants.noInternetConnection);
      }
    });
  }

  Future<void> _initProfileUpdate(
      ProfileUpdateRequest mProfileUpdateRequest) async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        _mProfileUpdateBloc.add(ProfileUpdateClickEvent(
            mProfileUpdateListRequest: mProfileUpdateRequest));
      } else {
        AppAlert.showSnackBar(context, MessageConstants.noInternetConnection);
      }
    });
  }

  // Future<void> _initProfilePicUpdate(String mPicFile) async {
  //   await NetworkUtils()
  //       .checkInternetConnection()
  //       .then((isInternetAvailable) async {
  //     if (isInternetAvailable) {
  //       mProfilePicUpdateBloc.add(
  //           ProfilePicUpdateClickEvent(mProfilePicUpdateListRequest: mPicFile));
  //     } else {
  //       AppAlert.showSnackBar(context, MessageConstants.noInternetConnection);
  //     }
  //   });
  // }

  Future<void> saveProfile() async {
    await NetworkUtils()
        .checkInternetConnection()
        .then((isInternetAvailable) async {
      if (isInternetAvailable) {
        if (checkValue()) {
          ProfileUpdateRequest mProfileUpdateRequest = ProfileUpdateRequest(
            firstName: _firstNameController.text,
            lastName: "",
            email: _emailController.text,
            raceId: mMyProfileModel.sRacesId,
            genderId: mMyProfileModel.sGenderId,
            titleId: mMyProfileModel.sTitlesId,
            dateOfBirth: _dobController.text,
            city: _cityController.text,
            areaCode: _postalCodeController.text,
            addressLine1: _addressOneController.text,
            addressLine2: _addressTwoController.text,
          );

          _initProfileUpdate(mProfileUpdateRequest);
        }
      } else {
        AppAlert.showSnackBar(context, MessageConstants.noInternetConnection);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBars.appBar(
            (value) {}, AppConstants.mWordConstants.sEditProfile),
        body: MultiBlocListener(
          child: _buildEditProfileScreenWidgetView(),
          listeners: [
            BlocListener<ProfileUpdateBloc, ProfileUpdateState>(
                bloc: _mProfileUpdateBloc,
                listener: (context, state) {
                  _fProfileUpdateBlocListener(context, state);
                }),
            BlocListener<GetMemberDetailsBloc, GetMemberDetailsState>(
                bloc: _mGetMemberDetailsBloc,
                listener: (context, state) {
                  _fGetMemberDetailsBlocListener(context, state);
                }),
            BlocListener<ProfilePicUpdateBloc, ProfilePicUpdateState>(
                bloc: mProfilePicUpdateBloc,
                listener: (context, state) {
                  _blocProfilePicUpdateListener(context, state);
                }),
            BlocListener<GetGendersBloc, GetGendersState>(
                bloc: mGetGendersBloc,
                listener: (context, state) {
                  _blocGendersListener(context, state);
                }),
            BlocListener<GetRacesBloc, GetRacesState>(
                bloc: mGetRacesBloc,
                listener: (context, state) {
                  _blocGetRacesListener(context, state);
                }),
            BlocListener<GetTitlesBloc, GetTitlesState>(
                bloc: mGetTitlesBloc,
                listener: (context, state) {
                  _blocGetTitlesListener(context, state);
                }),
            BlocListener<ProfileDeleteBloc, ProfileDeleteState>(
                bloc: mEditProfileModelController.getProfileDeleteBloc(),
                listener: (context, state) {
                  mEditProfileModelController.blocProfileDeleteListener(
                      context, state);
                }),
          ],
        ));
  }

  _fProfileUpdateBlocListener(BuildContext context, ProfileUpdateState state) {
    switch (state.status) {
      case ProfileUpdateStatus.loading:
        AppAlert.showProgressDialog(context);
        break;
      case ProfileUpdateStatus.failed:
        AppAlert.closeDialog(context);
        if (state.webResponseFailed != null) {
          AppAlert.showSnackBar(
              context, state.webResponseFailed!.statusMessage ?? "");
        } else {
          AppAlert.showSnackBar(
            context,
            MessageConstants.wSomethingWentWrong,
          );
        }
        break;
      case ProfileUpdateStatus.success:
        AppAlert.closeDialog(context);
        if (state.mProfileUpdateResponse!.status!) {
          AppAlert.showSuccess(
            context,
            state.mProfileUpdateResponse!.message.toString(),
          ).then((value) async {
            _initGetMemberDetails();
          });
        } else {
          AppAlert.showError(
            context,
            state.mProfileUpdateResponse!.message.toString(),
          );
          //     .then((value) async {
          //   _initGetMemberDetails();
          // });
        }
        break;
    }
  }

  _fGetMemberDetailsBlocListener(
      BuildContext context, GetMemberDetailsState state) {
    switch (state.status) {
      case GetMemberDetailsStatus.loading:
        AppAlert.showProgressDialog(context);
        break;
      case GetMemberDetailsStatus.failed:
        AppAlert.closeDialog(context);
        if (state.webResponseFailed != null) {
          AppAlert.showSnackBar(
              context, state.webResponseFailed!.statusMessage ?? "");
        } else {
          AppAlert.showSnackBar(
            context,
            MessageConstants.wSomethingWentWrong,
          );
        }
        break;
      case GetMemberDetailsStatus.success:
        AppAlert.closeDialog(context);
        break;
    }
  }

  _blocProfilePicUpdateListener(
      BuildContext context, ProfilePicUpdateState state) {
    switch (state.status) {
      case ProfilePicUpdateStatus.loading:
        AppAlert.showProgressDialog(context);
        break;
      case ProfilePicUpdateStatus.failed:
        AppAlert.closeDialog(context);
        if (state.webResponseFailed != null) {
          AppAlert.showSnackBar(
              context, state.webResponseFailed!.statusMessage ?? "");
        } else {
          AppAlert.showSnackBar(
            context,
            MessageConstants.wSomethingWentWrong,
          );
        }
        break;
      case ProfilePicUpdateStatus.success:
        AppAlert.closeDialog(context);
        AppAlert.showSnackBar(
          context,
          state.mProfilePicUpdateResponse!.message.toString(),
        );
        _initGetMemberDetails();
        break;
    }
  }

  _blocGendersListener(BuildContext context, GetGendersState state) async {
    switch (state.status) {
      case GetGendersStatus.loading:
        AppAlert.showProgressDialog(context);
        break;
      case GetGendersStatus.failed:
        AppAlert.closeDialog(context);
        if (state.webResponseFailed != null) {
          AppAlert.showSnackBar(
              context, state.webResponseFailed!.statusMessage ?? "");
        } else {
          AppAlert.showSnackBar(
            context,
            MessageConstants.wSomethingWentWrong,
          );
        }
        break;
      case GetGendersStatus.success:
        AppAlert.closeDialog(context);
        mGetGendersResponse = state.mGetGendersResponse!;
        if (mGetGendersResponse.genders!.isNotEmpty) {
          mMyProfileModel.sGenderId =
              await showPopupGendersItem(_genderController, keyGender, context);
        }
        break;
    }
  }

  _blocGetRacesListener(BuildContext context, GetRacesState state) async {
    switch (state.status) {
      case GetRacesStatus.loading:
        AppAlert.showProgressDialog(context);
        break;
      case GetRacesStatus.failed:
        AppAlert.closeDialog(context);
        if (state.webResponseFailed != null) {
          AppAlert.showSnackBar(
              context, state.webResponseFailed!.statusMessage ?? "");
        } else {
          AppAlert.showSnackBar(
            context,
            MessageConstants.wSomethingWentWrong,
          );
        }
        break;
      case GetRacesStatus.success:
        AppAlert.closeDialog(context);
        mGetRacesResponse = state.mGetRacesResponse!;
        if (mGetRacesResponse.races!.isNotEmpty) {
          mMyProfileModel.sRacesId =
              await showPopupRacesItem(_racesController, keyRaces, context);
        }
        break;
    }
  }

  _blocGetTitlesListener(BuildContext context, GetTitlesState state) async {
    switch (state.status) {
      case GetTitlesStatus.loading:
        AppAlert.showProgressDialog(context);
        break;
      case GetTitlesStatus.failed:
        AppAlert.closeDialog(context);
        if (state.webResponseFailed != null) {
          AppAlert.showSnackBar(
              context, state.webResponseFailed!.statusMessage ?? "");
        } else {
          AppAlert.showSnackBar(
            context,
            MessageConstants.wSomethingWentWrong,
          );
        }
        break;
      case GetTitlesStatus.success:
        AppAlert.closeDialog(context);
        mGetTitlesResponse = state.mGetTitlesResponse!;
        if (mGetTitlesResponse.titles!.isNotEmpty) {
          mMyProfileModel.sTitlesId =
              await showPopupTitlesItem(_titlesController, keyTitles, context);
        }
        break;
    }
  }

  _buildEditProfileScreenWidgetView() {
    return FocusDetector(
        onForegroundGained: () {},
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: SizeConstants.s_30,
              ),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: SizeConstants.width * 0.26,
                      width: SizeConstants.width * 0.26,
                      padding: EdgeInsets.all(SizeConstants.s_10),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: const Offset(
                                  0, 1), // changes position of shadow
                            ),
                          ],
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: ColorConstants.kPrimaryColor.shade600)),
                      child: ClipOval(
                          child: Image.asset(
                        ImageAssets.imageAppBarLogo,
                      )),
                    )),
              ),
              SizedBox(
                height: SizeConstants.s_30,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset:
                            const Offset(0, 1), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(SizeConstants.s1 * 20),
                      topRight: Radius.circular(SizeConstants.s1 * 20),
                    ),
                  ),
                  child: Scrollbar(
                      thumbVisibility: true,
                      thickness: SizeConstants.s2,
                      //width of scrollbar
                      radius: const Radius.circular(20),
                      //corner radius of scrollbar
                      scrollbarOrientation: ScrollbarOrientation.right,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(SizeConstants.s_15),
                          child: Column(
                            children: [
                              SizedBox(
                                height: SizeConstants.s_8,
                              ),

                              ///titles
                              editTextFiledGlobalKeyClickView(
                                  _titlesController, keyTitles, (value) async {
                                await fetchGetTitlesList(
                                    context, mGetTitlesBloc);
                              },
                                  labelText: AppConstants.mWordConstants.sTitle,
                                  hintText:
                                      AppConstants.mWordConstants.sSelectTitles,
                                  mIcons: Icons.arrow_drop_down_sharp,
                                  readOnly: true,
                                  suffixIcon: true),
                              SizedBox(
                                height: SizeConstants.s_16,
                              ),

                              ///First Name

                              editTextFiled(
                                _firstNameController,
                                labelText:
                                    AppConstants.mWordConstants.sFullName,
                                hintText: AppConstants
                                    .mWordConstants.sEnterYourFirstName,
                                mIcons: Icons.person_outline,
                              ),
                              SizedBox(
                                height: SizeConstants.s_16,
                              ),

                              ///select Races and select gender
                              Row(
                                children: [
                                  Expanded(
                                    child: editTextFiledGlobalKeyClickView(
                                        _racesController, keyRaces,
                                        (value) async {
                                      await fetchGetRacesList(
                                          context, mGetRacesBloc);
                                    },
                                        labelText:
                                            AppConstants.mWordConstants.sRaces,
                                        hintText:
                                            AppConstants.mWordConstants.sRaces,
                                        mIcons: Icons.arrow_drop_down_sharp,
                                        readOnly: true,
                                        suffixIcon: true),
                                  ),
                                  SizedBox(
                                    width: SizeConstants.s_10,
                                  ),
                                  Expanded(
                                    child: editTextFiledGlobalKeyClickView(
                                        _genderController, keyGender,
                                        (value) async {
                                      await fetchGetGendersList(
                                          context, mGetGendersBloc);
                                    },
                                        labelText:
                                            AppConstants.mWordConstants.sGender,
                                        hintText:
                                            AppConstants.mWordConstants.sGender,
                                        mIcons: Icons.arrow_drop_down_sharp,
                                        readOnly: true,
                                        suffixIcon: true),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: SizeConstants.s_16,
                              ),

                              ///Email id
                              editTextFiled(
                                _emailController,
                                labelText: AppConstants.mWordConstants.sEmail,
                                hintText:
                                    AppConstants.mWordConstants.sEnterYourEmail,
                                mIcons: Icons.email_outlined,
                              ),
                              SizedBox(
                                height: SizeConstants.s_16,
                              ),

                              ///select dob
                              editTextFiledClickView(_dobController,
                                  (value) async {
                                _selectDate(context);
                              },
                                  labelText:
                                      AppConstants.mWordConstants.sDdMmYYYY,
                                  hintText:
                                      AppConstants.mWordConstants.sDdMmYYYY,
                                  mIcons: Icons.arrow_drop_down_sharp,
                                  readOnly: true,
                                  suffixIcon: true),
                              SizedBox(
                                height: SizeConstants.s_16,
                              ),

                              ///non edit phoneNumber

                              editTextFiled(_phoneNumberController,
                                  labelText:
                                      AppConstants.mWordConstants.sPhoneNumber,
                                  hintText: AppConstants
                                      .mWordConstants.sEnterPhoneNumber,
                                  mIcons: Icons.phone,
                                  readOnly: true),
                              SizedBox(
                                height: SizeConstants.s_16,
                              ),

                              ///city and Postal Code
                              Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: editTextFiled(
                                      _cityController,
                                      labelText:
                                          AppConstants.mWordConstants.sCity,
                                      hintText:
                                          AppConstants.mWordConstants.sCity,
                                      mIcons: Icons.location_city_outlined,
                                    ),
                                  ),
                                  SizedBox(
                                    width: SizeConstants.s_10,
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: editTextFiled(
                                      _postalCodeController,
                                      labelText: AppConstants
                                          .mWordConstants.sPostalCode,
                                      hintText: AppConstants
                                          .mWordConstants.sPostalCode,
                                      mIcons: Icons.location_history,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: SizeConstants.s_16,
                              ),

                              ///address1

                              editTextFiled(_addressOneController,
                                  labelText:
                                      AppConstants.mWordConstants.sAddress1,
                                  hintText: AppConstants
                                      .mWordConstants.sEnterYourAddress,
                                  mIcons: Icons.location_on_rounded,
                                  maxLines: 3),
                              SizedBox(
                                height: SizeConstants.s_16,
                              ),

                              ///address2
                              editTextFiled(_addressTwoController,
                                  labelText:
                                      AppConstants.mWordConstants.sAddress2,
                                  hintText: AppConstants
                                      .mWordConstants.sEnterYourAddress,
                                  mIcons: Icons.location_on_rounded,
                                  maxLines: 3),
                              SizedBox(
                                height: SizeConstants.s_30,
                              ),

                              ///SaveProfile button
                              SizedBox(
                                height: SizeConstants.width * 0.12,
                                width: SizeConstants.width / 2.5,
                                child: rectangleRoundedCornerButton(
                                    appbarActionInterface: (value) {
                                      saveProfile();
                                    },
                                    sButtonTitle:
                                        AppConstants.mWordConstants.sSave,
                                    cButtonBackGroundColor:
                                        ColorConstants.kPrimaryColor,
                                    cButtonTextColor: ColorConstants.cWhite,
                                    dButtonTextSize: SizeConstants.s_16,
                                    dButtonWidth: SizeConstants.width,
                                    cButtonBorderColor:
                                        ColorConstants.kPrimaryColor,
                                    dButtonRadius: SizeConstants.s_15),
                              ),
                              SizedBox(
                                height: SizeConstants.s_16,
                              ),

                              ///delete Profile button
                              GestureDetector(
                                onTap: () {
                                  deleteProfile();
                                },
                                child: Container(
                                    padding: EdgeInsets.only(
                                      bottom: SizeConstants.s3,
                                    ),
                                    // decoration: BoxDecoration(
                                    //     border: Border(
                                    //         bottom: BorderSide(
                                    //           color: ColorConstants.kPrimaryColor.shade600,
                                    //           width: SizeConstants
                                    //               .s1, // This would be the width of the underline
                                    //         ))),
                                    child: Text(
                                        AppConstants
                                            .mWordConstants.sDeleteProfile,
                                        style: getTextRegular(
                                          size: SizeConstants.s1 * 14,
                                          colors: ColorConstants
                                              .kPrimaryColor.shade600,
                                        ))),
                              ),

                              SizedBox(
                                height: SizeConstants.s_16,
                              ),
                            ],
                          ),
                        ),
                      )),
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1950, 8),
        lastDate: DateTime(2014, 12, 31),
        initialEntryMode: DatePickerEntryMode.calendarOnly);
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        String dob =
            "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
        _dobController.text = dob;
      });
    }
  }

  checkValue() {
    String sMessage = "";
    // else if (_lastNameController.text.isEmpty) {
    // sMessage = AppConstants.mWordConstants.sPleaseEnterTheLastName;
    // }
    if (_firstNameController.text.isEmpty) {
      sMessage = AppConstants.mWordConstants.sPleaseEnterTheFirstName;
    } else if (_emailController.text.isEmpty) {
      sMessage = AppConstants.mWordConstants.sPleaseEnterTheEmailId;
    } else if (_racesController.text.isEmpty) {
      sMessage = AppConstants.mWordConstants.sPleaseSelectRaces;
    } else if (_genderController.text.isEmpty) {
      sMessage = AppConstants.mWordConstants.sPleaseSelectGender;
    } else if (_dobController.text.isEmpty) {
      sMessage = AppConstants.mWordConstants.sPleaseSelectDob;
    } else if (_cityController.text.isEmpty) {
      sMessage = AppConstants.mWordConstants.sPleaseEnterTheCity;
    } else if (_postalCodeController.text.isEmpty) {
      sMessage = AppConstants.mWordConstants.sPleaseEnterThePostalCode;
    } else if (_addressOneController.text.isEmpty) {
      sMessage = AppConstants.mWordConstants.sPleaseEnterTheAddress;
    }
    if (sMessage.isNotEmpty) {
      AppAlert.showSnackBar(context, sMessage);
      return false;
    } else {
      return true;
    }
  }

  deleteProfile() {
    AppAlert.showCustomDialogNoYes(
      context,
      MessageConstants.wProfileDelete,
      MessageConstants.wProfileDeleteMessage,
      buttonOneText: MessageConstants.wCancel,
      buttonTwoText: MessageConstants.wConfirm,
    ).then((value) async {
      if (value == AlertAction.yes) {
        mEditProfileModelController.initProfileDelete();
      }
    });
  }
}
