import 'dart:async';

import 'package:invo_mobile/blocs/back_office/Menu/DiscountForm/discount_event.dart';
import 'package:invo_mobile/blocs/back_office/Menu/DiscountForm/discount_state.dart';

import 'package:invo_mobile/blocs/blockBase.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/helpers/dialog_service.dart';
import 'package:invo_mobile/models/custom/menu_item_list.dart';
import 'package:invo_mobile/models/custom/role_list.dart';
import 'package:invo_mobile/models/discount.dart';
import 'package:invo_mobile/models/menu_item.dart';
import 'package:invo_mobile/models/role.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';

import '../../../../service_locator.dart';
import '../../../property.dart';

class DiscountFormBloc implements BlocBase {
  ConnectionRepository? connectionRepository;
  final _eventController = StreamController<DiscountFormEvent>.broadcast();
  Sink<DiscountFormEvent> get eventSink => _eventController.sink;
  Property<DiscountLoadState> discount = Property<DiscountLoadState>();
  NavigatorBloc? _navigationBloc;
  Discount? discountitem;

  DiscountFormBloc(NavigatorBloc navigationBloc) {
    _navigationBloc = navigationBloc;
    connectionRepository = locator.get<ConnectionRepository>();
    _eventController.stream.listen(_mapEventToState);
  }

  Future loadDiscount(int discountId, {isCopy = false}) async {
    discount.sinkValue(DiscountIsLoading());
    if (discountId == null || discountId == 0) {
      discountitem = Discount(in_active: false, is_percentage: false, items: [], name: '');
    } else {
      discountitem = await connectionRepository!.discountService!.get(discountId);
    }
    if (isCopy) {
      discountitem!.id = 0;
      discountitem!.name = "";
    }
    discount.sinkValue(DiscountIsLoaded(discountitem!));
  }

  void addDicountItem(List<MenuItemList> temp) {
    for (var item in temp) {
      discountitem!.items!.add(DiscountItem(id: 0, menu_item_id: item.id, item: item));
    }
    discount.sinkValue(DiscountIsLoaded(discountitem!));
  }

  void deleteDiscountItem(DiscountItem item) {
    if (item.id == 0) {
      discountitem!.items!.remove(item);
    } else {
      item.isDeleted = true;
    }

    discount.sinkValue(DiscountIsLoaded(discountitem!));
  }

  void addRole(List<RoleList> temp) {
    for (var item in temp) {
      discountitem!.Roles!.add(Role(id_number: item.id, name: item.name));
    }
    discount.sinkValue(DiscountIsLoaded(discountitem!));
  }

  void deleteRole(Role role) {
    discountitem!.Roles!.remove(role);
    discount.sinkValue(DiscountIsLoaded(discountitem!));
  }

  void _mapEventToState(DiscountFormEvent event) {
    if (event is SaveDiscount) {
      connectionRepository!.discountService!.save(event.discount);
    }
  }

  @override
  void dispose() {
    _eventController.close();
  }

  String nameValidation = "";
  Future<bool> asyncValidate(Discount discount) async {
    locator.get<DialogService>().showLoadingProgressDialog();
    bool exist = await connectionRepository!.discountService!.checkIfNameExists(discount);
    locator.get<DialogService>().closeDialog();

    if (exist) {
      nameValidation = "Name must be unique";
      return false;
    }

    nameValidation = "";
    return true;
  }
}
