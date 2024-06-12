import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_stores_list/bloc/store_manager_stores_list_event.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_stores_list/bloc/store_manager_stores_list_state.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_stores_list/repo/store_manager_stores_list_repo.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_stores_list/repo/store_manager_stores_list_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';
import 'package:internal_base/data/remote/web_service.dart';


class GetStoreManagerStoresListBloc extends Bloc<
    GetStoreManagerStoresListEvent,
    GetStoreManagerStoresListState> {
  final GetStoreManagerStoresListRepository repository =
      GetStoreManagerStoresListRepository(
          sharedPrefs: SharedPrefs(), webservice: Webservice());

  GetStoreManagerStoresListBloc()
      : super( const GetStoreManagerStoresListState()) {
    on<GetStoreManagerStoresListClickEvent>(
      (event, emit) async {
        emit(state.copyWith(
            status: GetStoreManagerStoresListStatus.loading));
        try {
          var response =
              await repository.fetchGetStoreManagerStoresList();

          if (response is GetStoreManagerStoresListResponse) {

              emit(state.copyWith(
                status: GetStoreManagerStoresListStatus.success,
                mGetStoreManagerStoresListResponse: response,
              ));

          } else if (response is WebResponseFailed) {
            emit(state.copyWith(
                status: GetStoreManagerStoresListStatus.failed,
                webResponseFailed: response));
          }
        } catch (e) {
          emit(state.copyWith(
              status: GetStoreManagerStoresListStatus.failed,
              webResponseFailed: WebResponseFailed(
                  statusMessage: "Unable to process your request right now")));
        }
      },
    );
  }
}
