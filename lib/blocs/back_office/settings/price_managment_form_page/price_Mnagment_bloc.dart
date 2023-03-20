import 'dart:async';

import 'package:invo_mobile/blocs/back_office/settings/price_managment_form_page/price_Managment_state.dart';
import 'package:invo_mobile/blocs/back_office/settings/price_managment_form_page/price_Mangment_event.dart';
import 'package:invo_mobile/blocs/blockBase.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/helpers/dialog_service.dart';
import 'package:invo_mobile/models/custom/discount_list.dart';
import 'package:invo_mobile/models/custom/price_managment_list.dart';
import 'package:invo_mobile/models/custom/surcharge_list.dart';
import 'package:invo_mobile/models/price_label.dart';
import 'package:invo_mobile/models/price_managment.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:collection/collection.dart';

import '../../../../service_locator.dart';
import '../../../property.dart';

class PriceManagmentFormPageBloc implements BlocBase {
  ConnectionRepository? connectionRepository;
  final _eventController = StreamController<PriceManagmentFormEvent>.broadcast();
  Sink<PriceManagmentFormEvent> get eventSink => _eventController.sink;
  Property<PriceManagmentLoadState> priceManagment = new Property<PriceManagmentLoadState>();

  Property<List<PriceManagementList>> prices = new Property<List<PriceManagementList>>();

  Property<List<PriceLabel>> labels = new Property<List<PriceLabel>>();
  Property<List<DiscountList>> discounts = new Property<List<DiscountList>>();
  Property<List<SurchargeList>> surcharges = new Property<List<SurchargeList>>();

  NavigatorBloc? _navigationBloc;
  PriceManagement? priceManagement;

  int? get discountId {
    if (discounts.value == null) return null;
    DiscountList? temp = discounts.value!.firstWhereOrNull((f) => f.id == priceManagement!.discount_id);
    if (temp == null) return null;

    return temp.id;
  }

  int? get surchargeId {
    if (surcharges.value == null) return null;
    SurchargeList? temp = surcharges.value!.firstWhereOrNull((f) => f.id == priceManagement!.surcharge_id);
    if (temp == null) return null;

    return temp.id;
  }

  int? get labelId {
    if (surcharges.value == null) return null;
    PriceLabel? temp = labels.value!.firstWhereOrNull((f) => f.id == priceManagement!.price_label_id);
    if (temp == null) return null;

    return temp.id;
  }

  PriceManagmentFormPageBloc(NavigatorBloc navigationBloc) {
    _navigationBloc = navigationBloc;
    connectionRepository = locator.get<ConnectionRepository>();
    _eventController.stream.listen(_mapEventToState);
  }

  Future loadPriceManagment(int priceManagmentId) async {
    priceManagment.sinkValue(PriceManagmentIsLoading());

    await labels.sinkValue(await connectionRepository!.priceService!.getActiveList()!);
    await discounts.sinkValue(await connectionRepository!.discountService!.getActiveList()!);
    await surcharges.sinkValue(await connectionRepository!.surchargeService!.getActiveList()!);
    if (priceManagmentId == null || priceManagmentId == 0) {
      priceManagement = new PriceManagement(price_label_id: 0, discount_id: 0, surcharge_id: 0);
    } else {
      priceManagement = await connectionRepository!.priceManagmentService!.get(priceManagmentId);
    }

    priceManagment.sinkValue(PriceManagmentIsLoaded(priceManagement!));
  }

  void _mapEventToState(PriceManagmentFormEvent event) async {
    if (event is SavePriceManagment) {
      locator.get<DialogService>().showLoadingProgressDialog();
      await connectionRepository!.priceManagmentService!.save(event.price);
      locator.get<DialogService>().closeDialog();
    }
  }

  String nameValidation = "";
  Future<bool> asyncValidate(PriceManagement price) async {
    locator.get<DialogService>().showLoadingProgressDialog();
    bool exist = await connectionRepository!.priceManagmentService!.checkIfNameExists(price);
    locator.get<DialogService>().closeDialog();

    if (exist) {
      nameValidation = "Name must be unique";
      return false;
    }

    nameValidation = "";
    return true;
  }

  @override
  void dispose() {
    _eventController.close();
    priceManagment.dispose();
    prices.dispose();
    labels.dispose();
    discounts.dispose();
    surcharges.dispose();
  }
}
