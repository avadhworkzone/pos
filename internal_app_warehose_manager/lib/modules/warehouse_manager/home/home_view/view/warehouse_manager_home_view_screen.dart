import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:internal_app_warehose_manager/constants/image_assets_constants.dart';
import 'package:internal_app_warehose_manager/modules/common/custom_navigation_drawer/custom_navigation_drawer_screen.dart';
import 'package:internal_app_warehose_manager/modules/warehouse_manager/home/home_view/view/model/warehouse_manager_home_view_model.dart';
import 'package:internal_app_warehose_manager/routes/route_constants.dart';
import 'package:internal_base/common/app_constants.dart';
import 'package:internal_base/common/appbars_constants.dart';
import 'package:internal_base/common/call_back.dart';
import 'package:internal_base/common/color_constants.dart';
import 'package:internal_base/common/size_constants.dart';
import 'package:internal_base/common/text_styles_constants.dart';
import 'package:internal_base/common/widget/dropdown_button_view/dropdown_button2.dart';
import 'package:internal_base/common/widget/home/home_page_item_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_home/bloc/warehouse_manager_home_bloc.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_home/bloc/warehouse_manager_home_state.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_home/repo/warehouse_manager_home_response.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_profile_details/bloc/warehouse_manager_profile_details_bloc.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_profile_details/bloc/warehouse_manager_profile_details_state.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_profile_details/repo/warehouse_manager_profile_details_response.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouses/bloc/get_warehouses_bloc.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouses/bloc/get_warehouses_state.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouses/repo/get_warehouses_response.dart';

class WarehouseManagerHomeViewScreenWidget extends StatefulWidget {
  final CallbackModel mCallbackModel;

  const WarehouseManagerHomeViewScreenWidget(
      {super.key, required this.mCallbackModel});

  @override
  State<WarehouseManagerHomeViewScreenWidget> createState() =>
      _WarehouseManagerHomeViewScreenWidgetState();
}

class _WarehouseManagerHomeViewScreenWidgetState
    extends State<WarehouseManagerHomeViewScreenWidget> {
  late WarehouseManagerHomeViewScreenModel mWarehouseManagerHomeViewScreenModel;

  @override
  void initState() {
    mWarehouseManagerHomeViewScreenModel =
        WarehouseManagerHomeViewScreenModel(context, widget.mCallbackModel);
    mWarehouseManagerHomeViewScreenModel.setGetWarehousesBloc();
    mWarehouseManagerHomeViewScreenModel.setGetWarehouseManagerHomeBloc();
    mWarehouseManagerHomeViewScreenModel
        .setWarehouseManagerProfileDetailsBloc();
    mWarehouseManagerHomeViewScreenModel
        .fetchGetWarehouseManagerProfileDetailsUrl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            key: mWarehouseManagerHomeViewScreenModel.scaffoldKey,
            appBar: PreferredSize(
                child: topBar(),
                preferredSize: Size.fromHeight(SizeConstants.s1 * 75)),
            drawer: CustomNavigationDrawer(
                mCallbackModel:
                    mWarehouseManagerHomeViewScreenModel.mCallbackModel),
            body: _buildSplashScreenWidgetView()));
  }

  _buildSplashScreenWidgetView() {
    return FocusDetector(
        child: SafeArea(
            child: MultiBlocListener(
                child: warehouseManagerHomeView(),
                listeners: [
          BlocListener<GetWarehousesBloc, GetWarehousesState>(
            bloc: mWarehouseManagerHomeViewScreenModel.getGetWarehousesBloc(),
            listener: (context, state) {
              mWarehouseManagerHomeViewScreenModel.blocGetWarehouse(
                  context, state);
            },
          ),
          BlocListener<GetWarehouseManagerHomeBloc,
              GetWarehouseManagerHomeState>(
            bloc: mWarehouseManagerHomeViewScreenModel
                .getGetWarehouseManagerHomeBloc(),
            listener: (context, state) {
              mWarehouseManagerHomeViewScreenModel
                  .blocGetWarehouseManagerHomeListener(context, state);
            },
          ),
          BlocListener<GetWarehouseManagerProfileDetailsBloc,
              GetWarehouseManagerProfileDetailsState>(
            bloc: mWarehouseManagerHomeViewScreenModel
                .getWarehouseManagerProfileDetailsBloc(),
            listener: (context, state) {
              mWarehouseManagerHomeViewScreenModel
                  .blocGetWarehouseManagerProfileDetailsListener(
                      context, state);
            },
          ),
        ])));
  }

  topBar() {
    return StreamBuilder<GetWarehouseManagerProfileDetailsResponse?>(
      stream:
          mWarehouseManagerHomeViewScreenModel.responseSubjectProfileDetails,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          GetWarehouseManagerProfileDetailsResponse
              mGetWarehouseManagerProfileDetailsResponse =
              snapshot.data as GetWarehouseManagerProfileDetailsResponse;
          WarehouseManagerDetails mWarehouseManagerDetails =
              mGetWarehouseManagerProfileDetailsResponse
                  .warehouseManagerDetails!;

          return AppBars.appBar((value) {
            if (value == AppConstants.cWordConstants.wMenuText) {
              mWarehouseManagerHomeViewScreenModel.scaffoldKey.currentState!
                  .openDrawer();
            } else {
              Navigator.pushReplacementNamed(context,
                  RouteConstants.rWarehouseManagerProfileSettingsScreenWidget,
                  arguments:
                      mWarehouseManagerHomeViewScreenModel.mCallbackModel);
            }
          }, mWarehouseManagerDetails.username ?? "--",
              sMenu: AppConstants.cWordConstants.wMenuText);
        }

        return AppBars.appBar((value) {
          if (value == AppConstants.cWordConstants.wMenuText) {
            mWarehouseManagerHomeViewScreenModel.scaffoldKey.currentState!
                .openDrawer();
          } else {
            Navigator.pushReplacementNamed(context,
                RouteConstants.rWarehouseManagerProfileSettingsScreenWidget,
                arguments: mWarehouseManagerHomeViewScreenModel.mCallbackModel);
          }
        }, "Home", sMenu: AppConstants.cWordConstants.wMenuText);
      },
    );
  }

  warehouseManagerHomeView() {
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
          onRefresh: mWarehouseManagerHomeViewScreenModel.refresh,
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
    return StreamBuilder<Warehouses?>(
      stream: mWarehouseManagerHomeViewScreenModel.responseSubjectSelectStore,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          Warehouses mStores = snapshot.data as Warehouses;
          return topDropdownStreamBuilder(mStores);
        }
        return const SizedBox();
      },
    );
  }

  topDropdownStreamBuilder(Warehouses mStores) {
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
          items: mWarehouseManagerHomeViewScreenModel.createList(),
          value: mStores,
          onChanged: (value) {
            setState(() {
              Warehouses mStores = value as Warehouses;
              mWarehouseManagerHomeViewScreenModel.mSelectStore = mStores;
              mWarehouseManagerHomeViewScreenModel
                  .fetchGetWarehouseManagerHomeUrl(mStores);
              mWarehouseManagerHomeViewScreenModel.setSelectStore(mStores);
            });
          },
          hint: Row(
            children: [
              Image(
                  height: SizeConstants.s1 * 25,
                  width: SizeConstants.s1 * 25,
                  image: AssetImage(ImageAssetsConstants.warehouseManagerStockWarehouse)),
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
    return StreamBuilder<GetWarehouseManagerHomeResponse?>(
      stream: mWarehouseManagerHomeViewScreenModel.responseSubject,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          GetWarehouseManagerHomeResponse mGetWarehouseManagerHomeResponse =
              snapshot.data as GetWarehouseManagerHomeResponse;
          return homeViewStreamBuilder(mGetWarehouseManagerHomeResponse);
        }
        return const SizedBox();
      },
    );
  }

  homeViewStreamBuilder(
      GetWarehouseManagerHomeResponse mGetWarehouseManagerHomeResponse) {
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
            margin: EdgeInsets.only(left: SizeConstants.s1 * 10, right: SizeConstants.s1 * 10),
            padding: EdgeInsets.fromLTRB(SizeConstants.s1 * 10, SizeConstants.s1 * 25, SizeConstants.s1 * 10, SizeConstants.s1 * 25),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                  color: Colors.grey.shade200, width: SizeConstants.s1 * 1.25),
              borderRadius:
                  BorderRadius.all(Radius.circular(SizeConstants.s1 * 8)),
            ),
            child: Column(
              children: [
                Text(AppConstants.cWordConstants.wStockDetailsText,
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
                            mCallbackModel: mWarehouseManagerHomeViewScreenModel
                                .mWarehouseManagerHomeViewScreenModelCallbackModel,
                            sIcon: "",
                            imageAssets: ImageAssetsConstants.homeSku,
                            sTitle: AppConstants.cWordConstants.wSKUManagedText,
                            sSubTitle:
                                mGetWarehouseManagerHomeResponse.skuManaged ??
                                    "0")),
                    SizedBox(
                      width: SizeConstants.s1 * 20,
                    ),
                    Expanded(
                        child: HomePageItemView(
                            mCallbackModel: mWarehouseManagerHomeViewScreenModel
                                .mWarehouseManagerHomeViewScreenModelCallbackModel,
                            sIcon: "",
                            imageAssets: ImageAssetsConstants.homeNoStock,
                            sTitle: AppConstants.cWordConstants.wNoStockText,
                            sSubTitle:
                                mGetWarehouseManagerHomeResponse.noStock ??
                                    "0")),
                  ],
                ),
              ],
            )),
      ],
    );
  }
}
