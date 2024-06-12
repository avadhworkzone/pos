import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:member_app/common/alert/app_alert.dart';
import 'package:member_app/common/message_constants.dart';
import 'package:member_app/common/size_constants.dart';
import 'package:member_app/common/utils/network_utils.dart';
import 'package:member_app/common/widget/no_transactions_found.dart';
import 'package:member_app/common/widget/pull_to_refresh_header_widget.dart';
import 'package:member_app/data/all_bloc/member_voucher_paginated_list_bloc/bloc/member_voucher_paginated_list_bloc.dart';
import 'package:member_app/data/all_bloc/member_voucher_paginated_list_bloc/bloc/member_voucher_paginated_list_event.dart';
import 'package:member_app/data/all_bloc/member_voucher_paginated_list_bloc/bloc/member_voucher_paginated_list_state.dart';
import 'package:member_app/data/all_bloc/member_voucher_paginated_list_bloc/repo/member_voucher_paginated_list_request.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'reward_list_item_vouchers_view.dart';

class RewardShowVouchersViewWidget extends StatefulWidget {
  const RewardShowVouchersViewWidget({super.key});

  @override
  State<RewardShowVouchersViewWidget> createState() =>
      _RewardShowVouchersViewWidgetState();
}

class _RewardShowVouchersViewWidgetState
    extends State<RewardShowVouchersViewWidget> {
  late MemberVoucherPaginatedListBloc _mMemberVoucherPaginatedListBloc;

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

    _mMemberVoucherPaginatedListBloc = MemberVoucherPaginatedListBloc();
    _initMemberVoucherPaginatedList(
        MemberVoucherPaginatedListEventStatus.initial);
  }

  void _onRefresh() async {
    onRefresh = 1;
    page = 1;
    _initMemberVoucherPaginatedList(
        MemberVoucherPaginatedListEventStatus.refresh);
  }

  void _onLoading() async {
    onRefresh = 2;
    page = page + 1;
    _initMemberVoucherPaginatedList(
        MemberVoucherPaginatedListEventStatus.other);
  }

  Future<void> _initMemberVoucherPaginatedList(
      MemberVoucherPaginatedListEventStatus eventStatus) async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        _mMemberVoucherPaginatedListBloc.add(
            MemberVoucherPaginatedListClickEvent(
                mMemberVoucherPaginatedListRequest:
                    MemberVoucherPaginatedListRequest(
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
    return BlocConsumer<MemberVoucherPaginatedListBloc,
        MemberVoucherPaginatedListState>(
      bloc: _mMemberVoucherPaginatedListBloc,
      builder: (context, state) {
        return _fMemberVoucherPaginatedListViewBuilder(context, state);
      },
      listener: _fMemberVoucherPaginatedListBlocListener,
    );
  }

  _fMemberVoucherPaginatedListBlocListener(
      BuildContext context, MemberVoucherPaginatedListState state) {
    switch (state.status) {
      case MemberVoucherPaginatedListStatus.loading:
        AppAlert.showProgressDialog(context);
        break;
      case MemberVoucherPaginatedListStatus.failed:
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
      case MemberVoucherPaginatedListStatus.success:
        loadEnd();
        break;
    }
  }

  Widget _fMemberVoucherPaginatedListViewBuilder(
      BuildContext context, MemberVoucherPaginatedListState state) {
    switch (state.status) {
      case MemberVoucherPaginatedListStatus.loading:
        return SizedBox();
      case MemberVoucherPaginatedListStatus.failed:
        return SizedBox();
      case MemberVoucherPaginatedListStatus.success:
        return _buildRewardShowVouchersView(state);
    }
  }

  _buildRewardShowVouchersView(MemberVoucherPaginatedListState state) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(SizeConstants.s1 * 20),
          topRight: Radius.circular(SizeConstants.s1 * 20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
              child: Scrollbar(
                  thumbVisibility: true,
                  thickness: SizeConstants.s2,
                  radius: Radius.circular(20),
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
                      child: state.vouchersList.isNotEmpty
                          ? ListView.builder(
                              itemCount: state.vouchersList!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return RewardItemVouchersView(
                                    index: index,
                                    mVouchers: state.vouchersList![index]);
                              })
                          : Center(
                              child: noVoucherFound(),
                            ))))
        ],
      ),
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
