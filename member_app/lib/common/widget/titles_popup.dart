import 'package:flutter/material.dart';
import 'package:member_app/common/alert/app_alert.dart';
import 'package:member_app/common/message_constants.dart';
import 'package:member_app/common/size_constants.dart';
import 'package:member_app/common/utils/network_utils.dart';
import 'package:member_app/data/all_bloc/get_titles_bloc/bloc/get_titles_bloc.dart';
import 'package:member_app/data/all_bloc/get_titles_bloc/bloc/get_titles_event.dart';
import 'package:member_app/data/all_bloc/get_titles_bloc/repo/get_titles_response.dart';

late GetTitlesResponse mGetTitlesResponse;

///only call
Future<void> fetchGetTitlesList(BuildContext context,GetTitlesBloc mGetTitlesBloc) async {
  await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
    if (isInternetAvailable) {
      mGetTitlesBloc.add(const GetTitlesClickEvent());
    } else {
      AppAlert.showSnackBar(context, MessageConstants.noInternetConnection);
    }
  });
}

/// get Races id
Future<String> showPopupTitlesItem(TextEditingController textEditingController,
    GlobalKey mGlobalKey, BuildContext context) async {
  var sValue ;
  RenderBox box = mGlobalKey.currentContext
      ?.findRenderObject() as RenderBox;
  Offset offset =
  box.localToGlobal(Offset.zero);
  List<PopupMenuEntry> itemsPopupMenuEntry = [];
  for (int i = 0; i < mGetTitlesResponse.titles!.length; i++) {
    itemsPopupMenuEntry.add(PopupMenuItem<String>(
      value: mGetTitlesResponse.titles![i].id.toString(),
      child: Text(mGetTitlesResponse.titles![i].name.toString()),
      onTap: () {
        textEditingController.text =
            mGetTitlesResponse.titles![i].name.toString();
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
      constraints: BoxConstraints(maxHeight: SizeConstants.width/2)
  );
  if (sValue.toString().toLowerCase() != "null") {
    return sValue.toString();
  }else {
    return "";
  }
}

