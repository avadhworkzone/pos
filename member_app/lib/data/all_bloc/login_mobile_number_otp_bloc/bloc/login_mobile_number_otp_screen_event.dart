import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class LoginMobileNumberOtpScreenEvent extends Equatable{
  const LoginMobileNumberOtpScreenEvent();
}

class LoginMobileNumberOtpScreenClickEvent
    extends LoginMobileNumberOtpScreenEvent {
  final dynamic mLoginMobileNumberOtpScreenListRequest;
  const LoginMobileNumberOtpScreenClickEvent({@required this.mLoginMobileNumberOtpScreenListRequest});

  @override
  List<Object> get props => [mLoginMobileNumberOtpScreenListRequest];
}
