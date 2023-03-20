import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:http/http.dart' as http;
import 'package:invo_mobile/models/Number.dart';
import 'package:invo_mobile/models/Service.dart';
import 'package:invo_mobile/models/custom/mini_order.dart';
import 'package:invo_mobile/models/custom/table_status.dart';
import 'package:invo_mobile/models/customer/customer.dart';
import 'package:invo_mobile/models/customer/customer_contact.dart';
import 'package:invo_mobile/models/dineIn_group.dart';
import 'package:invo_mobile/models/discount.dart';
import 'package:invo_mobile/models/employee.dart';
import 'package:invo_mobile/models/order/order_header.dart';
import 'package:invo_mobile/models/payment_method.dart';
import 'package:invo_mobile/models/price_managment.dart';
import 'package:invo_mobile/models/service_order.dart';
import 'package:invo_mobile/models/surcharge.dart';
import 'package:invo_mobile/models/wizard.dart';
import 'package:invo_mobile/repositories/interface/Employee/IEmployeeService.dart';
import 'package:invo_mobile/repositories/interface/Employee/IRoleServices.dart';
import 'package:invo_mobile/repositories/interface/Menu/IDiscountService.dart';
import 'package:invo_mobile/repositories/interface/Menu/IMenuCategoryService.dart';
import 'package:invo_mobile/repositories/interface/Menu/IMenuItemService.dart';
import 'package:invo_mobile/repositories/interface/Menu/IMenuModifier.dart';

import 'package:invo_mobile/repositories/interface/Menu/ISurchargeService.dart';
import 'package:invo_mobile/repositories/interface/Settings/IPaymentMethosService.dart';
import 'package:invo_mobile/repositories/interface/Settings/IPriceManagment.dart';
import 'package:invo_mobile/repositories/invo/Cashier/CashierInvoService.dart';
import 'package:invo_mobile/repositories/invo/Customer/CustomerInvoService.dart';
import 'package:invo_mobile/repositories/invo/Employee/EmployeeInvoServices.dart';
import 'package:invo_mobile/repositories/invo/Employee/RoleInvoServices.dart';
import 'package:invo_mobile/repositories/invo/Menu/DiscountInvoServices.dart';
import 'package:invo_mobile/repositories/invo/Menu/MenuGroupInvoService.dart';
import 'package:invo_mobile/repositories/invo/Menu/MenuModifiersInvoServices.dart';
import 'package:invo_mobile/repositories/invo/Menu/MenuTypeInvoService.dart';
import 'package:invo_mobile/repositories/invo/Menu/PriceInvoServices.dart';
import 'package:invo_mobile/repositories/invo/Menu/SurchargeInvoServices.dart';
import 'package:invo_mobile/repositories/invo/Menu/menuCategoryInvoService.dart';
import 'package:invo_mobile/repositories/invo/Menu/menuItemInvoServices.dart';
import 'package:invo_mobile/repositories/invo/Order/OrderInvoService.dart';
import 'package:invo_mobile/repositories/invo/Report/ReportInvoService.dart';
import 'package:invo_mobile/repositories/invo/Settings/PreferenceInvoService.dart';
import 'package:invo_mobile/repositories/invo/Settings/PriceManagmentInvoServices.dart';
import 'package:invo_mobile/repositories/invo/Settings/TerminalInvoService.dart';
import 'package:invo_mobile/repositories/invo/Settings/dineInInvoServices.dart';
import 'package:invo_mobile/repositories/invo/Settings/paymentMethodInvoServices.dart';
import 'package:invo_mobile/repositories/invo/Settings/typeInvoServices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'connection_repository.dart';
import 'package:collection/collection.dart';

import 'package:invo_mobile/models/menu_group.dart';
import 'package:invo_mobile/models/menu_item.dart';
import 'package:invo_mobile/models/menu_item_group.dart';
import 'package:invo_mobile/models/menu_modifier.dart';
import 'package:invo_mobile/models/menu_type.dart';
import 'package:invo_mobile/models/preference.dart';
import 'package:invo_mobile/models/terminal.dart';

import 'interface/Cashier/ICashierService.dart';
import 'interface/Customer/ICustomerService.dart';
import 'interface/Menu/IMenuGroupService.dart';
import 'interface/Menu/IMenuTypeService.dart';
import 'interface/Menu/IPriceService.dart';
import 'interface/Order/IOrderService.dart';
import 'interface/Report/IReportService.dart';
import 'interface/Settings/IDineInService.dart';
import 'interface/Settings/IPreferenceService.dart';
import 'interface/Settings/ITerminalService.dart';
import 'interface/Settings/ITypeService.dart';

typedef Void2IntFunc = Function(int);

class InvoConnectionRepository implements ConnectionRepository {
  @override
  IDiscountService? discountService;
  @override
  IEmployeeService? employeeService;
  @override
  IMenuCategoryService? menuCategoryService;
  @override
  IMenuItemService? menuItemService;
  @override
  IMenuModifierService? menuModifierService;
  @override
  IPriceService? priceService;
  @override
  IPaymentMethodService? paymentMethodService;
  @override
  IPriceManagmentService? priceManagmentService;
  @override
  IRoleService? roleService;
  @override
  ISurchargeService? surchargeService;
  @override
  IMenuGroupService? menuGroupService;
  @override
  IMenuTypeService? menuTypeService;
  @override
  IPreferenceService? preferenceService;
  @override
  ITerminalService? terminalService;
  @override
  IDineInService? dineInService;
  @override
  ITypeService? typeService;
  @override
  ICashierService? cashierService;
  @override
  IOrderService? orderService;
  @override
  IReportService? reportService;
  @override
  ICustomerService? customerService;

  InvoConnectionRepository() {
    getDeviceInfo();

    discountService = DiscountInvoService();
    employeeService = EmployeeInvoService();
    menuCategoryService = MenuCategoryInvoService();
    menuItemService = MenuItemInvoService();
    menuModifierService = MenuModifiersInvoService();
    priceService = PriceInvoService();
    paymentMethodService = PaymentMethodInvoService();
    priceManagmentService = PriceManagmentInvoService();
    roleService = RoleInvoService();
    surchargeService = SurchargeInvoService();
    menuTypeService = MenuTypeInvoService();
    menuGroupService = MenuGroupInvoService();
    preferenceService = PreferenceInvoService();
    orderService = OrderInvoService();
    terminalService = TerminalInvoService();
    dineInService = DineInInvoService();
    typeService = TypeInvoServices();
    cashierService = CashierInvoService();
    reportService = ReportInvoService();
    customerService = CustomerInvoService();
  }

  String? deviceId;

  Map<String, String>? headers;
  getDeviceInfo() async {
    try {
      var deviceInfo = DeviceInfoPlugin();
      if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor;
      } else if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.androidId;
      } else if (Platform.isWindows) {
        deviceId = "WINDOWS";
      }
    } catch (e) {
      deviceId = "WEB";
    }

    headers = new Map<String, String>();

    headers!["DeviceID"] = deviceId!; // this.device.uuid
    headers!["Device-Type"] = "1";
    headers!["Content-Type"] = "application/json";

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("DeviceID", deviceId!);
  }

  String? ip;
  Terminal? terminal;
  Preference? preference;
  List<MenuType>? menuTypes;
  List<MenuGroup>? menuGroups;
  List<MenuItemGroup>? menuItemGroups;
  List<MenuItem>? menuItems;
  List<MenuModifier>? menuModifiers;
  List<DineInGroup>? dineInGroups;
  List<Employee>? employees;
  List<Service>? services;
  List<PriceManagement>? priceManagements;
  List<Discount>? discounts;
  List<Surcharge>? surcharges;
  PaymentMethod? cash;
  @override
  String? httpRequestError;
  @override
  Void2BoolFunc? connection;
  Void2IntFunc? progress;

  List<MenuGroup>? getMenuGroup() {
    menuGroups!.sort((a, b) {
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

  String get baseUrl {
    return "http://" + "$ip:8081";
  }

  increaseProgress(int i) {
    if (progress != null) {
      progress!(i);
    }
  }

  Future<bool> connect({
    String? ip,
  }) async {
    this.ip = ip;
    if (deviceId == null) await getDeviceInfo();
    bool flag = false;
    flag = await fetchTerminal();

    if (!flag) return false;
    increaseProgress(4);
    flag = await fetchPreference();
    if (!flag) return false;
    increaseProgress(8);
    flag = await fetchMenus();
    if (!flag) return false;
    increaseProgress(12);
    flag = await fetchMenuGroups();
    if (!flag) return false;
    increaseProgress(16);
    flag = await fetchMenuItemGroups();
    if (!flag) return false;
    increaseProgress(20);
    flag = await fetchMenuItems();
    if (!flag) return false;
    increaseProgress(40);
    flag = await fetchMenuModifiers();
    if (!flag) return false;
    increaseProgress(50);

    flag = await fetchPriceManagements();
    if (!flag) return false;
    increaseProgress(55);

    flag = await fetchDiscounts();
    if (!flag) return false;
    increaseProgress(62);

    flag = await fetchSurcharges();
    if (!flag) return false;
    increaseProgress(70);

    flag = await fetchEmployees();
    if (!flag) return false;
    increaseProgress(80);

    flag = await fetchDineInGroups();
    if (!flag) return false;
    increaseProgress(90);

    flag = await fetchServices();
    if (!flag) return false;
    increaseProgress(94);

    flag = await fetchPaymentMethods();
    if (!flag) return false;
    increaseProgress(98);

    Number.symbol = (cash!.symbol == null) ? "\$" : cash!.symbol;
    Number.afterDecimal = (cash!.after_decimal == null) ? 2 : cash!.after_decimal;
    // GetIt.instance.registerLazySingleton<Number>(() => nn);
    httpRequestError = "";
    increaseProgress(100);

    return true;
  }
  // String imageLink;
  //   void getItemImage()  {
  //   }

  Future<bool>? checkDatabaseIfExist() {}

  Future<bool> fetchTerminal() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/Terminal/Get/" + deviceId!), headers: this.headers).timeout(Duration(seconds: 10));
      if (response == null) {
        httpRequestError = "Cannot Connect , Please check your connection";
        return false;
      }
      if (response.statusCode == 200) {
        if (response.body == "") {
          httpRequestError = "";
          return false;
        }
        // If server returns an OK response, parse the JSON.
        this.terminal = Terminal.fromJson(json.decode(response.body));
        return true;
      } else if (response.statusCode == 409) {
        httpRequestError = "Connection Reach Limit";
        return false;
      } else {
        print("error");
        httpRequestError = "";
        // If that response was not OK, throw an error.
        // throw Exception('Failed to load post');
        return false;
      }
    } on SocketException {
      httpRequestError = "Cannot Connect , Please check your connection";
      return false;
    }
  }

  Future<bool> fetchPreference() async {
    final response = await http.get(Uri.parse("$baseUrl/Preference/Get"), headers: this.headers);
    if (response.statusCode == 200) {
      if (response.body == "") {
        return false;
      }
      // If server returns an OK response, parse the JSON.
      this.preference = Preference.fromJson(json.decode(response.body));
      return true;
    } else {
      print("error");
      // If that response was not OK, throw an error.
      // throw Exception('Failed to load post');
      return false;
    }
  }

  Future<bool> fetchMenus() async {
    final response = await http.get(Uri.parse("$baseUrl/MenuTypes/GetAll"), headers: this.headers);
    if (response.statusCode == 200) {
      if (response.body == "") {
        return false;
      }
      // If server returns an OK response, parse the JSON.
      List<MenuType> list = List<MenuType>.empty(growable: true);
      for (var item in json.decode(response.body)) {
        list.add(MenuType.fromJson(item));
      }
      this.menuTypes = list;

      return true;
    } else {
      print("error");
      // If that response was not OK, throw an error.
      // throw Exception('Failed to load post');
      return false;
    }
  }

  Future<bool> fetchMenuGroups() async {
    final response = await http.get(Uri.parse("$baseUrl/MenuGroups/GetAll"), headers: this.headers);
    if (response.statusCode == 200) {
      if (response.body == "") {
        return false;
      }
      // If server returns an OK response, parse the JSON.
      List<MenuGroup> list = List<MenuGroup>.empty(growable: true);
      for (var item in json.decode(response.body)) {
        list.add(MenuGroup.fromJson(item));
      }
      this.menuGroups = list.where((f) => f.in_active == false).toList();
      return true;
    } else {
      print("error");
      // If that response was not OK, throw an error.
      // throw Exception('Failed to load post');
      return false;
    }
  }

  Future<bool> fetchMenuItemGroups() async {
    final response = await http.get(Uri.parse("$baseUrl/MenuItemGroups/GetAll"), headers: this.headers);
    if (response.statusCode == 200) {
      if (response.body == "") {
        return false;
      }
      // If server returns an OK response, parse the JSON.
      List<MenuItemGroup> list = List<MenuItemGroup>.empty(growable: true);

      for (var item in json.decode(response.body)) {
        list.add(MenuItemGroup.fromJson(item));
      }
      this.menuItemGroups = list;
      return true;
    } else {
      print("error");
      // If that response was not OK, throw an error.
      // throw Exception('Failed to load post');
      return false;
    }
  }

  Future<bool> fetchMenuItems() async {
    final response = await http.get(Uri.parse("$baseUrl/MenuItems/GetAll"), headers: this.headers);
    if (response.statusCode == 200) {
      if (response.body == "") {
        return false;
      }
      // If server returns an OK response, parse the JSON.
      List<MenuItem> list = List<MenuItem>.empty(growable: true);
      for (var item in json.decode(response.body)) {
        list.add(MenuItem.fromJson(item));
      }

      this.menuItems = list;

      for (var menuItem in list) {
        for (var menu_selection in menuItem.selections!) {
          for (var item in menu_selection.Selections!) {
            item.menuItem = list.firstWhereOrNull((f) => f.id == item.menu_item_id);
          }

          for (var item in menu_selection.Selections!.toList().where((element) => element.menuItem == null)) {
            menu_selection.Selections!.remove(item);
          }
        }
      }

      setMenuItemGroup();
      return true;
    } else {
      print("error");
      // If that response was not OK, throw an error.
      // throw Exception('Failed to load post');
      return false;
    }
  }

  void setMenuItemGroup() {
    for (var item in menuItemGroups!) {
      item.menu_item = menuItems?.firstWhereOrNull((f) => f.id == item.menu_item_id);
    }
  }

  Future<bool> fetchMenuModifiers() async {
    final response = await http.get(Uri.parse("$baseUrl/MenuModifiers/GetAll"), headers: this.headers);
    if (response.statusCode == 200) {
      if (response.body == "") {
        return false;
      }
      // If server returns an OK response, parse the JSON.
      List<MenuModifier> list = List<MenuModifier>.empty(growable: true);

      for (var item in json.decode(response.body)) {
        list.add(MenuModifier.fromJson(item));
      }
      this.menuModifiers = list;

      return true;
    } else {
      print("error");
      // If that response was not OK, throw an error.
      // throw Exception('Failed to load post');
      return false;
    }
  }

  Future<bool> fetchPriceManagements() async {
    final response = await http.get(Uri.parse("$baseUrl/PriceManagment/GetAll"), headers: this.headers);
    if (response.statusCode == 200) {
      if (response.body == "") {
        return false;
      }
      // If server returns an OK response, parse the JSON.
      List<PriceManagement> list = List<PriceManagement>.empty(growable: true);

      for (var item in json.decode(response.body)) {
        list.add(PriceManagement.fromJson(item));
      }
      this.priceManagements = list;

      return true;
    } else {
      print("error");
      // If that response was not OK, throw an error.
      // throw Exception('Failed to load post');
      return false;
    }
  }

  Future<bool> fetchDiscounts() async {
    final response = await http.get(Uri.parse("$baseUrl/Discounts/GetAll"), headers: this.headers);
    if (response.statusCode == 200) {
      if (response.body == "") {
        return false;
      }
      // If server returns an OK response, parse the JSON.
      List<Discount> list = List<Discount>.empty(growable: true);

      for (var item in json.decode(response.body)) {
        list.add(Discount.fromJson(item));
      }
      this.discounts = list;

      return true;
    } else {
      print("error");
      // If that response was not OK, throw an error.
      // throw Exception('Failed to load post');
      return false;
    }
  }

  Future<bool> fetchSurcharges() async {
    final response = await http.get(Uri.parse("$baseUrl/Surcharges/GetAll"), headers: this.headers);
    if (response.statusCode == 200) {
      if (response.body == "") {
        return false;
      }
      // If server returns an OK response, parse the JSON.
      List<Surcharge> list = List<Surcharge>.empty(growable: true);

      for (var item in json.decode(response.body)) {
        list.add(Surcharge.fromJson(item));
      }
      this.surcharges = list;

      return true;
    } else {
      print("error");
      // If that response was not OK, throw an error.
      // throw Exception('Failed to load post');
      return false;
    }
  }

  Future<bool> fetchEmployees() async {
    final response = await http.get(Uri.parse("$baseUrl/Employees/getAll"), headers: this.headers);
    if (response.statusCode == 200) {
      if (response.body == "") {
        return false;
      }
      // If server returns an OK response, parse the JSON.
      List<Employee> list = List<Employee>.empty(growable: true);

      for (var item in json.decode(response.body)) {
        list.add(Employee.fromJson(item));
      }
      this.employees = list;

      return true;
    } else {
      print("error");
      // If that response was not OK, throw an error.
      // throw Exception('Failed to load post');
      return false;
    }
  }

  Future<bool> fetchDineInGroups() async {
    final response = await http.get(Uri.parse("$baseUrl/DineIn/group/getAll"), headers: this.headers);
    if (response.statusCode == 200) {
      if (response.body == "") {
        return false;
      }
      // If server returns an OK response, parse the JSON.
      List<DineInGroup> list = List<DineInGroup>.empty(growable: true);

      for (var item in json.decode(response.body)) {
        list.add(DineInGroup.fromJson(item));
      }

      dineInGroups = list;
      return true;
    } else {
      print("error");
      // If that response was not OK, throw an error.
      // throw Exception('Failed to load post');
      return false;
    }
  }

  Future<bool> fetchServices() async {
    final response = await http.get(Uri.parse("$baseUrl/MyServices/GetAll"), headers: this.headers);
    if (response.statusCode == 200) {
      if (response.body == "") {
        return false;
      }
      // If server returns an OK response, parse the JSON.
      List<Service> list = List<Service>.empty(growable: true);

      for (var item in json.decode(response.body)) {
        list.add(Service.fromJson(item));
      }
      this.services = list;

      return true;
    } else {
      print("error");
      // If that response was not OK, throw an error.
      // throw Exception('Failed to load post');
      return false;
    }
  }

  Future<bool> fetchPaymentMethods() async {
    final response = await http.get(Uri.parse("$baseUrl/PaymentMethod/GetAll"), headers: this.headers);
    if (response.statusCode == 200) {
      if (response.body == "") {
        return false;
      }
      // If server returns an OK response, parse the JSON.
      List<PaymentMethod> list = List<PaymentMethod>.empty(growable: true);

      for (var item in json.decode(response.body)) {
        list.add(PaymentMethod.fromJson(item));
      }
      this.cash = list.firstWhereOrNull((f) => f.id == 1);

      return true;
    } else {
      print("error");
      // If that response was not OK, throw an error.
      // throw Exception('Failed to load post');
      return false;
    }
  }

  Future<List<ServiceOrder>> fetchServicesOrders() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/MyServices/ServiceOrder"), headers: this.headers).timeout(Duration(seconds: 10)).catchError((error) {
        print(error);
      });

      if (response == null) {
        if (connection != null) connection!(false);
        return List<ServiceOrder>.empty(growable: true);
      }

      if (response.statusCode == 200) {
        if (connection != null) connection!(true);
        if (response.body == "") {
          return List<ServiceOrder>.empty(growable: true);
        }
        // If server returns an OK response, parse the JSON.
        List<ServiceOrder> list = List<ServiceOrder>.empty(growable: true);

        for (var item in json.decode(response.body)) {
          list.add(ServiceOrder.fromJson(item));
        }
        return list;
      } else {
        if (connection != null) connection!(false);
        print("error");
        // If that response was not OK, throw an error.
        // throw Exception('Failed to load post');
        return List<ServiceOrder>.empty(growable: true);
      }
    } catch (e) {
      if (connection != null) connection!(false);
      return List<ServiceOrder>.empty(growable: true);
    }
  }

  Future<List<TableStatus>> fetchTablesStatus() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/DineIn/getTablestatus"), headers: this.headers).timeout(Duration(seconds: 10)).catchError((error) {
        print(error);
      });

      if (response == null) {
        if (connection != null) connection!(false);
        return List<TableStatus>.empty(growable: true);
      }

      if (response.statusCode == 200) {
        if (connection != null) connection!(true);
        if (response.body == "") {
          return List<TableStatus>.empty(growable: true);
        }
        // If server returns an OK response, parse the JSON.
        List<TableStatus> list = List<TableStatus>.empty(growable: true);

        for (var item in json.decode(response.body)) {
          list.add(TableStatus.fromJson(item));
        }
        return list;
      } else {
        if (connection != null) connection!(false);
        print("error");
        // If that response was not OK, throw an error.
        // throw Exception('Failed to load post');
        return List<TableStatus>.empty(growable: true);
      }
    } on SocketException {
      if (connection != null) connection!(false);
      return List<TableStatus>.empty(growable: true);
    }
  }

  Future<TableStatus?> fetchTableStatus(int id) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/DineIn/TableStatus/" + id.toString()), headers: this.headers).timeout(Duration(seconds: 10)).catchError((error) {
        print(error);
      });

      if (response == null) {
        if (connection != null) connection!(false);
        return null;
      }

      if (response.statusCode == 200) {
        if (connection != null) connection!(true);
        if (response.body == "") {
          return null;
        }

        TableStatus temp = TableStatus.fromJson(json.decode(response.body));
        return temp;
      } else {
        if (connection != null) connection!(false);
        print("error");
        // If that response was not OK, throw an error.
        // throw Exception('Failed to load post');
        return null;
      }
    } on SocketException {
      if (connection != null) connection!(false);
      return null;
    }
  }

  @override
  Future<List<MiniOrder>> fetchServiceOrder(int serviceId) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/Order/OpenOrders/mini/all/" + serviceId.toString()), headers: this.headers).timeout(Duration(seconds: 10)).catchError((error) {
        print(error);
      });

      if (response == null) {
        if (connection != null) connection!(false);
        return List<MiniOrder>.empty(growable: true);
      }

      if (response.statusCode == 200) {
        if (connection != null) connection!(true);
        if (response.body == "") {
          return List<MiniOrder>.empty(growable: true);
        }
        // If server returns an OK response, parse the JSON.
        List<MiniOrder> list = List<MiniOrder>.empty(growable: true);
        for (var item in json.decode(response.body)) {
          list.add(MiniOrder.fromJson(item));
        }
        return list;
      } else {
        if (connection != null) connection!(false);
        // If that response was not OK, throw an error.
        // throw Exception('Failed to load post');
        return List<MiniOrder>.empty(growable: true);
      }
    } on SocketException {
      if (connection != null) connection!(false);
      return List<MiniOrder>.empty(growable: true);
    }
  }

  @override
  Future<List<MiniOrder>?> fetchPendingOrders() async {
    return null;
  }

  @override
  Future<List<MiniOrder>?> fetchServicePaidOrders(int serviceId, DateTime _date) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/Order/SetteledOrders/mini/all/" + serviceId.toString() + "/" + _date.year.toString() + "-" + _date.month.toString() + "-" + _date.day.toString()), headers: this.headers).timeout(Duration(seconds: 10)).catchError((error) {
        print(error);
      });

      if (response == null) {
        if (connection != null) connection!(false);
        return List<MiniOrder>.empty(growable: true);
      }

      if (response.statusCode == 200) {
        if (response.body == "") {
          return List<MiniOrder>.empty(growable: true);
        }
        // If server returns an OK response, parse the JSON.
        List<MiniOrder> list = List<MiniOrder>.empty(growable: true);

        for (var item in json.decode(response.body)) {
          list.add(MiniOrder.fromJson(item));
        }
        return list;
      } else {
        print("error");
        // If that response was not OK, throw an error.
        // throw Exception('Failed to load post');
        return List<MiniOrder>.empty(growable: true);
      }
    } on SocketException {
      return null;
    }
  }

  @override
  Future<OrderHeader?>? fetchFullOrder(int orderId) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/Order/Full/" + orderId.toString()), headers: this.headers).timeout(Duration(seconds: 10)).catchError((error) {
        print(error);
      });

      if (response == null) {
        if (connection != null) connection!(false);
        return null;
      }

      if (response.statusCode == 200) {
        if (response.body == "") {
          return null;
        }
        // If server returns an OK response, parse the JSON.
        return OrderHeader.fromJson(json.decode(response.body));
      } else {
        print("error");
        // If that response was not OK, throw an error.
        // throw Exception('Failed to load post');
        return null;
      }
    } on SocketException {
      return null;
    }
  }

  @override
  Future<OrderHeader?>? fetchFullPendingOrder(int orderId) async {
    return null;
  }

  Future<List<OrderHeader>?>? loadOrders(int tableId) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/Order/Table_Open_Orders/" + tableId.toString()), headers: this.headers).timeout(Duration(seconds: 10)).catchError((error) {
        print("error" + error);
      });

      if (response == null) {
        if (connection != null) connection!(false);
        return null;
      }

      if (response.statusCode == 200) {
        if (response.body == "") {
          return null;
        }
        List<OrderHeader> list = List<OrderHeader>.empty(growable: true);
        for (var item in json.decode(response.body)) {
          list.add(OrderHeader.fromJson(item));
        }
        return list;
        // If server returns an OK response, parse the JSON.
      } else {
        print("error");
        // If that response was not OK, throw an error.
        // throw Exception('Failed to load post');
        return null;
      }
    } on SocketException {
      return null;
    }
  }

  @override
  Future<Customer?>? loadCustomer(String phone) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/Customer/getByPhone/" + phone.toString()), headers: this.headers).timeout(Duration(seconds: 10)).catchError((error) {
        print(error);
      });

      if (response == null) {
        if (connection != null) connection!(false);
        return null;
      }

      if (response.statusCode == 200) {
        if (response.body == "") {
          List<CustomerContact> contacts = List<CustomerContact>.empty(growable: true);
          contacts.add(CustomerContact(type: 1, contact: phone));
          return Customer(contacts: contacts, addresses: [], id_number: 0, name: '');
        }
        return Customer.fromJson(json.decode(response.body));

        // If server returns an OK response, parse the JSON.
      } else {
        print("error");
        // If that response was not OK, throw an error.
        // throw Exception('Failed to load post');
        return null;
      }
    } on SocketException {
      return null;
    }
  }

  @override
  Future<Customer?>? saveCustomer(Customer customer) async {
    final response = await http.post(Uri.parse("$baseUrl/Customer/Save"), body: jsonEncode(customer.toJson()), headers: this.headers).timeout(Duration(seconds: 10)).catchError((error) {
      print(error);
    });

    if (response == null) {
      return null;
    }

    if (response.statusCode == 200) {
      if (response.body == "") {
        return null;
      }
      return Customer.fromJson(json.decode(response.body));

      // If server returns an OK response, parse the JSON.
    } else {
      // If that response was not OK, throw an error.
      // throw Exception('Failed to load post');
      return null;
    }
  }

  List<OrderHeader> queues = new List<OrderHeader>.empty(growable: true);
  Timer? queueTimer;
  Void2IntFunc? queueNumber;

  @override
  Future<OrderHeader?>? saveOrder(OrderHeader order) async {
    // savePendingOrder
    //
    // UniqueNumber  AE
    //

    var x = order.toJson();
    print(x.toString());
    final response = await http.post(Uri.parse("$baseUrl/Order/Save"), body: jsonEncode(order.toJson()), headers: this.headers).timeout(Duration(seconds: 800)).catchError((error) {
      print(error);
    });
    if (response != null && response.statusCode == 200) {
      if (response.body == "") {
        queues.add(order);
        startQueue();
        return null;
      }
      return OrderHeader.fromJson(json.decode(response.body));

      // If server returns an OK response, parse the JSON.
    } else {
      print("error");
      queues.add(order);
      startQueue();
      // If that response was not OK, throw an error.
      // throw Exception('Failed to load post');
      return null;
    }
  }

  @override
  Future<List<OrderHeader>?>? saveOrders(List<OrderHeader> orders) async {
    try {
      List jsonList = List.empty(growable: true);
      orders.map((item) => jsonList.add(item.toJson())).toList();
      String x = jsonEncode(jsonList);
      print(x);
      final response = await http.post(Uri.parse("$baseUrl/Order/SaveOrders"), body: x, headers: this.headers).timeout(Duration(seconds: 8));
      if (response != null && response.statusCode == 200) {
        if (response.body == "") {
          queues.addAll(orders);
          startQueue();
          return null;
        }

        List<OrderHeader> _orders = List<OrderHeader>.empty(growable: true);
        for (var json in json.decode(response.body)) {
          _orders.add(OrderHeader.fromJson(json));
        }
        return _orders;

        // If server returns an OK response, parse the JSON.
      } else {
        print("error");
        queues.addAll(orders);
        startQueue();
        // If that response was not OK, throw an error.
        // throw Exception('Failed to load post');
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void startQueue() {
    if (queueNumber != null) queueNumber!(queues.length);
    if (queueTimer == null || !queueTimer!.isActive) queueTimer = new Timer.periodic(const Duration(seconds: 10), saveQueueOrders);
  }

  void saveQueueOrders(Timer timer) async {
    queueTimer?.cancel();

    List jsonList = List.empty(growable: true);
    if (queues.length == 0) return;
    queues.map((item) => jsonList.add(item.toJson())).toList();

    final response = await http.post(Uri.parse("$baseUrl/Order/SaveOrders"), body: jsonEncode(jsonList), headers: this.headers).timeout(Duration(seconds: 8)).catchError((error) {
      print(error);
    });

    if (response != null && response.statusCode == 200) {
      if (response.body == "") {
        return null;
      }

      List<OrderHeader> _orders = List<OrderHeader>.empty(growable: true);
      for (var json in json.decode(response.body)) {
        _orders.add(OrderHeader.fromJson(json));
      }

      OrderHeader? temp;
      for (var item in _orders) {
        temp = queues.firstWhereOrNull((f) => f.GUID == item.GUID);
        if (temp != null) queues.remove(temp);
      }

      // If server returns an OK response, parse the JSON.
    } else {
      print("error");
    }

    if (queues.length > 0) {
      if (queueTimer == null || !queueTimer!.isActive) {
        queueTimer = new Timer.periodic(const Duration(seconds: 10), saveQueueOrders);
      }
    }
    if (queueNumber != null) queueNumber!(queues.length);
  }

  @override
  Future<bool> printOrder(OrderHeader order) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/Print/PrintOrder/" + order.id.toString() + "/1"), headers: this.headers).timeout(Duration(seconds: 10)).catchError((error) {
        print(error);
      });

      if (response == null) {
        return false;
      }

      if (response.statusCode == 200) {
        if (response.body == "") {
          return false;
        }

        if (response.body == "false")
          return false;
        else
          return true;

        // If server returns an OK response, parse the JSON.
      } else {
        print("error");
        // If that response was not OK, throw an error.
        // throw Exception('Failed to load post');
        return false;
      }
    } on SocketException {
      return false;
    }
  }

  @override
  Future<bool>? discountOrder(OrderHeader order, Discount? discount, int employeeId) async {
    var json = <String, dynamic>{
      "orderId": order.id,
      "discount_id": (discount != null) ? discount.id : 0,
      "discount_amount": (discount != null) ? discount.amount : 0,
      "discount_percentage": (discount != null) ? (discount.is_percentage == null ? false : discount.is_percentage) : false,
      "grand_price": order.grand_price,
      "sub_total_price": order.sub_total_price,
      "discount_actual_amount": order.discount_actual_amount,
      "surcharge_actual_amount": order.surcharge_actual_amount,
      "Rounding": order.Rounding,
      "total_tax": order.total_tax,
      "total_tax2": order.total_tax2,
      "total_tax3": order.total_tax3,
      "employee_id": employeeId
    };

    final response = await http.post(Uri.parse("$baseUrl/Order/DirectDiscount"), body: jsonEncode(json), headers: this.headers).timeout(Duration(seconds: 10)).catchError((error) {
      print(error);
    });

    if (response == null) {
      return false;
    }
    if (response.statusCode == 200) {
      if (response.body == "") {
        return false;
      }

      if (response.body == "false")
        return false;
      else
        return true;

      // If server returns an OK response, parse the JSON.
    } else {
      print("error");
      // If that response was not OK, throw an error.
      // throw Exception('Failed to load post');
      return false;
    }
  }

  @override
  Future<bool> surchargeOrder(OrderHeader order, Surcharge surcharge) async {
    var json = <String, dynamic>{
      "orderId": order.id,
      "surcharge_id": (surcharge != null) ? surcharge.id : 0,
      "surcharge_amount": (surcharge != null) ? surcharge.amount : 0,
      "surcharge_percentage": (surcharge != null) ? (surcharge.is_percentage == null ? false : surcharge.is_percentage) : false,
      "grand_price": order.grand_price,
      "surcharge_apply_tax1": (surcharge != null) ? surcharge.apply_tax1 : false,
      "surcharge_apply_tax2": (surcharge != null) ? surcharge.apply_tax2 : false,
      "surcharge_apply_tax3": (surcharge != null) ? surcharge.apply_tax3 : false,
      "sub_total_price": order.sub_total_price,
      "surcharge_actual_amount": order.surcharge_actual_amount,
      "Rounding": order.Rounding,
      "total_tax": order.total_tax,
      "total_tax2": order.total_tax2,
      "total_tax3": order.total_tax3,
    };

    final response = await http.post(Uri.parse("$baseUrl/Order/DirectSurcharge"), body: jsonEncode(json), headers: this.headers).timeout(Duration(seconds: 10)).catchError((error) {
      print(error);
    });

    if (response == null) {
      return false;
    }
    if (response.statusCode == 200) {
      if (response.body == "") {
        return false;
      }

      if (response.body == "false")
        return false;
      else
        return true;

      // If server returns an OK response, parse the JSON.
    } else {
      print("error");
      // If that response was not OK, throw an error.
      // throw Exception('Failed to load post');
      return false;
    }
  }

  @override
  Future<bool> followUp(OrderHeader order) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/Print/followUp/" + order.id.toString()), headers: this.headers).timeout(Duration(seconds: 5)).catchError((error) {
        print(error);
      });

      if (response == null) {
        return false;
      }
      if (response.statusCode == 200) {
        if (response.body == "") {
          return false;
        }

        if (response.body == "false")
          return false;
        else
          return true;

        // If server returns an OK response, parse the JSON.
      } else {
        print("error");
        // If that response was not OK, throw an error.
        // throw Exception('Failed to load post');
        return false;
      }
    } on SocketException {
      return false;
    }
  }

  @override
  Future<bool> voidOrder(OrderHeader order, int employeeId, String reason, bool waste) async {
    var json = <String, dynamic>{
      "order_id": order.id,
      "status": order.status,
      "employee_id": employeeId,
      "reason": reason,
      "grand_price": order.grand_price,
      "waste": waste,
    };

    try {
      final response = await http.post(Uri.parse("$baseUrl/Order/VoidOrder"), body: jsonEncode(json), headers: this.headers).timeout(Duration(seconds: 10)).catchError((error) {
        print(error);
      });

      if (response == null) {
        return false;
      }
      if (response.statusCode == 200) {
        if (response.body == "") {
          return false;
        }

        if (response.body == "false")
          return false;
        else
          return true;

        // If server returns an OK response, parse the JSON.
      } else {
        print("error");
        // If that response was not OK, throw an error.
        // throw Exception('Failed to load post');
        return false;
      }
    } on SocketException {
      return false;
    }
  }

  @override
  Future<Terminal?>? saveTerminal(Terminal terminal) async {
    try {
      final response = await http.post(Uri.parse("$baseUrl/Terminal/Save"), body: jsonEncode(terminal.toJson()), headers: this.headers).timeout(Duration(seconds: 10)).catchError((error) {
        print(error);
      });

      if (response == null) {
        return null;
      }
      if (response.statusCode == 200) {
        if (response.body == "") {
          return null;
        }

        this.terminal = Terminal.fromJson(json.decode(response.body));
        return this.terminal;
      } else {
        print("error");
        return null;
      }
    } on SocketException {
      return null;
    }
  }

  @override
  // TODO: implement repoName
  String get repoName => "INVO Connection";

  @override
  dailyBackupDB() {
    // TODO: implement dailyBackupDB
    throw UnimplementedError();
  }
}
