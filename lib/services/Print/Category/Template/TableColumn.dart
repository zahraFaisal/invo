class TableColumn {
  String width;
  String headerValue;

  TableColumn({this.headerValue = "", this.width = ""});
  int getWidth() {
    if (width == null || width == "") {
      return 0;
    } else {
      int temp = 0;
      temp = int.parse(width);
      return temp;
    }
  }

  factory TableColumn.fromJson(Map<String, dynamic> json) {
    return TableColumn(
      width: json['Width'],
      headerValue: json['HeaderValue'],
    );
  }
}
