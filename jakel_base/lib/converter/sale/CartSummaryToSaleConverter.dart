import '../../database/sale/model/CartSummary.dart';
import '../../restapi/sales/model/history/SaveSaleResponse.dart';

abstract class CartSummaryToSaleConverter {
  Future<Sale?> getSaleFromCartSummary(CartSummary cartSummary);
}
