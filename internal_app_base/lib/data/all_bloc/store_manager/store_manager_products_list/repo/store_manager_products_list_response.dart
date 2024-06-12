/// products : [{"id":79942,"name":"SCRUNCHIE","article_number":"M274","price":12},{"id":79941,"name":"SCRUNCHIE","article_number":"M274","price":12},{"id":79940,"name":"SCRUNCHIE","article_number":"M274","price":12},{"id":79939,"name":"SCRUNCHIE","article_number":"M274","price":12},{"id":79938,"name":"SCRUNCHIE","article_number":"M274","price":12},{"id":79937,"name":"SCRUNCHIE","article_number":"M274","price":12},{"id":79936,"name":"SCRUNCHIE","article_number":"M274","price":12},{"id":79935,"name":"SCRUNCHIE","article_number":"M274","price":12},{"id":79934,"name":"SCRUNCHIE","article_number":"M274","price":12},{"id":79933,"name":"LAIKA JUBAH","article_number":"JBH-032307","price":1}]
/// total_records : 51467
/// last_page : 5147
/// current_page : 1
/// per_page : 10

class GetStoreManagerProductsListResponse {
  GetStoreManagerProductsListResponse({
    this.products,
    this.totalRecords,
    this.lastPage,
    this.currentPage,
    this.perPage,});

  GetStoreManagerProductsListResponse.fromJson(dynamic json) {
    if (json['data'] != null) {
      products = [];
      json['data'].forEach((v) {
        products?.add(Products.fromJson(v));
      });
    }
    totalRecords = json['total_records'];
    lastPage = json['last_page'];
    currentPage = json['current_page'];
    perPage = json['per_page'];
  }
  List<Products>? products;
  int? totalRecords;
  int? lastPage;
  int? currentPage;
  int? perPage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (products != null) {
      map['data'] = products?.map((v) => v.toJson()).toList();
    }
    map['total_records'] = totalRecords;
    map['last_page'] = lastPage;
    map['current_page'] = currentPage;
    map['per_page'] = perPage;
    return map;
  }

}

/// id : 79942
/// name : "SCRUNCHIE"
/// article_number : "M274"
/// price : 12
/// upc : M274M25800

class Products {
  Products({
    this.id,
    this.name,
    this.articleNumber,
    this.price,
    this.upc,
    this.stock,
  });

  Products.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    articleNumber = json['article_number'];
    price = json['retail_price'];
    upc = json['upc'];
    stock = json['stock'].toString();
  }
  num? id;
  String? name;
  String? articleNumber;
  num? price;
  String? upc;
  String? stock;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['article_number'] = articleNumber;
    map['retail_price'] = price;
    map['upc'] = upc;
    map['stock'] = stock;
    return map;
  }

}