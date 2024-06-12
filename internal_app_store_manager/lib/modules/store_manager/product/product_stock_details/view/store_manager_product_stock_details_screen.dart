import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:internal_app_store_manager/modules/store_manager/product/product_stock_details/model/store_manager_product_stock_details_model.dart';
import 'package:internal_app_store_manager/modules/store_manager/product/product_stock_details/view/store_manager_product_stock_list_row.dart';
import 'package:internal_base/common/app_constants.dart';
import 'package:internal_base/common/appbar_action_constants.dart';
import 'package:internal_base/common/appbars_constants.dart';
import 'package:internal_base/common/call_back.dart';
import 'package:internal_base/common/size_constants.dart';
import 'package:internal_base/common/text_styles_constants.dart';
import 'package:internal_base/common/widget/edit_text_field.dart';
import 'package:internal_base/common/widget/no_data_found_widget.dart';
import 'package:internal_base/common/widget/pull_to_refresh_header_widget.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_products_stock_list/bloc/store_manager_products_stock_list_bloc.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_products_stock_list/bloc/store_manager_products_stock_list_state.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_products_stock_list/repo/store_manager_products_stock_list_response.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoreManagerProductStockDetailsScreenWidget extends StatefulWidget {
  final CallbackModel mCallbackModel;

  const StoreManagerProductStockDetailsScreenWidget(
      {super.key, required this.mCallbackModel});

  @override
  State<StoreManagerProductStockDetailsScreenWidget> createState() =>
      _StoreManagerProductStockDetailsScreenWidgetState();
}

class _StoreManagerProductStockDetailsScreenWidgetState
    extends State<StoreManagerProductStockDetailsScreenWidget> {
  late StoreManagerProductStockDetailsScreenModel
      mStoreManagerProductStockDetailsScreenModel;

  @override
  void initState() {
    mStoreManagerProductStockDetailsScreenModel =
        StoreManagerProductStockDetailsScreenModel(context, widget.mCallbackModel);

    mStoreManagerProductStockDetailsScreenModel.setStoreManagerProductsStockListBloc();
    mStoreManagerProductStockDetailsScreenModel.onInitial();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBars.appBarBack((value) {
          if (value == AppBarActionConstants.actionBack) {
            Navigator.pop(context);
          }
        }, AppConstants.cWordConstants.wStockDetailsText),
        body: _buildSplashScreenWidgetView());
  }

  _buildSplashScreenWidgetView() {
    return FocusDetector(
        child: SafeArea(
          child: Container(
              height: SizeConstants.height,
              width: SizeConstants.width,
              padding: EdgeInsets.only(top: SizeConstants.s1 * 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(SizeConstants.s1 * 20),
                    topLeft: Radius.circular(SizeConstants.s1 * 20),
                  )),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(
                        left: SizeConstants.s1 * 25,
                        top: SizeConstants.s1 * 5,
                        bottom: SizeConstants.s1 * 10),
                    child: Text(AppConstants.cWordConstants.wStockText,
                        style: getTextSemiBold(
                            size: SizeConstants.s1 * 17, colors: Colors.black)),
                  ),

                  ///stock View
                  stockView(),
                ],
              )),
        ));
  }

  stockView() {
    return Expanded(
        child: Container(
          margin: EdgeInsets.only(
              left: SizeConstants.s1 * 25,
              right: SizeConstants.s1 * 25,
              bottom: SizeConstants.s1 * 10),
          padding: EdgeInsets.all(SizeConstants.s1 * 15),
          width: SizeConstants.width,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
                color: Colors.grey.shade200, width: SizeConstants.s1 * 1.25),
            borderRadius: BorderRadius.all(Radius.circular(SizeConstants.s1 * 8)),
          ),
          child: Column(
            children: [
              ///search
              editSearchText(
                  mStoreManagerProductStockDetailsScreenModel
                      .mSearchTextEditingController, () {
                mStoreManagerProductStockDetailsScreenModel.onInitial();
              },
                  labelText: AppConstants.cWordConstants.wSearchText,
                  hintText: AppConstants.cWordConstants.wPleaseEnterSearchText,
                  mIcons: Icons.search),

              ///list
              Expanded(child: listView())
            ],
          ),
        ));
  }

  listView() {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.only(
                top: SizeConstants.s1 * 20,
                left: SizeConstants.s1 * 5,
                right: SizeConstants.s1 * 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Location",
                    style: getTextSemiBold(
                        size: SizeConstants.s1 * 15, colors: Colors.black)),
                Text(AppConstants.cWordConstants.wStockText,
                    style: getTextSemiBold(
                        size: SizeConstants.s1 * 15, colors: Colors.black)),
              ],
            )),
        Expanded(
            child: Container(
                margin: EdgeInsets.only(
                    left: SizeConstants.s1 * 5,
                    right: SizeConstants.s1 * 5,
                    bottom: SizeConstants.s1 * 3,
                    top: SizeConstants.s1 * 8),
                padding: EdgeInsets.all(SizeConstants.s1 * 15),
                width: SizeConstants.width,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                      color: Colors.grey.shade200,
                      width: SizeConstants.s1 * 1.25),
                  borderRadius:
                  BorderRadius.all(Radius.circular(SizeConstants.s1 * 8)),
                ),
                child: MultiBlocListener(child: getListView(), listeners: [
                  BlocListener<GetStoreManagerProductsStockListBloc,
                      GetStoreManagerProductsStockListState>(
                    bloc: mStoreManagerProductStockDetailsScreenModel
                        .getStoreManagerProductsStockListBloc(),
                    listener: (context, state) {
                      mStoreManagerProductStockDetailsScreenModel
                          .storeManagerProductsStockListListener(context, state);
                    },
                  ),
                ])

              // view(),
            ))
      ],
    );
  }

  getListView() {
    return StreamBuilder<GetStoreManagerProductsStockListResponse?>(
      stream: mStoreManagerProductStockDetailsScreenModel.responseSubject,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          GetStoreManagerProductsStockListResponse
          mGetStoreManagerProductsStockListResponse =
          snapshot.data as GetStoreManagerProductsStockListResponse;
          if (mGetStoreManagerProductsStockListResponse.storeStock != null ) {
            return setView(mGetStoreManagerProductsStockListResponse.lastPage ?? 0,
                mGetStoreManagerProductsStockListResponse.totalRecords ?? 0);
          }
        }
        return Container();
      },
    );
  }

  setView(int lastPage, int totalRecords) {
    return SmartRefresher(
      controller: mStoreManagerProductStockDetailsScreenModel.refreshController,
      onLoading: mStoreManagerProductStockDetailsScreenModel.onLoading,
      onRefresh: mStoreManagerProductStockDetailsScreenModel.onRefresh,

      /// load more
      enablePullUp: mStoreManagerProductStockDetailsScreenModel.sPage < lastPage,

      /// pull to refresh
      enablePullDown: true,
      footer: CustomFooter(builder: (context, loadStatus) {
        return customFooter(loadStatus);
      }),
      header: waterDropHeader(),
      child: mStoreManagerProductStockDetailsScreenModel.storeStockList.isNotEmpty
          ? ListView.builder(
          padding: const EdgeInsets.all(0),
          itemCount:
          mStoreManagerProductStockDetailsScreenModel.storeStockList.length,
          itemBuilder: (BuildContext context, int index) {
            return StoreManagerProductsStockListRowWidget(
                index,
                mStoreManagerProductStockDetailsScreenModel,
                mStoreManagerProductStockDetailsScreenModel
                    .storeStockList[index]);
          })
          : Container(
          height: SizeConstants.height * 0.55,
          alignment: Alignment.center,
          child: NoDataFoundWidget(
            isLoadedAndEmpty: mStoreManagerProductStockDetailsScreenModel
                .storeStockList.isEmpty,
          )),
    );
  }
}
