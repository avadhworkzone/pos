///per_page:10
///page:1
///sort_by:id
///sort_direction:desc

class GetPromoterCommissionListRequest {
  GetPromoterCommissionListRequest({
    String? sortDirection,
    String? perPage,
    String? sortBy,
    String? page,
    String? storeId,
    String? startDate,
    String? endDate,
  }) {
    _perPage = perPage;
    _sortDirection = sortDirection;
    _sortBy = sortBy;
    _page = page;
    _storeId = storeId;
    _startDate = startDate;
    _endDate = endDate;
  }

  String? _perPage;
  String? _sortDirection;
  String? _sortBy;
  String? _page;
  String? _storeId;
  String? _startDate;
  String? _endDate;

  String? get sortDirection => _sortDirection;
  String? get perPage => _perPage;
  String? get sortBy => _sortBy;
  String? get page => _page;
  String? get storeId => _storeId;
  String? get startDate => _startDate;
  String? get endDate => _endDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sort_by'] = _sortBy;
    map['sort_direction'] = _sortDirection;
    map['per_page'] = _perPage;
    map['page'] = _page;
    map['store_id'] = _storeId;
    map['start_date'] = _startDate;
    map['end_date'] = _endDate;
    return map;
  }
}
