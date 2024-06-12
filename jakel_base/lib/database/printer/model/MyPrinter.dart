class MyPrinter {
  final String url;
  final String name;
  final String location;
  final String comment;
  final bool isDefault;
  final bool isAvailable;
  final String model;

  MyPrinter(
      {required this.url,
      required this.name,
      required this.model,
      required this.location,
      required this.comment,
      required this.isDefault,
      required this.isAvailable});

  factory MyPrinter.fromJson(dynamic json) {
    return MyPrinter(
      url: json['url'],
      model: json['model'],
      name: json['name'],
      location: json['location'],
      comment: json['comment'],
      isDefault: json['isDefault'],
      isAvailable: json['isAvailable'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['model'] = model;
    data['url'] = url;
    data['name'] = name;
    data['location'] = location;
    data['comment'] = comment;
    data['isDefault'] = isDefault;
    data['isAvailable'] = isAvailable;

    return data;
  }
}
