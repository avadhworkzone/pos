import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:internal_app_warehose_manager/constants/image_assets_constants.dart';
import 'package:internal_app_warehose_manager/modules/warehouse_manager/product/product_details/model/warehouse_manager_product_details_model.dart';
import 'package:internal_app_warehose_manager/routes/route_constants.dart';
import 'package:internal_base/common/app_constants.dart';
import 'package:internal_base/common/appbar_action_constants.dart';
import 'package:internal_base/common/appbars_constants.dart';
import 'package:internal_base/common/button_constants.dart';
import 'package:internal_base/common/call_back.dart';
import 'package:internal_base/common/color_constants.dart';
import 'package:internal_base/common/size_constants.dart';
import 'package:internal_base/common/text_styles_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_products_details/bloc/warehouse_manager_products_details_bloc.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_products_details/bloc/warehouse_manager_products_details_state.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_products_details/repo/warehouse_manager_products_details_response.dart';

class WarehouseManagerProductDetailsScreenWidget extends StatefulWidget {
  final CallbackModel mCallbackModel;

  const WarehouseManagerProductDetailsScreenWidget(
      {super.key, required this.mCallbackModel});

  @override
  State<WarehouseManagerProductDetailsScreenWidget> createState() =>
      _WarehouseManagerProductDetailsScreenWidgetState();
}

class _WarehouseManagerProductDetailsScreenWidgetState
    extends State<WarehouseManagerProductDetailsScreenWidget> {
  late WarehouseManagerProductDetailsScreenModel
      mWarehouseManagerProductDetailsScreenModel;

  @override
  void initState() {
    mWarehouseManagerProductDetailsScreenModel =
        WarehouseManagerProductDetailsScreenModel(context, widget.mCallbackModel);
    mWarehouseManagerProductDetailsScreenModel.setGetWarehouseManagerProductsDetailsBloc();
    mWarehouseManagerProductDetailsScreenModel.getSharedPrefsSelectStore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBars.appBarBack((value) {
          if (value == AppBarActionConstants.actionBack) {
            Navigator.pop(context);
          }
        }, AppConstants.cWordConstants.wProductDetailsText),
        body: _buildSplashScreenWidgetView());
  }

  _buildSplashScreenWidgetView() {
    return FocusDetector(
        child: SafeArea(
            child: MultiBlocListener(child: productDetailsView(), listeners: [
              BlocListener<GetWarehouseManagerProductsDetailsBloc,
                  GetWarehouseManagerProductsDetailsState>(
                bloc:
                mWarehouseManagerProductDetailsScreenModel.getWarehouseManagerProductsDetailsBloc(),
                listener: (context, state) {
                  mWarehouseManagerProductDetailsScreenModel
                      .blocGetWarehouseManagerProductsDetailsListener(context, state);
                },
              ),
            ])));
  }

  productDetailsView() {
    return StreamBuilder<GetWarehouseManagerProductsDetailsResponse?>(
      stream: mWarehouseManagerProductDetailsScreenModel.responseSubject,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          GetWarehouseManagerProductsDetailsResponse
          mGetWarehouseManagerProductsDetailsResponse =
          snapshot.data as GetWarehouseManagerProductsDetailsResponse;
          return warehouseManagerProductDetailsView(
              mGetWarehouseManagerProductsDetailsResponse);
        }
        return const SizedBox();
      },
    );
  }

  warehouseManagerProductDetailsView(
      GetWarehouseManagerProductsDetailsResponse mGetWarehouseManagerProductsDetailsResponse) {
    return FocusDetector(
        child: SafeArea(
          child: Container(
              height: SizeConstants.height,
              width: SizeConstants.width,
              padding: EdgeInsets.only(
                  bottom: SizeConstants.s1 * 95, top: SizeConstants.s1 * 15),
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
                    Container(
                      margin: EdgeInsets.only(
                          left: SizeConstants.s1 * 25,
                          top: SizeConstants.s1 * 10,
                          bottom: SizeConstants.s1 * 15),
                      child: Row(
                        children: [
                          Text(AppConstants.cWordConstants.wDetailsText,
                              style: getTextSemiBold(
                                  size: SizeConstants.s1 * 16,
                                  colors: Colors.black)),
                        ],
                      ),
                    ),

                    ///details View
                    detailsView(
                        mGetWarehouseManagerProductsDetailsResponse.productDetails),

                    Container(
                      margin: EdgeInsets.only(
                          left: SizeConstants.s1 * 25,
                          top: SizeConstants.s1 * 10,
                          bottom: SizeConstants.s1 * 15),
                      child: Row(
                        children: [
                          Text(AppConstants.cWordConstants.wStockText,
                              style: getTextSemiBold(
                                  size: SizeConstants.s1 * 16,
                                  colors: Colors.black)),
                        ],
                      ),
                    ),

                    /// stock
                    stockView(mGetWarehouseManagerProductsDetailsResponse.stock ?? 0),
                  ],
                ),
              )),
        ));
  }

  detailsView(ProductDetails? mProductDetails) {
    return Container(
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
      child: mProductDetails == null
          ? const SizedBox()
          : Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppConstants.cWordConstants.wNameText,
                  style: getTextLight(
                      size: SizeConstants.s1 * 14, colors: Colors.black)),
              Expanded(
                  child: Text(mProductDetails.name ?? "-",
                      style: getTextSemiBold(
                          size: SizeConstants.s1 * 15,
                          colors: Colors.black))),
            ],
          ),
          SizedBox(
            height: SizeConstants.s1 * 5,
          ),
          Row(
            children: [
              Text(AppConstants.cWordConstants.wArticleNumberText,
                  style: getTextLight(
                      size: SizeConstants.s1 * 14, colors: Colors.black)),
              Text(mProductDetails.articleNumber ?? "--",
                  style: getTextSemiBold(
                      size: SizeConstants.s1 * 15, colors: Colors.black)),
            ],
          ),
          SizedBox(
            height: SizeConstants.s1 * 5,
          ),
          Row(
            children: [
              Text(AppConstants.cWordConstants.wPriceText,
                  style: getTextLight(
                      size: SizeConstants.s1 * 14, colors: Colors.black)),
              Text("RM${mProductDetails.retailPrice ?? "-"}",
                  style: getTextSemiBold(
                      size: SizeConstants.s1 * 15, colors: Colors.black)),
            ],
          ),
          SizedBox(
            height: SizeConstants.s1 * 5,
          ),
          Row(
            children: [
              Text(AppConstants.cWordConstants.wColorText,
                  style: getTextLight(
                      size: SizeConstants.s1 * 14, colors: Colors.black)),
              Text(mProductDetails.color ?? "-",
                  style: getTextSemiBold(
                      size: SizeConstants.s1 * 15, colors: Colors.black)),
            ],
          ),
          SizedBox(
            height: SizeConstants.s1 * 5,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppConstants.cWordConstants.wCategoriesText,
                  style: getTextLight(
                      size: SizeConstants.s1 * 14, colors: Colors.black)),
              Expanded(
                  child:
                  Text(
                      mProductDetails.categories == null
                          ? "-"
                          : (mProductDetails.categories!.isEmpty
                          ? "-"
                          : (mProductDetails.categories!.first.name ??
                          "-")),
                      style: getTextSemiBold(
                          size: SizeConstants.s1 * 15, colors: Colors.black))),
            ],
          ),
          SizedBox(
            height: SizeConstants.s1 * 5,
          ),
          Row(
            children: [
              Text(AppConstants.cWordConstants.wBrandText,
                  style: getTextLight(
                      size: SizeConstants.s1 * 14, colors: Colors.black)),
              Text(mProductDetails.brand ?? "-",
                  style: getTextSemiBold(
                      size: SizeConstants.s1 * 15, colors: Colors.black)),
            ],
          ),
          SizedBox(
            height: SizeConstants.s1 * 5,
          ),
          Row(
            children: [
              Text(AppConstants.cWordConstants.wUPCText,
                  style: getTextLight(
                      size: SizeConstants.s1 * 14, colors: Colors.black)),
              Text(mProductDetails.upc ?? "--",
                  style: getTextSemiBold(
                      size: SizeConstants.s1 * 15, colors: Colors.black)),
            ],
          ),
          SizedBox(
            height: SizeConstants.s1 * 5,
          ),
          Row(
            children: [
              Text(AppConstants.cWordConstants.wSizeText,
                  style: getTextLight(
                      size: SizeConstants.s1 * 14, colors: Colors.black)),
              Text(mProductDetails.size ?? "-",
                  style: getTextSemiBold(
                      size: SizeConstants.s1 * 15, colors: Colors.black)),
            ],
          ),
        ],
      ),
    );
  }

  stockView(int iStock) {
    return Container(
      margin: EdgeInsets.only(
          left: SizeConstants.s1 * 20,
          right: SizeConstants.s1 * 20,
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
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // warehouseManagerStockWarehouse
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: SizeConstants.s1 * 28,
                width: SizeConstants.s1 * 28,
                child: Image(
                  image: AssetImage(
                      ImageAssetsConstants.warehouseManagerStockWarehouse),
                ),
              ),
              SizedBox(
                width: SizeConstants.s1 * 10,
              ),
              Text(
                  mWarehouseManagerProductDetailsScreenModel.mSelectStore!.name ?? "--",
                  style: getTextRegular(
                      size: SizeConstants.s1 * 18, colors: Colors.black)),
              SizedBox(
                width: SizeConstants.s1 * 5,
              ),
              Text("$iStock",
                  style: getTextSemiBold(
                      size: SizeConstants.s1 * 17, colors: Colors.black)),
            ],
          ),
          SizedBox(
            height: SizeConstants.s1 * 15,
          ),
          mediumRoundedCornerButton(
            appbarActionInterface: (value) {
              Navigator.pushReplacementNamed(context,
                  RouteConstants.rWarehouseManagerProductStockDetailsScreenWidget,
                  arguments: mWarehouseManagerProductDetailsScreenModel.mCallbackModel);
            },
            sButtonTitle: AppConstants.cWordConstants.wStockInOthers,
            dButtonWidth: SizeConstants.s1 * 250,
            cButtonTextColor: Colors.white,
            cButtonBackGroundColor: ColorConstants.kPrimaryColor,
            dButtonTextSize: SizeConstants.s1 * 15,
          ),
        ],
      ),
    );
  }
}
