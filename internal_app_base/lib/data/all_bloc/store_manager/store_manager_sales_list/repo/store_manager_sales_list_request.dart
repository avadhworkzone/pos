///per_page:10
///page:1
///sort_by:id
///sort_direction:desc
///date_selection:""

class GetStoreManagerSalesListRequest {
  GetStoreManagerSalesListRequest({
    String? sortDirection,
    String? perPage,
    String? sortBy,
    String? page,
    String? dateSelection,
    String? storeId,
  }) {
    _perPage = perPage;
    _sortDirection = sortDirection;
    _sortBy = sortBy;
    _page = page;
    _dateSelection = dateSelection;
    _storeId = storeId;
  }

  GetStoreManagerSalesListRequest.fromJson(dynamic json) {
    _perPage = json['per_page'];
    _sortDirection = json['sort_direction'];
    _sortBy = json['sort_by'];
    _page = json['page'];
    _dateSelection = json['date_selection'];
    _storeId = json['store_id'];
  }

  String? _perPage;
  String? _sortDirection;
  String? _sortBy;
  String? _page;
  String? _dateSelection;
  String? _storeId;

  String? get sortDirection => _sortDirection;
  String? get perPage => _perPage;
  String? get sortBy => _sortBy;
  String? get page => _page;
  String? get dateSelection => _dateSelection;
  String? get storeId => _storeId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sort_by'] = _sortBy;
    map['sort_direction'] = _sortDirection;
    map['per_page'] = _perPage;
    map['page'] = _page;
    map['store_id'] = _storeId;
    if(_dateSelection!.isNotEmpty) {
      map['date_selection'] = _dateSelection;
    }
    return map;
  }
}
