///per_page:10
///page:1
///sort_by:id
///sort_direction:desc
///search_text:""

class GetPromoterProductsListRequest {
  GetPromoterProductsListRequest({
    String? sortDirection,
    String? perPage,
    String? sortBy,
    String? page,
    String? searchText,
    String? stock,
    String? storeId,
  }) {
    _perPage = perPage;
    _sortDirection = sortDirection;
    _sortBy = sortBy;
    _page = page;
    _searchText = searchText;
    _stock = stock;
    _storeId = storeId;
  }

  GetPromoterProductsListRequest.fromJson(dynamic json) {
    _perPage = json['per_page'];
    _sortDirection = json['sort_direction'];
    _sortBy = json['sort_by'];
    _page = json['page'];
    _searchText = json['search_text'];
    _stock = json['out_of_stock_products'];
    _storeId = json['store_id'];
  }

  String? _perPage;
  String? _sortDirection;
  String? _sortBy;
  String? _page;
  String? _searchText;
  String? _stock;
  String? _storeId;

  String? get sortDirection => _sortDirection;
  String? get perPage => _perPage;
  String? get sortBy => _sortBy;
  String? get page => _page;
  String? get searchText => _searchText;
  String? get stock => _stock;
  String? get storeId => _storeId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sort_by'] = _sortBy;
    map['sort_direction'] = _sortDirection;
    map['per_page'] = _perPage;
    map['page'] = _page;
    if (_searchText!.isNotEmpty) {
      map['search_text'] = _searchText;
    }
    if (_stock!.isNotEmpty) {
      map['out_of_stock_products'] = _stock;
    }
    ;
    map['store_id'] = _storeId;
    return map;
  }
}
