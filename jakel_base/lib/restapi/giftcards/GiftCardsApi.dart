import 'model/GiftCardsResponse.dart';

abstract class GiftCardsApi {
  Future<GiftCardsResponse> getGiftCards(int pageNo, int perPage);
}
