import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:member_app/data/all_bloc/login_mobile_number_otp_bloc/bloc/login_mobile_number_otp_screen_event.dart';
import 'package:member_app/data/all_bloc/login_mobile_number_otp_bloc/bloc/login_mobile_number_otp_screen_state.dart';
import 'package:member_app/data/all_bloc/login_mobile_number_otp_bloc/repo/login_mobile_number_otp_screen_repo.dart';
import 'package:member_app/data/all_bloc/login_mobile_number_otp_bloc/repo/login_mobile_number_otp_screen_response.dart';
import 'package:member_app/data/local/shared_prefs/shared_prefs.dart';
import 'package:member_app/data/remote/web_response_failed.dart';
import 'package:member_app/data/remote/web_service.dart';


class LoginMobileNumberOtpScreenBloc extends Bloc<
    LoginMobileNumberOtpScreenEvent,
    LoginMobileNumberOtpScreenState> {
  final LoginMobileNumberOtpScreenRepository repository =
      LoginMobileNumberOtpScreenRepository(
          sharedPrefs: SharedPrefs(), webservice: Webservice());

  LoginMobileNumberOtpScreenBloc()
      : super( const LoginMobileNumberOtpScreenState()) {
    on<LoginMobileNumberOtpScreenClickEvent>(
      (event, emit) async {
        emit(state.copyWith(
            status: LoginMobileNumberOtpScreenStatus.loading));
        try {
          var response =
              await repository.fetchLoginMobileNumberOtpScreen(event.mLoginMobileNumberOtpScreenListRequest);

          if (response is LoginMobileNumberOtpScreenResponse) {

              emit(state.copyWith(
                status: LoginMobileNumberOtpScreenStatus.success,
                mLoginMobileNumberOtpScreenResponse: response!,
              ));

          } else if (response is WebResponseFailed) {
            emit(state.copyWith(
                status: LoginMobileNumberOtpScreenStatus.failed,
                webResponseFailed: WebResponseFailed(
                    statusMessage:
                        "Unable to process your request right now")));
          }
        } catch (e) {
          emit(state.copyWith(
              status: LoginMobileNumberOtpScreenStatus.failed,
              webResponseFailed: WebResponseFailed(
                  statusMessage: "Unable to process your request right now")));
        }
      },
    );
  }
}
