import 'dart:convert';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:member_app/common/app_constants.dart';
import 'package:member_app/common/color_constants.dart';
import 'package:member_app/common/image_assets.dart';
import 'package:member_app/common/size_constants.dart';
import 'package:member_app/common/text_styles_constants.dart';
import 'package:member_app/common/widget/no_transactions_found.dart';
import 'package:member_app/data/all_bloc/get_members_details_bloc/bloc/get_members_details_bloc.dart';
import 'package:member_app/data/all_bloc/get_members_details_bloc/bloc/get_members_details_state.dart';
import 'package:member_app/data/all_bloc/get_members_details_bloc/repo/member_details.dart';
import 'package:member_app/data/all_bloc/get_members_details_bloc/repo/get_members_details_response.dart';
import 'package:member_app/modules/home/home_screen/home_screen_model.dart';
import 'package:member_app/modules/home/my_card/view/my_card_list_item_points_view.dart';
import 'package:member_app/routes/route_constants.dart';

class MyCardScreenWidget extends StatefulWidget {
  final HomeScreenModel mHomeScreenModel;

  const MyCardScreenWidget({super.key, required this.mHomeScreenModel});

  @override
  State<MyCardScreenWidget> createState() => _MyCardScreenWidgetState();
}

class _MyCardScreenWidgetState extends State<MyCardScreenWidget> {
  late MemberDetails mLoginMemberDetails;
  GetMemberDetailsResponse mGetMemberDetailsResponse =
      GetMemberDetailsResponse();

  @override
  void initState() {
    super.initState();
    widget.mHomeScreenModel.initGetMemberDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<GetMemberDetailsBloc, GetMemberDetailsState>(
            bloc: widget.mHomeScreenModel.mGetMemberDetailsBloc,
            builder: (context, state) {
              return _fGetMemberDetailsViewBuilder(context, state);
            },
            listener: (context, state) {
              return widget.mHomeScreenModel
                  .fGetMemberDetailsBlocListener(context, state);
            }));
  }

  Widget _fGetMemberDetailsViewBuilder(
      BuildContext context, GetMemberDetailsState state) {
    switch (state.status) {
      case GetMemberDetailsStatus.loading:
        if (mGetMemberDetailsResponse.currentlyAvailableLoyaltyPoints
                .toString() ==
            "null") {
          return const SizedBox();
        } else {
          return _buildMyCardScreenWidgetView();
        }
      case GetMemberDetailsStatus.failed:
        return const SizedBox();
      case GetMemberDetailsStatus.success:
        mGetMemberDetailsResponse = state.mGetMemberDetailsResponse!;
        widget.mHomeScreenModel.getLoginMemberDetails();
        return _buildMyCardScreenWidgetView();
    }
  }

  _buildMyCardScreenWidgetView() {
    return FocusDetector(
        child: SafeArea(
      child: SizedBox(
        height: SizeConstants.height,
        child: _showMiddleView(),
      ),
    ));
  }

  _showMiddleView() {
    return RefreshIndicator(
      child: Scrollbar(
        thumbVisibility: true,
        thickness: SizeConstants.s2,
        radius: const Radius.circular(20),
        scrollbarOrientation: ScrollbarOrientation.right,
        child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: SizeConstants.s_15,
                ),
                Container(
                    margin: EdgeInsets.only(
                        left: SizeConstants.s_20, right: SizeConstants.s_20),
                    height: SizeConstants.width * 0.54,
                    width: SizeConstants.width,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                      gradient: const LinearGradient(
                        begin: Alignment.bottomRight,
                        end: Alignment.topLeft,
                        colors: [
                          Color(0xfff8c2da),
                          Color(0xffba688a),
                          Color(0xffA93367),
                        ],
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(SizeConstants.s1 * 23),
                      ),
                    ),
                    child: Stack(
                      children: [
                        // ClipRRect(
                        //     borderRadius: BorderRadius.circular(SizeConstants.s1 * 23),
                        //     // Image border
                        //     child: Image.asset(
                        //       height: SizeConstants.width * 0.6,
                        //       width: SizeConstants.width,
                        //       ImageAssets.imageCardBackground,
                        //       fit: BoxFit.fill,
                        //       colorBlendMode: BlendMode.modulate,
                        //     )),
                        _showMiddleTopView(),
                      ],
                    )),
                SizedBox(
                  height: SizeConstants.s_15,
                ),
                streamBuildViewWallet(),
                SizedBox(
                  height: SizeConstants.s_15,
                ),
                Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.only(
                          left: SizeConstants.s_20,
                          right: SizeConstants.s_20,
                          bottom: SizeConstants.s_30),
                      decoration: BoxDecoration(
                        color: ColorConstants.kPrimaryColor.shade600,
                        boxShadow: [
                          BoxShadow(
                            color:
                                ColorConstants.kPrimaryColor.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(
                                0, 1), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(SizeConstants.s1 * 20),
                          topRight: Radius.circular(SizeConstants.s1 * 20),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              child: Container(
                                  alignment: Alignment.center,
                                  height: SizeConstants.width * 0.2,
                                  width: SizeConstants.width * 0.3,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                          mGetMemberDetailsResponse
                                              .currentlyAvailableLoyaltyPoints
                                              .toString(),
                                          style: getTextMedium(
                                              colors: Colors.white,
                                              size: SizeConstants.s_26)),
                                      Text(
                                          AppConstants
                                              .mWordConstants.sLoyaltyPoints,
                                          style: getTextLight(
                                              colors: Colors.white,
                                              size: SizeConstants.s_16)),
                                    ],
                                  )),
                              onTap: () {
                                widget.mHomeScreenModel.sValue =
                                    AppConstants.mWordConstants.sLoyaltyPoints;
                                widget.mHomeScreenModel.returnValueChanged(1);
                              },
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            width: SizeConstants.s1,
                            height: SizeConstants.s_32,
                          ),
                          Expanded(
                            child: GestureDetector(
                              child: Container(
                                  alignment: Alignment.center,
                                  height: SizeConstants.width * 0.2,
                                  width: SizeConstants.width * 0.3,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                          mGetMemberDetailsResponse
                                              .activeVoucherCount
                                              .toString(),
                                          style: getTextMedium(
                                              colors: Colors.white,
                                              size: SizeConstants.s_26)),
                                      Text(
                                          AppConstants.mWordConstants.sVouchers,
                                          style: getTextLight(
                                              colors: Colors.white,
                                              size: SizeConstants.s_16)),
                                    ],
                                  )),
                              onTap: () {
                                widget.mHomeScreenModel.sValue =
                                    AppConstants.mWordConstants.sVouchers;
                                widget.mHomeScreenModel.returnValueChanged(1);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: SizeConstants.s_10 * 8),
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(top: SizeConstants.s_18),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        boxShadow: [
                          BoxShadow(
                            color: mGetMemberDetailsResponse
                                    .lastTransactionsDetails!.isEmpty
                                ? Colors.transparent
                                : Colors.grey.withOpacity(0.3),
                            spreadRadius: mGetMemberDetailsResponse
                                    .lastTransactionsDetails!.isEmpty
                                ? 0
                                : 1,
                            blurRadius: mGetMemberDetailsResponse
                                    .lastTransactionsDetails!.isEmpty
                                ? 0
                                : 3,
                            offset: Offset(
                                0,
                                mGetMemberDetailsResponse
                                        .lastTransactionsDetails!.isEmpty
                                    ? 0
                                    : 1), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(SizeConstants.s1 * 20),
                          topRight: Radius.circular(SizeConstants.s1 * 20),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(AppConstants.mWordConstants.sLatestTransaction,
                              style: getTextSemiBold(
                                  colors: Colors.black,
                                  size: SizeConstants.s_22)),
                          SizedBox(
                            height: SizeConstants.s_10,
                          ),
                          Container(
                              color: Colors.grey.shade50,
                              child: mGetMemberDetailsResponse
                                      .lastTransactionsDetails!.isEmpty
                                  ? noTransactionsFound()
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: mGetMemberDetailsResponse
                                          .lastTransactionsDetails!.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return MyCardItemPointsView(
                                            index: index,
                                            mLoyaltyPoints:
                                                mGetMemberDetailsResponse
                                                        .lastTransactionsDetails![
                                                    index]);
                                      })),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            )),
      ),
      onRefresh: () async {
        widget.mHomeScreenModel.initGetMemberDetails();
      },
    );
  }

  _showMiddleTopView() {
    String name =
        mGetMemberDetailsResponse.memberDetails!.firstName.toString() == "null"
            ? ""
            : mGetMemberDetailsResponse.memberDetails!.firstName.toString();
    String lastName =
        mGetMemberDetailsResponse.memberDetails!.lastName.toString() == "null"
            ? ""
            : mGetMemberDetailsResponse.memberDetails!.lastName.toString();
    return Container(
      padding: EdgeInsets.all(SizeConstants.s_20),
      width: SizeConstants.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            height: SizeConstants.width * 0.065,
            ImageAssets.imageLogoMyCard,
            fit: BoxFit.fitWidth,
            colorBlendMode: BlendMode.modulate,
          ),
          Text("Membership Card",
              textAlign: TextAlign.center,
              maxLines: 1,
              style: getTextRegular(
                  colors: ColorConstants.cWhite,
                  size: SizeConstants.s_14,
                  letterSpacing: 0.5)),
          Text(" $name $lastName".trim(),
              textAlign: TextAlign.center,
              maxLines: 2,
              style: getTextMedium(
                  colors: ColorConstants.cWhite, size: SizeConstants.s_16)),
          SizedBox(
            height: SizeConstants.s_10,
          ),
          Container(
              padding: EdgeInsets.all(SizeConstants.s_10),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1), // changes position of shadow
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: Column(
                children: [
                  BarcodeWidget(
                    barcode: Barcode.code128(),
                    data: mGetMemberDetailsResponse.memberDetails!.cardNumber ??
                        "",
                    height: SizeConstants.width * 0.13,
                    width: SizeConstants.width * 0.6,
                    style: getTextRegular(
                        colors: Colors.black,
                        size: SizeConstants.s_14,
                        letterSpacing: 3.0),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  streamBuildViewWallet() {
    return StreamBuilder<MemberDetails?>(
      stream: widget.mHomeScreenModel.responseSubject,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          mLoginMemberDetails = snapshot.data as MemberDetails;
          if (mLoginMemberDetails != null) {
            return Container(
                margin: EdgeInsets.only(
                    left: SizeConstants.s_26,
                    right: SizeConstants.s_26,
                    top: SizeConstants.s_10,
                    bottom: SizeConstants.s_10),
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () async {
                            if (mLoginMemberDetails.email.toString() !=
                                    "null" &&
                                mLoginMemberDetails.email
                                    .toString()
                                    .trim()
                                    .isNotEmpty) {
                              widget.mHomeScreenModel.openUrl(
                                  mLoginMemberDetails.androidDigitalPassLink ??
                                      "");
                            } else {
                              await Navigator.pushNamed(context,
                                  RouteConstants.rEditProfileScreenWidget,
                                  arguments: widget.mHomeScreenModel
                                      .getCallbackModel(mLoginMemberDetails));
                              widget.mHomeScreenModel.getLoginMemberDetails();
                            }
                          },
                          child: Container(
                              height: SizeConstants.s1 * 40,
                              width: SizeConstants.width,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                image: AssetImage(ImageAssets.imageAndroidPay),
                                fit: BoxFit.fitHeight,
                              ))),
                        )),
                    SizedBox(
                      width: SizeConstants.s_20,
                    ),
                    Expanded(
                        flex: 1,
                        child: GestureDetector(
                            onTap: () async {
                              if (mLoginMemberDetails.email.toString() !=
                                      "null" &&
                                  mLoginMemberDetails.email
                                      .toString()
                                      .trim()
                                      .isNotEmpty) {
                                widget.mHomeScreenModel.openUrl(
                                    mLoginMemberDetails.iosDigitalPassLink ??
                                        "");
                              } else {
                                await Navigator.pushNamed(context,
                                    RouteConstants.rEditProfileScreenWidget,
                                    arguments: widget.mHomeScreenModel
                                        .getCallbackModel(mLoginMemberDetails));
                                widget.mHomeScreenModel.getLoginMemberDetails();
                              }
                            },
                            child: Container(
                                height: SizeConstants.s1 * 40,
                                width: SizeConstants.width,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  image: AssetImage(ImageAssets.imageIosPay),
                                  fit: BoxFit.fitHeight,
                                ))))),
                  ],
                ));
          } else {
            return const SizedBox();
          }
        }
        return const SizedBox();
      },
    );
  }
}
