import 'package:equatable/equatable.dart';
import 'package:member_app/data/all_bloc/login_mobile_number_bloc/repo/login_mobile_number_screen_response.dart';
import 'package:member_app/data/remote/web_response_failed.dart';

enum LoginMobileNumberScreenStatus { loading, success, failed }

class LoginMobileNumberScreenState extends Equatable {
  const LoginMobileNumberScreenState(
      {this.status = LoginMobileNumberScreenStatus.loading,
        this.mLoginMobileNumberScreenResponse ,
        this.webResponseFailed});

  final LoginMobileNumberScreenStatus status;
  final LoginMobileNumberScreenResponse? mLoginMobileNumberScreenResponse;
  final WebResponseFailed? webResponseFailed;



  LoginMobileNumberScreenState copyWith({
    LoginMobileNumberScreenStatus? status,
    LoginMobileNumberScreenResponse? mLoginMobileNumberScreenResponse,
    WebResponseFailed? webResponseFailed
  }) {
    return LoginMobileNumberScreenState(
      status: status ?? this.status,
      mLoginMobileNumberScreenResponse:
      mLoginMobileNumberScreenResponse ?? this.mLoginMobileNumberScreenResponse,
      webResponseFailed:  webResponseFailed ?? this.webResponseFailed,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, LoginMobileNumberScreenResponse: $mLoginMobileNumberScreenResponse }''';
  }

  @override
  List<Object> get props => [
    status,
    mLoginMobileNumberScreenResponse??LoginMobileNumberScreenResponse(),
    webResponseFailed ?? WebResponseFailed()
  ];
}
