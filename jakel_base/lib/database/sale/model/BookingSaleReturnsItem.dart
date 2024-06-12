
import 'package:jakel_base/restapi/promoters/model/PromotersResponse.dart';

import '../../../restapi/products/model/ProductsResponse.dart';

class BookingResetProducts {
  Products? returnItems;
  List<Promoters>? promoters;
  int? quantity;
  BookingResetProducts({ this.returnItems,this.promoters,this.quantity});

}