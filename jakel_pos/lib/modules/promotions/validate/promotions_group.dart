class PromotionsGroup {
  static final PromotionsGroup _singleton = PromotionsGroup._internal();

  factory PromotionsGroup() {
    return _singleton;
  }

  PromotionsGroup._internal();

  //This is used to group the discounted items.For example bundle buy of 3 items. Wil be put in same group.
  //while returning these items with groupId should be returned in bundle.
  //In case cheapest free or buy 2 get 3 , like so group of items should be grouped
  int groupId = 0;

  int getNewGroupId() {
    groupId = groupId + 1;
    return groupId;
  }
}
