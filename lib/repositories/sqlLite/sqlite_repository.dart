import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:device_info/device_info.dart';
import 'package:invo_mobile/main.dart';
import 'package:invo_mobile/models/Number.dart';
import 'package:invo_mobile/models/Service.dart';
import 'package:invo_mobile/models/cashier.dart';
import 'package:invo_mobile/models/custom/database_list.dart';
import 'package:invo_mobile/models/custom/mini_order.dart';
import 'package:invo_mobile/models/customer/customer.dart';
import 'package:invo_mobile/models/dineIn_group.dart';
import 'package:invo_mobile/models/discount.dart';
import 'package:invo_mobile/models/employee.dart';
import 'package:invo_mobile/models/global.dart';
import 'package:invo_mobile/models/menu_group.dart';
import 'package:invo_mobile/models/menu_item.dart';
import 'package:invo_mobile/models/menu_item_group.dart';
import 'package:invo_mobile/models/menu_modifier.dart';
import 'package:invo_mobile/models/menu_type.dart';
import 'package:invo_mobile/models/order/order_header.dart';
import 'package:invo_mobile/models/payment_method.dart';
import 'package:invo_mobile/models/preference.dart';
import 'package:invo_mobile/models/price_managment.dart';
import 'package:invo_mobile/models/role.dart';
import 'package:invo_mobile/models/surcharge.dart';
import 'package:invo_mobile/models/terminal.dart';
import 'package:invo_mobile/models/wizard.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/repositories/interface/Cashier/ICashierService.dart';
import 'package:invo_mobile/repositories/interface/Customer/ICustomerService.dart';
import 'package:invo_mobile/repositories/interface/Employee/IEmployeeService.dart';
import 'package:invo_mobile/repositories/interface/Employee/IRoleServices.dart';
import 'package:invo_mobile/repositories/interface/Menu/IDiscountService.dart';
import 'package:invo_mobile/repositories/interface/Menu/IMenuCategoryService.dart';
import 'package:invo_mobile/repositories/interface/Menu/IMenuGroupService.dart';
import 'package:invo_mobile/repositories/interface/Menu/IMenuItemService.dart';
import 'package:invo_mobile/repositories/interface/Menu/IMenuModifier.dart';
import 'package:invo_mobile/repositories/interface/Menu/IMenuTypeService.dart';

import 'package:invo_mobile/repositories/interface/Menu/IPriceService.dart';

import 'package:invo_mobile/repositories/interface/Menu/ISurchargeService.dart';
import 'package:invo_mobile/repositories/interface/Order/IOrderService.dart';
import 'package:invo_mobile/repositories/interface/Report/IReportService.dart';
import 'package:invo_mobile/repositories/interface/Settings/IDineInService.dart';
import 'package:invo_mobile/repositories/interface/Settings/IPaymentMethosService.dart';
import 'package:invo_mobile/repositories/interface/Settings/IPreferenceService.dart';
import 'package:invo_mobile/repositories/interface/Settings/IPriceManagment.dart';
import 'package:invo_mobile/repositories/interface/Settings/ITerminalService.dart';
import 'package:invo_mobile/repositories/interface/Settings/ITypeService.dart';
import 'package:invo_mobile/repositories/sqlLite/Cashier/CashierService.dart';
import 'package:invo_mobile/repositories/sqlLite/Customer/CustomerService.dart';
import 'package:invo_mobile/repositories/sqlLite/Employee/EmployeeServices.dart';
import 'package:invo_mobile/repositories/sqlLite/Employee/RoleServices.dart';
import 'package:invo_mobile/repositories/sqlLite/Menu/DiscountServices.dart';
import 'package:invo_mobile/repositories/sqlLite/Menu/MenuGroupService.dart';
import 'package:invo_mobile/repositories/sqlLite/Menu/MenuModifiersServices.dart';
import 'package:invo_mobile/repositories/sqlLite/Menu/MenuTypeService.dart';

import 'package:invo_mobile/repositories/sqlLite/Menu/SurchargeServices.dart';
import 'package:invo_mobile/repositories/sqlLite/Menu/menuCategoryService.dart';
import 'package:invo_mobile/repositories/sqlLite/Menu/menuItemServices.dart';
import 'package:invo_mobile/repositories/sqlLite/Order/OrderService.dart';
import 'package:invo_mobile/repositories/sqlLite/Report/ReportService.dart';
import 'package:invo_mobile/repositories/sqlLite/Settings/PreferenceService.dart';
import 'package:invo_mobile/repositories/sqlLite/Settings/PriceManagmentServices.dart';
import 'package:invo_mobile/repositories/sqlLite/Settings/TerminalService.dart';
import 'package:invo_mobile/repositories/sqlLite/Settings/dineInServices.dart';
import 'package:invo_mobile/repositories/sqlLite/Settings/paymentMethodServices.dart';
import 'package:invo_mobile/repositories/sqlLite/Settings/typeServices.dart';
import 'package:invo_mobile/services/GoogleDrive/googleDrive.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

import '../../service_locator.dart';
import 'Menu/PriceServices.dart';

class SqliteRepository implements ConnectionRepository {
  @override
  IDiscountService? discountService = DiscountService();
  @override
  IEmployeeService? employeeService = EmployeeService();
  @override
  IMenuCategoryService? menuCategoryService = MenuCategoryService();
  @override
  IMenuItemService? menuItemService = MenuItemService();
  @override
  IMenuModifierService? menuModifierService = MenuModifiersService();
  @override
  IPriceService? priceService = PriceService();
  @override
  IPaymentMethodService? paymentMethodService = PaymentMethodService();
  @override
  IPriceManagmentService? priceManagmentService = PriceManagmentService();
  @override
  IRoleService? roleService = RoleService();
  @override
  ISurchargeService? surchargeService = SurchargeService();
  @override
  IMenuGroupService? menuGroupService = MenuGroupService();
  @override
  IMenuTypeService? menuTypeService = MenuTypeService();
  @override
  IPreferenceService? preferenceService = PreferenceService();
  @override
  IOrderService? orderService = OrderService();
  @override
  ITerminalService? terminalService = TerminalService();
  @override
  IDineInService? dineInService = DineInService();
  @override
  ITypeService? typeService = TypeServices();
  @override
  ICashierService? cashierService = CashierService();
  @override
  IReportService? reportService = ReportService();
  @override
  ICustomerService? customerService = CustomerService();
  @override
  late PaymentMethod? cash;
  @override
  late var connection;
  @override
  late List<DineInGroup>? dineInGroups;
  @override
  late List<Discount>? discounts;
  @override
  late List<Employee>? employees;
  @override
  late String? httpRequestError;
  @override
  late String? ip;
  @override
  late List<MenuGroup>? menuGroups;
  @override
  late List<MenuItemGroup>? menuItemGroups;
  @override
  late List<MenuItem>? menuItems;
  @override
  late List<MenuModifier>? menuModifiers;
  @override
  late List<MenuType>? menuTypes;
  @override
  late Preference? preference = Preference();
  @override
  late List<PriceManagement>? priceManagements;
  @override
  var progress = (x) {};
  @override
  var queueNumber = (x) {};
  @override
  late List<Service>? services;
  @override
  late List<Surcharge>? surcharges;
  @override
  late Terminal? terminal;

  SqliteRepository() {
    discountService = DiscountService();
    employeeService = EmployeeService();
    menuCategoryService = MenuCategoryService();
    menuItemService = MenuItemService();
    menuModifierService = MenuModifiersService();
    priceService = PriceService();
    paymentMethodService = PaymentMethodService();
    priceManagmentService = PriceManagmentService();
    roleService = RoleService();
    surchargeService = SurchargeService();
    menuTypeService = MenuTypeService();
    menuGroupService = MenuGroupService();
    preferenceService = PreferenceService();
    orderService = OrderService();
    terminalService = TerminalService();
    dineInService = DineInService();
    typeService = TypeServices();
    cashierService = CashierService();
    reportService = ReportService();
    customerService = CustomerService();
  }

  late String deviceId;
  getDeviceInfo() async {
    var deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceId = androidInfo.androidId;
  }

  @override
  Future<bool> connect({String? ip}) async {
    try {
      var db = await initDatabase();

      if (db.isOpen) {
        //await resetData();
        await loadData();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> loadData() async {
    getDeviceInfo();

    Database? dastbase = await db;
    cash = PaymentMethod.fromMap((await dastbase!.rawQuery('SELECT *from payment_methods ')).first);

    List<Map<String, dynamic>> temp = await dastbase.rawQuery("SELECT * from employees");
    employees = [];
    for (var item in temp) {
      employees!.add(Employee.fromMap(item));
    }

    temp = await dastbase.rawQuery("SELECT * from roles");
    List<Role> roles = List.generate(temp.length, (i) {
      return Role.fromMap(temp[i]);
    });

    for (var item in employees!) {
      try {
        item.job_title = roles.firstWhere((f) => f.id_number == item.job_title_id_number);
      } catch (e) {
        item.job_title = null;
      }
    }

    temp = await dastbase.rawQuery("SELECT * from services");
    services = [];
    for (var item in temp) {
      services?.add(Service.fromMap(item));
    }
    print("hiiii");
    print(await dastbase.rawQuery("SELECT * from preferences where id = 1"));
    if ((await dastbase.rawQuery("SELECT * from preferences where id = 1")).isNotEmpty)
      preference = Preference.fromMap((await dastbase.rawQuery("SELECT * from preferences where id = 1")).first);

    menuTypes = await menuTypeService!.getActiveList();
    menuGroups = await menuGroupService!.getActive();
    menuItemGroups = await menuItemService!.getMenuItemGroupAll();
    menuItems = await menuItemService!.getAll();
    menuModifiers = await menuModifierService!.getAll();
    discounts = await discountService!.getAll();
    surcharges = await surchargeService!.getAll();
    priceManagements = await priceManagmentService!.getAll();
    dineInGroups = await dineInService!.getAll();
    setMenuItemGroup();

    terminal = await getTerminal();
    Cashier? cashier = await cashierService!.getTerminalCashier(terminal!.id);
    if (cashier != null) {
      locator.get<Global>().setCashier(cashier);
    }
    Number.symbol = (cash!.symbol == null) ? "\$" : cash!.symbol;
    Number.afterDecimal = (cash!.after_decimal == null) ? 2 : cash!.after_decimal;
    return true;
  }

  final drive = GoogleDrive();
  localBackupDB() async {
    var databasesFolderPath = await getDatabasesPath();

    var dbPath = join(databasesFolderPath, 'invopos_database_backup.db');
    try {
      // delete existing if any
      if (await new File(dbPath).exists()) {
        await deleteDatabase(dbPath);
      }

      // Copy
      await new File(join(databasesFolderPath, "invopos_database.db")).copy(dbPath);

      //await drive.clearCredentials();
      // await drive.upload(new File(dbPath));
    } catch (e) {
      print(e);
    }
  }

  Future<bool> dailyBackupDB() async {
    return false;
    // return await drive.dailyBackupUpdate();
  }

  Future<List<DatabaseList>> listDB() async {
    return [];
    // return await drive.listAllDB();
  }

  Future<bool> restoreDB(DatabaseList selectedDB) async {
    return false;
    // try {
    //   var databasesFolderPath = await getDatabasesPath();
    //   await drive.download(selectedDB.name, selectedDB.id, databasesFolderPath);
    //   var dbPath = join(databasesFolderPath, 'invopos_database.db');
    //   File backupFile = new File(join(databasesFolderPath, selectedDB.name));

    //   // delete existing if any
    //   if (await backupFile.exists()) {
    //     File newRestore = await backupFile.copy(dbPath);
    //     // await initDatabase();
    //     // if (database.isOpen) {
    //     //   await loadData();
    //     // }
    //     return true;
    //   } else {
    //     return false;
    //   }
    // } catch (e) {
    //   return false;
    // }
  }

  late Wizard initData;
  Future<bool> initDatabaseWithData(Wizard wizard) async {
    initData = wizard;
    return await connect(ip: "");
  }

  Future<Terminal> getTerminal() async {
    Database? dastbase = await db;
    var list = (await dastbase!.query("Terminals", where: "computer_name = ?", whereArgs: [deviceId]));
    if (list.length > 0) {
      return Terminal.fromMap(list.first);
    } else {
      Terminal terminal = Terminal(computer_name: deviceId, langauge: 'en', id: 0);
      terminal.id = await dastbase.insert("Terminals", terminal.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      return terminal;
    }
  }

  static Database? _db;
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    print("init database");
    var databasesPath = await getDatabasesPath();
    // deleteDatabase(join(databasesPath, 'invopos_database.db'));

    var db = openDatabase(
      join(databasesPath, 'invopos_database.db'),

      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onOpen: (Database db) {
        print(db.isOpen ? "Database opened" : "database not opened");
      },

      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 15,
    );

    return db;
  }

  Future<bool> deleteDatabse() async {
    var databasesPath = await getDatabasesPath();
    deleteDatabase(join(databasesPath, 'invopos_database.db'));

    return true;
  }

  @override
  Future<bool> checkDatabaseIfExist() async {
    var databasesFolderPath = await getDatabasesPath();

    var dbPath = join(databasesFolderPath, 'invopos_database.db');
    //await deleteDatabase(dbPath);
    return databaseFactory.databaseExists(dbPath);
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print("upgraded version " + oldVersion.toString() + " to version " + newVersion.toString());
    if (oldVersion < 2) await db.execute('''CREATE TABLE Transaction_modifiers(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	  transaction_id INTEGER NULL,
	  modifier_id INTEGER NULL,
	  qty REAL NOT NULL,
	  price REAL NOT NULL,
	  note TEXT NULL,
	  is_forced NUMERIC NOT NULL,
    FOREIGN KEY(modifier_id)REFERENCES Menu_modifiers(id),
    FOREIGN KEY(transaction_id)REFERENCES Order_transactions(id)
    )''');

    if (oldVersion < 3) await db.execute('''ALTER TABLE Menu_popup_modifiers
        ADD COLUMN local NUMERIC NOT NULL default 0;''');

    if (oldVersion < 4) await db.execute('''ALTER TABLE preferences
       ADD COLUMN cloud_settings TEXT NULL;''');

    if (oldVersion < 5) {
      await db.execute('''ALTER TABLE preferences
       ADD COLUMN update_time NUMERIC NULL ''');
      await db.execute('''ALTER TABLE Menu_items
       ADD COLUMN update_time NUMERIC NULL  ''');
      await db.execute('''ALTER TABLE Menu_types
       ADD COLUMN update_time NUMERIC NULL  ''');
    }

    if (oldVersion < 6) {
      await db.execute('''ALTER TABLE Menu_popup_modifiers
        ADD COLUMN online NUMERIC NOT NULL default 0;''');
    }

    if (oldVersion < 7) {
      await db.execute('''CREATE TABLE Pending_orders(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        "order" TEXT NOT NULL,
        status INTEGER NOT NULL default 0,
        pending_date_time TEXT NULL,
        type INTEGER NOT NULL default 0,
        ticketNumber TEXT NOT NULL
        )''');

      await db.execute('''CREATE TABLE Pending_Status(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        type INTEGER NOT NULL,
        status TEXT NULL,
        is_sent INTEGER NOT NULL default 0,
        server_sent INTEGER NOT NULL default 0
        )''');
    }

    if (oldVersion < 8) {
      await db.execute('''ALTER TABLE order_payments
        ADD COLUMN onlineService TEXT NULL;''');
      await db.execute('''ALTER TABLE order_payments
        ADD COLUMN onlineData TEXT NULL;''');
    }

    if (oldVersion < 10) {
      await db.execute('''ALTER TABLE preferences
       ADD COLUMN purchaseOrders INTEGER NOT NULL default 0;''');
    }

    if (oldVersion < 12) {
      await db.execute('''ALTER TABLE payment_methods
       ADD COLUMN verification_required INTEGER NOT NULL default 0;''');

      await db.execute('''ALTER TABLE payment_methods
       ADD COLUMN verification_only_numerical INTEGER NOT NULL default 0;''');

      await db.execute('''ALTER TABLE preferences
       ADD COLUMN vat_registration_number TEXT NULL;''');

      await db.execute('''ALTER TABLE Menu_items
       ADD COLUMN secondary_name TEXT NULL  ''');

      await db.execute('''ALTER TABLE Menu_items
       ADD COLUMN secondary_description TEXT NULL  ''');

      await db.execute('''ALTER TABLE Menu_modifiers
       ADD COLUMN secondary_description TEXT NULL  ''');

      await db.execute('''ALTER TABLE Menu_modifiers
       ADD COLUMN secondary_display_name TEXT NULL  ''');
    }

    if (oldVersion < 13) {
      await db.execute('''ALTER TABLE Menu_popup_modifiers
       ADD COLUMN secondary_description TEXT NULL  ''');
    }

    if (oldVersion < 14) {
      await db.execute('''ALTER TABLE Customer_addresses
       ADD COLUMN flat TEXT NULL ''');

      await db.execute('''ALTER TABLE Customer_addresses
       ADD COLUMN building TEXT NULL ''');

      await db.execute('''ALTER TABLE Customer_addresses
       ADD COLUMN house TEXT NULL ''');

      await db.execute('''ALTER TABLE Customer_addresses
       ADD COLUMN road TEXT NULL ''');

      await db.execute('''ALTER TABLE Customer_addresses
       ADD COLUMN street TEXT NULL ''');

      await db.execute('''ALTER TABLE Customer_addresses
       ADD COLUMN block TEXT NULL ''');

      await db.execute('''ALTER TABLE Customer_addresses
       ADD COLUMN zipCode TEXT NULL ''');

      await db.execute('''ALTER TABLE Customer_addresses
       ADD COLUMN city TEXT NULL ''');

      await db.execute('''ALTER TABLE Customer_addresses
       ADD COLUMN state TEXT NULL ''');

      await db.execute('''ALTER TABLE Customer_addresses
       ADD COLUMN postalCode TEXT NULL ''');
    }

    if (oldVersion < 15) {
      await db.execute('''ALTER TABLE Customer_addresses
       ADD COLUMN additional_information TEXT NULL ''');
    }
  }

  _onCreate(Database db, int version) async {
    //pending orders
    await db.execute('''CREATE TABLE Pending_orders(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        "order" TEXT NOT NULL,
        status INTEGER NOT NULL default 0,
        type INTEGER NOT NULL default 0,
        pending_date_time TEXT NULL,
        ticketNumber TEXT NOT NULL
        )''');

    //pending status
    await db.execute('''CREATE TABLE Pending_Status(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        type INTEGER NOT NULL,
        status TEXT NULL,
        is_sent INTEGER NOT NULL default 0,
        server_sent INTEGER NOT NULL default 0
        )''');

    //Roles
    await db.execute('''CREATE TABLE Roles
        (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
         name TEXT NULL UNIQUE,
         security TEXT NULL,
         notifications TEXT NULL,
         ReportSettings TEXT NULL,
         in_active NUMERIC NOT NULL
        )''');
//EMPLOYEE
    await db.execute('''CREATE TABLE Employees 
        (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
        social_number TEXT NOT NULL,
        name TEXT NOT NULL,
        nick_name TEXT  NULL,
        password TEXT  NULL,
        msc_code TEXT  NULL,
        job_title_id_number INTEGER  NULL,
        gender TEXT  NULL,
        phone1 TEXT  NULL,
        phone2 TEXT  NULL,
        email TEXT  NULL,
        picture NUMERIC NULL,
        address1 TEXT  NULL,
        address2 TEXT  NULL,
        date_hierd NUMERIC NULL,
        date_released NUMERIC NULL,
        birth_date NUMERIC NULL,
        in_active NUMERIC NOT NULL,
        FOREIGN KEY (job_title_id_number) REFERENCES Roles (id)
        )''');
//terminals
    await db.execute('''CREATE TABLE terminals
        (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
         computer_name TEXT NOT NULL,
        language TEXT NULL,
        locked_menu_type_id INTEGER NULL,
        settings TEXT NULL,
        kitchen_printers TEXT NULL,
        alias TEXT NULL
        )''');
    //preferences
    await db.execute('''CREATE TABLE preferences
        (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
        resturant_name TEXT NULL,
        day_start NUMERIC NULL,
        logo NUMERIC NULL,
        time_to_sent_report NUMERIC NULL,
        Receipt_note TEXT NULL,
        tax1_name TEXT NULL,
        tax1 REAL  NULL,
        tax2_name TEXT NULL,
        tax2 REAL  NULL,
        tax2_tax1 NUMERIC NULL,
        tax3_name TEXT NULL,
        tax3 REAL  NULL,
        tax3_tax1 NUMERIC  NULL,
        tax3_tax2 NUMERIC  NULL,
        resturant_info TEXT NULL,
        front_office_setting TEXT NULL,
        mod_filter_setting TEXT NULL,
        currency_setting TEXT NULL,
        void_reasons TEXT NULL,
        address_format TEXT NULL,
        purchaseOrders INTEGER NOT NULL default 0,
        cloud_settings TEXT NULL,
        vat_registration_number TEXT NULL,
        update_time NUMERIC NULL
        )''');
    //cashier
    await db.execute('''CREATE TABLE Cashiers 
        (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
        employee_id INTEGER NOT NULL,
        terminal_id INTEGER NOT NULL,
        cashier_in NUMERIC NOT NULL,
        cashier_out NUMERIC NULL,
        start_amount REAL NOT NULL,
        end_amount REAL NOT NULL,
        variance_amount REAL NOT NULL,
        variance_reason TEXT NULL,
        approved_employee_id INTEGER NULL,
        FOREIGN KEY(approved_employee_id)REFERENCES Employees(id),
        FOREIGN KEY(employee_id)REFERENCES Employees(id),
        FOREIGN KEY(terminal_id)REFERENCES terminals(id)

        )''');
    //PAYMENT METHODS
    await db.execute('''CREATE TABLE payment_methods
        (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
         name TEXT NOT NULL UNIQUE,
         rate REAL NOT NULL,
         after_decimal INTEGER NOT NULL,
          type INTEGER NOT NULL,
          symbol TEXT NULL,
          image NUMERIC NULL,
          verification_required NUMERIC NOT NULL default 0,
          verification_only_numerical NUMERIC NOT NULL default 0,
          in_active NUMERIC NOT NULL
        )''');
    //cashier details
    await db.execute('''CREATE TABLE Cashier_details 
        (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
        cashier_id INTEGER NOT NULL,
        payment_method_id INTEGER NOT NULL,
        rate REAL NOT NULL,
        start_amount REAL NOT NULL,
        end_amount REAL NOT NULL,
        FOREIGN KEY(cashier_id)REFERENCES Cashiers(id),
        FOREIGN KEY(payment_method_id)REFERENCES payment_methods(id)
        )''');
    //price lables
    await db.execute('''CREATE TABLE price_labels
        (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
         name TEXT NULL UNIQUE,
         in_active NUMERIC NOT NULL
        )''');
//Customers
    await db.execute('''CREATE TABLE Customers
        (id_number INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
        saluation TEXT NULL,
        name TEXT NULL,
        MSC TEXT NULL,
        note TEXT NULL,
        birth_date NUMERIC NULL,
        picture NUMERIC NULL,
        since_date NUMERIC NULL,
        in_active NUMERIC NOT NULL,
        allow_credit NUMERIC NOT NULL,
        credit_limits REAL NOT NULL,
        discount REAL NOT NULL,
        price_id INTEGER NULL,
        FOREIGN KEY(price_id)REFERENCES price_labels(id)
        )''');
//customer addresses
    await db.execute('''CREATE TABLE Customer_addresses 
        (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
        address_line1 TEXT NULL,
        address_line2 TEXT NULL,
        flat TEXT NULL,
        additional_information TEXT NULL,
        building TEXT NULL,
        house TEXT NULL,
        road TEXT NULL,
        street TEXT NULL,
        block TEXT NULL,
        zipCode TEXT NULL,
        city TEXT NULL,
        state TEXT NULL,
        postalCode TEXT NULL,
        is_default NUMERIC NOT NULL,
        delivery_charge REAL NOT NULL,
        customer_id_number INTEGER NULL,
        FOREIGN KEY(customer_id_number)REFERENCES Customers(id_number)
        
        )''');
//customer contacts
    await db.execute('''CREATE TABLE Customer_contacts 
        (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
        contact TEXT NULL,
        custome_type TEXT NULL,
         type INTEGER  NOT NULL,
        customer_id_number INTEGER NULL,
        FOREIGN KEY(customer_id_number)REFERENCES Customers(id_number)
        )''');
//dine in table groups
    await db.execute('''CREATE TABLE DineIn_table_groups
        (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
        name TEXT NULL UNIQUE,
        price_id INTEGER NULL,
        in_active NUMERIC NOT NULL,
        position TEXT NULL,
         FOREIGN KEY(price_id)REFERENCES price_labels(id)
        )''');
//Surcharges
    await db.execute('''CREATE TABLE Surcharges
        (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
         name TEXT NULL UNIQUE,
         description TEXT NULL,
        in_active NUMERIC NOT NULL,
        amount REAL NOT NULL,
        is_percentage NUMERIC NOT NULL,
        apply_tax1 NUMERIC NOT NULL,
        apply_tax2 NUMERIC NOT NULL,
        apply_tax3 NUMERIC NOT NULL
        )''');
//dine in tables
    await db.execute('''CREATE TABLE DineIn_tables
        (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
        name TEXT NULL,
        position TEXT NULL,
        in_active NUMERIC NOT NULL,
        min_charge REAL NOT NULL,
        max_seat INTEGER NOT NULL,
        charge_per_hour REAL NULL,
        charge_after INTEGER NOT NULL,
        image_type INTEGER NOT NULL,
        table_group_id INTEGER NULL,
        surcharge_id INTEGER NULL,
         FOREIGN KEY(table_group_id)REFERENCES DineIn_table_groups(id),
          FOREIGN KEY(surcharge_id)REFERENCES  Surcharges(id)
                )''');
//DISCOUNTS
    await db.execute('''CREATE TABLE Discounts 
        (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
        name TEXT NULL UNIQUE,
        description TEXT NULL,
        start_date NUMERIC NULL,
        expire_date NUMERIC NULL,
        in_active NUMERIC NOT NULL,
        amount REAL NOT NULL,
        is_percentage NUMERIC NOT NULL,
        min_price REAL NOT NULL

        )''');
//Menu_items
    await db.execute('''CREATE TABLE Menu_items
        (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL , 
        name TEXT NOT NULL UNIQUE, 
        receipt_text TEXT NULL,
        kitchen_text TEXT NULL,
        menu_category_id INTEGER NULL,
        default_price REAL NOT NULL,
        description TEXT NULL,
        in_active NUMERIC NOT NULL,
        in_stock NUMERIC NOT NULL,
        count_down INTEGER NOT NULL,
        discountable NUMERIC NOT NULL,
        apply_tax1 NUMERIC NOT NULL,
        apply_tax2 NUMERIC NOT NULL,
        apply_tax3 NUMERIC NOT NULL,
        default_icon NUMERIC NULL,
        default_forecolor TEXT NULL,
        barcode TEXT NULL,
        icon TEXT NULL,
        order_By_Weight NUMERIC NOT NULL,
        weight_unit Text  NULL,
        open_price NUMERIC NOT NULL,
        type INTEGER NOT NULL,
        preperation_time INTEGER NOT NULL,
        additional_cost REAL NOT NULL,
        food_nutrition TEXT NULL,
        enable_count_down NUMERIC NOT NULL,
        seasonale_price NUMERIC NOT NULL,
        update_time NUMERIC NULL,
        secondary_name TEXT NULL,
        secondary_description TEXT NULL,
        FOREIGN KEY(menu_category_id)REFERENCES   Menu_categories(id)
        
        )''');

// discount_items
    await db.execute('''CREATE TABLE discount_items
        (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
        discount_id INTEGER NULL,
        menu_item_id INTEGER NULL,
         FOREIGN KEY(discount_id)REFERENCES  Discounts(id), 
         FOREIGN KEY(menu_item_id)REFERENCES Menu_items(id) 
                )''');
//discount roles
    await db.execute('''CREATE TABLE discount_roles
        (
           Discount_id INTEGER NOT NULL, 
           Role_id_number INTEGER NOT NULL,
           FOREIGN KEY(Discount_id)REFERENCES  Discounts(id),
           FOREIGN KEY( Role_id_number)REFERENCES  Roles(id)
                )''');
//MENU CATEGORIES
    await db.execute('''CREATE TABLE Menu_categories
        (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL , 
        name TEXT NULL UNIQUE,
        [index] INTEGER NOT NULL,
        in_active NUMERIC NOT NULL,
        department_id INTEGER 
        )''');
//Menu_combos
    await db.execute('''CREATE TABLE Menu_combos
        (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
        sub_menu_item_id INTEGER NULL,
        parent_menu_item_id INTEGER NULL,
        qty INTEGER NULL,
        FOREIGN KEY( parent_menu_item_id)REFERENCES  Menu_items(id),
        FOREIGN KEY(sub_menu_item_id)REFERENCES  Menu_items(id)
        )''');
// menu types
    await db.execute('''CREATE TABLE Menu_types
        (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
         name TEXT NULL UNIQUE,
         start_time NUMERIC NULL,
         in_active NUMERIC NOT NULL,
         price_id INTEGER NULL,
          update_time NUMERIC NULL,
          FOREIGN KEY(price_id)REFERENCES price_labels(id)
        )''');
//Menu_groups
    await db.execute('''CREATE TABLE Menu_groups
        (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
        name TEXT NULL UNIQUE,
        backcolor TEXT  NULL,
        [index] INTEGER  NOT NULL,
        menu_type_id INTEGER  NULL,
        in_active NUMERIC NOT NULL,
        update_time NUMERIC NULL,
         FOREIGN KEY(menu_type_id)REFERENCES  Menu_types(id)  
        )''');

//Menu_item_group
    await db.execute('''CREATE TABLE Menu_item_groups
        (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
        menu_item_id INTEGER NOT NULL,
        menu_group_id INTEGER  NOT NULL,
         [index] INTEGER  NOT NULL,
         double_height NEUMERIC NOT NULL,
         double_width NEUMERIC NOT NULL,
          update_time NUMERIC NULL,
          FOREIGN KEY( menu_group_id)REFERENCES  Menu_groups(id),
          FOREIGN KEY( menu_item_id )REFERENCES  Menu_items(id)
        )''');

//menu_modifiers
    await db.execute('''CREATE TABLE Menu_modifiers
        (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
        name TEXT NOT NULL UNIQUE,
        display_name TEXT NULL,
        description TEXT NULL,
        additional_price REAL NOT NULL,
        is_multiple NUMERIC NOT NULL,
        is_visible NUMERIC NOT NULL,
        in_active NUMERIC NOT NULL,
        food_nutrition TEXT NULL,
        receipt_text TEXT NULL,
        kitchen_text TEXT NULL, 
        update_time NUMERIC NULL,
        secondary_description TEXT NULL,
        secondary_display_name TEXT NULL
        )''');

//popup modifier
    await db.execute('''CREATE TABLE Menu_popup_modifiers
        (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
        menu_item_id INTEGER NULL,
        level INTEGER NOT NULL,
        is_forced NUMERIC NOT NULL,
        repeat INTEGER NOT NULL,
        description TEXT NULL,
        secondary_description TEXT NULL,
        local NUMERIC NOT NULL,
        online NUMERIC NOT NULL,
         FOREIGN KEY(menu_item_id)REFERENCES Menu_items(id)
        )''');

//menu prices
    await db.execute('''CREATE TABLE Menu_prices
        (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
        label_id INTEGER NOT NULL,
        menu_item_id INTEGER NULL,
        price REAL NOT NULL,
        FOREIGN KEY(menu_item_id) REFERENCES Menu_items(id),
        FOREIGN KEY(label_id) REFERENCES price_labels(id)
        )''');

//quick modifiers
    await db.execute('''CREATE TABLE Menu_quick_modifiers
        (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
        menu_item_id INTEGER NULL,
        modifier_id INTEGER NULL,
        FOREIGN KEY(menu_item_id)REFERENCES Menu_items(id),
        FOREIGN KEY( modifier_id)REFERENCES Menu_modifiers(id)
        )''');

//modifier prices
    await db.execute('''CREATE TABLE modifier_prices
        (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
        label_id INTEGER NULL,
        menu_modifier_id INTEGER NULL,
        price REAL NOT NULL,
        FOREIGN KEY(menu_modifier_id)REFERENCES Menu_modifiers(id),
         FOREIGN KEY(label_id)REFERENCES price_labels(id)
        )''');

//menu selections
    await db.execute('''CREATE TABLE Menu_selections
        (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
        menu_item_id INTEGER NOT NULL,
        level INTEGER NOT NULL,
        no_of_selection INTEGER NOT NULL,
        FOREIGN KEY(menu_item_id)REFERENCES Menu_items(id)
        )''');

//Services
    await db.execute('''CREATE TABLE Services
        (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
         name TEXT NULL UNIQUE,
         alternative TEXT NULL,
        in_active NUMERIC NULL,
        features TEXT NULL,
        price_id INTEGER NULL,
        surcharge_id INTEGER NULL,
          FOREIGN KEY(price_id)REFERENCES price_labels(id),
          FOREIGN KEY(surcharge_id)REFERENCES Surcharges(id)
        )''');

//Order_headers
    await db.execute('''CREATE TABLE order_headers
        (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
         ticket_number INTEGER NOT NULL,
         date_time NUMERIC NOT NULL,
        print_time NUMERIC  NULL,
        employee_id INTEGER NOT NULL,
        terminal_id INTEGER  NOT NULL,
        service_id INTEGER NOT NULL,
        dinein_table_id INTEGER NULL,
        customer_id_number INTEGER NULL,
        customer_contact TEXT NULL,
        customer_address TEXT NULL,
        driver_id INTEGER NULL,
        depature_time NUMERIC NULL,
        arrival_time NUMERIC NULL,
        status INTEGER NOT NULL,
        Label TEXT NULL,
        delivery_charge REAL NOT NULL,
        discount_id INTEGER NULL,
        discount_amount REAL NOT NULL,
        discount_percentage NUMERIC NOT NULL,
        surcharge_id INTEGER NULL,
        surcharge_amount REAL NOT NULL,
        surcharge_percentage NUMERIC NOT NULL,
        hold_time NUMERIC  NULL,
        smallest_currency REAL NOT NULL,
        Round_type INTEGER NOT NULL,
        grand_price REAL NOT NULL,
        no_of_guests INTEGER NULL,
        minimum_charge REAL NOT NULL,
        charge_per_hour REAL NOT NULL,
        charge_after INTGER NOT NULL,
        total_charge_per_hour REAL NOT NULL,
        update_time NUMERIC NULL,
        GUID TEXT NULL,
        total_tax REAL NOT NULL,
        note TEXT NULL,
        ready_at NUMERIC NULL,
        total_tax2 REAL NOT NULL,
        total_tax3 REAL NOT NULL,
        prepared_date NUMERIC NULL,
        tax1 REAL NOT NULL,
        tax2 REAL NOT NULL,
        tax3 REAL NOT NULL,
        tax2_tax1 NUMERIC NOT NULL,
        surcharge_apply_tax1 NUMERIC NOT NULL,
        surcharge_apply_tax2 NUMERIC NOT NULL,
        surcharge_apply_tax3 NUMERIC NOT NULL,
        taxable1_amount REAL NOT NULL,
        taxable2_amount REAL NOT NULL,
        taxable3_amount REAL NOT NULL,
        sub_total_price REAL NOT NULL,
        min_charge REAL NOT NULL,
        discount_actual_amount REAL NOT NULL,
        surcharge_actual_amount REAL NOT NULL,
        Rounding REAL NOT NULL,
        FOREIGN KEY(customer_id_number)REFERENCES Customers(id_number),
        FOREIGN KEY(dinein_table_id)REFERENCES DineIn_tables(id),
             FOREIGN KEY(discount_id)REFERENCES  Discounts(id),
             FOREIGN KEY(employee_id)REFERENCES  Employees(id),
             FOREIGN KEY(service_id)REFERENCES  Services(id),
              FOREIGN KEY(surcharge_id)REFERENCES Surcharges(id)

        )''');
//order payment
    await db.execute('''CREATE TABLE order_payments
        (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
         date_time NUMERIC NOT NULL,
         order_id INTEGER NULL,
         employee_id INTEGER NULL,
         cashier_id INTEGER NULL,
         amount_tendered REAL NOT NULL,
         amount_paid REAL NOT NULL,
         onlineData TEXT NULL,
         onlineService TEXT NULL,
         rate REAL NOT NULL,
         reference TEXT NULL,
         status INTEGER NOT NULL,
         credit_customer_id_number INTEGER NULL,
         payment_method_id INTEGER NULL,
         FOREIGN KEY(cashier_id)REFERENCES Cashiers(id),
         FOREIGN KEY(credit_customer_id_number)REFERENCES Customers(id_number),
         FOREIGN KEY(employee_id)REFERENCES  Employees(id),
         FOREIGN KEY(order_id)REFERENCES order_headers(id),
        FOREIGN KEY(payment_method_id)REFERENCES payment_methods(id)
        )''');
//order transaction
    await db.execute('''CREATE TABLE order_transactions
        (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
         date_time NUMERIC NOT NULL,
         print_time NUMERIC  NULL,
         order_id INTEGER NOT NULL,
         employee_id INTEGER NULL,
         menu_item_id INTEGER NULL,
         item_price REAL NOT NULL,
          qty REAL NOT NULL,
          discount_id INTEGER NULL,
          discount_amount REAL NOT NULL,
          discount_percentage NUMERIC NOT NULL,
         status INTEGER NOT NULL,
         seat_number INTEGER NOT NULL,
         is_printed NUMERIC NOT NULL,
         hold_time NUMERIC NULL,
        grand_price REAL NOT NULL,
        GUID TEXT NULL,
        tax1_amount REAL NOT NULL,
        tax2_amount REAL NOT NULL,
        tax3_amount REAL NOT NULL,
        cost REAL NOT NULL,
        discountable NUMERIC NOT NULL,
        apply_tax1 NUMERIC NOT NULL,
         apply_tax2 NUMERIC NOT NULL,
         apply_tax3 NUMERIC NOT NULL,
         prepared_date NUMERIC NULL,
         discount_actual_price REAL NOT NULL,
         default_price REAL NOT NULL,
         FOREIGN KEY(discount_id)REFERENCES  Discounts(id),
          FOREIGN KEY(employee_id)REFERENCES  Employees(id),
           FOREIGN KEY(menu_item_id)REFERENCES Menu_items(id),
           FOREIGN KEY(order_id)REFERENCES order_headers(id)

        )''');
//order voids
    await db.execute('''CREATE TABLE order_voids
        (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
         order_id INTEGER NULL,
         transacion_id INTEGER NULL,
         employee_id INTEGER NULL,
         reasons TEXT NULL,
         date_time NUMERIC NOT NULL,
         amount REAL NOT NULL,
           FOREIGN KEY(employee_id)REFERENCES  Employees(id),
           FOREIGN KEY(order_id)REFERENCES order_headers(id),
           FOREIGN KEY(transacion_id)REFERENCES order_transactions(id)
        )''');
//PayOUT_categories
    await db.execute('''CREATE TABLE PayOut_categories
        (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
         name TEXT NULL
        )''');
//payOut
    await db.execute('''CREATE TABLE PayOut
        (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
         PayTO TEXT NULL,
         date NUMERIC NOT NULL,
         cashier_id INTEGER NOT NULL,
         employee_id INTEGER NOT NULL,
         amount REAL NOT NULL,
         note TEXT NOT NULL,
         category_id INTEGER NULL,
         FOREIGN KEY(category_id)REFERENCES  PayOut_categories(id)
        )''');
//popup level modifier
    await db.execute('''CREATE TABLE Popup_level_modifiers
        (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
         menu_popup_mod_id INTEGER NULL,
         modifier_id INTEGER NULL,
          FOREIGN KEY(modifier_id)REFERENCES  Menu_modifiers(id),
          FOREIGN KEY(menu_popup_mod_id)REFERENCES  Menu_popup_modifiers(id)
        )''');
//price managment
    await db.execute('''CREATE TABLE Price_Managment
        (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
        title TEXT NULL UNIQUE,
        repeat INTEGER NOT NULL,
        price_label_id INTEGER NULL,
       discount_id INTEGER NULL,
        surcharge_id INTEGER NULL,
        services TEXT NULL,
        from_date NUMERIC NOT NULL,
        to_date NUMERIC NOT NULL,
        from_time NUMERIC NOT NULL,
         to_time NUMERIC NOT NULL,
        saturday NUMERIC NOT NULL,
        sunday NUMERIC NOT NULL,
        Monday NUMERIC NOT NULL,
        tuesday NUMERIC NOT NULL,
        wednesday NUMERIC NOT NULL,
        thursday NUMERIC NOT NULL,
        friday NUMERIC NOT NULL,
        FOREIGN KEY(discount_id)REFERENCES  Discounts(id),
          FOREIGN KEY( price_label_id )REFERENCES price_labels(id),
          FOREIGN KEY(surcharge_id)REFERENCES Surcharges(id)
        )''');
//selections
    await db.execute('''CREATE TABLE Selections
        (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
         name TEXT NULL,
         menu_item_id INTEGER NULL,
         menu_selection_id INTEGER NULL,
         FOREIGN KEY(menu_selection_id )REFERENCES Menu_selections(id),
           FOREIGN KEY(menu_item_id  )REFERENCES Menu_items(id)

        )''');

    await db.execute('''CREATE TABLE Transaction_modifiers(
     id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	   transaction_id INTEGER NULL,
     modifier_id INTEGER NULL,
     qty REAL NOT NULL,
	   price REAL NOT NULL,
	   note TEXT NULL,
	   is_forced NUMERIC NOT NULL,
     FOREIGN KEY(modifier_id)REFERENCES Menu_modifiers(id),
     FOREIGN KEY(transaction_id) REFERENCES Order_transactions(id)
    )''');
    if (initData == null) {
      await defaultData(db);
    } else {
      await insertInitData(db);
    }
  }

  Future<bool> insertInitData(db) async {
    PaymentMethod paymentMethod = new PaymentMethod(name: "Cash", rate: 1, type: 1, symbol: initData.symbol, after_decimal: initData.dicamal);
    await db.insert('payment_methods', paymentMethod.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    Role role = Role(
        name: "Owner",
        security:
            "111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111",
        reportSettings: "1,1,1,1,1,1,1,1,1,1,1,1,1");
    await db.insert('Roles', role.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    Employee employee = Employee(
        name: initData.admin_name, nick_name: "Owner", gender: "Male", password: initData.pass_code, job_title_id_number: 1, social_number: "1");
    await db.insert('Employees', employee.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    role = Role(
        name: "Cashier",
        security: "11211112211121111221222222222222222222222222222222222122112222222222222222222222222222222221",
        reportSettings: "0,0,0,0,0,0,0,0,1");
    await db.insert('Roles', role.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    role = Role(
        name: "Waiter",
        security: "11212212211121111222222222222222222222222222222222222222112222222222222222222222222222222221",
        reportSettings: "0,0,0,0,0,0,0,0,0");
    await db.insert('Roles', role.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    role = Role(
        name: "Supervisor",
        security: "11111111111111111111122212222222222222222222222222221111111111111111111111111111111122222221",
        reportSettings: "1,1,1,1,1,1,1,1,1");
    await db.insert('Roles', role.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    DineInGroup group = DineInGroup(name: "Zone 1", position: "0");
    await db.insert('DineIn_table_groups', group.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    MenuType type = MenuType(name: "Dinner");
    await db.insert('Menu_types', type.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    Preference preference = Preference(restaurantName: initData.company_name, restaurantLogo: initData.image_path);

    preference.address1 = initData.company_address1;
    preference.address2 = initData.company_address2;
    preference.phone = initData.phone;

    await db.insert("preferences", preference.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    Service service = Service(id: 1, name: "Dine In", alternative: "Dine In");
    await db.insert("Services", service.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    service = Service(id: 2, name: "Pick up", alternative: "Pick up");
    await db.insert("Services", service.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    service = Service(id: 3, name: "Car Hop", alternative: "Car Hop");
    await db.insert("Services", service.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    service = Service(id: 4, name: "Delivery", alternative: "Delivery");
    await db.insert("Services", service.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    service = Service(id: 5, name: "Pending", alternative: "Pending");
    await db.insert("Services", service.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    return true;
  }

  Future<bool> resetData() async {
    Database? dastbase = await db;
    await dastbase!.delete("order_voids");
    await dastbase.delete("Order_transactions");
    await dastbase.delete("Order_payments");
    await dastbase.delete("Order_headers");
    await dastbase.delete("Cashier_details");
    await dastbase.delete("Cashiers");
    await dastbase.delete("PayOut");
    await dastbase.delete("Pending_orders");

    /*  await dastbase.execute(''' 
                                DELETE From Order_voids;

                                DELETE From Order_transactions;

                                DELETE From Order_payments;

                                DELETE From Order_headers;

                                DELETE From Cashier_details;

                                DELETE From Cashiers;

                                DELETE From PayOut;


                                '''); */
    return true;
  }

  //defaultData
  Future<bool> defaultData(Database db) async {
    PaymentMethod paymentMethod = PaymentMethod(name: "Cash", rate: 1, type: 1, symbol: "\$", after_decimal: 2);
    await db.insert('payment_methods', paymentMethod.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    Role role = Role(
        name: "Owner",
        security:
            "111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111",
        reportSettings: "1,1,1,1,1,1,1,1,1,1,1,1,1");
    await db.insert('Roles', role.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    Employee employee = Employee(name: "Owner", nick_name: "Owner", gender: "Male", password: "1", job_title_id_number: 1, social_number: "1");
    await db.insert('Employees', employee.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    role = Role(
        name: "Cashier",
        security: "11211112211121111221222222222222222222222222222222222122112222222222222222222222222222222221",
        reportSettings: "0,0,0,0,0,0,0,0,1");
    await db.insert('Roles', role.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    role = Role(
        name: "Waiter",
        security: "11212212211121111222222222222222222222222222222222222222112222222222222222222222222222222221",
        reportSettings: "0,0,0,0,0,0,0,0,0");
    await db.insert('Roles', role.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    role = Role(
        name: "Supervisor",
        security: "11111111111111111111122212222222222222222222222222221111111111111111111111111111111122222221",
        reportSettings: "1,1,1,1,1,1,1,1,1");
    await db.insert('Roles', role.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    DineInGroup group = DineInGroup(name: "Zone 1", position: "0");
    await db.insert('DineIn_table_groups', group.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    MenuType type = MenuType(name: "Dinner");
    await db.insert('Menu_types', type.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    Preference preference = Preference(restaurantName: "INVO Resturant");
    await db.insert("preferences", (preference.toMap() as Map<String, Object>), conflictAlgorithm: ConflictAlgorithm.replace);

    Service service = Service(id: 1, name: "Dine In", alternative: "Dine In");
    await db.insert("Services", service.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    service = Service(id: 2, name: "Pick up", alternative: "Pick up");
    await db.insert("Services", service.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    service = Service(id: 3, name: "Car Hop", alternative: "Car Hop");
    await db.insert("Services", service.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    service = Service(id: 4, name: "Delivery", alternative: "Delivery");
    await db.insert("Services", service.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    return true;
  }

  void setMenuItemGroup() {
    for (var item in menuItemGroups!.toList()) {
      try {
        item.menu_item = menuItems!.firstWhere((f) => f.id == item.menu_item_id);
      } catch (e) {
        menuItemGroups!.remove(item);
      }
    }
  }

  @override
  Future<bool> discountOrder(OrderHeader? order, Discount? discount, int? employeeId) async {
    return await orderService!.discountOrder(order!, discount!, employeeId!);
  }

  @override
  Future<OrderHeader> fetchFullOrder(int orderId) async {
    return await orderService!.fetchFullOrder(orderId);
  }

  @override
  Future<OrderHeader?> fetchFullPendingOrder(int orderId) async {
    return await orderService!.fetchFullPendingOrder(orderId);
  }

  @override
  Future<List<MiniOrder>> fetchServiceOrder(int serviceId) {
    return orderService!.fetchServiceOrder(serviceId);
  }

  @override
  fetchServicePaidOrders(int serviceId, DateTime _date) {
    return orderService!.fetchServicePaidOrders(serviceId, _date);
  }

  @override
  fetchPendingOrders() {
    return orderService!.fetchPendingOrders();
  }

  @override
  fetchServicesOrders() async {
    return await orderService!.fetchServicesOrders();
  }

  @override
  fetchTableStatus(int id) {}

  @override
  fetchTablesStatus() async {
    return dineInService!.fetchTablesStatus();
  }

  @override
  Future<bool> followUp(OrderHeader order) {
    // TODO: implement followUp
    throw UnimplementedError();
  }

  @override
  List<MenuGroup> getMenuGroup() {
    // TODO: implement getMenuGroup
    return [];
  }

  @override
  Future<Customer?> loadCustomer(String phone) async {
    return await customerService!.getByPhone(phone);
  }

  @override
  Future<List<OrderHeader>> loadOrders(int tableId) async {
    return await orderService!.loadOrders(tableId);
  }

  @override
  Future<bool> printOrder(OrderHeader order) {
    // TODO: implement printOrder
    throw UnimplementedError();
  }

  @override
  Future<Customer?> saveCustomer(Customer customer) async {
    return await customerService!.save(customer);
  }

  @override
  Future<OrderHeader?> saveOrder(OrderHeader order) async {
    return await orderService!.saveOrder(order);
  }

  @override
  Future<List<OrderHeader>> saveOrders(List<OrderHeader> orders) async {
    return await orderService!.saveOrders(orders);
  }

  @override
  Future<Terminal?> saveTerminal(Terminal _terminal) async {
    terminal = await terminalService!.save(_terminal);
    return terminal;
  }

  @override
  Future<bool> surchargeOrder(OrderHeader order, Surcharge surcharge) async {
    return await orderService!.surchargeOrder(order, surcharge);
  }

  @override
  Future<bool> voidOrder(OrderHeader order, int employeeId, String reason, bool waste) async {
    return await orderService!.voidOrder(order, employeeId, reason, waste);
  }

  @override
  // TODO: implement repoName
  String get repoName => "Database Connection";
}
