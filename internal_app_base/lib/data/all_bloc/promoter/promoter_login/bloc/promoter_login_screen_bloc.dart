import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_base/data/all_bloc/promoter/promoter_login/bloc/promoter_login_screen_event.dart';
import 'package:internal_base/data/all_bloc/promoter/promoter_login/bloc/promoter_login_screen_state.dart';
import 'package:internal_base/data/all_bloc/promoter/promoter_login/repo/promoter_login_screen_repo.dart';
import 'package:internal_base/data/all_bloc/promoter/promoter_login/repo/promoter_login_screen_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';
import 'package:internal_base/data/remote/web_service.dart';



class PromoterLoginScreenBloc extends Bloc<
    PromoterLoginScreenEvent,
    PromoterLoginScreenState> {
  final PromoterLoginScreenRepository repository =
      PromoterLoginScreenRepository(
          sharedPrefs: SharedPrefs(), webservice: Webservice());

  PromoterLoginScreenBloc()
      : super( const PromoterLoginScreenState()) {
    on<PromoterLoginScreenClickEvent>(
      (event, emit) async {
        emit(state.copyWith(
            status: PromoterLoginScreenStatus.loading));
        try {
          var response =
              await repository.fetchPromoterLoginScreen(event.mPromoterLoginScreenListRequest);

          if (response is PromoterLoginScreenResponse) {
              emit(state.copyWith(
                status: PromoterLoginScreenStatus.success,
                mPromoterLoginScreenResponse: response!,
              ));

          } else if (response is WebResponseFailed) {
            emit(state.copyWith(
                status: PromoterLoginScreenStatus.failed,
                webResponseFailed: response));
          }
        } catch (e) {
          emit(state.copyWith(
              status: PromoterLoginScreenStatus.failed,
              webResponseFailed: WebResponseFailed(
                  statusMessage: "Unable to process your request right now")));
        }
      },
    );
  }
}
