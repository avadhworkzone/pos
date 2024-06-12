import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:member_app/common/alert/app_alert.dart';
import 'package:member_app/common/app_constants.dart';
import 'package:member_app/common/color_constants.dart';
import 'package:member_app/common/message_constants.dart';
import 'package:member_app/common/size_constants.dart';
import 'package:member_app/common/text_styles_constants.dart';
import 'package:member_app/common/utils/network_utils.dart';
import 'package:member_app/common/widget/no_transactions_found.dart';
import 'package:member_app/common/widget/pull_to_refresh_header_widget.dart';
import 'package:member_app/data/all_bloc/transactions_list_bloc/bloc/transactions_list_bloc.dart';
import 'package:member_app/data/all_bloc/transactions_list_bloc/bloc/transactions_list_event.dart';
import 'package:member_app/data/all_bloc/transactions_list_bloc/bloc/transactions_list_state.dart';
import 'package:member_app/data/all_bloc/transactions_list_bloc/repo/transactions_list_request.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'reward_list_item_loyalty_points_view.dart';

class RewardShowLoyaltyPointsViewWidget extends StatefulWidget {
  const RewardShowLoyaltyPointsViewWidget({super.key});

  @override
  State<RewardShowLoyaltyPointsViewWidget> createState() =>
      _RewardShowLoyaltyPointsViewWidgetState();
}

class _RewardShowLoyaltyPointsViewWidgetState
    extends State<RewardShowLoyaltyPointsViewWidget> {
  late TransactionsListBloc _mTransactionsListBloc;

  int onRefresh = 0;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool onLoading = true;
  bool isLoadedAndEmpty = false;
  bool isSearchedAndEmpty = false;
  int page = 1;

  @override
  void initState() {
    super.initState();

    _mTransactionsListBloc = TransactionsListBloc();
    _initTransactionsList(TransactionsListEventStatus.initial);
  }

  void _onRefresh() async {
    onRefresh = 1;
    page = 1;
    _initTransactionsList(TransactionsListEventStatus.refresh);
  }

  void _onLoading() async {
    onRefresh = 2;
    page = page + 1;
    _initTransactionsList(TransactionsListEventStatus.other);
  }

  Future<void> _initTransactionsList(
      TransactionsListEventStatus eventStatus) async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        _mTransactionsListBloc.add(TransactionsListClickEvent(
            mTransactionsListRequest: TransactionsListRequest(
                    page: page.toString(),
                    perPage: "10",
                    sortBy: "id",
                    sortDirection: "desc")
                .toJson(),
            eventStatus: eventStatus));
      } else {
        AppAlert.showSnackBar(context, MessageConstants.noInternetConnection);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionsListBloc, TransactionsListState>(
      bloc: _mTransactionsListBloc,
      builder: (context, state) {
        return _fTransactionsListViewBuilder(context, state);
      },
      listener: _fTransactionsListBlocListener,
    );
  }

  _fTransactionsListBlocListener(
      BuildContext context, TransactionsListState state) {
    switch (state.status) {
      case TransactionsListStatus.loading:
        AppAlert.showProgressDialog(context);
        break;
      case TransactionsListStatus.failed:
        loadEnd();
        if (state.webResponseFailed != null) {
          AppAlert.showSnackBar(
              context, state.webResponseFailed!.statusMessage ?? "");
        } else {
          AppAlert.showSnackBar(
            context,
            MessageConstants.wSomethingWentWrong,
          );
        }
        break;
      case TransactionsListStatus.success:
        loadEnd();
        break;
    }
  }

  Widget _fTransactionsListViewBuilder(
      BuildContext context, TransactionsListState state) {
    switch (state.status) {
      case TransactionsListStatus.loading:
        return const SizedBox();
      case TransactionsListStatus.failed:
        return const SizedBox();
      case TransactionsListStatus.success:
        return _buildRewardShowLoyaltyPointsView(state);
    }
  }

  _buildRewardShowLoyaltyPointsView(TransactionsListState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(
                  left: SizeConstants.s_15,
                  right: SizeConstants.s_15,
                  bottom: SizeConstants.s_30),
              decoration: BoxDecoration(
                color: ColorConstants.kPrimaryColor.shade600,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.all(SizeConstants.s_10),
                        alignment: Alignment.center,
                        height: SizeConstants.width * 0.23,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                                state.mTransactionsListResponse!.totalPoints
                                            .toString() ==
                                        "null"
                                    ? "0"
                                    : state
                                        .mTransactionsListResponse!.totalPoints
                                        .toString(),
                                style: getTextMedium(
                                    colors: ColorConstants.cWhite,
                                    size: SizeConstants.s1 * 22)),
                            Text(AppConstants.mWordConstants.sLoyaltyPoints,
                                textAlign: TextAlign.center,
                                style: getTextLight(
                                    colors: ColorConstants.cWhite,
                                    size: SizeConstants.s_16)),
                          ],
                        )),
                  ),
                  Container(
                    color: Colors.white,
                    width: SizeConstants.s1,
                    height: SizeConstants.s_32,
                  ),
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.all(SizeConstants.s_10),
                        alignment: Alignment.center,
                        height: SizeConstants.width * 0.23,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                                state.mTransactionsListResponse!.redeemPoints! <
                                        0
                                    ? (state.mTransactionsListResponse!
                                                .redeemPoints! *
                                            (-1))
                                        .toString()
                                    : state.mTransactionsListResponse!
                                        .redeemPoints!
                                        .toString(),
                                style: getTextMedium(
                                    colors: ColorConstants.cWhite,
                                    size: SizeConstants.s1 * 22)),
                            Text(AppConstants.mWordConstants.sRedeemPoints,
                                textAlign: TextAlign.center,
                                style: getTextLight(
                                    colors: ColorConstants.cWhite,
                                    size: SizeConstants.s_16)),
                          ],
                        )),
                  ),
                  Container(
                    color: Colors.white,
                    width: SizeConstants.s1,
                    height: SizeConstants.s_32,
                  ),
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.all(SizeConstants.s_10),
                        alignment: Alignment.center,
                        height: SizeConstants.width * 0.23,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                                state.mTransactionsListResponse!.availablePoints
                                            .toString() ==
                                        "null"
                                    ? "0"
                                    : state.mTransactionsListResponse!
                                        .availablePoints
                                        .toString(),
                                style: getTextMedium(
                                    colors: ColorConstants.cWhite,
                                    size: SizeConstants.s1 * 22)),
                            Text(AppConstants.mWordConstants.sAvailablePoints,
                                textAlign: TextAlign.center,
                                style: getTextLight(
                                    colors: ColorConstants.cWhite,
                                    size: SizeConstants.s_16)),
                          ],
                        )),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: SizeConstants.s_10 * 9),
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                  top: SizeConstants.s_10, bottom: SizeConstants.s_18),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(SizeConstants.s1 * 20),
                  topRight: Radius.circular(SizeConstants.s1 * 20),
                ),
              ),
              child: Scrollbar(
                  thumbVisibility: true,
                  thickness: SizeConstants.s2,
                  //width of scrollbar
                  radius: Radius.circular(20),
                  //corner radius of scrollbar
                  scrollbarOrientation: ScrollbarOrientation.right,
                  child: SmartRefresher(
                    controller: _refreshController,
                    onLoading: _onLoading,
                    onRefresh: _onRefresh,
                    enablePullUp: state.hasReachedMax,
                    enablePullDown: true,
                    footer: CustomFooter(builder: (context, loadStatus) {
                      return customFooter(loadStatus);
                    }),
                    header: waterDropHeader(),
                    child: state.loyaltyPointsList.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.loyaltyPointsList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return RewardItemLoyaltyPointsView(
                                  index: index,
                                  mLoyaltyPoints:
                                      state.loyaltyPointsList[index]);
                            })
                        : Center(
                            child: noTransactionsFound(),
                          ),
                  )),
            )
          ],
        ))
      ],
    );
  }

  void loadEnd() {
    if (onRefresh == 0) {
      AppAlert.closeDialog(context);
    } else if (onRefresh == 1) {
      _refreshController.refreshCompleted();
      onLoading = true;
    } else if (onRefresh == 2) {
      _refreshController.loadComplete();
    }
  }
}
