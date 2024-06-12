import 'package:jakel_base/restapi/counters/model/GetStoresResponse.dart';

String getStoreName(Stores? store) {
  if (store == null) {
    return "";
  }
  return store.name!;
}

int getStoreId(Stores? store) {
  if (store == null) {
    return 0;
  }
  return store.id!;
}

String getStoreCode(Stores? store) {
  if (store == null) {
    return "";
  }
  return store.code!;
}

String getStoreAddress(Stores? store) {
  if (store == null) {
    return "";
  }
  String value = "";
  if (store.addressLine1 != null) {
    value = "$value${store.addressLine1!},";
  }

  if (store.addressLine2 != null) {
    value = "$value${store.addressLine2!},";
  }

  if (store.city != null) {
    value = value + store.city!;
  }
  return value;
}
