import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jakel_base/restapi/me/model/CurrentUserResponse.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';
import 'package:jakel_pos/modules/common/UserViewModel.dart';
import 'package:jakel_pos/modules/utils/logout_utils.dart';

import '../../../../routing/route_names.dart';

class OpenCounterAppBar extends StatefulWidget {
  const OpenCounterAppBar({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _OpenCounterAppBarState();
  }
}

class _OpenCounterAppBarState extends State<OpenCounterAppBar> {
  var userViewModel = UserViewModel();
  CurrentUserResponse? currentUser;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Row(
        children: [
          Expanded(flex: 3, child: getLeftWidget()),
          MyInkWellWidget(
              child: Icon(
                Icons.account_tree_outlined,
                color: Theme.of(context).primaryColor,
              ),
              onTap: () {
                Navigator.pushNamed(context, LocalCountersInfoRoute,
                    arguments: true);
              }),
          Expanded(child: getCurrentUser())
        ],
      ),
    );
  }

  Widget getCurrentUser() {
    return FutureBuilder(
        future: userViewModel.getCurrentUser(),
        builder: (BuildContext context,
            AsyncSnapshot<CurrentUserResponse?> snapshot) {
          if (snapshot.hasData) {
            currentUser = snapshot.data;
            return rightWidget();
          }
          return const Text("Loading Widget");
        });
  }

  Widget rightWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(
          width: 10,
        ),
        Container(
          height: double.infinity,
          width: 1,
          margin: const EdgeInsets.all(5),
          color: Theme.of(context).dividerColor,
        ),
        CircleAvatar(
          maxRadius: 15,
          backgroundImage: NetworkImage(
            userViewModel.getProfilePic(currentUser),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
            child: Text(userViewModel.getDisplayName(currentUser),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(color: Colors.white, fontSize: 15))),
        const SizedBox(
          width: 10,
        ),
        _profilePopUp(),
        const SizedBox(
          width: 10,
        ),
      ],
    );
  }

  Widget _profilePopUp() {
    return PopupMenuButton<int>(
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 1,
          child: Text('Logout'),
        ),
        const PopupMenuItem(
          value: 2,
          child: Text(
            'Logout & Clear configuration',
          ),
        ),
        const PopupMenuItem(
          value: 3,
          child: Text(
            'Exit',
          ),
        ),
      ],
      icon: const Icon(
        Icons.keyboard_arrow_down_outlined,
        size: 20.0,
        color: Colors.white,
      ),
      offset: const Offset(0, 40),
      tooltip: "Menu",
      onSelected: (value) {
        setState(() {
          if (value == 0) {
            //
          }
          if (value == 1) {
            // Logout
            _logout(false);
          }
          if (value == 2) {
            // Logout
            _logout(true);
          }
          if (value == 3) {
            // Exit the application
            SystemNavigator.pop();
          }
        });
      },
    );
  }

  Widget getLeftWidget() {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(const SizedBox(
      width: 10,
    ));

    //Menu item
    widgets.add(const Text(
      "Open Counter",
      style: TextStyle(fontSize: 15, color: Colors.white),
    ));

    return Row(children: widgets);
  }

  Future<void> _logout(bool clearConfiguration) async {
    await logout(clearConfiguration, context);
    if (!mounted) return;
    await routeToSplash(context);
  }
}
