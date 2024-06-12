import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:internal_app_promoter/modules/promoter/home/home_add_member/model/promoter_home_add_member_model.dart';
import 'package:internal_base/common/alert/app_alert.dart';
import 'package:internal_base/common/app_constants.dart';
import 'package:internal_base/common/appbars_constants.dart';
import 'package:internal_base/common/button_constants.dart';
import 'package:internal_base/common/call_back.dart';
import 'package:internal_base/common/color_constants.dart';
import 'package:internal_base/common/size_constants.dart';
import 'package:internal_base/common/utils/app_calendar_utils.dart';
import 'package:internal_base/common/widget/edit_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_base/data/all_bloc/promoter/add_member/bloc/add_member_bloc.dart';
import 'package:internal_base/data/all_bloc/promoter/add_member/bloc/add_member_state.dart';

class PromoterHomeAddMemberScreenWidget extends StatefulWidget {
  final CallbackModel mCallbackModel;

  const PromoterHomeAddMemberScreenWidget(
      {super.key, required this.mCallbackModel});

  @override
  State<PromoterHomeAddMemberScreenWidget> createState() =>
      _PromoterHomeAddMemberScreenWidgetState();
}

class _PromoterHomeAddMemberScreenWidgetState
    extends State<PromoterHomeAddMemberScreenWidget> {
  late PromoterHomeAddMemberModel mPromoterHomeAddMemberScreenModel;

  bool fieldValidation = false;

  @override
  void initState() {
    mPromoterHomeAddMemberScreenModel =
        PromoterHomeAddMemberModel(context, widget.mCallbackModel);
    mPromoterHomeAddMemberScreenModel.setAddMemberBloc();
    mPromoterHomeAddMemberScreenModel.getSharedPrefsSelectStore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBars.appBarBack((value) {
          Navigator.pop(context);
        }, AppConstants.cWordConstants.wAddMemberTitleText),
        body: _buildMemberWidgetView());
  }

  _buildMemberWidgetView() {
    return FocusDetector(
        child: SafeArea(
            child: MultiBlocListener(
                child: _buildSplashScreenWidgetView(),
                listeners: [
          BlocListener<AddMemberBloc, AddMemberState>(
            bloc: mPromoterHomeAddMemberScreenModel.getAddMemberBloc(),
            listener: (context, state) {
              mPromoterHomeAddMemberScreenModel.blocAddMemberListener(
                  context, state);
            },
          ),
        ])));
  }

  _buildSplashScreenWidgetView() {
    return FocusDetector(
        child: Listener(
          onPointerDown: (PointerDownEvent event) => FocusManager.instance.primaryFocus?.unfocus(),
          child: SafeArea(
      child: Container(
            height: SizeConstants.height,
            width: SizeConstants.width,
            padding: EdgeInsets.only(
                bottom: SizeConstants.s1 * 95, top: SizeConstants.s1 * 15),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(SizeConstants.s1 * 20),
                  topLeft: Radius.circular(SizeConstants.s1 * 20),
                )),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: detailsView(),
            )),
    ),
        ));
  }

  detailsView() {
    return Container(
      margin: EdgeInsets.only(
          left: SizeConstants.s1 * 15,
          right: SizeConstants.s1 * 15,
          bottom: SizeConstants.s1 * 10),
      padding: EdgeInsets.all(SizeConstants.s1 * 13),
      width: SizeConstants.width,
      child: Column(
        children: [
          ///Enter Full Name
          editTextFiled(
            mPromoterHomeAddMemberScreenModel.mUsernameTextEditingController,
            // () {},
            labelText: AppConstants.cWordConstants.wEnterFullNameText,
            hintText: AppConstants.cWordConstants.wPleaseEnterFullNameText,
            cursorColor: Colors.black,
            labelColor: Colors.grey,
              validate: (mPromoterHomeAddMemberScreenModel.mUsernameTextEditingController.text.isEmpty) ? fieldValidation : false,
              mandatoryField: true
          ),
          SizedBox(
            height: SizeConstants.s1 * 15,
          ),

          ///mobile number
          editTextFiled(
            mPromoterHomeAddMemberScreenModel.mPhoneNumberTextEditingController,
            labelText: AppConstants.cWordConstants.wMobileNumberText,
            hintText: AppConstants.cWordConstants.wPleaseMobileNumberText,
            cursorColor: Colors.black,
            textInputType: TextInputType.number,
            labelColor: Colors.grey,
              validate: (mPromoterHomeAddMemberScreenModel.mPhoneNumberTextEditingController.text.isEmpty) ? fieldValidation : false,
            mandatoryField: true
          ),
          SizedBox(
            height: SizeConstants.s1 * 15,
          ),

          ///EmailId

          editTextFiled(
            mPromoterHomeAddMemberScreenModel.mEmailIdTextEditingController,
            labelText: AppConstants.cWordConstants.wEmailIdText,
            hintText: AppConstants.cWordConstants.wPleaseEnterEmailIdText,
            cursorColor: Colors.black,
            labelColor: Colors.grey,
              textInputType: TextInputType.emailAddress,
              validate: (mPromoterHomeAddMemberScreenModel.mEmailIdTextEditingController.text.isEmpty) ? fieldValidation : false,
              mandatoryField: true
          ),
          SizedBox(
            height: SizeConstants.s1 * 15,
          ),

          ///DateOfBirth
          editTextFiledSelection(
            mPromoterHomeAddMemberScreenModel.mDateOfBirthTextEditingController,
            () async {
              var values = await AppAlert.buildCalendarDialog(
                  context,
                  mPromoterHomeAddMemberScreenModel.dialogCalendarPickerValue,
                  getCalendarDatePickerSingle(context));

              print("##values##${values.toString()} ");

              mPromoterHomeAddMemberScreenModel.stringCalendarPickerValue
                  .clear();
              mPromoterHomeAddMemberScreenModel.stringCalendarPickerValue =
                  values;
              if (mPromoterHomeAddMemberScreenModel
                  .stringCalendarPickerValue.isNotEmpty) {
                mPromoterHomeAddMemberScreenModel
                        .mDateOfBirthTextEditingController.text =
                    mPromoterHomeAddMemberScreenModel
                        .stringCalendarPickerValue[0]!;
              }
            },
            labelText: AppConstants.cWordConstants.wEnterDateOfBirthText,
            hintText: AppConstants.cWordConstants.wHintDateOfBirthText,
            cursorColor: Colors.black,
            labelColor: Colors.grey,
              validate: (mPromoterHomeAddMemberScreenModel.mDateOfBirthTextEditingController.text.isEmpty) ? fieldValidation : false,
              mandatoryField: true
          ),
          SizedBox(
            height: SizeConstants.s1 * 35,
          ),

          ///Submit
          mediumRoundedCornerButton(
            appbarActionInterface: (value) {
              setState(() {
                fieldValidation = true;
              });
              if (mPromoterHomeAddMemberScreenModel
                      .mUsernameTextEditingController.text.isNotEmpty &&
                  mPromoterHomeAddMemberScreenModel
                      .mPhoneNumberTextEditingController.text.isNotEmpty &&
                  mPromoterHomeAddMemberScreenModel
                      .mEmailIdTextEditingController.text.isNotEmpty &&
                  mPromoterHomeAddMemberScreenModel
                      .mDateOfBirthTextEditingController.text.isNotEmpty) {
                mPromoterHomeAddMemberScreenModel.addMemberUrl();
              }
            },
            sButtonTitle: AppConstants.cWordConstants.wSubmitText,
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
    );
  }
}
