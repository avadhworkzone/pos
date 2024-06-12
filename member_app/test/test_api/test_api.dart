
import 'package:member_app/common/utils/network_utils.dart';
import 'package:member_app/data/all_bloc/login_mobile_number_bloc/bloc/login_mobile_number_screen_bloc.dart';
import 'package:member_app/data/all_bloc/login_mobile_number_bloc/bloc/login_mobile_number_screen_event.dart';
import 'package:member_app/data/all_bloc/login_mobile_number_bloc/repo/login_mobile_number_screen_request.dart';
import 'package:member_app/data/all_bloc/login_mobile_number_otp_bloc/bloc/login_mobile_number_otp_screen_bloc.dart';
import 'package:member_app/data/all_bloc/login_mobile_number_otp_bloc/bloc/login_mobile_number_otp_screen_event.dart';
import 'package:member_app/data/all_bloc/login_mobile_number_otp_bloc/repo/login_mobile_number_otp_screen_request.dart';

class TestApi {
  late LoginMobileNumberScreenBloc _mLoginMobileNumberScreenBloc;
  late LoginMobileNumberOtpScreenBloc _mLoginMobileNumberOtpScreenBloc;

  ///login Mobile Number
  loginMobileNumber(){
    _mLoginMobileNumberScreenBloc = LoginMobileNumberScreenBloc();
     _initLoginMobileNumberScreen("0129505989");
  }

  Future<void> _initLoginMobileNumberScreen(String sMobileNumber) async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        _mLoginMobileNumberScreenBloc.add(LoginMobileNumberScreenClickEvent(
            mLoginMobileNumberScreenListRequest:
            LoginMobileNumberScreenRequest(mobileNumber: sMobileNumber)));
      } else {
        // AppAlert.showSnackBar(context, MessageConstants.noInternetConnection);
      }
    });
  }

  ///login Mobile Number Otp
  loginMobileNumberOtp(){
    _mLoginMobileNumberOtpScreenBloc = LoginMobileNumberOtpScreenBloc();
    _initLoginMobileNumberOtpScreen("0129505989","9999");
  }

  Future<void> _initLoginMobileNumberOtpScreen(String sMobileNumber,String sOtp) async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        _mLoginMobileNumberOtpScreenBloc.add(LoginMobileNumberOtpScreenClickEvent(
            mLoginMobileNumberOtpScreenListRequest:
            LoginMobileNumberOtpScreenRequest(mobileNumber: sMobileNumber,otp: sOtp)));
      } else {
        // AppAlert.showSnackBar(context, MessageConstants.noInternetConnection);
      }
    });
  }
}