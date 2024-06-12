import 'package:equatable/equatable.dart';
import 'package:member_app/data/all_bloc/login_mobile_number_otp_bloc/repo/login_mobile_number_otp_screen_response.dart';
import 'package:member_app/data/remote/web_response_failed.dart';

enum LoginMobileNumberOtpScreenStatus { loading, success, failed }

class LoginMobileNumberOtpScreenState extends Equatable {
  const LoginMobileNumberOtpScreenState(
      {this.status = LoginMobileNumberOtpScreenStatus.loading,
        this.mLoginMobileNumberOtpScreenResponse ,
        this.webResponseFailed});

  final LoginMobileNumberOtpScreenStatus status;
  final LoginMobileNumberOtpScreenResponse? mLoginMobileNumberOtpScreenResponse;
  final WebResponseFailed? webResponseFailed;



  LoginMobileNumberOtpScreenState copyWith({
    LoginMobileNumberOtpScreenStatus? status,
    LoginMobileNumberOtpScreenResponse? mLoginMobileNumberOtpScreenResponse,
    WebResponseFailed? webResponseFailed
  }) {
    return LoginMobileNumberOtpScreenState(
      status: status ?? this.status,
      mLoginMobileNumberOtpScreenResponse:
      mLoginMobileNumberOtpScreenResponse ?? this.mLoginMobileNumberOtpScreenResponse,
      webResponseFailed:  webResponseFailed ?? this.webResponseFailed,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, LoginMobileNumberOtpScreenResponse: $mLoginMobileNumberOtpScreenResponse }''';
  }

  @override
  List<Object> get props => [
    status,
    mLoginMobileNumberOtpScreenResponse??LoginMobileNumberOtpScreenResponse(),
    webResponseFailed ?? WebResponseFailed()
  ];
}
