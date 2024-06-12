import 'package:jakel_base/database/sale/model/BookingSaleReturnsItem.dart';
import 'package:jakel_base/restapi/customers/model/CustomersResponse.dart';
import 'package:jakel_base/restapi/promoters/model/PromotersResponse.dart';

class BookingItemsResetData {
  List<BookingResetProducts>? returnItems;
  List<Promoters>? returnPromoters;
  Customers? customers;
  int? returnId;


  BookingItemsResetData(
      {this.customers, this.returnItems,this.returnPromoters});

}
