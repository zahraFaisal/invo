import 'package:invo_mobile/models/terminal.dart';
import 'package:invo_mobile/repositories/interface/Settings/ITerminalService.dart';
import 'package:sqflite/sqflite.dart';

import '../sqlite_repository.dart';

class TerminalService implements ITerminalService {
  @override
  Future<Terminal?> save(Terminal terminal) async {
    final Database? database = await SqliteRepository().db;
    if (terminal.id == 0) {
      terminal.id = await database!.insert('terminals', terminal.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      await database!.update('terminals', terminal.toMap(), where: "id = ?", whereArgs: [terminal.id]);
    }
    return terminal;
  }
}
