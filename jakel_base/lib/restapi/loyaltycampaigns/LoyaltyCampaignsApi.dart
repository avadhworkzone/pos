import 'package:jakel_base/restapi/loyaltycampaigns/model/LoyaltyCampaignsResponse.dart';

abstract class LoyaltyCampaignsApi {
  Future<LoyaltyCampaignsResponse> getLoyaltyCampaigns();
}
