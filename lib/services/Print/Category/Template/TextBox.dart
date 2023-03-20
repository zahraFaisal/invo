import 'package:invo_mobile/services/Print/Category/Template/IElement.dart';

class TextBox extends IElement {
  String alignment;
  String padding;

  TextBox({this.alignment = "", this.padding = ""});

  getPadding() {
    if (padding == null || padding == "") {
      return 0;
    } else {
      return int.parse(padding);
    }
  }

  fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    alignment = json['Alignment'] ?? "";
    padding = json['Padding'] ?? "";
  }
}
