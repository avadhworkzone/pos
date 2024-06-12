class FilterValue {

  String? text;
  String? sStock;

  FilterValue(this.text, this.sStock);

  FilterValue.fromJson(dynamic json) {
    text = json['text'];
    sStock = json['stock'];
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'stock': sStock,
    };
  }
}