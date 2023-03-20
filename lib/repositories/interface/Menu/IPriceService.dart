import 'package:invo_mobile/models/menu_price.dart';
import 'package:invo_mobile/models/modifier_price.dart';
import 'package:invo_mobile/models/price_label.dart';

class IPriceService {
  Future<List<PriceLabel>>? getActiveList() {}
  Future<List<PriceLabel>>? getList() {}
  Future<PriceLabel>? get(int id) {}
  void save(PriceLabel price) {}
  void delete(int id) {}
  void savePrices(PriceLabel price, List<ModifierPrice> modifiers, List<MenuPrice> menuItems) {}
  @override
  Future<bool>? saveIfNotExists(List<PriceLabel> prices) {}
  checkIfNameExists(PriceLabel price) {}
  Future<List<MenuPrice>>? getMenuPrice(int id) {}
  Future<List<ModifierPrice>>? getModifierPrice(int id) {}
}
