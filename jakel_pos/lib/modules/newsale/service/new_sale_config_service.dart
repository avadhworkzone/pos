import 'package:jakel_pos/modules/newsale/model/NewSaleConfiguration.dart';

mixin NewSaleConfigService {
  ///Get New Sale Configuration To be used while doing cart summary calculation
  NewSaleConfiguration getConfig();
}
