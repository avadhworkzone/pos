import 'package:jakel_base/restapi/counters/model/GetCountersResponse.dart';

String getCounterName(Counters? counter) {
  if (counter == null) {
    return "";
  }
  return counter.name!;
}

int getStoreId(Counters? counter) {
  if (counter == null) {
    return 0;
  }
  return counter.id!;
}

bool isLocked(Counters? counter) {
  if (counter == null) {
    return false;
  }
  if (counter.isLocked == null) {
    return false;
  }
  return counter.isLocked as bool;
}

bool isOpened(Counters? counter) {
  if (counter == null) {
    return false;
  }
  if (counter.isOpened == null) {
    return false;
  }
  return counter.isOpened as bool;
}
