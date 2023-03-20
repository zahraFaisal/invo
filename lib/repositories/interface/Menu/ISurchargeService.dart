import 'package:invo_mobile/models/custom/surcharge_list.dart';
import 'package:invo_mobile/models/surcharge.dart';

class ISurchargeService {
  Future<List<SurchargeList>>? getActiveList() {}
  Future<List<SurchargeList>>? getList() {}
  Future<Surcharge>? get(int id) {}
  void save(Surcharge surcharge) {}
  void update(Surcharge surcharge) {}
  Future<bool>? saveIfNotExists(List<Surcharge> surcharges) {}
  checkIfNameExists(Surcharge surcharge) {}

  getAll() {}
}
