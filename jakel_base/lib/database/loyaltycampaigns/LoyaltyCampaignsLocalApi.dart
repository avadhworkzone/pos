
import 'package:jakel_base/restapi/loyaltycampaigns/model/LoyaltyCampaignsResponse.dart';

abstract class LoyaltyCampaignsLocalApi {
  /// Save
  Future<void> save(List<LoyaltyCampaigns> elements);

  /// Get All
  Future<List<LoyaltyCampaigns>> getAll();

  /// Delete
  Future<bool> delete(int id);

  /// Delete all
  Future<bool> deleteAll();

  Future<void> clearBox();
}
