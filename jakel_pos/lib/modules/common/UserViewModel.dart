import 'package:jakel_base/database/user/UserLocalApi.dart';
import 'package:jakel_base/extension/CurrentUserResponseExtension.dart';
import 'package:jakel_base/restapi/me/model/CurrentUserResponse.dart';
import 'package:jakel_base/restapi/takebreak/TakeBreakApi.dart';
import 'package:jakel_base/restapi/takebreak/model/TakeBreakRequest.dart';
import 'package:jakel_base/utils/my_date_utils.dart';
import 'package:jakel_base/utils/my_unique_id.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';
import 'package:jakel_base/locator.dart';
import 'package:jakel_pos/AppPreference.dart';

class UserViewModel extends BaseViewModel {
  Future<CurrentUserResponse?> getCurrentUser() async {
    var localUserApi = locator.get<UserLocalApi>();
    var user = await localUserApi.getCurrentUser();
    return user;
  }

  Future<String> getCurrentCounterWithStore() async {
    var localUserApi = locator.get<UserLocalApi>();
    var user = await localUserApi.getCurrentUser();
    return '${user?.counter?.name ?? ''}, ${user?.store?.name ?? ''}, ${user?.store?.addressLine1 ?? ''}, ${user?.store?.addressLine2 ?? ''}';
  }

  String getDisplayName(CurrentUserResponse? currentUserResponse) {
    if (currentUserResponse == null) {
      return "";
    }
    return currentUserResponse.getDisplayName();
  }

  String getStaffId(CurrentUserResponse? currentUserResponse) {
    return currentUserResponse?.cashier?.staffId ?? '';
  }

  String getProfilePic(CurrentUserResponse? currentUserResponse) {
    if (currentUserResponse == null) {
      return "https://www.woolha.com/media/2020/03/eevee.png";
    }
    return currentUserResponse.getProfilePic();
  }

  Future<void> takeBreak() async {
    var takeBreakApi = locator.get<TakeBreakApi>();
    var userApi = locator.get<UserLocalApi>();
    var user = await userApi.getCurrentUser();
    var uniqueId = getOfflineSaleUniqueId(
        user?.cashier?.id ?? 0, user?.counter?.id ?? 0, user?.counter?.id ?? 0);
    takeBreakApi.takeBreak(TakeBreakRequest(
        happenedAt: dateTimeYmdHis(), takeBreak: true, offlineId: uniqueId));
  }

  Future<void> resumeWorkFromBreak() async {
    var takeBreakApi = locator.get<TakeBreakApi>();
    var userApi = locator.get<UserLocalApi>();
    var user = await userApi.getCurrentUser();
    var uniqueId = getOfflineSaleUniqueId(
        user?.cashier?.id ?? 0, user?.counter?.id ?? 0, user?.counter?.id ?? 0);
    takeBreakApi.takeBreak(TakeBreakRequest(
        happenedAt: dateTimeYmdHis(), takeBreak: false, offlineId: uniqueId));
  }
}
