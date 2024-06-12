import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/restapi/customers/model/CustomersResponse.dart';
import 'package:jakel_base/restapi/vouchers/model/VoucherConfigurationResponse.dart';
import 'package:intl/intl.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/my_date_utils.dart';

bool isCustomerBirthdayMonth(
    Customers? customer, VoucherConfiguration voucherConfiguration) {
  String? dateOfBirth = customer?.dateOfBirth; // 1978-07-20

  if (dateOfBirth != null) {
    var dob = DateFormat("yyyy-MM-dd").parse(dateOfBirth);
    var now = getNow();

    if (now.month == dob.month) {
      return true;
    }
  }
  return false;
}
