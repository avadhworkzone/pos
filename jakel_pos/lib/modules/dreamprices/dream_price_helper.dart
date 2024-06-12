import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/restapi/dreamprice/model/DreamPriceResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/my_date_utils.dart';

import '../utils/validation_helper.dart';

bool isDreamPriceValidForThisCart(
    String tag, CartSummary cartSummary, DreamPrices dreamPrice) {
  // First check if valid for this user.
  if (_isValidForThisUser(tag, cartSummary, dreamPrice)) {
    // Next Check if valid for this date.
    MyLogUtils.logDebug("isDreamPriceValidForThisCart _isValidForThisUser");
    if (_isValidDate(tag, cartSummary, dreamPrice)) {
      return true;
    }
  }
  return false;
}

bool _isValidForThisUser(
    String tag, CartSummary cartSummary, DreamPrices dreamPrice) {
  // Guests Validation
  if (allowGuestMember(cartSummary, dreamPrice.allowWalkInMember)) {
    if (cartSummary.employees == null && cartSummary.customers == null) {
      return true;
    }
  }

  // Employees Validation
  if (allowEmployees(dreamPrice.allowEmployee)) {
    if (cartSummary.employees != null) {
      // Member groups compatibility.
      List<int> employeeGroupIds = List.empty(growable: true);

      dreamPrice.employeeGroups?.forEach((element) {
        employeeGroupIds.add(element.id ?? 0);
      });

      if (employeeGroupIds.isEmpty) {
        return true;
      }

      bool result = isAvailableInUserGroup(
          employeeGroupIds, cartSummary.employees?.employeeGroup?.id);

      if (result) {
        return true;
      }
      return true;
    }
  }

  // Members Validation
  if (allowRegisteredMember(dreamPrice.allowRegisteredMember)) {
    MyLogUtils.logDebug("allowRegisteredMember for dream Price");
    if (cartSummary.customers != null) {
      // Member groups compatibility.

      List<int> memberGroupIds = List.empty(growable: true);

      MyLogUtils.logDebug(
          "allowRegisteredMember for dream Price memberGroupIds : $memberGroupIds");

      dreamPrice.memberGroups?.forEach((element) {
        memberGroupIds.add(element.id ?? 0);
      });

      if (memberGroupIds.isEmpty) {
        return true;
      }

      bool result = isAvailableInUserGroup(
          memberGroupIds, cartSummary.customers?.memberGroup?.id);

      if (result) {
        return true;
      }
      return true;
    }
  }

  return false;
}

bool _isValidDate(String tag, CartSummary cartSummary, DreamPrices dreamPrice) {
  // Check for starting date
  bool checkStartDate = false;
  if (dreamPrice.startDate != null) {
    checkStartDate = checkTheDateIsAfterOrSame(dreamPrice.startDate!);
  } else {
    checkStartDate = true;
  }

  // Check for ending date.
  bool checkEndDate = false;
  if (dreamPrice.endDate != null) {
    checkEndDate = checkTheDateIsBeforeOrSame(dreamPrice.endDate!);
  } else {
    checkEndDate = true;
  }

  if (checkEndDate && checkStartDate && dreamPrice.products != null) {
    return true;
  }

  return false;
}
