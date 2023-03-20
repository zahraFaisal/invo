import 'package:invo_mobile/models/employee.dart';
import 'package:invo_mobile/models/price_label.dart';
import 'package:invo_mobile/models/menu_type.dart';
import 'package:invo_mobile/models/menu_item_group.dart';
import 'package:invo_mobile/models/menu_group.dart';
import 'package:invo_mobile/models/menu_modifier.dart';
import 'package:invo_mobile/models/menu_category.dart';
import 'package:invo_mobile/models/menu_item.dart';
import 'package:invo_mobile/models/surcharge.dart';
import 'package:invo_mobile/models/discount.dart';
import 'package:invo_mobile/models/payment_method.dart';
import 'package:invo_mobile/models/price_managment.dart';
import 'package:invo_mobile/models/dineIn_group.dart';
import 'package:invo_mobile/models/customer/customer.dart';

import '../role.dart';

class ExportDatabase {
  List<PriceLabel>? priceLabels;
  List<MenuType>? menuTypes;
  List<MenuItemGroup>? menuItemGroups;
  List<MenuGroup>? menuGroups;
  List<MenuModifier>? menuModifiers;
  List<MenuCategory>? menuCategories;
  List<MenuItem>? menuItems;
  List<DineInGroup>? dineInSections;
  List<Customer>? customers;
  List<Surcharge>? surcharges;
  List<Discount>? discounts;
  List<PaymentMethod>? paymentMethods;
  List<PriceManagement>? priceManagements;
  List<Employee>? employees;
  List<Role>? roles;

  ExportDatabase(
      {this.customers,
      this.discounts,
      this.menuCategories,
      this.menuGroups,
      this.menuItemGroups,
      this.menuItems,
      this.menuModifiers,
      this.menuTypes,
      this.paymentMethods,
      this.priceLabels,
      this.priceManagements,
      this.dineInSections,
      this.surcharges});

  ExportDatabase.fromMap(Map<String, dynamic> map) {
    List<PriceLabel> _priceLabels = List<PriceLabel>.empty(growable: true);
    if (map['Price_Labels'] != null) {
      for (var item in map['Price_Labels']) {
        _priceLabels.add(PriceLabel.fromMap(item));
      }
    }

    List<MenuType> _menuTypes = List<MenuType>.empty(growable: true);
    if (map['MenuTypes'] != null) {
      for (var item in map['MenuTypes']) {
        _menuTypes.add(MenuType.fromMap(item));
      }
    }

    List<MenuItemGroup> _menuItemGroups = List<MenuItemGroup>.empty(growable: true);
    if (map['MenuItemGroups'] != null) {
      for (var item in map['MenuItemGroups']) {
        _menuItemGroups.add(MenuItemGroup.fromJson(item));
      }
    }

    List<MenuGroup> _menuGroups = List<MenuGroup>.empty(growable: true);
    if (map['MenuGroups'] != null) {
      for (var item in map['MenuGroups']) {
        _menuGroups.add(MenuGroup.fromMap(item));
      }
    }

    List<MenuModifier> _menuModifiers = List<MenuModifier>.empty(growable: true);
    if (map['MenuModifiers'] != null) {
      for (var item in map['MenuModifiers']) {
        _menuModifiers.add(MenuModifier.fromMap(item));
      }
    }

    List<MenuCategory> _menuCategories = List<MenuCategory>.empty(growable: true);
    if (map['MenuCategories'] != null) {
      for (var item in map['MenuCategories']) {
        _menuCategories.add(MenuCategory.fromMap(item));
      }
    }

    List<MenuItem> _menuItems = List<MenuItem>.empty(growable: true);
    if (map['MenuItems'] != null) {
      for (var item in map['MenuItems']) {
        _menuItems.add(MenuItem.fromMap(item));
      }
    }

    List<DineInGroup> _dineInSections = List<DineInGroup>.empty(growable: true);
    if (map['DineInSections'] != null) {
      for (var item in map['DineInSections']) {
        _dineInSections.add(DineInGroup.fromJson(item));
      }
    }

    List<Customer> _customers = List<Customer>.empty(growable: true);
    if (map['Customers'] != null) {
      for (var item in map['Customers']) {
        _customers.add(Customer.fromMap(item));
      }
    }

    List<Surcharge> _surcharges = List<Surcharge>.empty(growable: true);
    if (map['Surcharges'] != null) {
      for (var item in map['Surcharges']) {
        _surcharges.add(Surcharge.fromMap(item));
      }
    }

    List<Discount> _discounts = List<Discount>.empty(growable: true);
    if (map['Discounts'] != null) {
      for (var item in map['Discounts']) {
        _discounts.add(Discount.fromJson(item));
      }
    }

    List<PaymentMethod> _paymentMethods = List<PaymentMethod>.empty(growable: true);
    if (map['PaymentMethods'] != null) {
      for (var item in map['PaymentMethods']) {
        _paymentMethods.add(PaymentMethod.fromMap(item));
      }
    }

    List<PriceManagement> _priceManagements = List<PriceManagement>.empty(growable: true);
    if (map['PriceManagments'] != null) {
      for (var item in map['PriceManagments']) {
        _priceManagements.add(PriceManagement.fromMap(item));
      }
    }

    List<Employee> _employees = List<Employee>.empty(growable: true);
    if (map['Employees'] != null) {
      for (var item in map['Employees']) {
        _employees.add(Employee.fromMap(item));
      }
    }

    List<Role> _roles = List<Role>.empty(growable: true);
    if (map['Roles'] != null) {
      for (var item in map['Roles']) {
        _roles.add(Role.fromJson(item));
      }
    }

    priceLabels = _priceLabels;
    menuTypes = _menuTypes;
    menuItemGroups = _menuItemGroups;
    menuGroups = _menuGroups;
    menuModifiers = _menuModifiers;
    menuCategories = _menuCategories;
    menuItems = _menuItems;
    dineInSections = _dineInSections;
    customers = _customers;
    surcharges = _surcharges;
    paymentMethods = _paymentMethods;
    priceManagements = _priceManagements;
    discounts = _discounts;
    employees = _employees;
    roles = _roles;
  }

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>>? _priceLabels = this.priceLabels != null ? this.priceLabels!.map((i) => i.toMapRequest()).toList() : null;
    List<Map<String, dynamic>>? _menuTypes = this.menuTypes != null ? this.menuTypes!.map((i) => i.toMap()).toList() : null;
    List<Map<String, dynamic>>? _menuItemGroups = this.menuTypes != null ? this.menuItemGroups!.map((i) => i.toMap()).toList() : null;
    List<Map<String, dynamic>>? _menuGroups = this.menuGroups != null ? this.menuGroups!.map((i) => i.toMap()).toList() : null;
    List<Map<String, dynamic>>? _menuModifiers = this.menuModifiers != null ? this.menuModifiers!.map((i) => i.toMap()).toList() : null;
    List<Map<String, dynamic>>? _menuCategories = this.menuCategories != null ? this.menuCategories!.map((i) => i.toMap()).toList() : null;
    List<Map<String, dynamic>>? _menuItems = this.menuItems != null ? this.menuItems!.map((i) => i.toMap()).toList() : null;
    List<Map<String, dynamic>>? _dineInSections = this.dineInSections != null ? this.dineInSections!.map((i) => i.toMap()).toList() : null;
    List<Map<String, dynamic>>? _customers = this.customers != null ? this.customers!.map((i) => i.toMap()).toList() : null;
    List<Map<String, dynamic>>? _surcharges = this.surcharges != null ? this.surcharges!.map((i) => i.toMap()).toList() : null;
    List<Map<String, dynamic>>? _discounts = this.discounts != null ? this.discounts!.map((i) => i.toMap()).toList() : null;
    List<Map<String, dynamic>>? _paymentMethods = this.paymentMethods != null ? this.paymentMethods!.map((i) => i.toMap()).toList() : null;
    List<Map<String, dynamic>>? _priceManagements = this.priceManagements != null ? this.priceManagements!.map((i) => i.toMap()).toList() : null;
    List<Map<String, dynamic>>? _employees = this.employees != null ? this.employees!.map((i) => i.toMap()).toList() : null;
    List<Map<String, dynamic>>? _roles = this.roles != null ? this.roles!.map((i) => i.toMap()).toList() : null;

    var map = <String, dynamic>{
      "priceLabels": _priceLabels,
      "menuItemGroups": _menuItemGroups,
      "menuGroups": _menuGroups,
      "menuModifiers": _menuModifiers,
      "menuCategories": _menuCategories,
      "menuItems": _menuItems,
      "dineInSections": _dineInSections,
      "customers": _customers,
      "surcharges": _surcharges,
      "discounts": _discounts,
      "paymentMethods": _paymentMethods,
      "priceManagements": priceManagements,
      "employees": _employees,
      "roles": _roles
    };
    return map;
  }
}
