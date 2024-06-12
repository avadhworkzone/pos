import 'dart:convert';

import '../../../utils/num_utils.dart';

/// products : [{"id":1,"name":"product 4535eveniet name 316593811878","code":"80870430-9bfc-3440-9d53-913e35cfb8eb","unit_of_measure":{"id":1,"name":"Ellen Upton III"},"season":{"id":1,"name":"facilis"},"department":{"id":1,"name":"ea"},"sub_department":"Gds","color":{"id":1,"name":"nobis"},"size":{"id":1,"name":"quo"},"brand":{"id":1,"name":"voluptate"},"style":{"id":1,"name":"dolor"},"upc":"9569141230","ean":"14702675342","custom_sku":"2062398065","manufacturer_sku":"2153607482","article_number":"47320626","price":81.88,"is_temporarily_unavailable":true,"has_batch":true,"stock":"354.00","batch_numbers":[{"batch_number":"72product 4535eveniet name 316593811878","stock":491.1}],"media":[],"categories":[{"id":1,"name":"pariatur"},{"id":2,"name":"repudiandae"},{"id":3,"name":"unde"},{"id":4,"name":"velit"},{"id":5,"name":"deleniti"},{"id":6,"name":"vel"},{"id":7,"name":"adipisci"},{"id":8,"name":"tempore"},{"id":9,"name":"mollitia"},{"id":10,"name":"saepe"},{"id":11,"name":"omnis"},{"id":12,"name":"sequi"},{"id":13,"name":"doloribus"},{"id":14,"name":"quas"},{"id":15,"name":"similique"}],"tags":[{"id":1,"name":"518quod"},{"id":2,"name":"919ut"}]}]
/// total_records : 10000
/// last_page : 10000
/// current_page : 1

ProductsResponse productsResponseFromJson(String str) =>
    ProductsResponse.fromJson(json.decode(str));

String productsResponseToJson(ProductsResponse data) =>
    json.encode(data.toJson());

class ProductsResponse {
  ProductsResponse({
    List<Products>? products,
    int? totalRecords,
    int? lastPage,
    int? currentPage,
  }) {
    _products = products;
    _totalRecords = totalRecords;
    _lastPage = lastPage;
    _currentPage = currentPage;
  }

  ProductsResponse.fromJson(dynamic json) {
    if (json['products'] != null) {
      _products = [];
      json['products'].forEach((v) {
        _products?.add(Products.fromJson(v));
      });
    }
    _totalRecords = json['total_records'];
    _lastPage = json['last_page'];
    _currentPage = json['current_page'];
  }

  List<Products>? _products;
  int? _totalRecords;
  int? _lastPage;
  int? _currentPage;

  ProductsResponse copyWith({
    List<Products>? products,
    int? totalRecords,
    int? lastPage,
    int? currentPage,
  }) =>
      ProductsResponse(
        products: products ?? _products,
        totalRecords: totalRecords ?? _totalRecords,
        lastPage: lastPage ?? _lastPage,
        currentPage: currentPage ?? _currentPage,
      );

  List<Products>? get products => _products;

  int? get totalRecords => _totalRecords;

  int? get lastPage => _lastPage;

  int? get currentPage => _currentPage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_products != null) {
      map['products'] = _products?.map((v) => v.toJson()).toList();
    }
    map['total_records'] = _totalRecords;
    map['last_page'] = _lastPage;
    map['current_page'] = _currentPage;
    return map;
  }
}

/// id : 1
/// name : "product 4535eveniet name 316593811878"
/// code : "80870430-9bfc-3440-9d53-913e35cfb8eb"
/// unit_of_measure : {"id":1,"name":"Ellen Upton III"}
/// season : {"id":1,"name":"facilis"}
/// department : {"id":1,"name":"ea"}
/// sub_department : "Gds"
/// color : {"id":1,"name":"nobis"}
/// size : {"id":1,"name":"quo"}
/// brand : {"id":1,"name":"voluptate"}
/// style : {"id":1,"name":"dolor"}
/// upc : "9569141230"
/// ean : "14702675342"
/// custom_sku : "2062398065"
/// manufacturer_sku : "2153607482"
/// article_number : "47320626"
/// price : 81.88
/// is_temporarily_unavailable : true
/// has_batch : true
/// stock : "354.00"
/// batch_numbers : [{"batch_number":"72product 4535eveniet name 316593811878","stock":491.1}]
/// media : []
/// categories : [{"id":1,"name":"pariatur"},{"id":2,"name":"repudiandae"},{"id":3,"name":"unde"},{"id":4,"name":"velit"},{"id":5,"name":"deleniti"},{"id":6,"name":"vel"},{"id":7,"name":"adipisci"},{"id":8,"name":"tempore"},{"id":9,"name":"mollitia"},{"id":10,"name":"saepe"},{"id":11,"name":"omnis"},{"id":12,"name":"sequi"},{"id":13,"name":"doloribus"},{"id":14,"name":"quas"},{"id":15,"name":"similique"}]
/// tags : [{"id":1,"name":"518quod"},{"id":2,"name":"919ut"}]

Products productsFromJson(String str) => Products.fromJson(json.decode(str));

String productsToJson(Products data) => json.encode(data.toJson());

class Products {
  Products({
    int? id,
    String? name,
    String? code,
    UnitOfMeasure? unitOfMeasure,
    ProductType? productType,
    Season? season,
    Department? department,
    String? subDepartment,
    ProductColor? color,
    Size? size,
    Brand? brand,
    Style? style,
    String? upc,
    String? ean,
    String? customSku,
    String? manufacturerSku,
    String? articleNumber,
    double? price,
    double? wholesalePrice,
    double? staffPrice,
    double? minimumPrice,
    bool? isTemporarilyUnavailable,
    bool? hasBatch,
    double? stock,
    List<BatchNumbers>? batchNumbers,
    List<dynamic>? media,
    List<Categories>? categories,
    List<Tags>? tags,
  }) {
    _id = id;
    _name = name;
    _code = code;
    _staffPrice = staffPrice;
    _unitOfMeasure = unitOfMeasure;
    _productType = productType;
    _season = season;
    _department = department;
    _subDepartment = subDepartment;
    _color = color;
    _size = size;
    _brand = brand;
    _style = style;
    _upc = upc;
    _ean = ean;
    _customSku = customSku;
    _manufacturerSku = manufacturerSku;
    _articleNumber = articleNumber;
    _price = price;
    _wholesalePrice = wholesalePrice;
    _minimumPrice = minimumPrice;
    _isTemporarilyUnavailable = isTemporarilyUnavailable;
    _hasBatch = hasBatch;
    _stock = stock;
    _batchNumbers = batchNumbers;
    _media = media;
    _categories = categories;
    _tags = tags;
  }

  Products.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _code = json['code'];
    _unitOfMeasure = json['unit_of_measure'] != null
        ? UnitOfMeasure.fromJson(json['unit_of_measure'])
        : null;
    _productType =
        json['type_id'] != null ? ProductType.fromJson(json['type_id']) : null;
    _season = json['season'] != null ? Season.fromJson(json['season']) : null;
    _department = json['department'] != null
        ? Department.fromJson(json['department'])
        : null;
    _subDepartment = json['sub_department'];
    _color =
        json['color'] != null ? ProductColor.fromJson(json['color']) : null;
    _size = json['size'] != null ? Size.fromJson(json['size']) : null;
    _brand = json['brand'] != null ? Brand.fromJson(json['brand']) : null;
    _style = json['style'] != null ? Style.fromJson(json['style']) : null;
    _upc = json['upc'];
    _ean = json['ean'];
    _customSku = json['custom_sku'];
    _manufacturerSku = json['manufacturer_sku'];
    _articleNumber = json['article_number'];
    _price = getDoubleValue(json['price']);
    _wholesalePrice = getDoubleValue(json['wholesale_price']);
    _staffPrice = getDoubleValue(json['staff_price']);
    _minimumPrice = getDoubleValue(json['minimum_price']);
    _isTemporarilyUnavailable = json['is_temporarily_unavailable'];
    _hasBatch = json['has_batch'];

    _stock = getDoubleValue(json['stock']);

    if (json['batch_numbers'] != null) {
      _batchNumbers = [];
      json['batch_numbers'].forEach((v) {
        _batchNumbers?.add(BatchNumbers.fromJson(v));
      });
    }
    // if (json['media'] != null) {
    //   _media = [];
    //   json['media'].forEach((v) {
    //     _media?.add(Dynamic.fromJson(v));
    //   });
    // }
    if (json['categories'] != null) {
      _categories = [];
      json['categories'].forEach((v) {
        _categories?.add(Categories.fromJson(v));
      });
    }
    if (json['tags'] != null) {
      _tags = [];
      json['tags'].forEach((v) {
        _tags?.add(Tags.fromJson(v));
      });
    }
  }

  int? _id;
  String? _name;
  String? _code;
  UnitOfMeasure? _unitOfMeasure;
  ProductType? _productType;
  Season? _season;
  Department? _department;
  String? _subDepartment;
  ProductColor? _color;
  Size? _size;
  Brand? _brand;
  Style? _style;
  String? _upc;
  String? _ean;
  String? _customSku;
  String? _manufacturerSku;
  String? _articleNumber;
  double? _price;
  double? _wholesalePrice;
  double? _staffPrice;
  double? _minimumPrice;
  bool? _isTemporarilyUnavailable;
  bool? _hasBatch;
  double? _stock;
  List<BatchNumbers>? _batchNumbers;
  List<dynamic>? _media;
  List<Categories>? _categories;
  List<Tags>? _tags;

  int? get id => _id;

  String? get name => _name;

  String? get code => _code;

  UnitOfMeasure? get unitOfMeasure => _unitOfMeasure;

  ProductType? get productType => _productType;

  Season? get season => _season;

  Department? get department => _department;

  String? get subDepartment => _subDepartment;

  ProductColor? get color => _color;

  Size? get size => _size;

  Brand? get brand => _brand;

  Style? get style => _style;

  String? get upc => _upc;

  String? get ean => _ean;

  String? get customSku => _customSku;

  String? get manufacturerSku => _manufacturerSku;

  String? get articleNumber => _articleNumber;

  double? get price => _price;

  double? get wholesalePrice => _wholesalePrice;

  double? get staff_price => _staffPrice;

  double? get minimumPrice => _minimumPrice;

  bool? get isTemporarilyUnavailable => _isTemporarilyUnavailable;

  bool? get hasBatch => _hasBatch;

  double? get stock => _stock;

  List<BatchNumbers>? get batchNumbers => _batchNumbers;

  List<dynamic>? get media => _media;

  List<Categories>? get categories => _categories;

  List<Tags>? get tags => _tags;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['code'] = _code;
    if (_unitOfMeasure != null) {
      map['unit_of_measure'] = _unitOfMeasure?.toJson();
    }

    if (_productType != null) {
      map['type_id'] = _productType?.toJson();
    }

    if (_season != null) {
      map['season'] = _season?.toJson();
    }
    if (_department != null) {
      map['department'] = _department?.toJson();
    }
    map['sub_department'] = _subDepartment;
    if (_color != null) {
      map['color'] = _color?.toJson();
    }
    if (_size != null) {
      map['size'] = _size?.toJson();
    }
    if (_brand != null) {
      map['brand'] = _brand?.toJson();
    }
    if (_style != null) {
      map['style'] = _style?.toJson();
    }
    map['upc'] = _upc;
    map['ean'] = _ean;
    map['custom_sku'] = _customSku;
    map['manufacturer_sku'] = _manufacturerSku;
    map['article_number'] = _articleNumber;
    map['price'] = _price;
    map['wholesale_price'] = _wholesalePrice;
    map['staff_price'] = _staffPrice;

    map['minimum_price'] = _minimumPrice;
    map['is_temporarily_unavailable'] = _isTemporarilyUnavailable;
    map['has_batch'] = _hasBatch;
    map['stock'] = _stock;
    if (_batchNumbers != null) {
      map['batch_numbers'] = _batchNumbers?.map((v) => v.toJson()).toList();
    }
    if (_media != null) {
      map['media'] = _media?.map((v) => v.toJson()).toList();
    }
    if (_categories != null) {
      map['categories'] = _categories?.map((v) => v.toJson()).toList();
    }
    if (_tags != null) {
      map['tags'] = _tags?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 1
/// name : "518quod"

Tags tagsFromJson(String str) => Tags.fromJson(json.decode(str));

String tagsToJson(Tags data) => json.encode(data.toJson());

class Tags {
  Tags({
    int? id,
    String? name,
  }) {
    _id = id;
    _name = name;
  }

  Tags.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
  }

  int? _id;
  String? _name;

  Tags copyWith({
    int? id,
    String? name,
  }) =>
      Tags(
        id: id ?? _id,
        name: name ?? _name,
      );

  int? get id => _id;

  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    return map;
  }
}

/// id : 1
/// name : "pariatur"

Categories categoriesFromJson(String str) =>
    Categories.fromJson(json.decode(str));

String categoriesToJson(Categories data) => json.encode(data.toJson());

class Categories {
  Categories({
    int? id,
    String? name,
  }) {
    _id = id;
    _name = name;
  }

  Categories.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
  }

  int? _id;
  String? _name;

  Categories copyWith({
    int? id,
    String? name,
  }) =>
      Categories(
        id: id ?? _id,
        name: name ?? _name,
      );

  int? get id => _id;

  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    return map;
  }
}

/// batch_number : "72product 4535eveniet name 316593811878"
/// stock : 491.1

BatchNumbers batchNumbersFromJson(String str) =>
    BatchNumbers.fromJson(json.decode(str));

String batchNumbersToJson(BatchNumbers data) => json.encode(data.toJson());

class BatchNumbers {
  BatchNumbers({
    String? batchNumber,
    double? stock,
  }) {
    _batchNumber = batchNumber;
    _stock = stock;
  }

  BatchNumbers.fromJson(dynamic json) {
    _batchNumber = json['batch_number'];
    _stock = getDoubleValue(json['stock']);
  }

  String? _batchNumber;
  double? _stock;

  BatchNumbers copyWith({
    String? batchNumber,
    double? stock,
  }) =>
      BatchNumbers(
        batchNumber: batchNumber ?? _batchNumber,
        stock: stock ?? _stock,
      );

  String? get batchNumber => _batchNumber;

  double? get stock => _stock;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['batch_number'] = _batchNumber;
    map['stock'] = _stock;
    return map;
  }
}

/// id : 1
/// name : "dolor"

Style styleFromJson(String str) => Style.fromJson(json.decode(str));

String styleToJson(Style data) => json.encode(data.toJson());

class Style {
  Style({
    int? id,
    String? name,
  }) {
    _id = id;
    _name = name;
  }

  Style.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
  }

  int? _id;
  String? _name;

  Style copyWith({
    int? id,
    String? name,
  }) =>
      Style(
        id: id ?? _id,
        name: name ?? _name,
      );

  int? get id => _id;

  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    return map;
  }
}

/// id : 1
/// name : "voluptate"

Brand brandFromJson(String str) => Brand.fromJson(json.decode(str));

String brandToJson(Brand data) => json.encode(data.toJson());

class Brand {
  Brand({
    int? id,
    String? name,
  }) {
    _id = id;
    _name = name;
  }

  Brand.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
  }

  int? _id;
  String? _name;

  Brand copyWith({
    int? id,
    String? name,
  }) =>
      Brand(
        id: id ?? _id,
        name: name ?? _name,
      );

  int? get id => _id;

  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    return map;
  }
}

/// id : 1
/// name : "quo"

Size sizeFromJson(String str) => Size.fromJson(json.decode(str));

String sizeToJson(Size data) => json.encode(data.toJson());

class Size {
  Size({
    int? id,
    String? name,
  }) {
    _id = id;
    _name = name;
  }

  Size.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
  }

  int? _id;
  String? _name;

  Size copyWith({
    int? id,
    String? name,
  }) =>
      Size(
        id: id ?? _id,
        name: name ?? _name,
      );

  int? get id => _id;

  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    return map;
  }
}

/// id : 1
/// name : "nobis"

ProductColor colorFromJson(String str) =>
    ProductColor.fromJson(json.decode(str));

String colorToJson(ProductColor data) => json.encode(data.toJson());

class ProductColor {
  ProductColor({
    int? id,
    String? name,
  }) {
    _id = id;
    _name = name;
  }

  ProductColor.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
  }

  int? _id;
  String? _name;

  ProductColor copyWith({
    int? id,
    String? name,
  }) =>
      ProductColor(
        id: id ?? _id,
        name: name ?? _name,
      );

  int? get id => _id;

  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    return map;
  }
}

/// id : 1
/// name : "ea"

Department departmentFromJson(String str) =>
    Department.fromJson(json.decode(str));

String departmentToJson(Department data) => json.encode(data.toJson());

class Department {
  Department({
    int? id,
    String? name,
  }) {
    _id = id;
    _name = name;
  }

  Department.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
  }

  int? _id;
  String? _name;

  Department copyWith({
    int? id,
    String? name,
  }) =>
      Department(
        id: id ?? _id,
        name: name ?? _name,
      );

  int? get id => _id;

  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    return map;
  }
}

/// id : 1
/// name : "facilis"

Season seasonFromJson(String str) => Season.fromJson(json.decode(str));

String seasonToJson(Season data) => json.encode(data.toJson());

class Season {
  Season({
    int? id,
    String? name,
  }) {
    _id = id;
    _name = name;
  }

  Season.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
  }

  int? _id;
  String? _name;

  Season copyWith({
    int? id,
    String? name,
  }) =>
      Season(
        id: id ?? _id,
        name: name ?? _name,
      );

  int? get id => _id;

  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    return map;
  }
}

/// id : 1
/// name : "Ellen Upton III"

UnitOfMeasure unitOfMeasureFromJson(String str) =>
    UnitOfMeasure.fromJson(json.decode(str));

String unitOfMeasureToJson(UnitOfMeasure data) => json.encode(data.toJson());

class UnitOfMeasure {
  UnitOfMeasure({
    int? id,
    String? name,
  }) {
    _id = id;
    _name = name;
  }

  UnitOfMeasure.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
  }

  int? _id;
  String? _name;

  UnitOfMeasure copyWith({
    int? id,
    String? name,
  }) =>
      UnitOfMeasure(
        id: id ?? _id,
        name: name ?? _name,
      );

  int? get id => _id;

  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    return map;
  }
}
// "id": 3,
// "name": "Custom Order",
// "key": "CUSTOM_ORDER"

ProductType productTypeFromJson(String str) =>
    ProductType.fromJson(json.decode(str));

String productTypeToJson(ProductType data) => json.encode(data.toJson());

class ProductType {
  ProductType({int? id, String? name, String? key}) {
    _id = id;
    _name = name;
    _key = key;
  }

  ProductType.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _key = json['key'];
  }

  int? _id;
  String? _name;
  String? _key;

  int? get id => _id;

  String? get name => _name;

  String? get key => _key;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['key'] = _key;

    return map;
  }
}
