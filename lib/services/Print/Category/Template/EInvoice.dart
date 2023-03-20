import 'package:invo_mobile/services/Print/Category/Template/Hidden.dart';
import 'package:invo_mobile/services/Print/Category/Template/IElement.dart';

class EInvoice extends IElement {
  String width;
  String height;

  EInvoice({this.height = "200", this.width = "200"});
}
