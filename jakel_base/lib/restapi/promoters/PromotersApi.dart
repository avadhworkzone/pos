import 'package:jakel_base/restapi/me/model/CashierPermissionResponse.dart';
import 'package:jakel_base/restapi/me/model/CurrentUserResponse.dart';
import 'package:jakel_base/restapi/paymenttypes/model/PaymentTypesResponse.dart';
import 'package:jakel_base/restapi/promoters/model/PromotersResponse.dart';

abstract class PromotersApi {
  Future<PromotersResponse> getPromoters();
}
