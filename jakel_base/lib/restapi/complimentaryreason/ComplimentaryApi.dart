import 'package:jakel_base/restapi/complimentaryreason/model/ComplimentaryReasonResponse.dart';

abstract class ComplimentaryApi {
  Future<ComplimentaryReasonResponse> getReasons();
}
