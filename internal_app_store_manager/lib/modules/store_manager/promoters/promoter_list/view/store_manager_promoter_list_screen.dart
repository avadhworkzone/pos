import 'package:flutter/material.dart';
import 'package:internal_base/common/app_constants.dart';
import 'package:internal_base/common/appbars_constants.dart';
import 'package:internal_base/common/call_back.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:internal_base/common/size_constants.dart';
import 'package:flutter_bloc/src/multi_bloc_listener.dart';
import 'package:internal_base/common/text_styles_constants.dart';
import 'package:internal_base/common/widget/pull_to_refresh_header_widget.dart';
import 'package:pull_to_refresh/src/smart_refresher.dart';
import 'package:internal_base/common/widget/no_data_found_widget.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_promoter_list/bloc/store_manager_promoter_list_bloc.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_promoter_list/bloc/store_manager_promoter_list_state.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_promoter_list/repo/store_manager_promoter_list_response.dart';
import '../../../../common/custom_navigation_drawer/custom_navigation_drawer_screen.dart';
import '../model/store_manager_promoter_list_model.dart';
import 'package:flutter_bloc/src/bloc_listener.dart';
import 'package:pull_to_refresh/src/indicator/custom_indicator.dart';

class StoreManagerPromoterListScreen extends StatefulWidget {
  const StoreManagerPromoterListScreen({Key? key, required this.mCallbackModel})
      : super(key: key);
  final CallbackModel mCallbackModel;

  @override
  State<StoreManagerPromoterListScreen> createState() =>
      _PromoterListScreenState();
}

class _PromoterListScreenState extends State<StoreManagerPromoterListScreen> {
  late StoreManagerPromoterListScreenModel mStoreManagerPromoterListScreenModel;

  @override
  void initState() {
    mStoreManagerPromoterListScreenModel =
        StoreManagerPromoterListScreenModel(context, widget.mCallbackModel);
    mStoreManagerPromoterListScreenModel.setStoreManagerPromoterListBloc();
    mStoreManagerPromoterListScreenModel.getSharedPrefsSelectStore();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            key: mStoreManagerPromoterListScreenModel.scaffoldKey,
            appBar: AppBars.appBar((value) async {
              if (value == "Menu") {
                mStoreManagerPromoterListScreenModel.scaffoldKey.currentState!
                    .openDrawer();
              } else {
                // var res = await AppAlert.showFilterDialog(context, "sTitle",
                //     AppConstants.cWordConstants.wDilogMessage);
                // if (res.isNotEmpty) {
                //   mStoreManagerPromoterListScreenModel.mFilterValue =
                //       FilterValue.fromJson(json.decode(res));
                //   mStoreManagerPromoterListScreenModel.onInitial();
                // }
              }
            }, AppConstants.cWordConstants.wPromoterText,
                // iconOne: AppBarActionConstants.actionFilter,
                // sImageAssetsOne: ImageAssetsConstants.filter,
                sMenu: AppConstants.cWordConstants.wMenuText),
            drawer: CustomNavigationDrawer(
                mCallbackModel:
                    mStoreManagerPromoterListScreenModel.mCallbackModel),
            body: _buildSplashScreenWidgetView()));
  }

  _buildSplashScreenWidgetView() {
    return FocusDetector(
        child: SafeArea(
      child: Container(
          height: SizeConstants.height,
          width: SizeConstants.width,
          padding: EdgeInsets.only(top: SizeConstants.s1 * 15),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(SizeConstants.s1 * 20),
                topLeft: Radius.circular(SizeConstants.s1 * 20),
              )),
          child: MultiBlocListener(child: getListView(), listeners: [
            BlocListener<GetStoreManagerPromoterListBloc,
                GetStoreManagerPromoterListState>(
              bloc: mStoreManagerPromoterListScreenModel
                  .getStoreManagerProductsListBloc(),
              listener: (context, state) {
                mStoreManagerPromoterListScreenModel
                    .storeManagerPromotersListListener(context, state);
              },
            ),
          ])),
    ));
  }

  getListView() {
    return StreamBuilder<GetStoreManagerPromoterListResponse?>(
      stream: mStoreManagerPromoterListScreenModel.responseSubject,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          GetStoreManagerPromoterListResponse
              mGetStoreManagerPromoterListResponse =
              snapshot.data as GetStoreManagerPromoterListResponse;
          if (mGetStoreManagerPromoterListResponse.promoters != null) {
            return setView();
          }
        }
        return Container(
            height: SizeConstants.height * 0.75,
            alignment: Alignment.center,
            child: const NoDataFoundWidget(
              isLoadedAndEmpty: true,
            ));
      },
    );
  }

  setView() {
    return Column(
      children: [
        // mStoreManagerPromoterListScreenModel.promoterList.isNotEmpty
        //     ? Container(
        //   margin: EdgeInsets.only(
        //       left: SizeConstants.s1 * 25,
        //       top: SizeConstants.s1 * 10,
        //       bottom: SizeConstants.s1 * 8),
        //   child: Row(
        //     children: [
        //       Text(AppConstants.cWordConstants.wCountsText,
        //           style: getTextLight(
        //               size: SizeConstants.s1 * 15, colors: Colors.black)),
        //       SizedBox(
        //         width: SizeConstants.s1 * 5,
        //       ),
        //       Text("$totalRecords",
        //           style: getTextSemiBold(
        //               size: SizeConstants.s1 * 15, colors: Colors.black)),
        //     ],
        //   ),
        // )
        //     : const SizedBox(),
        // (mStoreManagerProductListScreenModel.mFilterValue.text!.isNotEmpty ||
        //     mStoreManagerProductListScreenModel
        //         .mFilterValue.sStock!.isNotEmpty)
        //     ? Container(
        //   width: SizeConstants.width,
        //   alignment: Alignment.centerRight,
        //   margin: EdgeInsets.only(
        //       right: SizeConstants.s1 * 25,
        //       left: SizeConstants.s1 * 65,
        //       bottom: SizeConstants.s1 * 0),
        //   child: RichText(
        //     maxLines: 1,
        //     overflow: TextOverflow.ellipsis,
        //     text: TextSpan(
        //         text: 'Results for',
        //         style: getTextRegular(
        //             size: SizeConstants.s1 * 12, colors: Colors.black),
        //         children: <TextSpan>[
        //           TextSpan(
        //               text: mStoreManagerProductListScreenModel
        //                   .mFilterValue.text!.isNotEmpty
        //                   ? ' ${mStoreManagerProductListScreenModel.mFilterValue.text} :'
        //                   : "",
        //               style: getTextRegular(
        //                   size: SizeConstants.s1 * 12,
        //                   colors: ColorConstants.cOutOfStockTextColor),
        //               recognizer: TapGestureRecognizer()
        //                 ..onTap = () {
        //                   // navigate to desired screen
        //                 }),
        //           TextSpan(
        //               text: mStoreManagerProductListScreenModel
        //                   .mFilterValue.sStock!.isNotEmpty
        //                   ? (mStoreManagerProductListScreenModel
        //                   .mFilterValue.sStock ==
        //                   "0"
        //                   ? ' No Stock products'
        //                   : " All Stock products")
        //                   : "",
        //               style: getTextRegular(
        //                   size: SizeConstants.s1 * 12,
        //                   colors: ColorConstants.cOutOfStockTextColor),
        //               recognizer: TapGestureRecognizer()
        //                 ..onTap = () {
        //                   // navigate to desired screen
        //                 })
        //         ]),
        //   ),
        // )
        //     : const SizedBox(),
        Expanded(
            child: SmartRefresher(
          controller: mStoreManagerPromoterListScreenModel.refreshController,
          onLoading: mStoreManagerPromoterListScreenModel.onLoading,
          onRefresh: mStoreManagerPromoterListScreenModel.onRefresh,

          /// load more
          // enablePullUp: mStoreManagerPromoterListScreenModel.sPage < lastPage,

          /// pull to refresh
          enablePullDown: true,
          footer: CustomFooter(builder: (context, loadStatus) {
            return customFooter(loadStatus);
          }),
          header: waterDropHeader(),
          child: mStoreManagerPromoterListScreenModel.promoterList.isNotEmpty
              ? ListView.builder(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  itemCount:
                      mStoreManagerPromoterListScreenModel.promoterList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.only(
                          top: SizeConstants.s1 * 10,
                          left: SizeConstants.s1 * 20,
                          right: SizeConstants.s1 * 20,
                          bottom: SizeConstants.s1 * 10),
                      padding: EdgeInsets.all(SizeConstants.s1 * 15),
                      width: SizeConstants.width,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                            color: Colors.grey.shade200,
                            width: SizeConstants.s1 * 1.25),
                        borderRadius: BorderRadius.all(
                            Radius.circular(SizeConstants.s1 * 8)),
                      ),
                      child: Column(
                        children: [
                          mStoreManagerPromoterListScreenModel
                                          .promoterList[index].stores ==
                                      null ||
                                  mStoreManagerPromoterListScreenModel
                                      .promoterList[index].stores!.isEmpty
                              ? const SizedBox()
                              : Row(children: [
                                  Text(
                                    'Store Name: ',
                                    style: getTextLight(
                                        size: SizeConstants.s1 * 14,
                                        colors: Colors.black),
                                  ),
                                  mStoreManagerPromoterListScreenModel
                                                  .promoterList[index].stores ==
                                              [] ||
                                          mStoreManagerPromoterListScreenModel
                                              .promoterList[index]
                                              .stores!
                                              .isEmpty
                                      ? const SizedBox()
                                      : Row(
                                          children: List.generate(
                                              mStoreManagerPromoterListScreenModel
                                                  .promoterList[index]
                                                  .stores!
                                                  .length,
                                              (storeIndex) => Row(
                                                    children: [
                                                      Text(
                                                          '${mStoreManagerPromoterListScreenModel.promoterList[index].stores![storeIndex].name}${mStoreManagerPromoterListScreenModel.promoterList[index].stores!.length > 1 ? ', ' : ''}',
                                                          style: getTextSemiBold(
                                                              size:
                                                                  SizeConstants
                                                                          .s1 *
                                                                      15,
                                                              colors:
                                                                  Colors.black))
                                                    ],
                                                  )),
                                        )
                                ]),
                          Row(
                            children: [
                              Text(
                                  AppConstants
                                      .cWordConstants.wPromotersNameText,
                                  style: getTextLight(
                                      size: SizeConstants.s1 * 14,
                                      colors: Colors.black)),
                              Expanded(
                                  child: Text(
                                      mStoreManagerPromoterListScreenModel
                                              .promoterList[index].name ??
                                          "",
                                      style: getTextSemiBold(
                                          size: SizeConstants.s1 * 15,
                                          colors: Colors.black))),
                            ],
                          ),
                        ],
                      ),
                    );
                    //   Column(
                    //   children: [
                    //     Text(
                    //         '${mStoreManagerPromoterListScreenModel.promoterList[index].name}')
                    //   ],
                    // );
                    ///
                    // StoreManagerProductListRowWidget(
                    //   index,
                    //   mStoreManagerProductListScreenModel,
                    //   mStoreManagerProductListScreenModel
                    //       .productsList[index]);
                  })
              : Container(
                  height: SizeConstants.height * 0.75,
                  alignment: Alignment.center,
                  child: NoDataFoundWidget(
                    isLoadedAndEmpty: mStoreManagerPromoterListScreenModel
                        .promoterList.isEmpty,
                  )),
        ))
      ],
    );
  }
}
