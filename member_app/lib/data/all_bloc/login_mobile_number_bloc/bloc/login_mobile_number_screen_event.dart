import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class LoginMobileNumberScreenEvent extends Equatable{
  const LoginMobileNumberScreenEvent();
}

class LoginMobileNumberScreenClickEvent
    extends LoginMobileNumberScreenEvent {
  final dynamic mLoginMobileNumberScreenListRequest;
  const LoginMobileNumberScreenClickEvent({@required this.mLoginMobileNumberScreenListRequest});

  @override
  List<Object> get props => [mLoginMobileNumberScreenListRequest];
}
