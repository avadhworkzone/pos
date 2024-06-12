/// loyalty_points : [{"points":522,"closing_loyalty_points_balance":962,"type_id":"SALE","affected_by_type":"SALE","happened_at":"2023-03-05 00:09:34"},{"points":248,"closing_loyalty_points_balance":440,"type_id":"SALE","affected_by_type":"SALE","happened_at":"2023-03-04 23:00:26"},{"points":92,"closing_loyalty_points_balance":192,"type_id":"SALE","affected_by_type":"SALE","happened_at":"2023-02-15 13:16:02"},{"points":100,"closing_loyalty_points_balance":100,"type_id":"SIGNUP_BONUS","affected_by_type":"MEMBER","happened_at":"2023-02-15 13:13:54"}]
/// total_records : 4
/// last_page : 1
/// current_page : 1
/// per_page : 10

class TransactionsListResponse {
  TransactionsListResponse({
    this.availablePoints,
    this.redeemPoints,
    this.totalPoints,
    this.loyaltyPoints,
    this.totalRecords,
    this.lastPage,
    this.currentPage,
    this.perPage,});

  TransactionsListResponse.fromJson(dynamic json) {
    if (json['loyalty_points'] != null) {
      loyaltyPoints = [];
      json['loyalty_points'].forEach((v) {
        loyaltyPoints?.add(LoyaltyPoints.fromJson(v));
      });
    }
    totalRecords = json['total_records'];
    lastPage = json['last_page'];
    currentPage = json['current_page'];
    perPage = json['per_page'];
    totalPoints = json['total_points'];
    redeemPoints = json['redeem_points'];
    availablePoints = json['available_points'];
  }
  List<LoyaltyPoints>? loyaltyPoints;

  int? availablePoints;
  int? redeemPoints;
  int? totalPoints;
  int? totalRecords;
  int? lastPage;
  int? currentPage;
  int? perPage;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (loyaltyPoints != null) {
      map['loyalty_points'] = loyaltyPoints?.map((v) => v.toJson()).toList();
    }
    map['redeem_points'] = redeemPoints;
    map['total_records'] = totalRecords;
    map['last_page'] = lastPage;
    map['current_page'] = currentPage;
    map['per_page'] = perPage;
    map['total_points'] = totalPoints;
    map['available_points'] = availablePoints;
    return map;
  }

}

/// points : 522
/// closing_loyalty_points_balance : 962
/// type_id : "SALE"
/// affected_by_type : "SALE"
/// happened_at : "2023-03-05 00:09:34"

class LoyaltyPoints {
  LoyaltyPoints({
    this.points,
    this.closingLoyaltyPointsBalance,
    this.typeId,
    this.affectedByType,
    this.happenedAt,
    this.type,
  });

  LoyaltyPoints.fromJson(dynamic json) {
    points = json['points'];
    closingLoyaltyPointsBalance = json['closing_loyalty_points_balance'];
    typeId = json['type_id'];
    affectedByType = json['affected_by_type'];
    happenedAt = json['happened_at'];
    type = json['type'];
  }
  int? points;
  int? closingLoyaltyPointsBalance;
  String? typeId;
  String? affectedByType;
  String? happenedAt;
  String? type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['points'] = points;
    map['closing_loyalty_points_balance'] = closingLoyaltyPointsBalance;
    map['type_id'] = typeId;
    map['affected_by_type'] = affectedByType;
    map['happened_at'] = happenedAt;
    map['type'] = type;
    return map;
  }

}