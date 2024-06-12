mixin DisplayDeviceService {
  Future<bool> sendMessage(String message);

  Future<bool> initDevice();
}
