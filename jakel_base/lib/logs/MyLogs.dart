abstract class MyLogs {
  Future<bool> info(String tag, String? message);

  Future<bool> warning(String tag, String? message);

  Future<bool> error(String tag, String? message);

  Future<bool> exception(Exception exception);

  Future<bool> logNetworkError(
      String? url, dynamic request, dynamic response, int? responseCode);
}
