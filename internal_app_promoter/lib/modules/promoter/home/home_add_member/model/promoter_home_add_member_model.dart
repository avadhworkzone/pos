import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:internal_base/common/alert/app_alert.dart';
import 'package:internal_base/common/call_back.dart';
import 'package:internal_base/common/message_constants.dart';
import 'package:internal_base/common/utils/network_utils.dart';
import 'package:internal_base/data/all_bloc/promoter/add_member/bloc/add_member_bloc.dart';
import 'package:internal_base/data/all_bloc/promoter/add_member/bloc/add_member_event.dart';
import 'package:internal_base/data/all_bloc/promoter/add_member/bloc/add_member_state.dart';
import 'package:internal_base/data/all_bloc/promoter/add_member/repo/add_member_request.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_stores_list/repo/store_manager_stores_list_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';

class PromoterHomeAddMemberModel {
  final BuildContext cBuildContext;
  final CallbackModel mCallbackModel;

  List<DateTime?> dialogCalendarPickerValue = [];
  List<String?> stringCalendarPickerValue = [];

  final TextEditingController mUsernameTextEditingController =
      TextEditingController();
  final TextEditingController mEmailIdTextEditingController =
      TextEditingController();
  final TextEditingController mPhoneNumberTextEditingController =
      TextEditingController();
  final TextEditingController mDateOfBirthTextEditingController =
      TextEditingController();

  PromoterHomeAddMemberModel(this.cBuildContext, this.mCallbackModel);

  Future<void> refresh() async {
    addMemberUrl();
  }

  Stores? mSelectStore;

  ///SharedPrefs
  getSharedPrefsSelectStore() async {
    await SharedPrefs().getSelectStore().then((sSelectStore) async {
      if (sSelectStore.toString() != "null" &&
          sSelectStore.toString().isNotEmpty) {
        mSelectStore = Stores.fromJson(jsonDecode(sSelectStore));
      }
    });
  }

  ///AddMember

  late AddMemberBloc _mAddMemberBloc;

  setAddMemberBloc() {
    _mAddMemberBloc = AddMemberBloc();
  }

  getAddMemberBloc() {
    return _mAddMemberBloc;
  }

  Future<void> addMemberUrl() async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        _mAddMemberBloc.add(AddMemberClickEvent(
            mAddMemberListRequest: AddMemberRequest(
              firstName: mUsernameTextEditingController.text,
              email: mEmailIdTextEditingController.text,
              mobileNumber: mPhoneNumberTextEditingController.text,
              dateOfBirth: mDateOfBirthTextEditingController.text,
            ),
            mStoreID: "${mSelectStore?.id ?? 0}"));
      } else {
        AppAlert.showSnackBar(
            cBuildContext, MessageConstants.noInternetConnection);
      }
    });
  }

  blocAddMemberListener(BuildContext context, AddMemberState state) {
    debugPrint("adsfadsfasdf");
    switch (state.status) {
      case AddMemberStatus.loading:
        AppAlert.showProgressDialog(context);
        break;
      case AddMemberStatus.failed:
        AppAlert.closeDialog(context);
        AppAlert.showSnackBar(
            context, state.webResponseFailed?.statusMessage ?? "");
        break;
      case AddMemberStatus.success:
        AppAlert.closeDialog(context);
        AppAlert.showSnackBar(context, "Member added successfully");
        Navigator.pop(context);
        break;
    }
  }
}
