import 'package:jakel_pos/modules/newsale/model/NewSaleConfiguration.dart';
import 'package:jakel_pos/modules/newsale/service/new_sale_config_service.dart';

import '../jobs/GetCartCalculationOrderJob.dart';

class NewSaleConfigServiceImpl with NewSaleConfigService {
  @override
  NewSaleConfiguration getConfig() {
    final config = NewSaleConfiguration(
        newSaleCartCalculationSteps: getCartCalculationOrderJob());
    return config;
  }
}
