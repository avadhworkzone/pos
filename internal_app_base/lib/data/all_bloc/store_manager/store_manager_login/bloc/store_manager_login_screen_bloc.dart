import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_login/bloc/store_manager_login_screen_event.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_login/bloc/store_manager_login_screen_state.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_login/repo/store_manager_login_screen_repo.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_login/repo/store_manager_login_screen_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';
import 'package:internal_base/data/remote/web_service.dart';



class StoreManagerLoginScreenBloc extends Bloc<
    StoreManagerLoginScreenEvent,
    StoreManagerLoginScreenState> {
  final StoreManagerLoginScreenRepository repository =
      StoreManagerLoginScreenRepository(
          sharedPrefs: SharedPrefs(), webservice: Webservice());

  StoreManagerLoginScreenBloc()
      : super( const StoreManagerLoginScreenState()) {
    on<StoreManagerLoginScreenClickEvent>(
      (event, emit) async {
        emit(state.copyWith(
            status: StoreManagerLoginScreenStatus.loading));
        try {
          var response =
              await repository.fetchStoreManagerLoginScreen(event.mStoreManagerLoginScreenListRequest);

          if (response is StoreManagerLoginScreenResponse) {
              emit(state.copyWith(
                status: StoreManagerLoginScreenStatus.success,
                mStoreManagerLoginScreenResponse: response,
              ));

          } else if (response is WebResponseFailed) {
            emit(state.copyWith(
                status: StoreManagerLoginScreenStatus.failed,
                webResponseFailed: response));
          }
        } catch (e) {
          emit(state.copyWith(
              status: StoreManagerLoginScreenStatus.failed,
              webResponseFailed: WebResponseFailed(
                  statusMessage: "Unable to process your request right now")));
        }
      },
    );
  }
}
