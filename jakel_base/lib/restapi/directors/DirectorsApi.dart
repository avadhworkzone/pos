import 'package:jakel_base/restapi/directors/model/DirectorsResponse.dart';

abstract class DirectorsApi {
  Future<DirectorsResponse> getDirectors();
}
