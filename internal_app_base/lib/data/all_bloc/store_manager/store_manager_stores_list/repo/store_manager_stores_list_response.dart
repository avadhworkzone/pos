/// stores : [{"id":6,"name":"ARIANI GALLERY ALOR SETAR","code":"ARAALS"},{"id":9,"name":"ARIANI GALLERY BANDAR TUN HUSSEIN ONN (BTHO)","code":"ARABAT"},{"id":11,"name":"ARIANI GALLERY BANGI","code":"ARABAG"},{"id":13,"name":"ARIANI GALLERY DAMANSARA","code":"ARADAM"},{"id":15,"name":"ARIANI GALLERY GONG BADAK","code":"ARAGOB"},{"id":16,"name":"ARIANI GALLERY IPOH","code":"ARAIPO"},{"id":17,"name":"ARIANI GALLERY JOHOR BAHRU","code":"ARAJOB"},{"id":18,"name":"ARIANI GALLERY KOTA BHARU","code":"ARAKOB"},{"id":19,"name":"ARIANI READY TO WEAR KUALA LUMPUR","code":"ARRKUL"},{"id":20,"name":"ARIANI READY TO WEAR SHAH ALAM","code":"ARRSHA"},{"id":21,"name":"ARIANI READY TO WEAR BANGI","code":"ARRBAG"},{"id":22,"name":"ARIANI READY TO WEAR WANGSA WALK","code":"ARRWAW"},{"id":23,"name":"ARIANI READY TO WEAR BANDAR TUN HUSSEIN ONN (BTHO)","code":"ARRBAT"},{"id":24,"name":"ARIANI GALLERY KOTA KINABALU","code":"ARAKOK"},{"id":25,"name":"ARIANI READY TO WEAR SENAWANG","code":"ARRSEN"},{"id":26,"name":"ARIANI GALLERY KUALA LUMPUR","code":"ARAKUL"},{"id":27,"name":"ARIANI GALLERY KUALA TERENGGANU","code":"ARAKUT"},{"id":28,"name":"ARIANI GALLERY KUANTAN","code":"ARAKUA"},{"id":29,"name":"ARIANI GALLERY KUBANG KERIAN","code":"ARAKUK"},{"id":30,"name":"ARIANI GALLERY LANGKAWI","code":"ARALAK"},{"id":31,"name":"ARIANI GALLERY MELAKA","code":"ARAMEL"},{"id":32,"name":"ARIANI GALLERY PWTC","code":"ARAPWT"},{"id":33,"name":"ARIANI GALLERY SEGAMAT","code":"ARASEG"},{"id":34,"name":"ARIANI GALLERY SENAWANG","code":"ARASEN"},{"id":35,"name":"ARIANI GALLERY SHAH ALAM","code":"ARASHA"},{"id":36,"name":"ARIANI GALLERY SUNGAI PETANI","code":"ARASUP"},{"id":37,"name":"ARIANI GALLERY TANAH MERAH","code":"ARATAM"},{"id":38,"name":"ARIANI GALLERY WANGSA WALK","code":"ARAWAW"},{"id":44,"name":"ARIANI WAREHOUSE SEMENYIH - HQ","code":"ARAWHHQ"},{"id":45,"name":"ARIANI WAREHOUSE SEGAMAT","code":"ARAWHSG"},{"id":46,"name":"ARIANI READY TO WEAR WAREHOUSE SEMENYIH - HQ","code":"ARRWHHQ"},{"id":47,"name":"ARIANI READY TO WEAR - OPERATION","code":"ARROPN"},{"id":48,"name":"ARIANI E-COMMERCE","code":"ARAECM"},{"id":49,"name":"ARIANI READY TO WEAR WAREHOUSE KUALA LUMPUR","code":"ARRWKL"},{"id":50,"name":"ARIANI GALLERY - OPERATION","code":"ARAOPN"},{"id":51,"name":"SURIA PRIMAMAJU SDN BHD","code":"SPMSB"},{"id":52,"name":"JAKEL WAREHOUSE & DISTRIBUTION CENTRE","code":"JWDC"},{"id":53,"name":"JAKEL PWTC","code":"JAKPWT"},{"id":54,"name":"ARIANI GALLERY IOI","code":"ARAIOI"},{"id":55,"name":"HOUSE OF ARIANI","code":"ARAHOA"},{"id":56,"name":"DELISTED","code":"123"},{"id":57,"name":"KILANG JAKEL TANJUNG SENGKAWANG","code":"JAKTGS"},{"id":58,"name":"CUSTOMER ECOMMERCE","code":"ARACUS"},{"id":59,"name":"LA VELLE CELEBRITY VENDOR SDN BHD","code":"LAVEL"},{"id":60,"name":"ZAREETH ZEHRA WAREHOUSE SEMENYIH","code":"ZAZWAS"},{"id":61,"name":"JAKEL SENAWANG","code":"JAKSNW"}]

class GetStoreManagerStoresListResponse {
  GetStoreManagerStoresListResponse({
    this.stores,});

  GetStoreManagerStoresListResponse.fromJson(dynamic json) {
    if (json['stores'] != null) {
      stores = [];
      json['stores'].forEach((v) {
        stores?.add(Stores.fromJson(v));
      });
    }
  }
  List<Stores>? stores;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (stores != null) {
      map['stores'] = stores?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 6
/// name : "ARIANI GALLERY ALOR SETAR"
/// code : "ARAALS"

class Stores {
  Stores({
    this.id,
    this.name,
    this.code,});

  Stores.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
  }
  num? id;
  String? name;
  String? code;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['code'] = code;
    return map;
  }

}