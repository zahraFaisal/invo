class TextConverter {
  String value;
  String converter;
  TextConverter({this.converter = "", this.value = ""});

  factory TextConverter.fromJson(Map<String, dynamic> json) {
    return TextConverter(
      value: json['Value'],
      converter: json['Converter'],
    );
  }
}
