import 'package:flutter/material.dart';
import 'package:member_app/common/app_constants.dart';
import 'package:member_app/common/appbars_constants.dart';
import 'package:member_app/common/color_constants.dart';
import 'package:member_app/common/image_assets.dart';
import 'package:member_app/common/size_constants.dart';
import 'package:member_app/common/text_styles_constants.dart';
import 'package:member_app/modules/home/home_screen/home_screen_model.dart';

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({super.key});

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {


  late HomeScreenModel mHomeScreenModel;
  List<String> sTitle = [AppConstants.mWordConstants.sTabMyCard,AppConstants.mWordConstants.sTabReward,AppConstants.mWordConstants.sTabMyProfile];

  @override
  void initState() {
    mHomeScreenModel = HomeScreenModel(
      (value) {
        _onItemTapped(value as int);
      },
      context
    );
    mHomeScreenModel.setGetMemberDetailsBloc();
    mHomeScreenModel.setWidget();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars.appBarHome(
              (value) {

          },
          sTitle[mHomeScreenModel.selectedIndex]
      ),
      body: mHomeScreenModel.widgetOptions.elementAt(mHomeScreenModel.selectedIndex),
      bottomNavigationBar: Container(
        color: Colors.grey.shade50,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(SizeConstants.s1 * 20),
              topRight: Radius.circular(SizeConstants.s1 * 20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: ClipPath(
            clipper: ShapeBorderClipper(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(SizeConstants.s_20),
                        topLeft: Radius.circular(SizeConstants.s_20)))),
            child: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Container(
                    padding: EdgeInsets.all(SizeConstants.s_10),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: mHomeScreenModel.selectedIndex==0?Colors.white.withOpacity(0.3):Colors.transparent,
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset:
                              const Offset(0, 1), // changes position of shadow
                        ),
                      ],
                      color: mHomeScreenModel.selectedIndex==0?Colors.white:Colors.transparent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(SizeConstants.s1 * 8),
                      ),
                    ),
                    child: Image.asset(ImageAssets.imageMyCard,
                        height: SizeConstants.s_20,
                        width: SizeConstants.s_20),
                  ),
                  label: AppConstants.mWordConstants.sTabMyCard,
                ),
                BottomNavigationBarItem(
                  icon: Container(
                      padding: EdgeInsets.all(SizeConstants.s_10),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color:mHomeScreenModel.selectedIndex==1?Colors.white.withOpacity(0.3):Colors.transparent,
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(
                                0, 1), // changes position of shadow
                          ),
                        ],
                        color: mHomeScreenModel.selectedIndex==1?Colors.white:Colors.transparent,
                        borderRadius: BorderRadius.all(
                          Radius.circular(SizeConstants.s1 * 8),
                        ),
                      ),
                      child: Image.asset(ImageAssets.imageReward,
                          height: SizeConstants.s_20,
                          width: SizeConstants.s_20)),
                  label: AppConstants.mWordConstants.sTabReward,
                ),
                BottomNavigationBarItem(
                  icon: Container(
                      padding: EdgeInsets.all(SizeConstants.s_10),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color:mHomeScreenModel.selectedIndex==2?Colors.white.withOpacity(0.3):Colors.transparent,
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(
                                0, 1), // changes position of shadow
                          ),
                        ],
                        color: mHomeScreenModel.selectedIndex==2?Colors.white:Colors.transparent,
                        borderRadius: BorderRadius.all(
                          Radius.circular(SizeConstants.s1 * 8),
                        ),
                      ),
                      child: Image.asset(ImageAssets.imageProfile,
                          height: SizeConstants.s_20,
                          width: SizeConstants.s_20)),
                  label: AppConstants.mWordConstants.sTabMyProfile,
                ),
              ],
              type: BottomNavigationBarType.fixed,
              currentIndex: mHomeScreenModel.selectedIndex,
              showUnselectedLabels: false,
              showSelectedLabels: false,
              selectedItemColor: Colors.black,
              selectedLabelStyle: getTextMedium(
                  colors: ColorConstants.kPrimaryColor,
                  size: SizeConstants.width * 0.033),
              unselectedItemColor: ColorConstants.cHintText,
              unselectedLabelStyle: getTextRegular(
                  colors: ColorConstants.cHintText,
                  size: SizeConstants.width * 0.032),
              backgroundColor: Colors.grey.shade300,
              onTap: _onItemTapped,
            ),
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      mHomeScreenModel.selectedIndex = index;
    });
  }
}
