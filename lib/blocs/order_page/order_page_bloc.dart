import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:invo_mobile/blocs/blockBase.dart';
import 'package:invo_mobile/blocs/customer_list_page/customer_list_page_bloc.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/blocs/navigator/navigator_event.dart';
import 'package:invo_mobile/blocs/order_page/order_page_event.dart';
import 'package:invo_mobile/blocs/property.dart';
import 'package:invo_mobile/blocs/settle_page/settle_page_bloc.dart';
import 'package:invo_mobile/helpers/dialog_service.dart';
import 'package:invo_mobile/helpers/priviligers.dart';
import 'package:invo_mobile/models/Number.dart';
import 'package:invo_mobile/models/Service.dart';
import 'package:invo_mobile/models/custom/customer_list.dart';
import 'package:invo_mobile/models/custom/selected_customer.dart';
import 'package:invo_mobile/models/customer/customer.dart';
import 'package:invo_mobile/models/customer/customer_address.dart';
import 'package:invo_mobile/models/dineIn_table.dart';
import 'package:invo_mobile/models/discount.dart';
import 'package:invo_mobile/models/employee.dart';
import 'package:invo_mobile/models/global.dart';
import 'package:invo_mobile/models/menu_group.dart';
import 'package:invo_mobile/models/menu_item_group.dart';
import 'package:invo_mobile/models/menu_modifier.dart';
import 'package:invo_mobile/models/menu_price.dart';
import 'package:invo_mobile/models/menu_selection.dart';
import 'package:invo_mobile/models/menu_type.dart';
import 'package:invo_mobile/models/order/TransactionCombo.dart';
import 'package:invo_mobile/models/order/dineIn_table_reference.dart';
import 'package:invo_mobile/models/order/employee_reference.dart';
import 'package:invo_mobile/models/order/order_header.dart';
import 'package:invo_mobile/widgets/order_notification.dart';
import 'package:invo_mobile/models/order/order_transaction.dart';
import 'package:invo_mobile/models/order/service_reference.dart';
import 'package:invo_mobile/models/price_managment.dart';
import 'package:invo_mobile/models/surcharge.dart';
import 'package:invo_mobile/models/terminal.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:invo_mobile/services/Print/PrintService.dart';
import 'package:oktoast/oktoast.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';
import 'package:collection/collection.dart';

import 'order_page_state.dart';

class OrderPageBloc implements BlocBase {
  final NavigatorBloc? _navigationBloc;
  ConnectionRepository? connection;
  //Selection Properties
  int selectionLevel = 1;
  int levelNoOfSelection = 1;
  int levelItemSelected = 1;
  //=================================
  //Combo Properties
  TransactionCombo? comboItem;
  SettlePageBloc? settlePageBloc;
  Property<String> qty = Property<String>();

  List<OrderHeader> _orders = List<OrderHeader>.empty(growable: true);
  Property<OrderHeader> order = Property<OrderHeader>();
  Property<List<OrderHeader>> orders = Property<List<OrderHeader>>();

  //ordersLimit==========================
  int ordersLimit = 1;
  int ordersNumberToUse = 0;
  int? ordersCount;
  String testID = 'game_test';
  // InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;
  // bool _available = true;
  // List<ProductDetails> _products = [];
  // List<PurchaseDetails> _purchases = [];
  StreamSubscription? _subscription;
  Property<int> ordersCounts = Property<int>();

  //====================================

  List<Service>? services;
  Property<Service> selectedService = Property<Service>();

  List<MenuType>? menus;
  Property<MenuType> selectedMenuType = Property<MenuType>();

  Property<List<MenuItemGroup>> menuItemsList = Property<List<MenuItemGroup>>();
  Property<List<MenuGroup>> groups = Property<List<MenuGroup>>();
  Property<MenuGroup> selectedMenuGroup = Property<MenuGroup>();

  Property<List<MenuItemGroup>> items = Property<List<MenuItemGroup>>();

  Property<PopupPanelState> popup = Property<PopupPanelState>();
  Property<OrderPageOptionState> option = Property<OrderPageOptionState>();

  final _eventController = StreamController<OrderPageEvent>.broadcast();
  Sink<OrderPageEvent> get eventSink => _eventController.sink;

  CustomerListPageBloc? customerListPageBloc;
  List<MenuModifier> get modifiers {
    return locator.get<ConnectionRepository>().menuModifiers!.where((f) => f.in_active == false && f.is_visible == true).toList();
  }

  bool get isHalfItemEnabled {
    return !locator.get<ConnectionRepository>().preference!.disableHalfItem;
  }

  Property<int> orderQty = Property<int>();

  bool seveOrderClicked = false;

  // List<String> get modifierListFilters {
  //   List<String> temp = List<String>();
  //   temp.add("All");
  //   if (locator.get<ConnectionRepository>().preference.mod_filter_setting !=
  //       null) {
  //     temp.addAll(locator
  //         .get<ConnectionRepository>()
  //         .preference
  //         .mod_filter_setting
  //         .split(','));
  //   }
  //   return temp;
  // }

  OrderPageBloc(this._navigationBloc, Service? _service, OrderHeader? _order, SelectedCustomer? selectedCustomer, DineInTable? table, List<OrderHeader>? orders) {
    connection = locator.get<ConnectionRepository>();

    customerListPageBloc = CustomerListPageBloc(_navigationBloc);
    //min 50 order per day =============
    //ordersCountLimit();
    //==================================

    services = connection!.services!.where((f) => f.id < 5).toList();
    selectedService.sinkValue(_service ?? Service(id: 0, name: ''));
    popup.sinkValue(OrderPanel());

    menus = connection!.menuTypes!.toList();
    selectedMenuType.sinkValue(menus![0]);

    groups.sinkValue(connection!.menuGroups!.where((f) => f.menu_type_id == menus![0].id).toList());

    for (var item in connection!.menuItemGroups!) {
      if (item.index == null) item.index = 0;
    }

    if (groups.value != null && groups.value!.length > 0) items.sinkValue(connection!.menuItemGroups!.where((f) => f.menu_group_id == groups.value![0].id).toList());

    _eventController.stream.listen(_mapEventToState);

    if (table == null) {
      if (_order == null) {
        _order = newOrder();
        if (selectedCustomer != null) _order.setCustomer(selectedCustomer.customer, selectedCustomer.contact, selectedCustomer.address);
        order.sinkValue(_order);
        checkAutoPrice(null);
      } else {
        order.sinkValue(_order.clone());
        orderQty.sinkValue(order.value!.transaction.length);
      }
    } else {
      _loadTable(table, orders);
    }
  }

  List<MenuItemGroup> allItems = List<MenuItemGroup>.empty(growable: true);
  void loadList({List<int>? except}) async {
    allItems = List<MenuItemGroup>.empty(growable: true);
    allItems = connection!.menuItemGroups!.where((element) => element.menu_item != null).toList();
    menuItemsList.sinkValue(allItems);
  }

  CustomerAddress? selectedAddress;

  Future<void> editCustomer(String phone) async {
    SelectedCustomer customer = await _navigationBloc!.navigateToCustomerPage(this.selectedService.value!, phone);

    if (customer != null) {
      order.value!.setCustomer(customer.customer, customer.contact, customer.address);
      order.sinkValue(order.value ?? OrderHeader(employee_id: 0, payments: [], service_id: 0, transaction: [], terminal_id: null, id: 0));
      checkAutoPrice(null);
    }

    popup.sinkValue(OrderPanel());
  }

  //min 50 order per day ================================================

  // ordersCountLimit() async {
  //   var day_start = locator.get<ConnectionRepository>().preference.day_start;
  //   String formattedTime = DateFormat.Hms().format(day_start);
  //   var now = DateTime.now();
  //   //dates with the start time ========
  //   var starTime = DateTime(now.year, now.month, now.day, day_start.hour,
  //       day_start.minute, day_start.second, day_start.millisecond);
  //   var endTime = starTime.add(const Duration(days: 1));

  //   this.ordersCount = await locator
  //       .get<ConnectionRepository>()
  //       .orderService
  //       .fetchTodayOrdersCount(starTime, endTime);

  //   ordersCounts.sinkValue(this.ordersCount);

  //   _initialize();
  // }

  // Future<void> _initialize() async {
  //   InAppPurchaseConnection.enablePendingPurchases();
  //   _available = await _iap.isAvailable();
  //   if (_available) {
  //     await _getProducts();
  //     await _getPastPurchases();
  //     _verifyPurchase();
  //     _subscription = _iap.purchaseUpdatedStream.listen((data) {
  //       _purchases.addAll(data);
  //       _verifyPurchase();
  //     });
  //   }
  // }

  // Future<void> _getProducts() async {
  //   Set<String> ids = Set.from([testID]);
  //   ProductDetailsResponse response = await _iap.queryProductDetails(ids);
  //   _products = response.productDetails;
  // }

  // Future<void> _getPastPurchases() async {
  //   QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();
  //   _purchases = response.pastPurchases;
  // }

  // PurchaseDetails _hasPurchased(String productID) {
  //   return _purchases.firstWhereOrNull((purchase) => purchase.productID == productID);
  // }

  // void _verifyPurchase() {
  //   PurchaseDetails purchase = _hasPurchased(testID);
  //   if (purchase != null && purchase.status == PurchaseStatus.purchased) {
  //     this.ordersNumberToUse = 50;
  //   }
  // }

  // void _buyProduct(ProductDetails prod) {
  //   final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
  //   _iap.buyConsumable(purchaseParam: purchaseParam, autoConsume: false);
  // }

  // Future<void> _usePurchaseOrders(PurchaseDetails purchase) async {
  //   if (this.ordersNumberToUse == 0) {
  //     var res = await _iap.consumePurchase(purchase);
  //     await _getPastPurchases();
  //   }
  // }

  //=====================================================

  Future<void> selectCustomer(CustomerList customer) async {
    Customer? _customer = await connection!.customerService!.get(customer.customer_id);
    if (_customer!.addresses[0] != null) {
      order.value!.setCustomer(_customer, customer.contact, _customer.addresses[0].fullAddress.toString());
    } else {
      order.value!.setCustomer(_customer, customer.contact, "");
    }
    popup.sinkValue(OrderPanel());
  }

  void _mapEventToState(OrderPageEvent event) async {
    if (event is MenuTypeClicked) {
      _menuSelected(event.menu);
    } else if (event is MenuGroupClicked) {
      _groupSelected(event.group);
    } else if (event is MenuItemClicked) {
      _itemClicked(event);
    } else if (event is ServiceChanged) {
      _serviceChanged(event.service);
    } else if (event is SelectTransaction) {
      _transactionSelected(event.transaction);
    } else if (event is RemoveTransaction) {
      _removeTransaction(event.transaction);
    } else if (event is AddNewTicket) {
      _addNewTicket();
    } else if (event is ChangeTicket) {
      _changeTicket(event.order);
    } else if (event is EditCustomer) {
      editCustomer(event.phone);
    } else if (event is SelectCustomer) {
      selectCustomer(event.customerList);
    } else if (event is AddTransactionModifier) {
      if (event.selectedTranscation) {
        order.value!.addModifierToSelectedTransaction(event.modifier, event.isForced);
      } else
        order.value!.addModifier(event.modifier, event.isForced);
    } else if (event is RemoveTransactionModifier) {
      if (popup.value is PopUpModifier || popup.value is PopUpMenuSelection) return;
      if (event.selectedTranscation) {
        order.value!.removeModifierToSelectedTransaction(event.modifier);
      } else
        order.value!.removeModifier(event.modifier);
    } else if (event is CancelPopUpModifier) {
      if (event.deleteItem) order.value!.removeLastItem();
      popup.sinkValue(OrderPanel());
    } else if (event is AddSubItemModifier) {
      order.value!.addSubItemModifier(event.modifier, event.isForced);
    } else if (event is AddComboItemModifier) {
      if (comboItem != null)
        order.value!.addComboItemModifier(comboItem!, event.modifier, event.isForced);
      else
        popup.sinkValue(OrderPanel());
    } else if (event is IncreaseTransactionQty) {
      order.value!.increaseQty();
    } else if (event is DecreaseTransactionQty) {
      order.value!.decreaseQty();
    } else if (event is AdjTransactionPrice) {
      _adjPrice();
    } else if (event is AdjTransactionQty) {
      _adjQty();
    } else if (event is AdjGuestNumber) {
      _adjGuest();
    } else if (event is ReOrderTransaction) {
      _reOrderTransaction();
    } else if (event is HoldUntilFire) {
      order.value!.holdUntilFire();
      option.sinkValue(ItemOption());
    } else if (event is DiscountOrder) {
      Privilege priv = Privilege();
      if (!priv.checkPrivilege(Privilages.discount_order)) return;

      if (order.value!.discount_amount > 0) {
        order.value!.deleteDiscount();
        option.sinkValue(OrderPageOption());
        return;
      }
      popup.sinkValue(DiscountPanel(locator.get<ConnectionRepository>().discounts!, true));
    } else if (event is OrderDiscountClicked) {
      order.value!.addDiscount(event.discount);
      popup.sinkValue(OrderPanel());
    } else if (event is AddTransactionSubItem) {
      _addSubItem(event);
    } else if (event is FinishSubItemPopUpModifier) {
      _checkSubItemLevel();
    } else if (event is FinishComboItemPopUpModifier) {
      _checkNextCombo();
    } else if (event is ShowShortNote) {
      _shortNote();
    } else if (event is PayOrder) {
      payOrder();
    } else if (event is AddTag) {
      _addTag();
    } else if (event is SurchargeOrder) {
      Privilege priv = Privilege();
      if (!priv.checkPrivilege(Privilages.surcharge_order)) return;

      if (order.value!.surcharge_amount > 0) {
        order.value!.deleteSurcharge();
        option.sinkValue(OrderPageOption());
        return;
      }

      popup.sinkValue(SurchargePanel(locator.get<ConnectionRepository>().surcharges!));
    } else if (event is AddCustomer) {
      if (customerListPageBloc != null) customerListPageBloc!.dispose();
      customerListPageBloc = CustomerListPageBloc(_navigationBloc);
      popup.sinkValue(LoadCustomerPanel());
    } else if (event is SurchargeClicked) {
      order.value!.addSurcharge(event.surcharge);
      popup.sinkValue(OrderPanel());
    } else if (event is OrderDiscountItem) {
      Privilege priv = Privilege();
      if (!priv.checkPrivilege(Privilages.discount_order)) return;

      if (order.value!.itemSelected.value!.discount_amount > 0) {
        order.value!.deleteItemDiscount();
        option.sinkValue(ItemOption());
        return;
      }
      popup.sinkValue(DiscountPanel(locator.get<ConnectionRepository>().discounts!, false));
    } else if (event is OrderItemDiscountClicked) {
      order.value!.addItemDiscount(event.discount);
      popup.sinkValue(OrderPanel());
    } else if (event is RemoveTransactionDiscount) {
      order.value!.deleteItemDiscount();
      popup.sinkValue(OrderPanel());
    } else if (event is SaveOrder) {
      saveOrder(false, resetOrder: true);
    } else if (event is SaveAndPrintOrder) {
      saveOrder(true, resetOrder: false);
    } else if (event is VoidOrder) {
      voidOrder();
    } else if (event is GoBack) {
      _navigationBloc!.popBack(false);
    } else if (event is SearchItem) {
      loadList();
      popup.sinkValue(SearchItemPanel());
    }
  }

  void filterSearchResults(String query) {
    if (query == "" || query == null) {
      menuItemsList.sinkValue(allItems);
    } else {
      menuItemsList.sinkValue(allItems.where((f) => f.menu_item!.name!.toLowerCase().contains(query.toLowerCase()) || f.menu_item!.barcode!.contains(query)).toList());
    }
  }

  void payOrder() async {
    String? lang = locator.get<ConnectionRepository>().terminal!.getLangauge();
    AppLocalizations appLocalizations = await AppLocalizations.load(Locale(lang!));
    if (order.value == null) return;
    if (order.value!.status == 3 || order.value!.status == 4) return; //if paid or void ticket

    Privilege priv = Privilege();
    if (!priv.checkPrivilege(Privilages.settle_order)) return;
    if (locator.get<Global>().authCashier == null) {
      locator<DialogService>().showDialog(appLocalizations.translate("Cashier In First"), appLocalizations.translate("Cashier In First to access pay function"));
      return;
    }

    for (var item in order.value!.payments) {
      if (item.status == -1) {
        locator<DialogService>().showDialog(appLocalizations.translate("There is an online payment"), appLocalizations.translate("Check the domain cashier"));
        return;
      }
    }

    settlePageBloc = SettlePageBloc(this.order.value);
    settlePageBloc!.finish.stream.listen((response) async {
      // if (response) {
      saveOrder(locator.get<ConnectionRepository>().preference!.printTicketWhenSettle, resetOrder: true);
      await popup.sinkValue(OrderPanel());

      if (Number.getDouble(this.order.value!.amountChange) >= 0 && Number.getDouble(this.order.value!.amountBalance) <= 0) {
        try {
          await locator<DialogService>().showBalanceDialog(Number.formatCurrency(this.order.value!.amountChange), orderHeader: this.order.value);
        } catch (e) {
          print(e.toString());
        }
      }
      // }
    });
    popup.sinkValue(SettlePanel());
  }

  Future<void> _serviceChanged(Service service) async {
    Privilege privilage = Privilege();
    if (service.name == "Dine In") {
      if (!await privilage.checkLogin(Privilages.DineIn)) return;
    } else if (service.name == "Delivery") {
      if (!await privilage.checkLogin(Privilages.Delivery)) return;
    } else if (service.name == "Pick Up") {
      if (!await privilage.checkLogin(Privilages.TakeAway)) return;
    } else if (service.name == "Car Hop") {
      if (!await privilage.checkLogin(Privilages.DriveThru)) return;
    }

    this.order.value!.changeService(service);

    selectedService.sinkValue(service);
    checkAutoPrice(null);
  }

  void _menuSelected(MenuType menu) {
    selectedMenuType.sinkValue(menu);
    groups.sinkValue(locator.get<ConnectionRepository>().menuGroups!.where((f) => f.menu_type_id == menu.id).toList());
    if (groups.value!.length > 0) {
      _groupSelected(groups.value![0]);
    } else {
      _groupSelected(null);
    }
  }

  void _groupSelected(MenuGroup? group) {
    selectedMenuGroup.sinkValue(group!);
    if (group == null) {
      items.sinkValue(List<MenuItemGroup>.empty(growable: true));
    } else
      items.sinkValue(locator.get<ConnectionRepository>().menuItemGroups!.where((f) => f.menu_group_id == group.id).toList());
  }

  void _itemClicked(MenuItemClicked event) async {
    if (locator.get<Global>().authEmployee == null) return; //no authorized employee

    comboItem = null;
    if (order.value!.status == 6) return;
    if (event.item.in_stock == false) {
      showToast('Out of stock!', duration: Duration(seconds: 2), backgroundColor: Colors.red, radius: 5, textStyle: TextStyle(color: Colors.white, fontSize: 22), position: ToastPosition(align: Alignment.topCenter, offset: 0));
      return;
    }

    if (this.qty.value == null || this.qty.value == "") this.qty.sinkValue("1");
    if (event.item.enable_count_down!) {
      int qtyTemp = event.item.countDown - int.parse(this.qty.value!);
      if (qtyTemp < 0 && locator.get<ConnectionRepository>().preference!.dontAllowSaleWhenCountDownIsZero) {
        showToast('Out of stock!', duration: Duration(seconds: 2), backgroundColor: Colors.red, radius: 5, textStyle: TextStyle(color: Colors.white, fontSize: 22), position: ToastPosition(align: Alignment.topCenter, offset: 0));
        return;
      }
    }

    String itemQty = this.qty.value!;
    if (event.item.order_By_Weight != null && event.item.order_By_Weight!) {
      itemQty = await locator<DialogService>().showNumberDialog(NumberDialogRequest(title: "Enter Weight", hasDotButton: true, maxLength: 5));
    }
    if (itemQty == "" || itemQty == null || double.tryParse(itemQty) == null) return;

    String price = event.item.default_price.toString();
    if (event.item.open_price != null && event.item.open_price!) {
      price = await locator<DialogService>().showNumberDialog(NumberDialogRequest(title: "Enter Price", hasDotButton: true, maxLength: 1000));
      if (price == "" || price == null || double.tryParse(price) == null || price == "0") return;
    } else {
      int priceLabelId = getPriceId!;
      if (priceLabelId != 0) {
        MenuPrice? menuPrice = event.item.prices!.isNotEmpty ? event.item.prices!.firstWhereOrNull((f) => f.label_id == priceLabelId) : null;
        if (menuPrice != null)
          price = menuPrice.price.toString();
        else
          price = event.item.default_price.toString();
      } else {
        price = event.item.default_price.toString();
      }
    }

    Employee authEmployee = locator.get<Global>().authEmployee!;
    order.value!.addItem(event.item, locator.get<ConnectionRepository>().preference!, double.parse(itemQty), double.parse(price), authEmployee);
    this.qty.sinkValue("");

    orderQty.sinkValue(order.value!.transaction.length);
    if (order.value!.transaction.length > 0) {
      seveOrderClicked = false;
    }
    debugPrint(event.item.quick_mod!.length.toString());
    if (event.item.quick_mod!.length > 0) {
      List<MenuModifier> modifiers = List<MenuModifier>.empty(growable: true);
      MenuModifier? modifier;
      for (var item in event.item.quick_mod!) {
        modifier = locator.get<ConnectionRepository>().menuModifiers!.firstWhereOrNull((f) => f.id == item.modifier_id && f.in_active == false);
        if (modifier != null) modifiers.add(modifier);
      }
      option.sinkValue(QuickModifierOption(modifiers: modifiers, transaction: order.value!.lastTransaction()));
    } else {
      option.sinkValue(ItemOption());
    }

    if (event.item.selections != null && event.item.selections!.length > 0) {
      for (var subitem in event.item.selections!) {
        for (var item in subitem.Selections!.where((f) => f.menu_item_id == null)) {
          item.menuItem = locator.get<ConnectionRepository>().menuItems!.firstWhereOrNull((f) => f.id == item.menu_item_id);
        }
      }
      selectionLevel = 1;
      MenuSelection? menuSelection = event.item.selections!.firstWhereOrNull((f) => f.level == selectionLevel);
      if (menuSelection != null) {
        levelNoOfSelection = menuSelection.no_of_selection;
        popup.sinkValue(PopUpMenuSelection(event.item, selectionLevel, levelItemSelected));
      }
    } else if (event.item.menu_item_combo != null && event.item.menu_item_combo!.length > 0) {
      for (var item in event.item.menu_item_combo!) {
        order.value!.addSubItem(locator.get<ConnectionRepository>().menuItems!.firstWhereOrNull((f) => f.id == item.sub_menu_item_id), qty: item.qty.toDouble());
      }

      for (var item in order.value!.lastTransaction()!.sub_menu_item!) {
        if (item.menu_item!.popup_mod!.length > 0) {
          for (var popup in item.menu_item!.popup_mod!) {
            for (var modifier in popup.modifiers.where((f) => f.modifier == null)) {
              modifier.modifier = locator.get<ConnectionRepository>().menuModifiers!.firstWhereOrNull((f) => f.id == modifier.modifier_id && f.in_active == false);
            }
          }
          popup.sinkValue(PopUpModifier(item.menu_item!, false, true));
          comboItem = item;
          break;
        }
      }
    } else if (event.item.popup_mod != null && event.item.popup_mod!.length > 0) {
      _lastModifier(event.item);
    }
  }

  void _addSubItem(AddTransactionSubItem event) {
    order.value!.addSubItem(event.item);
    if (event.item.popup_mod != null && event.item.popup_mod!.length > 0) {
      for (var popup in event.item.popup_mod!) {
        for (var modifier in popup.modifiers.where((f) => f.modifier == null)) {
          modifier.modifier = locator.get<ConnectionRepository>().menuModifiers!.firstWhereOrNull((f) => f.id == modifier.modifier_id && f.in_active == false);
        }
      }

      if (event.item.popup_mod!.isNotEmpty) {
        popup.sinkValue(PopUpModifier(event.item, true, false));
      } else {
        _checkSubItemLevel();
      }
    } else {
      _checkSubItemLevel();
    }
  }

  void _checkSubItemLevel() {
    if (levelItemSelected < levelNoOfSelection) {
      levelItemSelected++;
      popup.sinkValue(PopUpMenuSelection(order.value!.itemSelected.value!.menu_item!, selectionLevel, levelItemSelected));
    } else {
      selectionLevel++;
      MenuSelection? menuSelection = order.value!.itemSelected.value!.menu_item!.selections!.firstWhereOrNull((f) => f.level == selectionLevel);

      if (menuSelection != null) {
        levelItemSelected = 1;
        levelNoOfSelection = menuSelection.no_of_selection;
        popup.sinkValue(PopUpMenuSelection(order.value!.itemSelected.value!.menu_item!, selectionLevel, levelItemSelected));
      } else {
        //here
        if (order.value!.itemSelected.value!.menu_item != null) {
          if (order.value!.itemSelected.value!.menu_item!.popup_mod != null && order.value!.itemSelected.value!.menu_item!.popup_mod!.isNotEmpty) {
            _lastModifier(order.value!.itemSelected.value!.menu_item);
          } else {
            popup.sinkValue(OrderPanel());
          }
        } else {
          popup.sinkValue(OrderPanel());
        }
      }
    }
  }

  void _checkNextCombo() {
    OrderTransaction? transaction = order.value!.lastTransaction();
    int index = transaction!.sub_menu_item!.indexOf(comboItem!);
    if (index + 1 <= transaction.sub_menu_item!.length - 1) {
      TransactionCombo item = transaction.sub_menu_item![index + 1];
      comboItem = item;
      if (item.menu_item!.popup_mod!.length > 0) {
        for (var popup in item.menu_item!.popup_mod!) {
          for (var modifier in popup.modifiers.where((f) => f.modifier == null)) {
            modifier.modifier = locator.get<ConnectionRepository>().menuModifiers!.firstWhereOrNull((f) => f.id == modifier.modifier_id);
          }
        }
        popup.sinkValue(PopUpModifier(item.menu_item!, false, true));
      } else {
        _checkNextCombo();
      }
    } else {
      if (transaction.menu_item!.popup_mod!.length > 0) {
        _lastModifier(transaction.menu_item);
      } else {
        popup.sinkValue(OrderPanel());
      }
    }
  }

  void _lastModifier(menu_item) {
    for (var popup in menu_item.popup_mod) {
      for (var modifier in popup.modifiers.where((f) => f.modifier == null)) {
        modifier.modifier = locator.get<ConnectionRepository>().menuModifiers!.firstWhereOrNull((f) => f.id == modifier.modifier_id && f.in_active == false);
      }
    }

    popup.sinkValue(PopUpModifier(menu_item, false, false));
  }

  void _adjPrice() async {
    if (order.value!.itemSelected.value == null) return;
    if (order.value!.status == 6) return;
    if (order.value!.itemSelected.value!.status == 2) return;

    Privilege priv = Privilege();
    if (!priv.checkPrivilege(Privilages.Change_Item_Price)) return;

    String price = await locator<DialogService>().showNumberDialog(NumberDialogRequest(title: "Enter Price", hasDotButton: true, maxLength: 1000));

    if (price == "0") return;
    order.value!.adjTransactionPrice(price);
  }

  void _adjQty() async {
    if (order.value!.itemSelected.value != null && order.value!.itemSelected.value!.id == 0 && order.value!.itemSelected.value!.status != 2) {
      String qty = await locator<DialogService>().showNumberDialog(NumberDialogRequest(title: "Enter Qty", hasHalfButton: true, maxLength: 2));
      if (qty == "0") return;
      order.value!.adjTransactionQty(qty);
    }
  }

  void _adjGuest() async {
    String guestNo = await locator<DialogService>().showNumberDialog(NumberDialogRequest(title: "Enter Guests Number", hasHalfButton: false, maxLength: 2));
    if (guestNo == "0") return;

    order.value!.no_of_guests = int.parse(guestNo);
    order.sinkValue(order.value ?? OrderHeader(employee_id: 0, payments: [], service_id: 0, transaction: [], terminal_id: null, id: 0));
  }

  void _reOrderTransaction() async {
    order.value!.reOrder();
  }

  void _shortNote() async {
    NoteDialogResponse response = await locator<DialogService>().shortNoteDialog();

    if (response.note != "" && response.note != null) order.value!.addShortNote(response.note!, response.price!);
  }

  void _transactionSelected(OrderTransaction? transaction) {
    if (popup.value is PopUpModifier || popup.value is PopUpMenuSelection) return;

    if (transaction == null) {
      order.value!.itemSelected.sinkValue(OrderTransaction());
      option.sinkValue(ItemOption());
    } else {
      order.value!.itemSelected.sinkValue(transaction);
      option.sinkValue(ItemOption());
    }
  }

  void _removeTransaction(OrderTransaction transaction) async {
    String? lang = locator.get<ConnectionRepository>().terminal!.getLangauge();
    AppLocalizations appLocalizations = await AppLocalizations.load(Locale(lang!));

    if (locator.get<Global>().authEmployee == null) return; //no authorized employee

    if (popup.value is PopUpModifier || popup.value is PopUpMenuSelection) return;

    if (transaction.id == 0) {
      int index = order.value!.transaction.indexOf(transaction);
      order.value!.removeItem(transaction);
      selectNextTransaction(index);
    } else {
      Privilege priv = Privilege();
      if (!priv.checkPrivilege(Privilages.void_order)) return;

      bool resault = await locator.get<DialogService>().showDialog(appLocalizations.translate("Void Order"), appLocalizations.translate("Are you sure you want to delete this item"), okButton: appLocalizations.translate("Yes"), cancelButton: appLocalizations.translate("No"));

      String reason = "";
      bool waste = false;

      if (resault) {
        //check reason
        if (locator.get<ConnectionRepository>().preference!.voidedItemNeedExplantion) {
          reason = await locator.get<DialogService>().noteDialog(appLocalizations.translate("Void Reason"));
          if (reason == "") {
            await locator.get<DialogService>().showDialog("", appLocalizations.translate("Voided Need Explantion"));
            return;
          }
        }

        //check waste
        waste = await locator.get<DialogService>().showDialog(appLocalizations.translate("Waste Order"), appLocalizations.translate("Is It Waste?"), okButton: appLocalizations.translate("Yes"), cancelButton: appLocalizations.translate("No"));

        transaction.Void_reason = reason;
        transaction.EmployeeVoid_id = locator.get<Global>().authEmployee!.id;
        transaction.Waste = waste;
        transaction.status = 2;
        transaction.Just_Voided = true;
        transaction.is_printed = false;
        transaction.calculateTotalPrice();
        order.value!.itemUpdated.sinkValue(transaction);
        order.value!.calculateItemTotal();
        int index = order.value!.transaction.indexOf(transaction);

        if (index >= 1)
          selectNextTransaction(index - 1);
        else
          selectNextTransaction(index);
      }
    }
  }

  selectNextTransaction(int index) {
    if (order.value!.transaction.length >= 0 && order.value!.transaction.length > index) {
      if (order.value!.transaction[index].status == 2) {
        _transactionSelected(null);
      } else
        _transactionSelected(order.value!.transaction[index]);
      return;
    } else if (order.value!.transaction.length == 0) {
      _transactionSelected(null);
      return;
    }

    selectNextTransaction(index - 1);
  }

  _addTag() async {
    String? lang = locator.get<ConnectionRepository>().terminal!.getLangauge();
    AppLocalizations appLocalizations = await AppLocalizations.load(Locale(lang!));
    String tag = await locator<DialogService>().noteDialog(appLocalizations.translate("Add Tag"));
    order.value!.addTag(tag);
  }

  void _loadTable(DineInTable table, List<OrderHeader>? orderList) async {
    if (locator.get<Global>().authEmployee == null) return; //no authorized employee
    String? lang = locator.get<ConnectionRepository>().terminal!.getLangauge();
    AppLocalizations appLocalizations = await AppLocalizations.load(Locale(lang!));
    order.sinkValue(OrderHeader(
        terminal_id: locator.get<ConnectionRepository>().terminal!.id,
        service: ServiceReference.fromService(selectedService.value!),
        employee: EmployeeReference.fromEmployee(locator.get<Global>().authEmployee!),
        employee_id: locator.get<Global>().authEmployee!.id,
        payments: [],
        service_id: selectedService.value!.id,
        transaction: []));

    if (orderList == null) {
      int guest = 1;
      if (selectedService.value!.showCustomerCount) {
        String resault = await locator<DialogService>().showNumberDialog(NumberDialogRequest(title: appLocalizations.translate("Guest Count"), maxLength: 2));
        if (resault == "") resault = "1";
        guest = int.parse(resault);
      }
      order.value!.dispose();

      OrderHeader temp = newOrder();
      temp.dinein_table = DineInTableReference.fromTable(table);
      temp.dinein_table_id = table.id;
      temp.no_of_guests = guest;
      temp.minimum_charge = table.min_charge;
      temp.charge_per_hour = table.charge_per_hour;
      temp.charge_after = table.charge_after;

      order.sinkValue(temp);
      checkAutoPrice(table);
      checkChargePerHour();

      if (!selectedService.value!.allowOneTicketPerTable) {
        _orders.add(temp);
        orders.sinkValue(_orders);
      }
    } else {
      _orders = orderList;
      if (_orders.length > 0) {
        order.sinkValue(_orders[0]);
        orders.sinkValue(_orders);
      }
      orderQty.sinkValue(order.value!.transaction.length);
      checkChargePerHour();
    }

    order.value!.calculateItemTotal();

    // setTableSeats(guest, DineIn_tableReference(table));
  }

  void _changeTicket(OrderHeader _order) {
    if (popup.value is PopUpModifier || popup.value is PopUpMenuSelection) return;

    order.sinkValue(_order);
  }

  void _addNewTicket() {
    if (locator.get<Global>().authEmployee == null) return; //no authorized employee

    if (popup.value is PopUpModifier || popup.value is PopUpMenuSelection) return;
    if (!selectedService.value!.allowOneTicketPerTable) {
      if (orders.value![orders.value!.length - 1].transaction.isEmpty || orders.value![0].minimum_charge > 0 || orders.value![0].charge_per_hour > 0) return;

      OrderHeader temp = OrderHeader(
          terminal_id: locator.get<ConnectionRepository>().terminal!.id,
          service: ServiceReference.fromService(selectedService.value!),
          dinein_table: order.value!.dinein_table,
          dinein_table_id: order.value!.dinein_table_id,
          Smallest_currency: order.value!.Smallest_currency,
          Round_Type: order.value!.Round_Type,
          surcharge: order.value!.surcharge,
          surcharge_amount: order.value!.surcharge_amount,
          surcharge_percentage: order.value!.surcharge_percentage,
          surcharge_apply_tax1: order.value!.surcharge_apply_tax1,
          surcharge_apply_tax2: order.value!.surcharge_apply_tax2,
          surcharge_apply_tax3: order.value!.surcharge_apply_tax3,
          tax1: connection!.preference!.tax1,
          tax2: connection!.preference!.tax2,
          tax3: connection!.preference!.tax3,
          tax2_tax1: connection!.preference!.tax2_tax1,
          minimum_charge: order.value!.min_charge,
          charge_per_hour: order.value!.charge_per_hour,
          charge_after: order.value!.charge_after,
          employee: EmployeeReference.fromEmployee(locator.get<Global>().authEmployee!),
          payments: [],
          service_id: selectedService.value!.id,
          transaction: [],
          employee_id: EmployeeReference.fromEmployee(locator.get<Global>().authEmployee!).id);
      order.sinkValue(temp);
      _orders.add(temp);
      orders.sinkValue(_orders);
    }
  }

  void checkAutoPrice(DineInTable? dineInTable) {
    if (order.value!.id == 0) {
      int? surchargeId;
      PriceManagement? autoPrice = getAutoPrice();

      //auto surcharge
      if (autoPrice != null) {
        if (autoPrice.surcharge_id != null) surchargeId = autoPrice.surcharge_id;
      }

      //table surcharge
      if (surchargeId == null) {
        if (order.value!.service_id == 1 && dineInTable != null) {
          surchargeId = dineInTable.surcharge_id;
        }
      }

      //service surcharge
      if (surchargeId == null) surchargeId = selectedService.value!.surcharge_id;

      if (surchargeId != null) {
        Surcharge? _surcharge = locator.get<ConnectionRepository>().surcharges != null ? locator.get<ConnectionRepository>().surcharges!.firstWhereOrNull((f) => f.id == surchargeId) : null;

        if (_surcharge != null) {
          order.value!.addSurcharge(_surcharge);
        }
      } else {
        order.value!.deleteSurcharge();
      }

      //Delivery Charge
      if (selectedService.value!.id == 4) {
        order.value!.delivery_charge = selectedService.value!.deliveryCharge;
      } else {
        order.value!.delivery_charge = 0;
      }

      if (autoPrice != null && autoPrice.discount_id != null) {
        if (order.value!.discount == null && order.value!.discount_amount > 0) {
        } else {
          Discount? discount = locator.get<ConnectionRepository>().discounts!.firstWhereOrNull((f) => f.id == autoPrice.discount_id);
          order.value!.addDiscount(discount);
        }
      } else {
        order.value!.calculateItemTotal();
      }
    }
  }

  bool validateOrder() {
    if ((order.value!.service_id == 1 || (order.value!.service != null && order.value!.service!.id == 1)) && selectedService.value!.showTableSelection) {
      if (order.value!.dinein_table == null) {
        //close loading dialog
        changeTable();
        return false;
      }
    } else if (order.value!.service_id == 4 || (order.value!.service != null && order.value!.service!.id == 4)) {
      if (order.value!.customer == null) {
        //close loading dialog
        changeCustomer();
        return false;
      }
    }

    return true;
  }

  void saveOrder(bool printRecipt, {bool resetOrder = true}) async {
    try {
      if (seveOrderClicked == false) {
        seveOrderClicked = true;
        String? lang = locator.get<ConnectionRepository>().terminal!.getLangauge();
        AppLocalizations appLocalizations = await AppLocalizations.load(Locale(lang!));
        // if (ordersCount < ordersLimit && order.value.id != 0) {
        int numberOfPrintTicketWhenSent = locator.get<ConnectionRepository>().preference!.numberOfPrintTicketWhenSent;
        if (order.value!.transaction.length == 0) {
          seveOrderClicked = false;
          return;
        }

        locator.get<DialogService>().showLoadingProgressDialog();
        if (order.value!.id == 0) order.value!.date_time = DateTime.now();

        order.value!.PrintCopy = 0;

        Terminal? terminal = locator.get<ConnectionRepository>().terminal;
        if (terminal!.bluetoothPrinter == "") {
          if (locator.get<ConnectionRepository>().preference!.printTicketWhenSent) {
            order.value!.PrintCopy = numberOfPrintTicketWhenSent;
            order.value!.print_time = DateTime.now();
          } else if (printRecipt) {
            order.value!.PrintCopy = 1;
            order.value!.print_time = DateTime.now();
          }
        }

        //close loading dialog
        locator.get<DialogService>().closeDialog();
        if (!validateOrder()) {
          seveOrderClicked = false;
          return;
        }

        if (orders.value == null || orders.value!.length == 0) {
          order.value!.terminal_id = terminal.id;

          OrderHeader? _order = await locator.get<ConnectionRepository>().saveOrder(order.value!);

          if (_order == null) {
            showToastWidget(
              OrderNotification(
                title: appLocalizations.translate("Warning"),
                message: appLocalizations.translate("Order Has Been Added To the Queue"),
                status: 2,
              ),
              handleTouch: true,
              duration: const Duration(seconds: 5),
              position: const ToastPosition(align: Alignment.topCenter, offset: -10),
            );

            finishOrder();
            order.sinkValue(newOrder());
          } else {
            PrintService printService = PrintService(terminal);
            printService.printOrder(_order);

            _order.service = ServiceReference.fromService(selectedService.value!);
            _order.calculateItemTotal();
            order.sinkValue(_order);
            showToastWidget(
              OrderNotification(
                title: appLocalizations.translate("Success"),
                message: appLocalizations.translate("Order#") + _order.id.toString() + appLocalizations.translate("Has Been Saved Successfully"),
                status: 3,
              ),
              handleTouch: true,
              duration: Duration(seconds: 5),
              position: ToastPosition(align: Alignment.topCenter, offset: -10),
            );

            if (locator.get<ConnectionRepository>().preference!.printTicketWhenSent || printRecipt) {
              if (terminal.bluetoothPrinter == "") {
                // await locator.get<ConnectionRepository>().printOrder(_order);
              } else {
                //printService.printOrder(_order);
              }
            }

            if (terminal.kitchenPrinter != null && terminal.kitchenPrinter != "") {
              //printService.kitchenPrinter(_order);
              locator.get<ConnectionRepository>().orderService!.updatePrintedItem(_order);
            }

            if (resetOrder) {
              finishOrder();
              order.sinkValue(newOrder());
            } else {
              order.sinkValue(_order);
            }
          }
        } else {
          List<OrderHeader> _orders = orders.value!.toList();
          _orders.forEach((element) {
            element.calculateItemTotal();
          });
          Map<String, int> localPrint = Map<String, int>();

          for (var item in _orders.toList()) {
            item.date_time = DateTime.now();

            if (item.print_time == null) item.PrintCopy = 0;

            if (terminal.bluetoothPrinter == "") {
              // for invo
              if (item.id == 0 && locator.get<ConnectionRepository>().preference!.printTicketWhenSent) {
                item.PrintCopy = numberOfPrintTicketWhenSent;
                item.print_time = DateTime.now();
              } else if (printRecipt && order.value!.GUID == item.GUID) {
                item.PrintCopy = 1;
                item.print_time = DateTime.now();
              }
            }

            //code==============
            if (printRecipt) {
              item.PrintCopy = 1;
              item.print_time = DateTime.now();
            }

            if (terminal.bluetoothPrinter != "") {
              try {
                List<OrderHeader> test = [];
                if (orders.value != null) {
                  for (var f in orders.value!) {
                    if (f.PrintCopy != null) {
                      if (f.PrintCopy > 0) {
                        test.add(f);
                      }
                    }
                  }
                }
                for (var item in test) {
                  localPrint[item.GUID] = item.PrintCopy;
                  item.PrintCopy = 0;
                }
              } catch (e) {}
            }

            item.terminal_id = locator.get<ConnectionRepository>().terminal!.id;
            if (item.id == 0 && item.transaction.length == 0) {
              _orders.remove(item);
              orders.value!.remove(item);
            }
          }

          _orders = (await locator.get<ConnectionRepository>().saveOrders(orders.value!))!;

          if (_orders == null || _orders.where((f) => f.id == 0).length > 0) {
            showToastWidget(
              OrderNotification(
                title: appLocalizations.translate("Warning"),
                message: appLocalizations.translate("Order Has Been Added To the Queue"),
                status: 2,
              ),
              handleTouch: true,
              duration: Duration(seconds: 5),
              position: ToastPosition(align: Alignment.topCenter, offset: -10),
            );
            finishOrder();
          } else {
            //get selected order
            OrderHeader? selectedOrder = _orders.firstWhereOrNull((f) => f.GUID == order.value!.GUID);
            selectedOrder!.service = ServiceReference.fromService(selectedService.value!);
            selectedOrder.amountChange = order.value!.amountChange;
            selectedOrder.amountTendered = order.value!.amountTendered;

            order.sinkValue(selectedOrder);

            showToastWidget(
              OrderNotification(
                title: appLocalizations.translate("Success"),
                message: appLocalizations.translate("Table Orders Has Been Saved Successfully"),
                status: 3,
              ),
              handleTouch: true,
              duration: Duration(seconds: 5),
              position: ToastPosition(align: Alignment.topCenter, offset: -10),
            );

            PrintService printService = PrintService(terminal);

            if (selectedOrder != null) {
              if (locator.get<ConnectionRepository>().preference!.printTicketWhenSent || printRecipt) {
                if (terminal.bluetoothPrinter == "") {
                  // if (selectedOrder.PrintCopy == 0)
                  //   await locator
                  //       .get<ConnectionRepository>()
                  //       .printOrder(selectedOrder);
                } else {
                  order.value!.print_time = DateTime.now();
                  await printService.printOrder(selectedOrder);
                }
              }
            }

            if (terminal.kitchenPrinter != null && terminal.kitchenPrinter != "") {
              for (var _order in _orders) {
                printService.kitchenPrinter(_order);
                locator.get<ConnectionRepository>().orderService?.updatePrintedItem(_order);
              }
            }

            if (resetOrder) {
              finishOrder();
            } else {
              orders.sinkValue(_orders);
              order.sinkValue(_orders.first);
            }
          }
        }

        orderQty.sinkValue(0);
        seveOrderClicked = false;
        // } else {
        //   await _getPastPurchases();
        // }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  finishOrder() {
    if (!locator.get<ConnectionRepository>().terminal!.stayAtOrderScreen!) {
      _navigationBloc!.navigatorSink.add(NavigateToHomePage());
    } else {
      if (selectedService.value!.id == 1 && selectedService.value!.showTableSelection && !locator.get<ConnectionRepository>().terminal!.skipTableSelection) {
        _navigationBloc!.popBack(true);
      } else {
        if (orders.value != null) {
          _navigationBloc!.popBack(true);
        }
      }
    }
  }

  voidOrder() async {
    if (order.value!.id == 0) return;
    if (locator.get<Global>().authEmployee == null) return; //no authorized employee

    Privilege priv = Privilege();
    if (!priv.checkPrivilege(Privilages.void_order)) return;
    String? lang = locator.get<ConnectionRepository>().terminal!.getLangauge();
    AppLocalizations appLocalizations = await AppLocalizations.load(Locale(lang!));
    // String lang = locator.get<ConnectionRepository>().terminal.langauge;
    // if (lang != null) {
    //   AppLocalizations appLocalizations =
    //       await AppLocalizations.load(Locale(lang));
    //   pendingOrderName.sinkValue(appLocalizations.translate("Pending Orders"));
    // }
    bool resault = await locator.get<DialogService>().showDialog(appLocalizations.translate("Void Order"), appLocalizations.translate("Are you sure you want to void the order"), okButton: appLocalizations.translate("Yes"), cancelButton: appLocalizations.translate("No"));

    String reason = "";
    bool waste = false;

    if (resault) {
      //check reason
      if (locator.get<ConnectionRepository>().preference!.voidedItemNeedExplantion) {
        reason = await locator.get<DialogService>().noteDialog(appLocalizations.translate("Void Reason"));
        if (reason == "") {
          await locator.get<DialogService>().showDialog("", appLocalizations.translate("Voided Need Explantion"));
          return;
        }
      }

      //check waste
      waste = await locator.get<DialogService>().showDialog(appLocalizations.translate("Waste Order"), appLocalizations.translate("Is It Waste?"), okButton: appLocalizations.translate("Yes"), cancelButton: appLocalizations.translate("No"));

      //save
      locator.get<DialogService>().showLoadingProgressDialog();
      bool? response = await locator.get<ConnectionRepository>().voidOrder(order.value!, locator.get<Global>().authEmployee!.id, reason, waste);
      locator.get<DialogService>().closeDialog();

      if (response!) {
        showToastWidget(
          OrderNotification(
            title: appLocalizations.translate("Success"),
            message: appLocalizations.translate("Order#") + order.value!.id.toString() + appLocalizations.translate("Has Been Voided"),
            status: 3,
          ),
          handleTouch: true,
          duration: Duration(seconds: 5),
          position: ToastPosition(align: Alignment.topCenter, offset: -10),
        );

        //go back
        _navigationBloc?.navigatorSink.add(NavigateToHomePage());
      }
    }
  }

  void changeTable() async {
    //go to table page on select change table
    String? lang = locator.get<ConnectionRepository>().terminal!.getLangauge();
    AppLocalizations appLocalizations = await AppLocalizations.load(Locale(lang!));
    showToastWidget(
      OrderNotification(
        title: appLocalizations.translate("Warning"),
        message: appLocalizations.translate("Select Table First"),
        status: 2,
      ),
      handleTouch: true,
      duration: Duration(seconds: 10),
      position: ToastPosition(align: Alignment.topCenter, offset: -10),
    );

    DineInTable temp = await _navigationBloc!.navigateToDineInPage();
    if (temp != null) {
      dineInPriceId = ((temp.group != null) ? temp.group?.price_id : null)!;
      order.value!.changeTable(temp);
      checkAutoPrice(temp);
      checkChargePerHour();
    }
  }

  void changeCustomer() async {
    String phone = await locator<DialogService>().showTelephoneDialog();
    if (phone == "") return;
    String? lang = locator.get<ConnectionRepository>().terminal!.getLangauge();
    AppLocalizations appLocalizations = await AppLocalizations.load(Locale(lang!));
    showToastWidget(
      OrderNotification(
        title: appLocalizations.translate("Warning"),
        message: appLocalizations.translate("Select Address"),
        status: 2,
      ),
      handleTouch: true,
      duration: Duration(seconds: 10),
      position: ToastPosition(align: Alignment.topCenter, offset: -10),
    );

    SelectedCustomer temp = await _navigationBloc!.navigateToCustomerPage(selectedService.value!, phone);
    if (temp != null) {
      customerPriceId = temp.customer.price_id;
      order.value!.setCustomer(temp.customer, temp.contact, temp.address);
      checkAutoPrice(null);
    }
  }

  void checkChargePerHour() {
    try {
      if (order.value == null || order.value!.dinein_table == null) return;

      DateTime currentDatetime = DateTime.now();
      DateTime dateTime;

      if (order.value!.charge_per_hour > 0) {
        if (currentDatetime.compareTo(order.value!.date_time!.add(Duration(hours: order.value!.charge_after, minutes: 15))) >= 0) {
          if (order.value!.print_time != null && currentDatetime.difference(order.value!.print_time!).inMinutes <= 15) {
            dateTime = order.value!.print_time!;
          } else {
            dateTime = currentDatetime;
          }

          int totalHours = dateTime.difference(order.value!.date_time!.add(Duration(hours: 0, minutes: 1))).inHours;

          order.value!.changeTotalChargePerHour(totalHours.abs() * order.value!.charge_per_hour);
        }
      }
    } catch (ex) {}
  }

  PriceManagement? getAutoPrice() {
    DateTime currentDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    PriceManagement? autoPrice;
    List<PriceManagement> prices = List<PriceManagement>.empty(growable: true);

    switch (selectedService.value!.id) {
      case 1:
        prices = locator.get<ConnectionRepository>().priceManagements!.where((f) => f.dineIn && f.from_date!.compareTo(currentDate) <= 0 && f.to_date!.compareTo(currentDate) >= 0).toList();
        break;
      case 2:
        prices = locator.get<ConnectionRepository>().priceManagements!.where((f) => f.takeAway && f.from_date!.compareTo(currentDate) <= 0 && f.to_date!.compareTo(currentDate) >= 0).toList();
        break;
      case 3:
        prices = locator.get<ConnectionRepository>().priceManagements!.where((f) => f.carService && f.from_date!.compareTo(currentDate) <= 0 && f.to_date!.compareTo(currentDate) >= 0).toList();
        break;
      case 4:
        prices = locator.get<ConnectionRepository>().priceManagements!.where((f) => f.delivery && f.from_date!.compareTo(currentDate) <= 0 && f.to_date!.compareTo(currentDate) >= 0).toList();
        break;
      case 5:
        prices = locator.get<ConnectionRepository>().priceManagements!.where((f) => f.retail && f.from_date!.compareTo(currentDate) <= 0 && f.to_date!.compareTo(currentDate) >= 0).toList();
        break;
      case 6:
        prices = locator.get<ConnectionRepository>().priceManagements!.where((f) => f.catering && f.from_date!.compareTo(currentDate) <= 0 && f.to_date!.compareTo(currentDate) >= 0).toList();
        break;
      default:
    }

    prices = prices
        .where((f) => (DateTime.now().hour > f.from_time!.hour || (DateTime.now().hour == f.from_time!.hour && DateTime.now().minute >= f.from_time!.minute)) && (DateTime.now().hour < f.to_time!.hour || (DateTime.now().hour == f.to_time!.hour && DateTime.now().minute <= f.to_time!.minute)))
        .toList();

    for (var price in prices) {
      if (price.repeat == 4) // yearly
      {
        if (price.from_date!.day == DateTime.now().day && price.from_date!.month == DateTime.now().month) {
          autoPrice = price;
        }
      } else if (price.repeat == 3) //monthly
      {
        if (price.from_date!.day == DateTime.now().day) {
          autoPrice = price;
        }
      } else if (price.repeat == 2) //weekly
      {
        if (price.from_date!.day == DateTime.now().weekday) {
          autoPrice = price;
        }
      } else {
        autoPrice = price;
      }
    }

    return autoPrice;
  }

  int? customerPriceId;
  int? dineInPriceId;
  int? get getPriceId {
    PriceManagement? autoPrice = getAutoPrice();
    int? auto_price_id;
    if (autoPrice != null) auto_price_id = autoPrice.price_label_id;

    if (auto_price_id != null) return auto_price_id;
    if (customerPriceId != null) return customerPriceId;
    if (selectedMenuType.value!.price_id != null) return selectedMenuType.value!.price_id;

    if (order.value!.dinein_table != null && dineInPriceId != null) return dineInPriceId;

    if (selectedService.value!.price_id != null) return selectedService.value!.price_id!;

    return null;
  }

  @override
  void dispose() {
    if (_subscription != null) _subscription!.cancel();

    _eventController.close();
    order.value!.dispose();
    order.dispose();

    if (orders != null && orders.value != null)
      for (var item in orders.value!) {
        item.dispose();
      }

    orders.dispose();
    qty.dispose();
    selectedService.dispose();
    selectedMenuType.dispose();
    groups.dispose();
    selectedMenuGroup.dispose();
    items.dispose();
    popup.dispose();
    option.dispose();
    orderQty.dispose();
    menuItemsList.dispose();
  }

  OrderHeader newOrder() {
    return OrderHeader(
        terminal_id: locator.get<ConnectionRepository>().terminal!.id,
        Smallest_currency: connection!.preference!.smallestCurrency!,
        Round_Type: connection!.preference!.roundType!,
        date_time: DateTime.now(),
        tax1: connection!.preference!.tax1,
        tax2: connection!.preference!.tax2,
        tax3: connection!.preference!.tax3,
        tax2_tax1: connection!.preference!.tax2_tax1,
        status: 1,
        service: ServiceReference.fromService(selectedService.value!),
        employee: EmployeeReference.fromEmployee(locator.get<Global>().authEmployee!),
        employee_id: locator.get<Global>().authEmployee!.id,
        payments: [],
        service_id: ServiceReference.fromService(selectedService.value!).id,
        transaction: []);
  }
}
