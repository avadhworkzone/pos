import 'package:flutter/material.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';

class NewSaleInheritedWidget extends InheritedWidget {
  const NewSaleInheritedWidget({
    Key? key,
    required this.cartSummary,
    required Widget child,
  }) : super(key: key, child: child);

  final CartSummary cartSummary;

  static NewSaleInheritedWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NewSaleInheritedWidget>()
        as NewSaleInheritedWidget;
  }

  @override
  bool updateShouldNotify(NewSaleInheritedWidget old) {
    return cartSummary != old.cartSummary;
  }
}
