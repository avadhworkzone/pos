import 'package:jakel_base/restapi/counters/model/GetStoresResponse.dart';
import 'package:jakel_base/restapi/generatememberloyaltypointvoucher/model/GenerateMemberLoyaltyPointVoucherRequest.dart';
import 'package:jakel_base/restapi/generatememberloyaltypointvoucher/model/GenerateMemberLoyaltyPointVoucherResponse.dart';

abstract class GenerateMemberLoyaltyPointVoucherApi {
  Future<GenerateMemberLoyaltyPointVoucherResponse> generateMemberLoyaltyPointVoucher(
      GenerateMemberLoyaltyPointVoucherRequest request);
}
