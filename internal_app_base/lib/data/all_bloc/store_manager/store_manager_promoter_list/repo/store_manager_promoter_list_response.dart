class GetStoreManagerPromoterListResponse {
  List<Promoters>? promoters;

  GetStoreManagerPromoterListResponse({this.promoters});

  GetStoreManagerPromoterListResponse.fromJson(Map<String, dynamic> json) {
    if (json['promoters'] != null) {
      promoters = <Promoters>[];
      json['promoters'].forEach((v) {
        promoters!.add(new Promoters.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.promoters != null) {
      data['promoters'] = this.promoters!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Promoters {
  int? id;
  int? employeeId;
  String? name;
  List<Stores>? stores;

  Promoters({this.id, this.employeeId, this.name, this.stores});

  Promoters.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employee_id'];
    name = json['name'];
    if (json['stores'] != null) {
      stores = <Stores>[];
      json['stores'].forEach((v) {
        stores!.add(new Stores.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['employee_id'] = this.employeeId;
    data['name'] = this.name;
    if (this.stores != null) {
      data['stores'] = this.stores!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Stores {
  int? id;
  String? name;

  Stores({this.id, this.name});

  Stores.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
