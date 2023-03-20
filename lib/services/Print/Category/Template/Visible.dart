class Visible {
  String property;
  String value;

  Visible({this.property = "", this.value = ""});

  factory Visible.fromJson(Map<String, dynamic> json) {
    return Visible(
      property: json['Property'],
      value: json['Value'],
    );
  }
}
