///per_page:10
///page:1
///sort_by:id
///sort_direction:desc

class MemberVoucherPaginatedListRequest {
  MemberVoucherPaginatedListRequest({
    String? sortDirection,
    String? perPage,
    String? sortBy,
    String? page,
  }) {
    _perPage = perPage;
    _sortDirection = sortDirection;
    _sortBy = sortBy;
    _page = page;
  }

  MemberVoucherPaginatedListRequest.fromJson(dynamic json) {
    _perPage = json['per_page'];
    _sortDirection = json['sort_direction'];
    _sortBy = json['sort_by'];
    _page = json['page'];
  }

  String? _perPage;
  String? _sortDirection;
  String? _sortBy;
  String? _page;

  String? get sortDirection => _sortDirection;
  String? get perPage => _perPage;
  String? get sortBy => _sortBy;
  String? get page => _page;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sort_by'] = _sortBy;
    map['sort_direction'] = _sortDirection;
    map['per_page'] = _perPage;
    map['page'] = _page;
    return map;
  }
}
