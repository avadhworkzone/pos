///per_page:10
///page:1
///sort_by:id
///sort_direction:desc

class GetPromoterSalesReturnsListRequest {
  GetPromoterSalesReturnsListRequest({
    String? sortDirection,
    String? perPage,
    String? sortBy,
    String? page,
    String? storeId,
    String? selectedDate,
  }) {
    _perPage = perPage;
    _sortDirection = sortDirection;
    _sortBy = sortBy;
    _page = page;
    _storeId = storeId;
    _selectedDate = selectedDate;
  }

  String? _perPage;
  String? _sortDirection;
  String? _sortBy;
  String? _page;
  String? _storeId;
  String? _selectedDate;

  String? get sortDirection => _sortDirection;
  String? get perPage => _perPage;
  String? get sortBy => _sortBy;
  String? get page => _page;
  String? get storeId => _storeId;
  String? get selectedDate => _selectedDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sort_by'] = _sortBy;
    map['sort_direction'] = _sortDirection;
    map['per_page'] = _perPage;
    map['page'] = _page;
    map['store_id'] = _storeId;
    map['selected_date'] = _selectedDate;
    return map;
  }
}
