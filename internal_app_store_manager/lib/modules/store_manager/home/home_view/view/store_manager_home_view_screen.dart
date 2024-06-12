import 'package:flutter/material.dart';
import 'package:internal_app_store_manager/constants/image_assets_constants.dart';
import 'package:internal_app_store_manager/modules/common/custom_navigation_drawer/custom_navigation_drawer_screen.dart';
import 'package:internal_app_store_manager/modules/store_manager/home/home_view/view/model/store_manager_home_view_model.dart';
import 'package:internal_app_store_manager/routes/route_constants.dart';
import 'package:internal_base/common/app_constants.dart';
import 'package:internal_base/common/appbars_constants.dart';
import 'package:internal_base/common/call_back.dart';
import 'package:internal_base/common/color_constants.dart';
import 'package:internal_base/common/size_constants.dart';
import 'package:internal_base/common/text_styles_constants.dart';
import 'package:internal_base/common/widget/dropdown_button_view/dropdown_button2.dart';
import 'package:internal_base/common/widget/home/home_page_item_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_home/bloc/store_manager_home_bloc.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_home/bloc/store_manager_home_state.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_home/repo/store_manager_home_response.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_profile_details/bloc/store_manager_profile_details_bloc.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_profile_details/bloc/store_manager_profile_details_state.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_profile_details/repo/store_manager_profile_details_response.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_stores_list/bloc/store_manager_stores_list_bloc.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_stores_list/bloc/store_manager_stores_list_state.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_stores_list/repo/store_manager_stores_list_response.dart';
import 'package:internal_base/common/phone_number_text_field/phone_number_validation.dart';

class StoreManagerHomeViewScreenWidget extends StatefulWidget {
  final CallbackModel mCallbackModel;

  const StoreManagerHomeViewScreenWidget(
      {super.key, required this.mCallbackModel});

  @override
  State<StoreManagerHomeViewScreenWidget> createState() =>
      _StoreManagerHomeViewScreenWidgetState();
}

class _StoreManagerHomeViewScreenWidgetState
    extends State<StoreManagerHomeViewScreenWidget> {
  late StoreManagerHomeViewScreenModel mStoreManagerHomeViewScreenModel;

  @override
  void initState() {
    mStoreManagerHomeViewScreenModel =
        StoreManagerHomeViewScreenModel(context, widget.mCallbackModel);
    mStoreManagerHomeViewScreenModel.setGetStoreManagerStoresListBloc();
    mStoreManagerHomeViewScreenModel.setGetStoreManagerHomeBloc();
    mStoreManagerHomeViewScreenModel.setStoreManagerProfileDetailsBloc();
    mStoreManagerHomeViewScreenModel.fetchGetStoreManagerProfileDetailsUrl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            key: mStoreManagerHomeViewScreenModel.scaffoldKey,
            appBar: PreferredSize(
                child: topBar(),
                preferredSize: Size.fromHeight(SizeConstants.s1 * 75)),
            drawer: CustomNavigationDrawer(
                mCallbackModel:
                    mStoreManagerHomeViewScreenModel.mCallbackModel),
            body: _buildSplashScreenWidgetView()));
  }

  _buildSplashScreenWidgetView() {
    return FocusDetector(
        child: SafeArea(
            child: MultiBlocListener(child: storeManagerHomeView(), listeners: [
      BlocListener<GetStoreManagerStoresListBloc,
          GetStoreManagerStoresListState>(
        bloc:
            mStoreManagerHomeViewScreenModel.getGetStoreManagerStoresListBloc(),
        listener: (context, state) {
          mStoreManagerHomeViewScreenModel.blocGetStoreManagerStoresListener(
              context, state);
        },
      ),
      BlocListener<GetStoreManagerHomeBloc, GetStoreManagerHomeState>(
        bloc: mStoreManagerHomeViewScreenModel.getGetStoreManagerHomeBloc(),
        listener: (context, state) {
          mStoreManagerHomeViewScreenModel.blocGetStoreManagerHomeListener(
              context, state);
        },
      ),
      BlocListener<GetStoreManagerProfileDetailsBloc,
          GetStoreManagerProfileDetailsState>(
        bloc: mStoreManagerHomeViewScreenModel
            .getStoreManagerProfileDetailsBloc(),
        listener: (context, state) {
          mStoreManagerHomeViewScreenModel
              .blocGetStoreManagerProfileDetailsListener(context, state);
        },
      ),
    ])));
  }

  topBar() {
    return StreamBuilder<GetStoreManagerProfileDetailsResponse?>(
      stream: mStoreManagerHomeViewScreenModel.responseSubjectProfileDetails,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          GetStoreManagerProfileDetailsResponse
              mGetStoreManagerProfileDetailsResponse =
              snapshot.data as GetStoreManagerProfileDetailsResponse;
          StoreManagerDetails mStoreManagerDetails =
              mGetStoreManagerProfileDetailsResponse.storeManagerDetails!;

          return AppBars.appBar((value) {
            if (value == AppConstants.cWordConstants.wMenuText) {
              mStoreManagerHomeViewScreenModel.scaffoldKey.currentState!
                  .openDrawer();
            } else {
              Navigator.pushReplacementNamed(context,
                  RouteConstants.rStoreManagerProfileSettingsScreenWidget,
                  arguments: mStoreManagerHomeViewScreenModel.mCallbackModel);
            }
          }, mStoreManagerDetails.username ?? "--",
              sMenu: AppConstants.cWordConstants.wMenuText);
        }

        return AppBars.appBar((value) {
          if (value == AppConstants.cWordConstants.wMenuText) {
            mStoreManagerHomeViewScreenModel.scaffoldKey.currentState!
                .openDrawer();
          } else {
            Navigator.pushReplacementNamed(context,
                RouteConstants.rStoreManagerProfileSettingsScreenWidget,
                arguments: mStoreManagerHomeViewScreenModel.mCallbackModel);
          }
        }, "Home", sMenu: AppConstants.cWordConstants.wMenuText);
      },
    );
  }

  storeManagerHomeView() {
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
      child: RefreshIndicator(
          onRefresh: mStoreManagerHomeViewScreenModel.refresh,
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
          )),
    );
  }

  topDropdown() {
    return StreamBuilder<Stores?>(
      stream: mStoreManagerHomeViewScreenModel.responseSubjectSelectStore,
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
          items: mStoreManagerHomeViewScreenModel.createList(),
          value: mStores,
          onChanged: (value) {
            setState(() {
              Stores mStores = value as Stores;
              mStoreManagerHomeViewScreenModel.mSelectStore = mStores;
              mStoreManagerHomeViewScreenModel
                  .fetchGetStoreManagerHomeUrl(mStores);
              mStoreManagerHomeViewScreenModel.setSelectStore(mStores);
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
    return StreamBuilder<GetStoreManagerHomeResponse?>(
      stream: mStoreManagerHomeViewScreenModel.responseSubject,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          GetStoreManagerHomeResponse mGetStoreManagerHomeResponse =
              snapshot.data as GetStoreManagerHomeResponse;
          return homeViewStreamBuilder(mGetStoreManagerHomeResponse);
        }
        return const SizedBox();
      },
    );
  }

  homeViewStreamBuilder(
      GetStoreManagerHomeResponse mGetStoreManagerHomeResponse) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(
              top: SizeConstants.s1 * 10,
              bottom: SizeConstants.s1 * 15,
              left: SizeConstants.s1 * 15,
              right: SizeConstants.s1 * 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppConstants.cWordConstants.wOverviewText,
                  style: getTextSemiBold(
                      size: SizeConstants.s1 * 17, colors: Colors.black)),
            ],
          ),
        ),
        Container(
            margin: const EdgeInsets.only(left: 15, right: 15),
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
                Text(AppConstants.cWordConstants.wTodayText,
                    style: getTextSemiBold(
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
                            mCallbackModel: mStoreManagerHomeViewScreenModel
                                .mStoreManagerHomeViewScreenModelCallbackModel,
                            sIcon: "",
                            imageAssets: ImageAssetsConstants.homeSalesCount,
                            sTitle: AppConstants.cWordConstants.wTotalReceipts,
                            sSubTitle: (mGetStoreManagerHomeResponse
                                        .today!.totalReceipts ??
                                    "0")
                                .toString())),
                    SizedBox(
                      width: SizeConstants.s1 * 15,
                    ),
                    Expanded(
                        child: HomePageItemView(
                      mCallbackModel: mStoreManagerHomeViewScreenModel
                          .mStoreManagerHomeViewScreenModelCallbackModel,
                      sIcon: "",
                      imageAssets: ImageAssetsConstants.homeComission,
                      sTitle: AppConstants.cWordConstants.wNetSales,
                      sSubTitle:
                          "RM ${(mGetStoreManagerHomeResponse.today!.netSales ?? "0.00").toString()}",
                    )),
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
                Text(AppConstants.cWordConstants.wThisMonthText,
                    style: getTextSemiBold(
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
                            mCallbackModel: mStoreManagerHomeViewScreenModel
                                .mStoreManagerHomeViewScreenModelCallbackModel,
                            sIcon: "",
                            imageAssets: ImageAssetsConstants.homeSalesCount,
                            sTitle: AppConstants.cWordConstants.wTotalReceipts,
                            sSubTitle: (mGetStoreManagerHomeResponse
                                        .thisMonth!.totalReceipts ??
                                    "0")
                                .toString())),
                    SizedBox(
                      width: SizeConstants.s1 * 15,
                    ),
                    Expanded(
                        child: HomePageItemView(
                            mCallbackModel: mStoreManagerHomeViewScreenModel
                                .mStoreManagerHomeViewScreenModelCallbackModel,
                            sIcon: "",
                            imageAssets: ImageAssetsConstants.homeComission,
                            sTitle: AppConstants.cWordConstants.wNetSales,
                            sSubTitle:
                                "RM ${(mGetStoreManagerHomeResponse.thisMonth!.netSales ?? "0.00").toString()}")),
                  ],
                ),
              ],
            )),
        SizedBox(
          height: SizeConstants.s1 * 15,
        ),
        // phoneNumberTextField(),
      ],
    );
  }
}
