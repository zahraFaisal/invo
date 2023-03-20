import 'package:invo_mobile/models/custom/menu_modifier_list.dart';
import 'package:invo_mobile/models/menu_modifier.dart';
import 'package:invo_mobile/models/modifier_price.dart';
import 'package:invo_mobile/models/price_label.dart';
import 'package:invo_mobile/repositories/interface/Menu/IMenuModifier.dart';

class MenuModifiersInvoService implements IMenuModifierService {
  @override
  checkIfNameExists(MenuModifier modifier) {
    // TODO: implement checkIfNameExists
    throw UnimplementedError();
  }

  @override
  void delete(int id) {
    // TODO: implement delete
  }

  @override
  Future<MenuModifier> get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<List<ModifierList>> getActiveList() {
    // TODO: implement getActiveList
    throw UnimplementedError();
  }

  @override
  Future<List<MenuModifier>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<List<ModifierList>> getList() {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future<int> save(MenuModifier modifier) {
    // TODO: implement save
    throw UnimplementedError();
  }

  @override
  UpdateMenuModifierNullUpdateTime() {
    // TODO: implement UpdateMenuModifierNullUpdateTime
    throw UnimplementedError();
  }

  @override
  Future<List<MenuModifier>> getUpdatedMenuModifiers(DateTime? lastUpdateTime) {
    // TODO: implement getUpdatedMenuModifiers
    throw UnimplementedError();
  }

  @override
  Future<bool> saveIfNotExists(List<MenuModifier> modifiers, List<PriceLabel> priceLabels) {
    throw UnimplementedError();
  }
}
