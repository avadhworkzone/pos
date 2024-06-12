import 'dart:math';

import 'package:jakel_base/restapi/cashbacks/model/CashbacksResponse.dart';
import 'package:jakel_base/restapi/sales/model/NewSaleRequest.dart';
import 'package:jakel_base/restapi/vouchers/model/VoucherConfigurationResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/my_date_utils.dart';
import 'package:jakel_pos/modules/cashbacks/validate/base_cashbacks.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_pos/modules/vouchers/validate/base_voucher_config.dart';
import 'package:jakel_pos/modules/vouchers/validate/voucher_config_service_impl.dart';

class CashBackAfterExcludeCategories with BaseCashBacks {
  @override
  String title() {
    return "Some of the categories are excluded in this cashback";
  }

  @override
  String description() {
    return "Some of the categories are excluded in this cashback";
  }

  @override
  bool isValidForThisCart(CartSummary cartSummary, Cashbacks cashback) {
    if (cashback.minimumSpendAmount == null) {
      return false;
    }

    if (cartSummary.getPayableExcludingCategory(cashback.categories ?? []) >
        cashback.minimumSpendAmount!) {
      return true;
    }
    return false;
  }
}
