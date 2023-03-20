import 'package:invo_mobile/services/Print/Category/Template/Hidden.dart';
import 'package:invo_mobile/services/Print/Category/Template/IElement.dart';

class SideTextBox extends IElement {
  List<dynamic>? leftValue;
  List<dynamic>? rightValue;

  fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    leftValue = json['LeftValue'];
    rightValue = json['RightValue'];
  }
}
