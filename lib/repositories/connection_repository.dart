import 'package:invo_mobile/models/Service.dart';
import 'package:invo_mobile/models/customer/customer.dart';
import 'package:invo_mobile/models/dineIn_group.dart';
import 'package:invo_mobile/models/discount.dart';
import 'package:invo_mobile/models/employee.dart';
import 'package:invo_mobile/models/menu_group.dart';
import 'package:invo_mobile/models/menu_item.dart';
import 'package:invo_mobile/models/menu_item_group.dart';
import 'package:invo_mobile/models/menu_modifier.dart';
import 'package:invo_mobile/models/menu_type.dart';
import 'package:invo_mobile/models/order/order_header.dart';
import 'package:invo_mobile/models/payment_method.dart';
import 'package:invo_mobile/models/preference.dart';
import 'package:invo_mobile/models/price_managment.dart';
import 'package:invo_mobile/models/service_order.dart';
import 'package:invo_mobile/models/surcharge.dart';
import 'package:invo_mobile/models/terminal.dart';
import 'package:invo_mobile/repositories/interface/Customer/ICustomerService.dart';
import 'package:invo_mobile/repositories/interface/Employee/IEmployeeService.dart';
import 'package:invo_mobile/repositories/interface/Employee/IRoleServices.dart';
import 'package:invo_mobile/repositories/interface/Menu/IDiscountService.dart';
import 'package:invo_mobile/repositories/interface/Menu/IMenuTypeService.dart';

import 'package:invo_mobile/repositories/interface/Menu/ISurchargeService.dart';
import 'package:invo_mobile/repositories/interface/Report/IReportService.dart';
import 'package:invo_mobile/repositories/interface/Settings/IDineInService.dart';
import 'package:invo_mobile/repositories/interface/Settings/IPaymentMethosService.dart';
import 'package:invo_mobile/repositories/interface/Settings/IPreferenceService.dart';
import 'package:invo_mobile/repositories/interface/Settings/IPriceManagment.dart';
import 'package:invo_mobile/repositories/interface/Settings/ITerminalService.dart';

import 'interface/Cashier/ICashierService.dart';
import 'interface/Menu/IMenuCategoryService.dart';
import 'interface/Menu/IMenuGroupService.dart';
import 'interface/Menu/IMenuItemService.dart';
import 'interface/Menu/IMenuModifier.dart';
import 'interface/Menu/IPriceService.dart';
import 'interface/Order/IOrderService.dart';
import 'interface/Settings/ITypeService.dart';
import 'invo_connection_repository.dart';

typedef Void2BoolFunc = void Function(bool);

abstract class ConnectionRepository {
  IMenuItemService? menuItemService;
  IPriceService? priceService;
  IMenuCategoryService? menuCategoryService;
  IMenuModifierService? menuModifierService;
  ISurchargeService? surchargeService;
  IDiscountService? discountService;
  IEmployeeService? employeeService;
  IRoleService? roleService;
  IPriceManagmentService? priceManagmentService;
  IPaymentMethodService? paymentMethodService;
  IMenuGroupService? menuGroupService;
  IMenuTypeService? menuTypeService;
  IPreferenceService? preferenceService;
  ITerminalService? terminalService;
  IDineInService? dineInService;
  ITypeService? typeService;
  ICashierService? cashierService;
  IOrderService? orderService;
  IReportService? reportService;
  ICustomerService? customerService;

  String get repoName {
    return "";
  }

  String? ip;
  Terminal? terminal;
  Preference? preference;
  List<MenuType>? menuTypes;
  List<MenuGroup>? menuGroups;
  List<MenuItemGroup>? menuItemGroups;
  List<MenuItem>? menuItems;
  List<MenuModifier>? menuModifiers;
  List<Employee>? employees;
  List<DineInGroup>? dineInGroups;
  List<Service>? services;
  List<Discount>? discounts;
  List<Surcharge>? surcharges;
  List<PriceManagement>? priceManagements;
  PaymentMethod? cash;

  Void2IntFunc? queueNumber;
  Void2BoolFunc? connection;

  String? httpRequestError;
  Void2IntFunc? progress;

  List<MenuGroup>? getMenuGroup() {
    menuGroups?.sort((a, b) {
      if (a.index == null) {
        a.index = 0;
      }

      if (b.index == null) {
        b.index = 0;
      }
      return a.index.compareTo(b.index);
    });

    return menuGroups;
  }

  connect({String? ip}) {}

  Future<bool>? checkDatabaseIfExist() {}

  fetchServicesOrders() {}

  fetchTablesStatus() {}

  fetchTableStatus(int id) {}

  fetchServiceOrder(int serviceId) {}

  fetchServicePaidOrders(int serviceId, DateTime _date) {}

  fetchPendingOrders() {}

  Future<OrderHeader?>? fetchFullOrder(int orderId) {
    return null;
  }

  Future<OrderHeader?>? fetchFullPendingOrder(int orderId) {
    return null;
  }

  Future<List<OrderHeader>?>? loadOrders(int tableId) {
    return null;
  }

  Future<Customer?>? loadCustomer(String phone) {}

  Future<Customer?>? saveCustomer(Customer customer) {}

  Future<OrderHeader?>? saveOrder(OrderHeader order) {}
  Future<List<OrderHeader>?>? saveOrders(List<OrderHeader> orders) {}

  Future<bool>? printOrder(OrderHeader order) {}

  Future<bool>? surchargeOrder(OrderHeader order, Surcharge surcharge) {}

  Future<bool>? discountOrder(OrderHeader order, Discount? discount, int employeeId) {}

  Future<bool>? followUp(OrderHeader order) {}

  Future<bool>? voidOrder(OrderHeader order, int employeeId, String reason, bool waste) {}

  Future<Terminal?>? saveTerminal(Terminal terminal) {}

  dailyBackupDB() {}
}
