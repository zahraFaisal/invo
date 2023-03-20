import 'package:invo_mobile/models/custom/menu_modifier_list.dart';
import 'package:invo_mobile/models/menu_modifier.dart';
import 'package:invo_mobile/models/price_label.dart';

class IMenuModifierService {
  Future<List<ModifierList>>? getActiveList() {}
  Future<List<ModifierList>>? getList() {}

  Future<List<MenuModifier>>? getAll() {}
  Future<MenuModifier>? get(int id) {}
  Future<int>? save(MenuModifier modifier) {}
  void delete(int id) {}
  Future<List<MenuModifier>>? getUpdatedMenuModifiers(DateTime? lastUpdateTime) {}
  Future<bool>? saveIfNotExists(List<MenuModifier> modifiers, List<PriceLabel> priceLabels) {}
  UpdateMenuModifierNullUpdateTime() {}
  checkIfNameExists(MenuModifier modifier) {}
}
