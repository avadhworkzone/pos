import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_home/bloc/get_promoter_home_event.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_home/bloc/get_promoter_home_state.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_home/repo/get_promoter_home_repo.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_home/repo/get_promoter_home_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';
import 'package:internal_base/data/remote/web_service.dart';


class GetPromoterHomeBloc extends Bloc<
    GetPromoterHomeEvent,
    GetPromoterHomeState> {
  final GetPromoterHomeRepository repository =
      GetPromoterHomeRepository(
          sharedPrefs: SharedPrefs(), webservice: Webservice());

  GetPromoterHomeBloc()
      : super( const GetPromoterHomeState()) {
    on<GetPromoterHomeClickEvent>(
      (event, emit) async {
        emit(state.copyWith(
            status: GetPromoterHomeStatus.loading));
        try {
          var response =
              await repository.fetchGetPromoterHome(event.mGetPromoterHomeRequest);

          if (response is GetPromoterHomeResponse) {

              emit(state.copyWith(
                status: GetPromoterHomeStatus.success,
                mGetPromoterHomeResponse: response,
              ));

          } else if (response is WebResponseFailed) {
            emit(state.copyWith(
                status: GetPromoterHomeStatus.failed,
                webResponseFailed: response));
          }
        } catch (e) {
          emit(state.copyWith(
              status: GetPromoterHomeStatus.failed,
              webResponseFailed: WebResponseFailed(
                  statusMessage: "Unable to process your request right now")));
        }
      },
    );
  }
}
