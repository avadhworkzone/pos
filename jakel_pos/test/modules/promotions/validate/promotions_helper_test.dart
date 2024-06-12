import 'package:flutter_test/flutter_test.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/restapi/customers/model/CustomersResponse.dart';
import 'package:jakel_base/restapi/employees/model/EmployeesResponse.dart';
import 'package:jakel_base/restapi/promotions/model/PromotionsResponse.dart';
import 'package:jakel_pos/modules/promotions/validate/promotion_helper.dart';

void main() {
  test(
      'Should return true for allowWalkInMember in promotion with guest user in cart',
      () {
    CartSummary cartSummary = CartSummary();
    Promotions promotions = Promotions(allowWalkInMember: true);
    expect(
        true,
        isPromotionValidForThisCartForGivenUser(
            "test", cartSummary, promotions));
  });

  test(
      'Should return false for allowWalkInMember in promotion with employee in cart',
      () {
    CartSummary cartSummary = CartSummary();
    cartSummary.employees = Employees();
    Promotions promotions = Promotions(allowWalkInMember: true);
    expect(
        false,
        isPromotionValidForThisCartForGivenUser(
            "test", cartSummary, promotions));
  });

  test(
      'Should return false for allowWalkInMember in promotion with customer in cart',
      () {
    CartSummary cartSummary = CartSummary();
    cartSummary.customers = Customers();
    Promotions promotions = Promotions(allowWalkInMember: true);
    expect(
        false,
        isPromotionValidForThisCartForGivenUser(
            "test", cartSummary, promotions));
  });

  test(
      'Should return true for allowWalkInMember & allowEmployee in promotion with employee attached to cart summary',
      () {
    CartSummary cartSummary = CartSummary();
    cartSummary.employees = Employees();

    Promotions promotions =
        Promotions(allowWalkInMember: true, allowEmployee: true);

    expect(
        true,
        isPromotionValidForThisCartForGivenUser(
            "test", cartSummary, promotions));
  });

  test(
      'Should return true for allowWalkInMember & allowEmployee in promotion with guest attached to cart',
      () {
    CartSummary cartSummary = CartSummary();

    Promotions promotions =
        Promotions(allowWalkInMember: true, allowEmployee: true);

    expect(
        true,
        isPromotionValidForThisCartForGivenUser(
            "test", cartSummary, promotions));
  });

  test(
      'Should return false for allowWalkInMember & allowEmployee in promotion with customer attached to cart',
      () {
    CartSummary cartSummary = CartSummary();
    cartSummary.customers = Customers();

    Promotions promotions =
        Promotions(allowWalkInMember: true, allowEmployee: true);

    expect(
        false,
        isPromotionValidForThisCartForGivenUser(
            "test", cartSummary, promotions));
  });

  test(
      'Should return false for allowRegistered Member in promotion with employee attached to cart summary',
      () {
    CartSummary cartSummary = CartSummary();
    cartSummary.employees = Employees();

    Promotions promotions = Promotions(allowRegisteredMember: true);

    expect(
        false,
        isPromotionValidForThisCartForGivenUser(
            "test", cartSummary, promotions));
  });

  test(
      'Should return false for allowRegistered Member in promotion with guest attached to cart summary',
      () {
    CartSummary cartSummary = CartSummary();

    Promotions promotions = Promotions(allowRegisteredMember: true);

    expect(
        false,
        isPromotionValidForThisCartForGivenUser(
            "test", cartSummary, promotions));
  });

  test(
      'Should return true for allowRegistered Member in promotion with customer attached to cart summary',
      () {
    CartSummary cartSummary = CartSummary();
    cartSummary.customers = Customers();

    Promotions promotions = Promotions(allowRegisteredMember: true);

    expect(
        true,
        isPromotionValidForThisCartForGivenUser(
            "test", cartSummary, promotions));
  });

  test(
      'Should return true for allowRegisteredMember,allowEmployee & allowWalkInMember Member '
      'in promotion with customer attached to cart summary', () {
    CartSummary cartSummary = CartSummary();
    cartSummary.customers = Customers();

    Promotions promotions = Promotions(
        allowRegisteredMember: true,
        allowEmployee: true,
        allowWalkInMember: true);

    expect(
        true,
        isPromotionValidForThisCartForGivenUser(
            "test", cartSummary, promotions));
  });

  test(
      'Should return true for allowRegisteredMember,allowEmployee & allowWalkInMember Member '
      'in promotion with employee attached to cart summary', () {
    CartSummary cartSummary = CartSummary();
    cartSummary.employees = Employees();

    Promotions promotions = Promotions(
        allowRegisteredMember: true,
        allowEmployee: true,
        allowWalkInMember: true);

    expect(
        true,
        isPromotionValidForThisCartForGivenUser(
            "test", cartSummary, promotions));
  });

  test(
      'Should return true for allowRegisteredMember,allowEmployee & allowWalkInMember Member '
      'in promotion with guest attached to cart summary', () {
    CartSummary cartSummary = CartSummary();

    Promotions promotions = Promotions(
        allowRegisteredMember: true,
        allowEmployee: true,
        allowWalkInMember: true);

    expect(
        true,
        isPromotionValidForThisCartForGivenUser(
            "test", cartSummary, promotions));
  });
}
