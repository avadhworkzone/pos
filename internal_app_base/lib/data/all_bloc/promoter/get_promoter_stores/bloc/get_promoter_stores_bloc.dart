import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_stores/bloc/get_promoter_stores_event.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_stores/bloc/get_promoter_stores_state.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_stores/repo/get_promoter_stores_repo.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_stores/repo/get_promoter_stores_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';
import 'package:internal_base/data/remote/web_service.dart';


class GetPromoterStoresBloc extends Bloc<
    GetPromoterStoresEvent,
    GetPromoterStoresState> {
  final GetPromoterStoresRepository repository =
      GetPromoterStoresRepository(
          sharedPrefs: SharedPrefs(), webservice: Webservice());

  GetPromoterStoresBloc()
      : super( const GetPromoterStoresState()) {
    on<GetPromoterStoresClickEvent>(
      (event, emit) async {
        emit(state.copyWith(
            status: GetPromoterStoresStatus.loading));
        try {
          var response =
              await repository.fetchGetPromoterStores();

          if (response is GetPromoterStoresResponse) {

              emit(state.copyWith(
                status: GetPromoterStoresStatus.success,
                mGetPromoterStoresResponse: response!,
              ));

          } else if (response is WebResponseFailed) {
            emit(state.copyWith(
                status: GetPromoterStoresStatus.failed,
                webResponseFailed: response));
          }
        } catch (e) {
          emit(state.copyWith(
              status: GetPromoterStoresStatus.failed,
              webResponseFailed: WebResponseFailed(
                  statusMessage: "Unable to process your request right now")));
        }
      },
    );
  }
}
