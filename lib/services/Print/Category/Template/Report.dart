import 'package:invo_mobile/services/Print/Category/Template/IElement.dart';
import 'package:invo_mobile/services/Print/Category/Template/Page.dart';
import 'package:pdf/widgets.dart';

class Report {
  PageT? page;
  List<IElement>? Header;
  List<IElement>? Body;
  List<IElement>? Footer;

  Report() {
    Header = List<IElement>.empty(growable: true);
    Body = List<IElement>.empty(growable: true);
    Footer = List<IElement>.empty(growable: true);
  }
}
