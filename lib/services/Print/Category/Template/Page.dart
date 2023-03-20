import 'package:invo_mobile/services/Print/Category/Template/Font.dart';

class PageT {
  String height;
  String width;
  String leftMargin;
  String rightMargin;
  String topMargin;
  String bottomMargin;
  TemplateStyle? defaultStyle;

  PageT({this.bottomMargin = "", this.height = "", this.leftMargin = "", this.rightMargin = "", this.topMargin = "", this.width = "", this.defaultStyle});

  factory PageT.fromJson(Map<String, dynamic> json) {
    TemplateStyle _defaultStyle = TemplateStyle.fromJson(json['defaultStyle']);
    return PageT(
      height: json['Height'].toString(),
      width: json['Width'].toString(),
      leftMargin: json['LeftMargin'].toString(),
      rightMargin: json['RightMargin'].toString(),
      topMargin: json['TopMargin'].toString(),
      bottomMargin: json['BottomMargin'].toString(),
      defaultStyle: _defaultStyle,
    );
  }

  getheight() {
    if (height == null || height == "") {
      return 0;
    } else {
      int temp = 0;
      temp = int.parse(height);
      return temp;
    }
  }

  getwidth() {
    if (width == null || width == "") {
      return 0;
    } else {
      int temp = 0;
      temp = int.parse(width);
      return temp;
    }
  }
}
