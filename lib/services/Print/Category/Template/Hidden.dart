class Hidden {
  String property;
  String value;

  Hidden({this.property = "", this.value = ""});

  factory Hidden.fromJson(Map<String, dynamic> json) {
    return Hidden(
      property: json['Property'],
      value: json['Value'],
    );
  }
}
