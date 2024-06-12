import 'package:jakel_base/restapi/me/model/CashierPermissionResponse.dart';
import 'package:jakel_base/restapi/me/model/CurrentUserResponse.dart';
import 'package:jakel_base/restapi/paymenttypes/model/PaymentTypesResponse.dart';

abstract class PaymentTypesApi {
  Future<PaymentTypesResponse> getPaymentTypes();
}
