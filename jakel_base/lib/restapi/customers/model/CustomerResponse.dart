import 'package:jakel_base/restapi/customers/model/CustomersResponse.dart';

/// member : {"id":85,"type_details":"ppp"}

class CustomerDetailsResponse {
  CustomerDetailsResponse({
      this.member,});

  CustomerDetailsResponse.fromJson(dynamic json) {
    member = json['member'] != null ? Customers.fromJson(json['member']) : null;
  }
  Customers? member;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (member != null) {
      map['member'] = member?.toJson();
    }
    return map;
  }

}
