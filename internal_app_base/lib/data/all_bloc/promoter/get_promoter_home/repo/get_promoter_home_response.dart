/// this_month_item_sold : 0
/// last_month_item_sold : null
/// last_month_commission_amount : null

class GetPromoterHomeResponse {
  GetPromoterHomeResponse({
    this.thisMonthItemSold,
    this.lastMonthItemSold,
    this.lastMonthCommissionAmount,});

  GetPromoterHomeResponse.fromJson(dynamic json) {
    thisMonthItemSold = json['this_month_item_sold'].toString();
    lastMonthItemSold = json['last_month_item_sold'].toString();
    lastMonthCommissionAmount = json['last_month_commission_amount'].toString();
  }
  String? thisMonthItemSold;
  String? lastMonthItemSold;
  String? lastMonthCommissionAmount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['this_month_item_sold'] = thisMonthItemSold;
    map['last_month_item_sold'] = lastMonthItemSold;
    map['last_month_commission_amount'] = lastMonthCommissionAmount;
    return map;
  }

}