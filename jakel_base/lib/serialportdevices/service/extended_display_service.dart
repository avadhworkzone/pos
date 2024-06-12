import 'package:jakel_base/database/sale/model/CartSummary.dart';

mixin ExtendedDisplayService {
  Future<bool> notifyCartUpdate(CartSummary cartSummary);

  Future<bool> createNewWindow();
}
