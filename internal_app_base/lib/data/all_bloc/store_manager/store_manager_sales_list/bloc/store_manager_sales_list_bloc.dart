import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_sales_list/bloc/store_manager_sales_list_event.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_sales_list/bloc/store_manager_sales_list_state.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_sales_list/repo/store_manager_sales_list_repo.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_sales_list/repo/store_manager_sales_list_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';
import 'package:internal_base/data/remote/web_service.dart';

class GetStoreManagerSalesListBloc extends Bloc<
    GetStoreManagerSalesListEvent,
    GetStoreManagerSalesListState> {
  final GetStoreManagerSalesListRepository repository =
      GetStoreManagerSalesListRepository(
          sharedPrefs: SharedPrefs(), webservice: Webservice());

  GetStoreManagerSalesListBloc()
      : super(const GetStoreManagerSalesListState()) {
    on<GetStoreManagerSalesListClickEvent>(
      (event, emit) async {
        try {
          if (event.eventStatus ==
              GetStoreManagerSalesListEventStatus.initial) {
            if (state.mSalesListData.isNotEmpty) {
              state.mSalesListData.clear();
            }
            emit(state.copyWith(
                status: GetStoreManagerSalesListStatus.loading));
          } else if (event.eventStatus ==
              GetStoreManagerSalesListEventStatus.refresh) {
            if (state.mSalesListData.isNotEmpty) {
              state.mSalesListData.clear();
            }
          } else {}
          var response = await repository.fetchGetStoreManagerSalesList(
              event.mGetStoreManagerSalesListRequest,
              event.mStringRequest);

          if (response is GetStoreManagerSalesListResponse) {
            if (response.data != null) {
              if (response.data!.isNotEmpty) {
                emit(state.copyWith(
                    mGetStoreManagerSalesListResponse: response,
                    status: GetStoreManagerSalesListStatus.success,
                    mSalesListData: List.of(state.mSalesListData)
                      ..addAll(
                        response.data!,
                      ),
                    hasReachedMax: response.lastPage));
              } else {
                emit(state.copyWith(
                    status: GetStoreManagerSalesListStatus.success,
                    mGetStoreManagerSalesListResponse: response,
                    mSalesListData: state.mSalesListData,
                    hasReachedMax: response.lastPage));
              }
            } else {
              emit(state.copyWith(
                  status: GetStoreManagerSalesListStatus.failed,
                  webResponseFailed: WebResponseFailed(
                      statusMessage:
                          "Unable to process your request right now")));
            }
          } else if (response is WebResponseFailed) {
            emit(state.copyWith(
                status: GetStoreManagerSalesListStatus.failed,
                webResponseFailed: response));
          }
        } catch (e) {
          emit(state.copyWith(
              status: GetStoreManagerSalesListStatus.failed,
              webResponseFailed: WebResponseFailed(
                  statusMessage: "Unable to process your request right now")));
        }
      },
    );
  }
}
