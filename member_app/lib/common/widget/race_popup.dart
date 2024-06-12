import 'package:flutter/material.dart';
import 'package:member_app/common/alert/app_alert.dart';
import 'package:member_app/common/message_constants.dart';
import 'package:member_app/common/size_constants.dart';
import 'package:member_app/common/utils/network_utils.dart';
import 'package:member_app/data/all_bloc/get_races_bloc/bloc/get_races_bloc.dart';
import 'package:member_app/data/all_bloc/get_races_bloc/bloc/get_races_event.dart';
import 'package:member_app/data/all_bloc/get_races_bloc/repo/get_races_response.dart';

late GetRacesResponse mGetRacesResponse;

///only call
Future<void> fetchGetRacesList(BuildContext context,GetRacesBloc mGetRacesBloc) async {
  await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
    if (isInternetAvailable) {
      mGetRacesBloc.add(const GetRacesClickEvent());
    } else {
      AppAlert.showSnackBar(context, MessageConstants.noInternetConnection);
    }
  });
}

/// get Races id
Future<String> showPopupRacesItem(TextEditingController textEditingController,
    GlobalKey mGlobalKey, BuildContext context) async {
  var sValue ;
  RenderBox box = mGlobalKey.currentContext
      ?.findRenderObject() as RenderBox;
  Offset offset =
  box.localToGlobal(Offset.zero);
  List<PopupMenuEntry> itemsPopupMenuEntry = [];
  for (int i = 0; i < mGetRacesResponse.races!.length; i++) {
    itemsPopupMenuEntry.add(PopupMenuItem<String>(
      value: mGetRacesResponse.races![i].id.toString(),
      child: Text(mGetRacesResponse.races![i].name.toString()),
      onTap: () {
        textEditingController.text =
            mGetRacesResponse.races![i].name.toString();
      },
    ));
  }
  // double left = offset.dx;
  double top = offset.dy;
  sValue = await showMenu(
    context: context,
    position: RelativeRect.fromLTRB(
        SizeConstants.s_20, top + SizeConstants.s_50, SizeConstants.s_20, 0),
    items: itemsPopupMenuEntry,
    elevation: 8.0,
      constraints: BoxConstraints(maxHeight: SizeConstants.width/2.5)

  );
  if (sValue.toString().toLowerCase() != "null") {
    return sValue.toString();
  }else {
    return "";
  }
}

