import 'package:invo_mobile/services/Print/Category/Template/Page.dart';

import 'IElement.dart';

class TemplateFormat {
  PageT? page;

  List<IElement>? header;
  List<IElement>? body;
  List<IElement>? footer;

  TemplateFormat() {
    header = [];
    body = [];
    footer = [];
  }
}
