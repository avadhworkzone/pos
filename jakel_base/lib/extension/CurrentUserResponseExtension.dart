import 'package:jakel_base/restapi/me/model/CurrentUserResponse.dart';

extension CurrentUserResponseExtension on CurrentUserResponse {
  String getDisplayName() {
    if (cashier != null && cashier!.firstName != null) {
      return cashier!.firstName!;
    }
    return "${getFirstName()} ${getLastName()}";
  }

  String getFirstName() {
    if (cashier != null && cashier!.firstName != null) {
      return cashier!.firstName!;
    }
    return "";
  }

  String getLastName() {
    if (cashier != null && cashier!.lastName != null) {
      return cashier!.lastName!;
    }
    return "";
  }

  String getProfilePic() {
    return "https://www.woolha.com/media/2020/03/eevee.png";
  }
}
