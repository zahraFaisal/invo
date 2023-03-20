import 'package:invo_mobile/models/custom/surcharge_list.dart';
import 'package:invo_mobile/models/surcharge.dart';
import 'package:invo_mobile/repositories/interface/Menu/ISurchargeService.dart';

class SurchargeInvoService implements ISurchargeService {
  @override
  checkIfNameExists(Surcharge surcharge) {
    // TODO: implement checkIfNameExists
    throw UnimplementedError();
  }

  @override
  Future<Surcharge> get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<List<SurchargeList>> getActiveList() {
    // TODO: implement getActiveList
    throw UnimplementedError();
  }

  @override
  getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<List<SurchargeList>> getList() {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  void save(Surcharge surcharge) {
    // TODO: implement save
  }

  @override
  void update(Surcharge surcharge) {
    // TODO: implement update
  }
  @override
  Future<bool> saveIfNotExists(List<Surcharge> surcharges) {
    throw UnimplementedError();
  }
}
