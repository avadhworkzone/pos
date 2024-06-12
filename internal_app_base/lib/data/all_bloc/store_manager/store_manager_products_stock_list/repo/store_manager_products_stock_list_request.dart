///per_page:10
///page:1
///sort_by:id
///sort_direction:desc
///search_text:""

class GetStoreManagerProductsStockListRequest {
  GetStoreManagerProductsStockListRequest({
    String? sortDirection,
    String? perPage,
    String? sortBy,
    String? page,
    String? searchText,
  }) {
    _perPage = perPage;
    _sortDirection = sortDirection;
    _sortBy = sortBy;
    _page = page;
    _searchText = searchText;
  }

  GetStoreManagerProductsStockListRequest.fromJson(dynamic json) {
    _perPage = json['per_page'];
    _sortDirection = json['sort_direction'];
    _sortBy = json['sort_by'];
    _page = json['page'];
    _searchText = json['search_text'];
  }

  String? _perPage;
  String? _sortDirection;
  String? _sortBy;
  String? _page;
  String? _searchText;

  String? get sortDirection => _sortDirection;
  String? get perPage => _perPage;
  String? get sortBy => _sortBy;
  String? get page => _page;
  String? get searchText => _searchText;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sort_by'] = _sortBy;
    map['sort_direction'] = _sortDirection;
    map['per_page'] = _perPage;
    map['page'] = _page;
    if(_searchText!.isNotEmpty) {
      map['search_text'] = _searchText;
    }
    return map;
  }
}
