/// Device Types
const deviceTypeDisplay = "display";
const deviceTypePaymentTerminal = "paymentTerminal";

class MySerialPortDevices {
  final String address;
  final String name;
  final String deviceType;

  MySerialPortDevices(
      {required this.name, required this.address, required this.deviceType});

  factory MySerialPortDevices.fromJson(dynamic json) {
    return MySerialPortDevices(
      name: json['name'],
      address: json['address'],
      deviceType: json['deviceType'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['address'] = address;
    data['deviceType'] = deviceType;
    return data;
  }
}
