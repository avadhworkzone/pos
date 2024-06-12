import 'package:jakel_base/database/sale/model/CartSummary.dart';

bool allowGuestMember(CartSummary cartSummary, bool? allowWalkInMember) {
  if (allowWalkInMember == true &&
      cartSummary.employees == null &&
      cartSummary.customers == null) {
    return true;
  }
  return false;
}

bool allowRegisteredMember(bool? allowRegisteredMember) {
  return allowRegisteredMember == true;
}

bool allowEmployees(bool? allowEmployee) {
  return allowEmployee == true;
}

// Check if the usr group is available in provided group ids
bool isAvailableInUserGroup(List<int>? groups, int? groupId) {
  var result = false;

  // If no group then return as true
  if ((groups ?? []).isEmpty) {
    return true;
  }

  // If groupId of a user is null return false.
  if (groupId == null) {
    return false;
  }

  groups?.forEach((element) {
    if (element == groupId) {
      result = true;
    }
  });

  return result;
}
