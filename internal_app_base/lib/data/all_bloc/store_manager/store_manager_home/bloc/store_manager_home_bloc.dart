import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_home/bloc/store_manager_home_event.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_home/bloc/store_manager_home_state.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_home/repo/store_manager_home_repo.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_home/repo/store_manager_home_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';
import 'package:internal_base/data/remote/web_service.dart';


class GetStoreManagerHomeBloc extends Bloc<
    GetStoreManagerHomeEvent,
    GetStoreManagerHomeState> {
  final GetStoreManagerHomeRepository repository =
      GetStoreManagerHomeRepository(
          sharedPrefs: SharedPrefs(), webservice: Webservice());

  GetStoreManagerHomeBloc()
      : super( const GetStoreManagerHomeState()) {
    on<GetStoreManagerHomeClickEvent>(
      (event, emit) async {
        emit(state.copyWith(
            status: GetStoreManagerHomeStatus.loading));
        try {
          var response =
              await repository.fetchGetStoreManagerHome(event.mGetStoreManagerHomeRequest);

          if (response is GetStoreManagerHomeResponse) {

              emit(state.copyWith(
                status: GetStoreManagerHomeStatus.success,
                mGetStoreManagerHomeResponse: response,
              ));

          } else if (response is WebResponseFailed) {
            emit(state.copyWith(
                status: GetStoreManagerHomeStatus.failed,
                webResponseFailed: response));
          }
        } catch (e) {
          emit(state.copyWith(
              status: GetStoreManagerHomeStatus.failed,
              webResponseFailed: WebResponseFailed(
                  statusMessage: "Unable to process your request right now")));
        }
      },
    );
  }
}
