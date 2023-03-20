import 'package:invo_mobile/models/terminal.dart';

abstract class ITerminalService {
  Future<Terminal?> save(Terminal terminal);
}
