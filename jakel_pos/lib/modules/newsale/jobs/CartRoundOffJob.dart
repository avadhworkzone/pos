import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/utils/num_utils.dart';

cartRoundOffJob(CartSummary cartSummary, double? amount) {
  double roundOffValue = 0.0;

  String totalAmount = '${getRoundedDoubleValue(amount ?? 0)}';

  if (totalAmount.contains(".")) {
    List<String> values = totalAmount.split(".");
    String decimalValue = values[1];

    String? lastCharacter = decimalValue.substring(1);

    if (lastCharacter.isNotEmpty) {
      lastCharacter = ".0$lastCharacter";

      cartSummary.roundingOffConfigurations?.forEach((element) {
        if (element.decimalPlace == lastCharacter) {
          roundOffValue = getDoubleValue(element.value);
        }
      });
    }
  }

  return roundOffValue;
}
