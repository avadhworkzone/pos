import 'dart:convert';

import 'package:jakel_base/database/paymenttypes/PaymentTypesLocalApi.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/database/sale/model/PaymentTypeData.dart';
import 'package:jakel_base/locator.dart';
import 'package:jakel_base/restapi/customers/model/CustomersResponse.dart';
import 'package:jakel_base/restapi/paymenttypes/model/PaymentTypesResponse.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';

class PaymentTypeViewModel extends BaseViewModel {
  Future<List<PaymentTypes>> getFilteredPaymentTypes(
      CartSummary cartSummary, List<PaymentTypes>? existing) async {
    List<PaymentTypes> allTypes =
        await getAllPaymentTypes(cartSummary.customers);
    List<PaymentTypes> allCartSummaryPaymentsTypes = [];

    if (existing == null || (cartSummary.payments ?? []).isEmpty) {
      return allTypes;
    }

    bool returnAllData = false;

    for (var value1 in existing) {
      if (!doesPaymentExists(value1, allTypes)) {
        returnAllData = true;
      }
    }

    for (var value in allTypes) {
      if (!doesPaymentExists(value, existing)) {
        returnAllData = true;
      }
    }

    if (cartSummary.payments!.isNotEmpty && !returnAllData) {
      returnAllData = true;
      for (var value1 in existing) {
        if (value1.name == cartSummary.payments![0].paymentType!.name &&
            value1.localId == cartSummary.payments![0].paymentType!.localId) {
          returnAllData = false;
          break;
        }
      }
    }

    if (returnAllData) {
      if (cartSummary.payments!.isNotEmpty) {
        for (var value in cartSummary.payments!) {
          allTypes
              .removeWhere((element) => element.id == value.paymentType!.id);
          allCartSummaryPaymentsTypes.add(value.paymentType!);
        }
        allTypes.addAll(allCartSummaryPaymentsTypes);
      }
      return allTypes;
    }

    return existing;
  }

  bool doesPaymentExists(PaymentTypes type, List<PaymentTypes> types) {
    for (var value in types) {
      if (value.id == type.id) {
        return true;
      }
    }
    return false;
  }

  Future<List<PaymentTypes>> getAllFilteredPaymentTypes(
      Customers? customers) async {
    List<PaymentTypes> allTypes = await getAllPaymentTypes(customers);
    List<PaymentTypes> allFilteredTypes = [];
    for (var paymentTypes in allTypes) {
      allFilteredTypes.add(paymentTypes);
    }

    return allFilteredTypes;
  }

  Future<List<PaymentTypes>> getAllPaymentTypes(Customers? customers) async {
    var api = locator.get<PaymentTypesLocalApi>();
    List<PaymentTypes> allTypes = await api.getAll();

    List<PaymentTypes> mainTypes = List.empty(growable: true);

    for (var value in allTypes) {
      mainTypes.add(value);
    }

    if (customers != null) {
      return getPaymentTypesWithLocalId(mainTypes);
    }

    List<PaymentTypes> filtered = List.empty(growable: true);
    for (var value in mainTypes) {
      if ((value.isCustomerRequired != null &&
          value.isCustomerRequired == false)) {
        filtered.add(value);
      }
    }

    return getPaymentTypesWithLocalId(filtered);
  }

  Future<List<PaymentTypes>> getAllFilteredBookingPaymentTypes() async {
    List<PaymentTypes> allTypes = await getAllBookingPaymentTypes();
    List<PaymentTypes> allFilteredTypes = [];
    for (var paymentTypes in allTypes) {
      if(paymentTypes.id != bookingPaymentId &&
          paymentTypes.id != creditNotePaymentId &&
          paymentTypes.id != loyaltyPointPaymentId &&
          paymentTypes.id != giftCardPaymentId) {
        allFilteredTypes.add(paymentTypes);
      }
    }

    return allFilteredTypes;
  }

  Future<List<PaymentTypes>> getAllBookingPaymentTypes() async {
    var api = locator.get<PaymentTypesLocalApi>();
    List<PaymentTypes> allTypes = await api.getAll();

    List<PaymentTypes> mainTypes = List.empty(growable: true);

    for (var value in allTypes) {
      mainTypes.add(value);
    }

      return getPaymentTypesWithLocalId(mainTypes);

  }

  List<PaymentTypes> getPaymentTypesWithLocalId(List<PaymentTypes> filtered) {
    List<PaymentTypes> finalList = List.empty(growable: true);
    for (var value1 in filtered) {
      finalList.add(getPaymentTypeWithLocalId(value1));
    }
    return finalList;
  }

  PaymentTypes getPaymentTypeWithLocalId(PaymentTypes type) {
    Map<String, dynamic> jsonMap = type.toJson();
    jsonMap['localId'] = '${DateTime.now().millisecondsSinceEpoch}-${type.id}';
    var newType = PaymentTypes.fromJson(jsonMap);
    return newType;
  }

  void sortPaymentTypes(List<PaymentTypes> paymentTypes) {
    paymentTypes.sort((a, b) {
      return (a.name ?? '').compareTo(b.name ?? '');
    });
  }

  double checkAndGetExistingPayment(
      CartSummary cartSummary, PaymentTypes paymentTypes) {
    double amount = 0.0;

    cartSummary.payments?.forEach((element) {
      if (element.paymentType?.localId == paymentTypes.localId) {
        amount = element.amount;
      }
    });
    return amount;
  }

  String checkAndGetExistingCardNo(
      CartSummary cartSummary, PaymentTypes paymentTypes) {
    String cardNo = "";

    cartSummary.payments?.forEach((element) {
      if (element.paymentType?.localId == paymentTypes.localId) {
        cardNo = element.cardNo ?? "";
      }
    });
    return cardNo;
  }

  int getLoyaltyPaymentId(CartSummary cartSummary, PaymentTypes paymentTypes) {
    int sLoyaltyPaymentId = -1;
    cartSummary.payments?.forEach((element) {
      if (element.paymentType?.localId == paymentTypes.localId) {
        sLoyaltyPaymentId = (element.loyaltyPoints??-1) ;
      }
    });
    return sLoyaltyPaymentId;
  }

  int getGiftCardId(CartSummary cartSummary, PaymentTypes paymentTypes) {
    String sGiftCardId = "-1";
    cartSummary.payments?.forEach((element) {
      if (element.paymentType?.localId == paymentTypes.localId) {
        sGiftCardId = element.giftCardNumber!;
      }
    });
    return int.parse(sGiftCardId);
  }

  double getGiftCardAmount(CartSummary cartSummary, PaymentTypes paymentTypes) {
    double sGiftCardAmount = 0.0;
    cartSummary.payments?.forEach((element) {
      if (element.paymentType?.localId == paymentTypes.localId) {
        sGiftCardAmount = element.amount!;
      }
    });
    return sGiftCardAmount;
  }

  int getCreditNoteId(CartSummary cartSummary, PaymentTypes paymentTypes) {
    int sCreditNoteId = -1;
    cartSummary.payments?.forEach((element) {
      if (element.paymentType?.localId == paymentTypes.localId) {
        sCreditNoteId = element.creditNoteId!;
      }
    });
    return sCreditNoteId;
  }

  bool getBookingPaymentsId(CartSummary cartSummary, PaymentTypes paymentTypes) {

    for(PaymentTypeData element in cartSummary.payments??[]){
      if (element.paymentType?.localId == paymentTypes.localId) {
        return true;
      }
    }
    return false;
  }

  double getCreditNoteAmount(
      CartSummary cartSummary, PaymentTypes paymentTypes) {
    double sCreditNoteAmount = 0.0;
    cartSummary.payments?.forEach((element) {
      if (element.paymentType?.localId == paymentTypes.localId) {
        sCreditNoteAmount = element.amount!;
      }
    });
    return sCreditNoteAmount;
  }

  bool showAddIcon(CartSummary cartSummary, PaymentTypes paymentTypes) {
    if (paymentTypes.id != bookingPaymentId &&
        paymentTypes.id != loyaltyPointPaymentId) {
      if ((cartSummary.payments ?? []).isNotEmpty) {
        for (var value in cartSummary.payments!) {
          if (value.amount > 0 &&
              value.paymentType?.localId == paymentTypes.localId) {
            return true;
          }
        }
      }
    }
    return false;
  }
}
