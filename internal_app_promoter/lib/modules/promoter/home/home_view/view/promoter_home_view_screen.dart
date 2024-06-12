import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:internal_app_promoter/constants/image_assets_constants.dart';
import 'package:internal_app_promoter/modules/common/custom_navigation_drawer/custom_navigation_drawer_screen.dart';
import 'package:internal_app_promoter/modules/promoter/home/home_view/view/model/promoter_home_view_model.dart';
import 'package:internal_app_promoter/routes/route_constants.dart';
import 'package:internal_base/common/app_constants.dart';
import 'package:internal_base/common/appbars_constants.dart';
import 'package:internal_base/common/call_back.dart';
import 'package:internal_base/common/color_constants.dart';
import 'package:internal_base/common/size_constants.dart';
import 'package:internal_base/common/text_styles_constants.dart';
import 'package:internal_base/common/widget/dropdown_button_view/dropdown_button2.dart';
import 'package:internal_base/common/widget/home/home_page_item_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_home/bloc/get_promoter_home_bloc.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_home/bloc/get_promoter_home_state.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_home/repo/get_promoter_home_response.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_profile_details/bloc/get_promoter_profile_details_bloc.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_profile_details/bloc/get_promoter_profile_details_state.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_profile_details/repo/get_promoter_profile_details_response.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_stores/bloc/get_promoter_stores_bloc.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_stores/bloc/get_promoter_stores_state.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_stores/repo/get_promoter_stores_response.dart';

class PromoterHomeViewScreenWidget extends StatefulWidget {
  final CallbackModel mCallbackModel;

  const PromoterHomeViewScreenWidget({super.key, required this.mCallbackModel});

  @override
  State<PromoterHomeViewScreenWidget> createState() =>
      _PromoterHomeViewScreenWidgetState();
}

class _PromoterHomeViewScreenWidgetState
    extends State<PromoterHomeViewScreenWidget> {
  late PromoterHomeViewScreenModel mPromoterHomeViewScreenModel;

  @override
  void initState() {
    mPromoterHomeViewScreenModel =
        PromoterHomeViewScreenModel(context, widget.mCallbackModel);
    mPromoterHomeViewScreenModel.setGetPromoterStoresBloc();
    mPromoterHomeViewScreenModel.setGetPromoterHomeBloc();
    mPromoterHomeViewScreenModel.setPromoteProfileDetailsBloc();
    mPromoterHomeViewScreenModel.fetchGetPromoteProfileDetailsUrl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            key: mPromoterHomeViewScreenModel.scaffoldKey,
            appBar:PreferredSize(
                child:  topBar(),
                preferredSize: Size.fromHeight(SizeConstants.s1 * 75)),
            drawer: CustomNavigationDrawer(
                mCallbackModel: mPromoterHomeViewScreenModel.mCallbackModel),
            body: _buildSplashScreenWidgetView()));
  }

  _buildSplashScreenWidgetView() {
    return FocusDetector(
        child: SafeArea(
            child: MultiBlocListener(child: promoterHomeView(), listeners: [
      BlocListener<GetPromoterStoresBloc, GetPromoterStoresState>(
        bloc: mPromoterHomeViewScreenModel.getGetPromoterStoresBloc(),
        listener: (context, state) {
          mPromoterHomeViewScreenModel.blocGetPromoterStoresListener(
              context, state);
        },
      ),
      BlocListener<GetPromoterHomeBloc, GetPromoterHomeState>(
        bloc: mPromoterHomeViewScreenModel.getGetPromoterHomeBloc(),
        listener: (context, state) {
          mPromoterHomeViewScreenModel.blocGetPromoterHomeListener(
              context, state);
        },
      ),
      BlocListener<GetPromoteProfileDetailsBloc, GetPromoteProfileDetailsState>(
        bloc: mPromoterHomeViewScreenModel.getPromoteProfileDetailsBloc(),
        listener: (context, state) {
          mPromoterHomeViewScreenModel.blocGetPromoteProfileDetailsListener(
              context, state);
        },
      ),
    ])));
  }

  topBar() {
    return StreamBuilder<GetPromoteProfileDetailsResponse?>(
      stream: mPromoterHomeViewScreenModel.responseSubjectProfileDetails,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          GetPromoteProfileDetailsResponse mGetPromoteProfileDetailsResponse = snapshot.data as GetPromoteProfileDetailsResponse;
          PromoterDetails mPromoterDetails =   mGetPromoteProfileDetailsResponse.promoterDetails!;

          return AppBars.appBarHome((value) {
            if (value == AppConstants.cWordConstants.wMenuText) {
              mPromoterHomeViewScreenModel.scaffoldKey.currentState!
                  .openDrawer();
            } else {
              Navigator.pushReplacementNamed(context,
                  RouteConstants.rPromoterProfileSettingsScreenWidget,
                  arguments: mPromoterHomeViewScreenModel.mCallbackModel);
            }
          }, mPromoterDetails.username??"--",
              sImageAssets: ImageAssetsConstants.editIcon,
              sMenu: AppConstants.cWordConstants.wMenuText);
        }

        return AppBars.appBar((value) {
          if (value == AppConstants.cWordConstants.wMenuText) {
            mPromoterHomeViewScreenModel.scaffoldKey.currentState!
                .openDrawer();
          } else {
            Navigator.pushReplacementNamed(context,
                RouteConstants.rPromoterProfileSettingsScreenWidget,
                arguments: mPromoterHomeViewScreenModel.mCallbackModel);
          }
        }, "Home",
            sMenu: AppConstants.cWordConstants.wMenuText);
      },
    );
  }

  promoterHomeView() {
    return Container(
      height: SizeConstants.height,
      width: SizeConstants.width,
      padding: EdgeInsets.only(
          top: SizeConstants.s1 * 15,
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
            ///top dropdown
            topDropdown(),
            /// homeView
            homeView(),
          ],
        ),
      ),
    );
  }

  topDropdown() {
    return StreamBuilder<Stores?>(
      stream: mPromoterHomeViewScreenModel.responseSubjectSelectStore,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          Stores mStores = snapshot.data as Stores;
          return topDropdownStreamBuilder(mStores);
        }
        return const SizedBox();
      },
    );
  }

  topDropdownStreamBuilder(Stores mStores) {
    return Container(
        width: SizeConstants.width * 0.85,
        margin: EdgeInsets.all(SizeConstants.s1 * 5),
        padding: EdgeInsets.only(
          left: SizeConstants.s1 * 15,
          right: SizeConstants.s1 * 15,
        ),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          border: Border.all(
              color: Colors.grey.shade200, width: SizeConstants.s1 * 1.25),
          borderRadius: BorderRadius.all(Radius.circular(SizeConstants.s1 * 8)),
        ),
        child: DropdownButtonHideUnderline(
            child: DropdownButton2(
          items: mPromoterHomeViewScreenModel.createList(),
          value: mStores,
          onChanged: (value) {
            setState(() {
              Stores mStores = value as Stores;
              mPromoterHomeViewScreenModel.mSelectStore = mStores;
              mPromoterHomeViewScreenModel.fetchGetPromoterHomeUrl(mStores);
              mPromoterHomeViewScreenModel.setSelectStore(mStores);
            });
          },
          hint: Row(
            children: [
              Image(
                  height: SizeConstants.s1 * 25,
                  width: SizeConstants.s1 * 25,
                  image: AssetImage(ImageAssetsConstants.homeStore)),
              SizedBox(
                width: SizeConstants.s1 * 15,
              ),
              Text("STORE LIST",
                  style: getTextMedium(
                      size: SizeConstants.s1 * 16, colors: Colors.black)),
              SizedBox(
                width: SizeConstants.s1 * 15,
              ),
            ],
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down_outlined,
            color: ColorConstants.cBlack,
          ),
        )));
  }

  homeView() {
    return StreamBuilder<GetPromoterHomeResponse?>(
      stream: mPromoterHomeViewScreenModel.responseSubject,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          GetPromoterHomeResponse mGetPromoterHomeResponse =
              snapshot.data as GetPromoterHomeResponse;
          return homeViewStreamBuilder(mGetPromoterHomeResponse);
        }
        return const SizedBox();
      },
    );
  }

  homeViewStreamBuilder(GetPromoterHomeResponse mGetPromoterHomeResponse) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(
              top: SizeConstants.s1 * 20,
              bottom: SizeConstants.s1 * 10,
              left: SizeConstants.s1 * 0,
              right: SizeConstants.s1 * 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppConstants.cWordConstants.wOverviewText,
                  style: getTextSemiBold(
                      size: SizeConstants.s1 * 18, colors: Colors.black)),
            ],
          ),
        ),
        Container(
            padding: EdgeInsets.all(SizeConstants.s1 * 15),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                  color: Colors.grey.shade200, width: SizeConstants.s1 * 1.25),
              borderRadius:
                  BorderRadius.all(Radius.circular(SizeConstants.s1 * 8)),
            ),
            child: Column(
              children: [
                Text(AppConstants.cWordConstants.wThisMonthText,
                    style: getTextMedium(
                        size: SizeConstants.s1 * 16, colors: Colors.black)),
                Container(
                  margin: EdgeInsets.only(
                      top: SizeConstants.s1 * 8, bottom: SizeConstants.s1 * 14),
                  height: SizeConstants.s1,
                  width: SizeConstants.width * 0.4,
                  color: Colors.grey.shade300,
                ),
                Row(
                  children: [
                    Expanded(
                        child: HomePageItemView(
                      mCallbackModel: mPromoterHomeViewScreenModel
                          .mPromoterHomeViewScreenModelCallbackModel,
                      imageAssets: ImageAssetsConstants.homeItemSold,
                      sTitle: AppConstants.cWordConstants.wItemsSold_Text,
                      sSubTitle:
                          mGetPromoterHomeResponse.thisMonthItemSold == "null"
                              ? "0"
                              : mGetPromoterHomeResponse.thisMonthItemSold
                                  .toString(),
                      sIcon: "",
                    )),
                    SizedBox(
                      width: SizeConstants.s1 * 15,
                    ),
                    Expanded(
                        child: HomePageItemView(
                            mCallbackModel: mPromoterHomeViewScreenModel
                                .mPromoterHomeViewScreenModelCallbackModel,
                            imageAssets: ImageAssetsConstants.homeComission,
                            sTitle: AppConstants.cWordConstants.wCommissionText,
                            sSubTitle: "",
                            sIcon: "time")),
                  ],
                ),
              ],
            )),
        SizedBox(
          height: SizeConstants.s1 * 15,
        ),
        Container(
            padding: EdgeInsets.all(SizeConstants.s1 * 15),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                  color: Colors.grey.shade200, width: SizeConstants.s1 * 1.25),
              borderRadius:
                  BorderRadius.all(Radius.circular(SizeConstants.s1 * 8)),
            ),
            child: Column(
              children: [
                Text(AppConstants.cWordConstants.wLastMonthText,
                    style: getTextMedium(
                        size: SizeConstants.s1 * 16, colors: Colors.black)),
                Container(
                  margin: EdgeInsets.only(
                      top: SizeConstants.s1 * 8, bottom: SizeConstants.s1 * 14),
                  height: SizeConstants.s1,
                  width: SizeConstants.width * 0.4,
                  color: Colors.grey.shade300,
                ),
                Row(
                  children: [
                    Expanded(
                        child: HomePageItemView(
                      mCallbackModel: mPromoterHomeViewScreenModel
                          .mPromoterHomeViewScreenModelCallbackModel,
                      sIcon: "",
                      imageAssets: ImageAssetsConstants.homeItemSold,
                      sTitle: AppConstants.cWordConstants.wItemsSold_Text,
                      sSubTitle:
                          mGetPromoterHomeResponse.lastMonthItemSold == "null"
                              ? "0"
                              : mGetPromoterHomeResponse.lastMonthItemSold
                                  .toString(),
                    )),
                    SizedBox(
                      width: SizeConstants.s1 * 15,
                    ),
                    Expanded(
                        child: HomePageItemView(
                            mCallbackModel: mPromoterHomeViewScreenModel
                                .mPromoterHomeViewScreenModelCallbackModel,
                            sIcon: "",
                            imageAssets: ImageAssetsConstants.homeComission,
                            sTitle: AppConstants.cWordConstants.wCommissionText,
                            sSubTitle: mGetPromoterHomeResponse
                                        .lastMonthCommissionAmount ==
                                    "null"
                                ? "RM0.00"
                                : "RM${mGetPromoterHomeResponse.lastMonthCommissionAmount}")),
                  ],
                ),
              ],
            )),
      ],
    );
  }
}
