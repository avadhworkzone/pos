import 'package:jakel_base/database/sale/model/CartSummary.dart';

import '../serialportdevices/service/may_bank_terminal_card_mapper.dart';
import '../utils/MyLogUtils.dart';

List<String>? getExtraDetailsFromMbb(CartSummary cartSummary) {
  List<String>? extraDetails;

  MyLogUtils.logDebug(
      "cartSummary.mayBankPaymentDetailList  : ${cartSummary.mayBankPaymentDetailList?.length}");

  if (cartSummary.mayBankPaymentDetailList != null &&
      cartSummary.mayBankPaymentDetailList!.isNotEmpty) {
    extraDetails = List.empty(growable: true);

    cartSummary.mayBankPaymentDetailList?.forEach((element) {
      extraDetails?.add(getPaymentCardFromMbbCode(element.cardType));

      if (element.cardNumber != null) {
        extraDetails?.add("Card No : ${element.cardNumber}");
      }

      if (element.expiry != null) {
        extraDetails?.add("Expiry :${element.expiry}");
      }

      if (element.approvalCode != null) {
        extraDetails?.add("Approval :${element.approvalCode}");
      }
    });
  }

  MyLogUtils.logDebug("getExtraDetailsFromMbb extraDetails : ${extraDetails}");
  return extraDetails;
}
