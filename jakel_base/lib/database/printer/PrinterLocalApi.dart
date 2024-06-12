import 'package:jakel_base/database/printer/model/MyPrinter.dart';

abstract class PrinterLocalApi {
  /// Save
  Future<void> save(MyPrinter elements);

  /// Get All
  Future<MyPrinter?> getMyPrinter();

  /// Delete
  Future<bool> delete();
}
