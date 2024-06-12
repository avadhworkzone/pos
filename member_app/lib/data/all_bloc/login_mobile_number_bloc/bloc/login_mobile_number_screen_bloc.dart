import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:member_app/data/local/shared_prefs/shared_prefs.dart';
import 'package:member_app/data/all_bloc/login_mobile_number_bloc/repo/login_mobile_number_screen_repo.dart';
import 'package:member_app/data/remote/web_response_failed.dart';
import 'package:member_app/data/remote/web_service.dart';

import '../repo/login_mobile_number_screen_response.dart';
import 'login_mobile_number_screen_event.dart';
import 'login_mobile_number_screen_state.dart';

class LoginMobileNumberScreenBloc extends Bloc<
    LoginMobileNumberScreenEvent,
    LoginMobileNumberScreenState> {
  final LoginMobileNumberScreenRepository repository =
      LoginMobileNumberScreenRepository(
          sharedPrefs: SharedPrefs(), webservice: Webservice());

  LoginMobileNumberScreenBloc()
      : super( const LoginMobileNumberScreenState()) {
    on<LoginMobileNumberScreenClickEvent>(
      (event, emit) async {
        emit(state.copyWith(
            status: LoginMobileNumberScreenStatus.loading));
        try {
          var response =
              await repository.fetchLoginMobileNumberScreen(event.mLoginMobileNumberScreenListRequest);

          if (response is LoginMobileNumberScreenResponse) {

              emit(state.copyWith(
                status: LoginMobileNumberScreenStatus.success,
                mLoginMobileNumberScreenResponse: response!,
              ));

          } else if (response is WebResponseFailed) {
            emit(state.copyWith(
                status: LoginMobileNumberScreenStatus.failed,
                webResponseFailed: WebResponseFailed(
                    statusMessage:
                        "Unable to process your request right now")));
          }
        } catch (e) {
          emit(state.copyWith(
              status: LoginMobileNumberScreenStatus.failed,
              webResponseFailed: WebResponseFailed(
                  statusMessage: "Unable to process your request right now")));
        }
      },
    );
  }
}
