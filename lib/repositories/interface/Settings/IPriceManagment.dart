import 'package:invo_mobile/models/custom/price_managment_list.dart';
import 'package:invo_mobile/models/price_managment.dart';

class IPriceManagmentService {
  Future<List<PriceManagementList>>? getList() {}
  Future<PriceManagement>? get(int id) {}
  Future<bool>? save(PriceManagement price) {}
  void delete(int id) {}

  checkIfNameExists(PriceManagement price) {}

  Future<List<PriceManagement>>? getAll() {}
}
