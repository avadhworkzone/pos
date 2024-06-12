import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:internal_app_promoter/modules/promoter/sales_returns/sales_returns_details/model/promoter_sales_returns_details_model.dart';
import 'package:internal_base/common/app_constants.dart';
import 'package:internal_base/common/appbar_action_constants.dart';
import 'package:internal_base/common/appbars_constants.dart';
import 'package:internal_base/common/call_back.dart';
import 'package:internal_base/common/color_constants.dart';
import 'package:internal_base/common/size_constants.dart';
import 'package:internal_base/common/text_styles_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_commission_details/bloc/get_promoter_products_details_bloc.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_commission_details/bloc/get_promoter_products_details_state.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_commission_details/repo/get_promoter_commission_details_response.dart';

class PromoterSalesReturnsDetailsScreenWidget extends StatefulWidget {
  final CallbackModel mCallbackModel;

  const PromoterSalesReturnsDetailsScreenWidget(
      {super.key, required this.mCallbackModel});

  @override
  State<PromoterSalesReturnsDetailsScreenWidget> createState() =>
      _PromoterSalesReturnsDetailsScreenWidgetState();
}

class _PromoterSalesReturnsDetailsScreenWidgetState
    extends State<PromoterSalesReturnsDetailsScreenWidget> {
  late PromoterSalesReturnsDetailsScreenModel
      mPromoterSalesReturnsDetailsScreenModel;

  @override
  void initState() {
    mPromoterSalesReturnsDetailsScreenModel =
        PromoterSalesReturnsDetailsScreenModel(context, widget.mCallbackModel);
    mPromoterSalesReturnsDetailsScreenModel
        .setGetPromoterCommissionDetailsBloc();
    mPromoterSalesReturnsDetailsScreenModel.getSharedPrefsSelectStore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBars.appBarBack((value) {
          if (value == AppBarActionConstants.actionBack) {
            Navigator.pop(context);
          }
        }, AppConstants.cWordConstants.wItemDetailsText),
        body: _buildSplashScreenWidgetView());
  }

  _buildSplashScreenWidgetView() {
    return FocusDetector(
        child: SafeArea(
            child: MultiBlocListener(listeners: [
      BlocListener<GetPromoterCommissionDetailsBloc,
          GetPromoterCommissionDetailsState>(
        bloc: mPromoterSalesReturnsDetailsScreenModel
            .getPromoterCommissionDetailsBloc(),
        listener: (context, state) {
          mPromoterSalesReturnsDetailsScreenModel
              .blocGetPromoterCommissionDetailsListener(context, state);
        },
      ),
    ], child: backgroundView())));

  }

  Widget backgroundView(){
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
            child: detailsView(),
          )),
    ));
  }

  detailsView() {
    return StreamBuilder<GetPromoterCommissionDetailsResponse?>(
      stream: mPromoterSalesReturnsDetailsScreenModel.responseSubject,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          GetPromoterCommissionDetailsResponse
              mGetPromoterCommissionDetailsResponse =
              snapshot.data as GetPromoterCommissionDetailsResponse;
          return promoterCommissionDetailsView(
              mGetPromoterCommissionDetailsResponse);
        }
        return const SizedBox();
      },
    );
  }

  promoterCommissionDetailsView(
      GetPromoterCommissionDetailsResponse
          mGetPromoterCommissionDetailsResponse) {
    List<String> promoterNames = [];
    for (var each
        in mGetPromoterCommissionDetailsResponse.details?.otherPromoters ??
            []) {
      promoterNames.add(each.name ?? "");
    }

    return Container(
      margin: EdgeInsets.only(
          top: SizeConstants.s1 * 10,
          left: SizeConstants.s1 * 25,
          right: SizeConstants.s1 * 25,
          bottom: SizeConstants.s1 * 10),
      padding: EdgeInsets.all(SizeConstants.s1 * 13),
      width: SizeConstants.width,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
            color: Colors.grey.shade200, width: SizeConstants.s1 * 1.25),
        borderRadius: BorderRadius.all(Radius.circular(SizeConstants.s1 * 8)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(AppConstants.cWordConstants.wProductNameText,
                  style: getTextLight(
                      size: SizeConstants.s1 * 15, colors: Colors.black)),
              Expanded(
                  child: Text(
                      mGetPromoterCommissionDetailsResponse
                              .details?.productName ??
                          "",
                      style: getTextSemiBold(
                          size: SizeConstants.s1 * 15, colors: Colors.black))),
              Container(
                padding: EdgeInsets.only(
                    left: SizeConstants.s1 * 10,
                    right: SizeConstants.s1 * 10,
                    top: SizeConstants.s1 * 3,
                    bottom: SizeConstants.s1 * 2),
                decoration: BoxDecoration(
                  color: ColorConstants.cOutOfStockBackGroundColor,
                  borderRadius:
                      BorderRadius.all(Radius.circular(SizeConstants.s1 * 8)),
                ),
                child: Text(
                  (widget.mCallbackModel.sMenuValue == "SALE")
                      ? AppConstants.cWordConstants.wSaleText
                      : AppConstants.cWordConstants.wReturnText,
                  style: getTextRegular(
                      size: SizeConstants.s1 * 12,
                      colors: ColorConstants.cOutOfStockTextColor),
                ),
              )
            ],
          ),
          SizedBox(
            height: SizeConstants.s1 * 5,
          ),
          Row(
            children: [
              Text(AppConstants.cWordConstants.wProductUPCText,
                  style: getTextLight(
                      size: SizeConstants.s1 * 15, colors: Colors.black)),
              Text(
                  mGetPromoterCommissionDetailsResponse.details?.productUpc ??
                      "",
                  style: getTextSemiBold(
                      size: SizeConstants.s1 * 15, colors: Colors.black)),
            ],
          ),
          SizedBox(
            height: SizeConstants.s1 * 5,
          ),
          Row(
            children: [
              Text(AppConstants.cWordConstants.wProductSizeText,
                  style: getTextLight(
                      size: SizeConstants.s1 * 15, colors: Colors.black)),
              Text(
                  mGetPromoterCommissionDetailsResponse.details?.productSize ??
                      "",
                  style: getTextSemiBold(
                      size: SizeConstants.s1 * 15, colors: Colors.black)),
            ],
          ),
          SizedBox(
            height: SizeConstants.s1 * 5,
          ),
          Row(
            children: [
              Text(AppConstants.cWordConstants.wProductColorText,
                  style: getTextLight(
                      size: SizeConstants.s1 * 15, colors: Colors.black)),
              Text(
                  mGetPromoterCommissionDetailsResponse.details?.productColor ??
                      "",
                  style: getTextSemiBold(
                      size: SizeConstants.s1 * 15, colors: Colors.black)),
            ],
          ),
          SizedBox(
            height: SizeConstants.s1 * 5,
          ),
          Row(
            children: [
              Text(AppConstants.cWordConstants.wProductDepartmenText,
                  style: getTextLight(
                      size: SizeConstants.s1 * 15, colors: Colors.black)),
              Text(
                  mGetPromoterCommissionDetailsResponse
                          .details?.productDepartment ??
                      "",
                  style: getTextSemiBold(
                      size: SizeConstants.s1 * 15, colors: Colors.black)),
            ],
          ),
          SizedBox(
            height: SizeConstants.s1 * 5,
          ),
          Row(
            children: [
              Text(AppConstants.cWordConstants.wProductBrandText,
                  style: getTextLight(
                      size: SizeConstants.s1 * 15, colors: Colors.black)),
              Text(
                  mGetPromoterCommissionDetailsResponse.details?.productBrand ??
                      "",
                  style: getTextSemiBold(
                      size: SizeConstants.s1 * 15, colors: Colors.black)),
            ],
          ),

          SizedBox(
            height: SizeConstants.s1 * 45,
          ),

          ///
          Row(
            children: [
              Expanded(
                  child: Container(
                padding: EdgeInsets.all(SizeConstants.s1 * 10),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                      color: Colors.grey.shade200,
                      width: SizeConstants.s1 * 1.25),
                  borderRadius:
                      BorderRadius.all(Radius.circular(SizeConstants.s1 * 8)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppConstants.cWordConstants.wQuantityText,
                        style: getTextLight(
                            size: SizeConstants.s1 * 15, colors: Colors.black)),
                    Text(
                        mGetPromoterCommissionDetailsResponse
                                .details?.quantity ??
                            "",
                        style: getTextSemiBold(
                            size: SizeConstants.s1 * 15, colors: Colors.black)),
                  ],
                ),
              )),
              SizedBox(
                width: SizeConstants.s1 * 10,
              ),
              Expanded(
                  child: Container(
                padding: EdgeInsets.all(SizeConstants.s1 * 10),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                      color: Colors.grey.shade200,
                      width: SizeConstants.s1 * 1.25),
                  borderRadius:
                      BorderRadius.all(Radius.circular(SizeConstants.s1 * 8)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${AppConstants.cWordConstants.wAmountText}:",
                        style: getTextLight(
                            size: SizeConstants.s1 * 15, colors: Colors.black)),
                    Text(
                        "${mGetPromoterCommissionDetailsResponse.details?.amount}",
                        style: getTextSemiBold(
                            size: SizeConstants.s1 * 15, colors: Colors.black)),
                  ],
                ),
              )),
            ],
          ),
          SizedBox(
            height: SizeConstants.s1 * 15,
          ),
          Container(
            width: SizeConstants.width,
            padding: EdgeInsets.all(SizeConstants.s1 * 10),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                  color: Colors.grey.shade200, width: SizeConstants.s1 * 1.25),
              borderRadius:
                  BorderRadius.all(Radius.circular(SizeConstants.s1 * 8)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${AppConstants.cWordConstants.wCommissionText}: ",
                    style: getTextLight(
                        size: SizeConstants.s1 * 15, colors: Colors.black)),
                Text(
                    (mGetPromoterCommissionDetailsResponse.details?.commission != null) ? "${mGetPromoterCommissionDetailsResponse.details?.commission}": "",
                    style: getTextSemiBold(
                        size: SizeConstants.s1 * 15, colors: Colors.black)),
              ],
            ),
          ),
          SizedBox(
            height: SizeConstants.s1 * 15,
          ),
          Container(
            width: SizeConstants.width,
            padding: EdgeInsets.all(SizeConstants.s1 * 10),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                  color: Colors.grey.shade200, width: SizeConstants.s1 * 1.25),
              borderRadius:
                  BorderRadius.all(Radius.circular(SizeConstants.s1 * 8)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppConstants.cWordConstants.wOtherPromotersText,
                    style: getTextLight(
                        size: SizeConstants.s1 * 15, colors: Colors.black)),
                Text(promoterNames.join(", "),
                    style: getTextSemiBold(
                        size: SizeConstants.s1 * 15, colors: Colors.black)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
