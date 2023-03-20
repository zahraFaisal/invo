import 'package:invo_mobile/models/custom/price_managment_list.dart';
import 'package:invo_mobile/models/price_managment.dart';
import 'package:invo_mobile/repositories/interface/Settings/IPriceManagment.dart';


class PriceManagmentInvoService implements IPriceManagmentService {
  @override
  checkIfNameExists(PriceManagement price) {
      // TODO: implement checkIfNameExists
      throw UnimplementedError();
    }
  
    @override
    void delete(int id) {
      // TODO: implement delete
    }
  
    @override
    Future<PriceManagement> get(int id) {
      // TODO: implement get
      throw UnimplementedError();
    }
  
    @override
    Future<List<PriceManagement>> getAll() {
      // TODO: implement getAll
      throw UnimplementedError();
    }
  
    @override
    Future<List<PriceManagementList>> getList() {
      // TODO: implement getList
      throw UnimplementedError();
    }
  
    @override
    Future<bool> save(PriceManagement price) {
    // TODO: implement save
    throw UnimplementedError();
  }
 
}
