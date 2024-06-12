import 'package:flutter/material.dart';

import '../../model/ShiftCloseDeclarationModel.dart';

class ShiftCloseInheritedWidget extends InheritedWidget {
  const ShiftCloseInheritedWidget({
    Key? key,
    required this.shiftDeclaration,
    required Widget child,
  }) : super(key: key, child: child);

  final ShiftCloseDeclarationModel shiftDeclaration;

  static ShiftCloseInheritedWidget of(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<ShiftCloseInheritedWidget>()
        as ShiftCloseInheritedWidget;
  }

  @override
  bool updateShouldNotify(ShiftCloseInheritedWidget old) {
    return shiftDeclaration != old.shiftDeclaration;
  }

  bool isPaymentMisMatch() {
    return shiftDeclaration.paymentMismatch != null &&
        shiftDeclaration.paymentMismatch == true;
  }
}
