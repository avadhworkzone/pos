import 'package:flutter/material.dart';
import 'package:member_app/common/alert/app_alert.dart';
import 'package:member_app/common/message_constants.dart';
import 'package:member_app/common/utils/network_utils.dart';
import 'package:member_app/data/all_bloc/profile_delete_bloc/bloc/profile_delete_bloc.dart';
import 'package:member_app/data/all_bloc/profile_delete_bloc/bloc/profile_delete_event.dart';
import 'package:member_app/data/all_bloc/profile_delete_bloc/bloc/profile_delete_state.dart';
import 'package:member_app/data/local/shared_prefs/shared_prefs.dart';
import 'package:member_app/routes/route_constants.dart';

class EditProfileModelController {
  final BuildContext context;

  EditProfileModelController(this.context);
  
  ///delete profile
  late ProfileDeleteBloc _mProfileDeleteBloc;
  
  setProfileDeleteBloc(){
    _mProfileDeleteBloc = ProfileDeleteBloc();
  }
  
  getProfileDeleteBloc(){
    return _mProfileDeleteBloc;
  }

  Future<void> initProfileDelete() async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        _mProfileDeleteBloc.add(const ProfileDeleteClickEvent( mProfileDeleteListRequest: ""));
      } else {
        AppAlert.showSnackBar(context, MessageConstants.noInternetConnection);
      }
    });
  }

  blocProfileDeleteListener(BuildContext context, ProfileDeleteState state) async {
    switch (state.status) {
      case ProfileDeleteStatus.loading:
        AppAlert.showProgressDialog(context);
        break;
      case ProfileDeleteStatus.failed:
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
      case ProfileDeleteStatus.success:
        AppAlert.closeDialog(context);
        AppAlert.showSnackBar(
          context,
          state.mProfileDeleteResponse!.message??"",
        );

        if(state.mProfileDeleteResponse!.status??false){
          await SharedPrefs().setUserToken("");
          await SharedPrefs().clearSharedPreferences();
          Navigator.pushNamedAndRemoveUntil(context,
              RouteConstants.rWelcomeScreenWidget, (route) => false);
        }
        break;
    }
  }
  
}
