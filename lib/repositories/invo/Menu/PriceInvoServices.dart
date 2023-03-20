import 'package:invo_mobile/models/menu_price.dart';
import 'package:invo_mobile/models/modifier_price.dart';
import 'package:invo_mobile/models/price_label.dart';
import 'package:invo_mobile/repositories/interface/Menu/IPriceService.dart';

class PriceInvoService implements IPriceService {
  @override
  checkIfNameExists(PriceLabel price) {
    // TODO: implement checkIfNameExists
    throw UnimplementedError();
  }

  @override
  void delete(int id) {
    // TODO: implement delete
  }

  @override
  Future<PriceLabel> get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<List<PriceLabel>> getActiveList() {
    // TODO: implement getActiveList
    throw UnimplementedError();
  }

  @override
  Future<List<PriceLabel>> getList() {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  void save(PriceLabel price) {
    // TODO: implement save
  }

  @override
  void savePrices(PriceLabel price, List<ModifierPrice> modifiers, List<MenuPrice> menuItems) {
    // TODO: implement savePrices
  }

  @override
  Future<bool>? saveIfNotExists(List<PriceLabel> prices) {}

  @override
  Future<List<MenuPrice>> getMenuPrice(int id) {
    // TODO: implement getMenuPrice
    throw UnimplementedError();
  }

  @override
  Future<List<ModifierPrice>> getModifierPrice(int id) {
    // TODO: implement getModifierPrice
    throw UnimplementedError();
  }
}
