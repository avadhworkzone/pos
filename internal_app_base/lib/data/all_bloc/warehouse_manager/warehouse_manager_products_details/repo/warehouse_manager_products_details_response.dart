/// productDetails : {"id":66220,"name":"SQ SERIES 190 CALEDONIA TWILL PRINTED","article_number":"SQ266","upc":"2000000001278","retail_price":129,"brand":"","color":"","size":"","categories":[{"id":49,"name":"SQUARE PRINTED WITHOUT DIAMOND"}]}
/// stock : 17

class GetWarehouseManagerProductsDetailsResponse {
  GetWarehouseManagerProductsDetailsResponse({
    this.productDetails,
    this.stock,
  });

  GetWarehouseManagerProductsDetailsResponse.fromJson(dynamic json) {
    productDetails = json['product_details'] != null
        ? ProductDetails.fromJson(json['product_details'])
        : null;
    stock = json['stock'];
  }
  ProductDetails? productDetails;
  int? stock;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (productDetails != null) {
      map['product_details'] = productDetails?.toJson();
    }
    map['stock'] = stock;
    return map;
  }
}

/// id : 66220
/// name : "SQ SERIES 190 CALEDONIA TWILL PRINTED"
/// article_number : "SQ266"
/// upc : "2000000001278"
/// retail_price : 129
/// brand : ""
/// color : ""
/// size : ""
/// categories : [{"id":49,"name":"SQUARE PRINTED WITHOUT DIAMOND"}]

class ProductDetails {
  ProductDetails({
    this.id,
    this.name,
    this.articleNumber,
    this.upc,
    this.retailPrice,
    this.brand,
    this.color,
    this.size,
    this.categories,
  });

  ProductDetails.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    articleNumber = json['article_number'];
    upc = json['upc'];
    retailPrice = json['retail_price'];
    brand = json['brand'];
    color = json['color'];
    size = json['size'];
    if (json['categories'] != null) {
      categories = [];
      json['categories'].forEach((v) {
        categories?.add(Categories.fromJson(v));
      });
    }
  }
  int? id;
  String? name;
  String? articleNumber;
  String? upc;
  int? retailPrice;
  String? brand;
  String? color;
  String? size;
  List<Categories>? categories;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['article_number'] = articleNumber;
    map['upc'] = upc;
    map['retail_price'] = retailPrice;
    map['brand'] = brand;
    map['color'] = color;
    map['size'] = size;
    if (categories != null) {
      map['categories'] = categories?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 49
/// name : "SQUARE PRINTED WITHOUT DIAMOND"

class Categories {
  Categories({
    this.id,
    this.name,
  });

  Categories.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
  int? id;
  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }
}
