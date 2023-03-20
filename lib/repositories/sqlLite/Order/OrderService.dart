import 'package:invo_mobile/models/custom/mini_order.dart';
import 'package:invo_mobile/models/discount.dart';
import 'package:invo_mobile/models/order/TransactionModifier.dart';
import 'package:invo_mobile/models/order/order_header.dart';
import 'package:invo_mobile/models/order/order_payment.dart';
import 'package:invo_mobile/models/order/order_status.dart';
import 'package:invo_mobile/models/order/order_transaction.dart';
import 'package:invo_mobile/models/order/pending_order.dart';
import 'package:invo_mobile/models/service_order.dart';
import 'package:invo_mobile/models/surcharge.dart';
import 'package:invo_mobile/models/departure_status.dart';
import 'package:invo_mobile/models/pending_status.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/repositories/interface/Order/IOrderService.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import 'package:collection/collection.dart';

import '../sqlite_repository.dart';

class OrderService implements IOrderService {
  @override
  Future<bool> discountOrder(OrderHeader? order, Discount? discount, int? employeeId) async {
    Database? database = await SqliteRepository().db;
    var list = <String, dynamic>{
      'discount_id': (discount != null) ? discount.id : 0,
      'discount_amount': (discount != null) ? discount.amount : 0,
      'discount_percentage': (discount != null) ? (discount.is_percentage) : false,
      'discount_actual_amount': order!.discount_actual_amount,
      'surcharge_actual_amount': order.surcharge_actual_amount,
      'total_tax': order.total_tax,
      'total_tax2': order.total_tax2,
      'total_tax3': order.total_tax3,
      'grand_price': order.grand_price,
      'Rounding': order.Rounding,
      'taxable1_amount': order.taxable1_amount,
      'taxable2_amount': order.taxable2_amount,
      'taxable3_amount': order.taxable3_amount,
      'sub_total_price': order.sub_total_price,
    };

    int resault = await database!.update("order_headers", list, where: "id = ?", whereArgs: [order.id], conflictAlgorithm: ConflictAlgorithm.replace);

    return resault > 0;
  }

  @override
  Future<OrderHeader>? getByGUID(String GUID) async {
    Database? database = await SqliteRepository().db;
    var list = await database!.rawQuery("""Select * From Order_headers  Where GUID = ?""", [GUID]);

    OrderHeader order = OrderHeader.fromMap(list.first);
    return order;
  }

  @override
  Future<OrderHeader?> fetchFullPendingOrder(int pendingOrderId) async {
    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> list = await database!.rawQuery("Select * from Pending_orders Where id = ?" "", [pendingOrderId]);

    OrderHeader? order;
    if (list.isNotEmpty) {
      Map<String, dynamic> _order = json.decode(list.first['order']);
      _order['date_time'] = list.first['pending_date_time'];
      order = OrderHeader.fromMap(_order);
      order.serverId = _order['server_id'];
      order.calculateItemTotal();
      // order = OrderHeader(employee_id: 0, payments: [], service_id: 0, transaction: [], terminal_id: 0);
    }

    return order;
  }

  @override
  Future<OrderHeader> fetchFullOrder(int orderId) async {
    Database? database = await SqliteRepository().db;
    var list = await database!.rawQuery("""Select Order_headers.*,  DineIn_tables.name As dineIn_table_name,
                                                            Discounts.name As discount_name,
                                                            Services.name As service_name,
                                                            Services.alternative As service_alternative,
                                                            Employees.name As employee_name,
                                                            Customers.name As customer_name,
                                                            Surcharges.name As surcharge_name,
                                                            Drivers.name  As driver_name
                                                            From Order_headers
                                                            left join Discounts On Order_headers.discount_id = Discounts.id
                                                            left join Services On Order_headers.service_id = Services.id
                                                            left join DineIn_tables On Order_headers.dinein_table_id = DineIn_tables.id
                                                            left join Employees On Order_headers.employee_id = Employees.id
                                                            left join Employees As Drivers On Order_headers.driver_id = Drivers.id
                                                            left join Customers On Order_headers.customer_id_number = Customers.id_number
                                                            left join Surcharges On Order_headers.surcharge_id = Surcharges.id
                                                            Where Order_headers.id = ?""", [orderId]);

    OrderHeader order = OrderHeader.fromMap(list.first);

    var transactions =
        await database.rawQuery("""Select Order_transactions.*,Menu_items.default_price As Item_default_price, Menu_items.name As Item_name,
        Menu_items.receipt_text As Item_receipt_name,Menu_items.kitchen_text As Item_kitchen_name,Menu_items.order_By_Weight,Menu_items.weight_unit,
                                                            TranDisc.name as discount_name,Employee.name as employee_name
                                                            From Order_transactions 
                                                            left join Menu_items On Order_transactions.menu_item_id = Menu_items.id
                                                            left join Discounts As TranDisc On Order_transactions.discount_id = TranDisc.id
                                                            left join Employees As Employee On Order_transactions.employee_id = Employee.id
                                                            Where order_id = ?""", [orderId]);

    order.transaction = List<OrderTransaction>.empty(growable: true);
    for (var item in transactions) {
      order.transaction.add(OrderTransaction.fromMap(item));
    }

    var modifiers = await database.rawQuery(
        """ Select Transaction_modifiers.*,modifier.id ,modifier.name,modifier.display_name,modifier.food_nutrition,modifier.kitchen_text,modifier.receipt_text  from Transaction_modifiers
                                                            Left join Menu_modifiers As modifier On Transaction_modifiers.modifier_id = modifier.id
                                                            where Transaction_modifiers.transaction_id In (Select id From Order_transactions where order_id = ?)""",
        [orderId]);

    TransactionModifier tModifier;
    OrderTransaction? tTransaction;
    for (var item in modifiers) {
      tModifier = TransactionModifier.fromMap(item);
      tTransaction = order.transaction.firstWhereOrNull((element) => element.id == tModifier.transaction_id);
      if (tTransaction != null) {
        tTransaction.modifiers?.add(tModifier);
      }
    }

    order.payments = List<OrderPayment>.empty(growable: true);
    var paymentList = await database.query("order_payments", where: "order_id = ?", whereArgs: [order.id]);
    for (var item in paymentList) {
      order.payments.add(OrderPayment.fromMap(item));
    }
    order.calculateItemTotal();
    return order;
  }

  @override
  Future<List<MiniOrder>> fetchServiceOrder(int serviceId) async {
    Database? database = await SqliteRepository().db;
    var list = await database!.rawQuery(
        """Select Order_headers.id,DineIn.name As table_name,Order_headers.customer_id_number,Customers.name as Customer_name,Driver.name as Driver_name,customer_contact,Employees.name as Employee_name,Order_headers.date_time,Order_headers.employee_id,driver_id,Order_headers.[status],ticket_number,
                           arrival_time,depature_time,print_time,grand_price,Label,Sum(amount_tendered * rate) as balance_amount, Order_headers.Label
                           from Order_headers 
                           Left Join Customers On Customers.id_number = Order_headers.customer_id_number
                           Left Join Employees On Employees.id = Order_headers.employee_id
                           Left Join Order_payments On Order_headers.id = Order_payments.order_id and Order_payments.[status] = 0
                           Left Join Employees As Driver On Driver.id = Order_headers.driver_id
                           Left Join DineIn_tables As DineIn On Order_headers.dinein_table_id = DineIn.id
                           Where  (service_id = ?) and Order_headers.[status] In (""" +
            '1,2,6' +
            """)
						   Group by Order_headers.id,DineIn.name ,Order_headers.customer_id_number,Customers.name,customer_contact,Employees.name,Order_headers.date_time,Order_headers.employee_id,driver_id,Order_headers.[status],ticket_number,
                           arrival_time,depature_time,print_time,grand_price,Label,Driver.name
                           Order by Order_headers.id desc""",
        [serviceId]);

    List<MiniOrder> orders = List<MiniOrder>.empty(growable: true);
    for (var item in list) {
      orders.add(MiniOrder.fromMap(item));
    }
    return orders;
  }

  @override
  Future<List<MiniOrder>?> fetchAllOrders(DateTime startDate, DateTime endDate, String searchText, int service, int status) async {
    int fromDate = new DateTime(startDate.year, startDate.month, startDate.day, 5, 0, 0, 0, 0).toUtc().millisecondsSinceEpoch;
    int toDate = new DateTime(endDate.year, endDate.month, endDate.day, 5, 0, 0, 0, 0).add(Duration(days: 1)).toUtc().millisecondsSinceEpoch;

    Database? database = await SqliteRepository().db;
    String seacrhCraiteria;
    if (searchText != "") {
      int? id = int.tryParse(searchText);
      seacrhCraiteria = """(Order_headers.id = """ +
          id.toString() +
          """
                         or Customers.name Like '%""" +
          searchText.toString() +
          """%' 
                         or customer_contact Like '% """ +
          searchText.toString() +
          """%' 
                         or Driver.name Like '%""" +
          searchText.toString() +
          """%'
                         or Employees.name Like '%""" +
          searchText.toString() +
          """%'
                         or ticket_number = """ +
          searchText.toString() +
          """
                         or DineIn.name Like '%""" +
          searchText.toString() +
          """%'
                         or Label Like '%""" +
          searchText.toString() +
          """%')""";
    } else {
      seacrhCraiteria = "1=1";
    }

    var list = await database!.rawQuery(
        """Select Order_headers.id,Order_headers.prepared_date,Order_headers.update_time,DineIn.name As table_name,Order_headers.customer_id_number,Customers.name as Customer_name,Driver.name as Driver_name,customer_contact,Employees.name as Employee_name,Order_headers.date_time,Order_headers.employee_id,driver_id,Order_headers.[status],ticket_number,
                           arrival_time,depature_time,print_time,grand_price,Label,(grand_price - Sum(amount_tendered * rate)) as balance_amount
                           from Order_headers 
                           Left Join Customers On Customers.id_number = Order_headers.customer_id_number
                           Left Join Employees On Employees.id = Order_headers.employee_id
                           Left Join Order_payments On Order_headers.id = Order_payments.order_id and Order_payments.[status] = 0
                           Left Join Employees As Driver On Driver.id = Order_headers.driver_id
                           Left Join DineIn_tables As DineIn On Order_headers.dinein_table_id = DineIn.id
                           Where  (? = 0 or service_id = ?) and (? = 0 or Order_headers.[status] = ?) and
                           Order_headers.date_time >= ? and Order_headers.date_time <= ? and ?
						   Group by Order_headers.id,Order_headers.prepared_date,Order_headers.update_time,DineIn.name,Order_headers.customer_id_number,Customers.name,customer_contact,Employees.name,Order_headers.date_time,Order_headers.employee_id,driver_id,Order_headers.[status],ticket_number,
                           arrival_time,depature_time,print_time,grand_price,Label,Driver.name
                           Order by Order_headers.id desc""", [service, service, status, status, fromDate, toDate, seacrhCraiteria]);

    List<MiniOrder> orders = List<MiniOrder>.empty(growable: true);
    for (var item in list) {
      orders.add(MiniOrder.fromMap(item));
    }
    return orders;
  }

  @override
  Future<List<ServiceOrder>> fetchServicesOrders() async {
    Database? database = await SqliteRepository().db;
    if (!database!.isOpen) return List<ServiceOrder>.empty(growable: true);
    String sql = """Select Count(*) as order_count,service_id
                            From Order_headers
                            Where status = 1 OR status = 2 OR status = 6
                            Group By service_id""";
    var list = await database.rawQuery(sql);

    List<ServiceOrder> orders = List<ServiceOrder>.empty(growable: true);
    for (var item in list) {
      orders.add(ServiceOrder.fromMap(item));
    }
    return orders;
  }

  @override
  Future<int>? fetchTodayOrdersCount(DateTime startDate, DateTime endDate) async {
    Database? database = await SqliteRepository().db;
    int fromDate = startDate.toUtc().millisecondsSinceEpoch;
    int toDate = endDate.toUtc().millisecondsSinceEpoch;
    String sql = """Select Count(*)
                    From Order_headers
                    where date_time >= ? and date_time <= ?""";
    var result = await database!.rawQuery(sql, [fromDate, toDate]);

    int count = 0;
    for (var item in result) {
      count = int.parse(item['Count(*)'].toString());
    }
    return count;
  }

  @override
  Future<List<MiniOrder>?>? fetchServicePaidOrders(int serviceId, DateTime _date) async {
    DateTime date = new DateTime(_date.year, _date.month, _date.day, 5, 0, 0, 0, 0);

    int fromDate = date.toUtc().millisecondsSinceEpoch;
    int toDate = date.add(Duration(days: 1)).toUtc().millisecondsSinceEpoch;

    Database? database = await SqliteRepository().db;

    if (!database!.isOpen) return List<MiniOrder>.empty(growable: true);
    var list = await database.rawQuery(
        """Select Order_headers.id,DineIn.name As table_name,Order_headers.customer_id_number,Customers.name as Customer_name,Driver.name as Driver_name,customer_contact,Employees.name as Employee_name,Order_headers.date_time,Order_headers.employee_id,driver_id,Order_headers.[status],ticket_number,
                           arrival_time,depature_time,print_time,grand_price,Label,Sum(amount_tendered * rate) as balance_amount
                           from Order_headers 
                           Left Join Customers On Customers.id_number = Order_headers.customer_id_number
                           Left Join Employees On Employees.id = Order_headers.employee_id
                           Left Join Order_payments On Order_headers.id = Order_payments.order_id and Order_payments.[status] = 0
                           Left Join Employees As Driver On Driver.id = Order_headers.driver_id
                           Left Join DineIn_tables As DineIn On Order_headers.dinein_table_id = DineIn.id
                           Where  (service_id = ?) and Order_headers.[status] = 3 
						               Group by Order_headers.id,DineIn.name ,Order_headers.customer_id_number,Customers.name,customer_contact,Employees.name,Order_headers.date_time,Order_headers.employee_id,driver_id,Order_headers.[status],ticket_number,
                           arrival_time,depature_time,print_time,grand_price,Label,Driver.name
                           HAVING MAX(Order_payments.date_time) >= ? and MAX(Order_payments.date_time) <= ? Order by Order_headers.id desc""",
        [serviceId, fromDate, toDate]);

    List<MiniOrder> orders = List<MiniOrder>.empty(growable: true);
    for (var item in list) {
      orders.add(MiniOrder.fromMap(item));
    }
    return orders;
  }

  @override
  Future<List<MiniOrder>?>? fetchPendingOrders() async {
    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> list = await database!.rawQuery("""Select * from Pending_orders order by pending_date_time DESC""");
    List<MiniOrder> orders = List<MiniOrder>.empty(growable: true);
    for (var item in list) {
      Map<String, dynamic> _order = json.decode(item['order']);
      _order['date_time'] = item['pending_date_time'];
      orders.add(MiniOrder.fromMap(_order));
      orders.last.serverId = _order['server_id'];
      orders.last.id = item['id'];
    }
    return orders;
  }

  @override
  Future<List<OrderHeader>> loadOrders(int tableId) async {
    Database? database = await SqliteRepository().db;
    String orderHeaderQuery = """Select Order_headers.*,  DineIn_tables.name As dineIn_table_name,
                                                            Discounts.name As discount_name,
                                                            Services.name As service_name,
                                                            Services.alternative As service_alternative,
                                                            Employees.name As employee_name,
                                                            Customers.name As customer_name,
                                                            Surcharges.name As surcharge_name,
                                                            Drivers.name  As driver_name
                                                            From Order_headers
                                                            left join Discounts On Order_headers.discount_id = Discounts.id
                                                            left join Services On Order_headers.service_id = Services.id
                                                            left join DineIn_tables On Order_headers.dinein_table_id = DineIn_tables.id
                                                            left join Employees On Order_headers.employee_id = Employees.id
                                                            left join Employees As Drivers On Order_headers.driver_id = Drivers.id
                                                            left join Customers On Order_headers.customer_id_number = Customers.id_number
                                                            left join Surcharges On Order_headers.surcharge_id = Surcharges.id
                                                            Where Order_headers.dinein_table_id = @id and Order_headers.[status] In (1,2,6)""";

    String orderTransactionQuery =
        """Select Order_transactions.*,Menu_items.default_price As Item_default_price, Menu_items.name As Item_name,Menu_items.receipt_text As Item_receipt_name,Menu_items.kitchen_text As Item_kitchen_name,Menu_items.order_By_Weight,Menu_items.weight_unit,
                                                            TranDisc.name as discount_name,Employee.name as employee_name
                                                            From Order_transactions 
                                                            left join Menu_items On Order_transactions.menu_item_id = Menu_items.id
                                                            left join Discounts As TranDisc On Order_transactions.discount_id = TranDisc.id
                                                            left join Employees As Employee On Order_transactions.employee_id = Employee.id
                                                            Where order_id In (Select id from Order_headers where dinein_table_id = @id and [status] In (1,2,6))""";

    var list = await database!.rawQuery(orderHeaderQuery, [tableId]);

    List<OrderHeader> orders = List<OrderHeader>.empty(growable: true);
    for (var item in list) {
      orders.add(OrderHeader.fromMap(item));
    }

    list = await database.rawQuery(orderTransactionQuery, [tableId]);
    var modifiers = await database.rawQuery(
        """ Select Transaction_modifiers.*,modifier.id ,modifier.name,modifier.display_name,modifier.food_nutrition,modifier.kitchen_text,modifier.receipt_text  from Transaction_modifiers
                                                            Left join Menu_modifiers As modifier On Transaction_modifiers.modifier_id = modifier.id
                                                            where Transaction_modifiers.transaction_id In (Select id From Order_transactions where order_id = (Select id from Order_headers where dinein_table_id = ? and [status] In (1,2,6)))""",
        [tableId]);

    OrderHeader? temp;
    TransactionModifier tModifier;
    OrderTransaction? tTransaction;
    for (var item in list) {
      temp = orders.firstWhereOrNull((f) => f.id == item['order_id']);
      if (temp != null) {
        temp.transaction.add(OrderTransaction.fromMap(item));
        for (var item in modifiers) {
          tModifier = TransactionModifier.fromMap(item);
          tTransaction = temp.transaction.firstWhereOrNull((element) => element.id == tModifier.transaction_id);
          if (tTransaction != null) {
            tTransaction.modifiers?.add(tModifier);
          }
        }
      }
    }

    return orders;
  }

  @override
  Future<OrderHeader?> saveOrder(OrderHeader order) async {
    try {
      DateTime dateTime = DateTime.now();
      Database? database = await SqliteRepository().db;
      var preference = await locator.get<ConnectionRepository>().preference;

      if (order.id == 0 || order.id == null) {
        order.id = await database!.insert("order_headers", order.toMapDB()..remove('payments'));

        List<Map<String, dynamic>> temp =
            await database.rawQuery("SELECT ticket_number FROM Order_headers Where id != ? ORDER BY id DESC Limit 1", [order.id]);
        if (temp == null || temp.length == 0) {
          order.ticket_number = 1;
        } else {
          order.ticket_number = int.parse(temp[0]['ticket_number'].toString()) + 1;
        }
        await database.rawUpdate("Update Order_headers Set ticket_number = ? where id = ?", [order.ticket_number, order.id]);
      } else {
        try {
          var list = order.toMapDB();
          list.remove("date_time");
          list.remove("service");
          await database!.update("order_headers", list, where: "id = ?", whereArgs: [order.id], conflictAlgorithm: ConflictAlgorithm.replace);
        } catch (e) {
          print(e);
        }
      }

      for (var item in order.transaction) {
        item.order_id = order.id;
        if (item.id == 0 || item.id == null) {
          item.id = await database!.insert("order_transactions", item.toMap()..remove('menu_item'));
        } else {
          await database!.update("order_transactions", item.toMap()..remove('menu_item'),
              where: "id = ?", whereArgs: [item.id], conflictAlgorithm: ConflictAlgorithm.replace);
        }
        if (item.modifiers!.isNotEmpty) {
          for (var mod in item.modifiers!) {
            mod.modifier_id = mod.modifier!.id;
            mod.transaction_id = item.id;
            if (mod.id == 0) {
              await database.insert("Transaction_modifiers", mod.toMap());
            } else {
              await database.update("Transaction_modifiers", mod.toMap(),
                  where: "transaction_id = ? AND modifier_id = ?",
                  whereArgs: [mod.transaction_id, mod.modifier_id],
                  conflictAlgorithm: ConflictAlgorithm.replace);
            }
          }
        }
        if (item.menu_item!.enable_count_down!) {
          item.menu_item?.countDown -= item.qty.toInt();

          await database.update("Menu_items", item.menu_item!.toMap(),
              where: "id = ?", whereArgs: [item.menu_item?.id], conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }

      await payOrder(order, order.status == 3);

      return order;
    } catch (e) {
      print("test");
      print(e.toString());
      return null;
    }
  }

  @override
  Future<OrderHeader> savePendingOrder(OrderHeader order) async {
    if (order != null) {
      Database? database = await SqliteRepository().db;
      PendingOrder pendingOrder = PendingOrder(
          pending_date_time: DateTime.now().toString(), type: 3, order: jsonEncode(order.toMapRequest()).toString(), status: 0, ticketNumber: "0");
      await database!.insert("Pending_orders", pendingOrder.toMap());
    }
    return order;
  }

  @override
  Future<List<OrderHeader>> saveOrders(List<OrderHeader> orders) async {
    OrderHeader? _temp;
    List<OrderHeader> list = List<OrderHeader>.empty(growable: true);
    for (var order in orders) {
      _temp = await saveOrder(order); //check if null => error
      if (_temp != null) {
        list.add(_temp);
      } else {
        return orders;
      }
    }
    return list;
  }

  @override
  void updatePrintedItem(OrderHeader order) async {
    Database? database = await SqliteRepository().db;
    await database!.rawUpdate("update order_transactions set is_printed = 1 where order_id =" + order.id.toString());
  }

  @override
  Future<void> removePendingOrder(int id) async {
    if (id > 0) {
      Database? database = await SqliteRepository().db;
      await database!.rawDelete('DELETE FROM Pending_orders WHERE id = ?', [id]);
    }
  }

  @override
  Future<void> rejectPendingOrder(String order_GUID, int pendingId) async {
    Database? database = await SqliteRepository().db;
    OrderStatus orderStatus = new OrderStatus();
    orderStatus.id = 0;
    orderStatus.ticket_number = 0;
    orderStatus.GUID = order_GUID;
    PendingStatus pendingStatus = new PendingStatus(type: 4, server_sent: false, is_sent: false, status: jsonEncode(orderStatus.toMap()).toString());
    await database!.insert("Pending_Status", pendingStatus.toMap());
    await removePendingOrder(pendingId);
  }

  @override
  Future<void> acceptPendingOrder(String orderGUID, int id, int ticket_number) async {
    Database? database = await SqliteRepository().db;
    OrderStatus orderStatus = new OrderStatus();
    orderStatus.id = id;
    orderStatus.ticket_number = ticket_number;
    orderStatus.GUID = orderGUID;
    PendingStatus pendingStatus = new PendingStatus(type: 5, server_sent: false, is_sent: false, status: jsonEncode(orderStatus.toMap()).toString());
    database!.insert("Pending_Status", pendingStatus.toMap());
  }

  @override
  Future<bool> surchargeOrder(OrderHeader order, Surcharge surcharge) async {
    Database? database = await SqliteRepository().db;
    var list = <String, dynamic>{
      'surcharge_id': (surcharge != null) ? surcharge.id : null,
      'surcharge_amount': (surcharge != null) ? surcharge.amount : 0,
      'surcharge_percentage': (surcharge != null) ? (surcharge.is_percentage == null ? false : surcharge.is_percentage) : false,
      'surcharge_apply_tax1': order.surcharge_apply_tax1,
      'surcharge_apply_tax2': order.surcharge_apply_tax2,
      'surcharge_apply_tax3': order.surcharge_apply_tax3,
      'total_tax': order.total_tax,
      'total_tax2': order.total_tax2,
      'total_tax3': order.total_tax3,
      'grand_price': order.grand_price,
      'surcharge_actual_amount': order.surcharge_actual_amount,
      'Rounding': order.Rounding,
      'taxable1_amount': order.taxable1_amount,
      'taxable2_amount': order.taxable2_amount,
      'taxable3_amount': order.taxable3_amount,
      'sub_total_price': order.sub_total_price,
    };

    int resault = await database!.update("order_headers", list, where: "id = ?", whereArgs: [order.id], conflictAlgorithm: ConflictAlgorithm.replace);

    return resault > 0;
  }

  //Select status from Order_headers where GUID ='" + guid + "'" 3 => true else => false
  @override
  Future<bool> isSettled(guid) async {
    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.rawQuery("Select status from Order_headers where GUID ='" + guid + "'");
    if (result.length == 0) {
      return false;
    } else {
      if (result[0].values.first == 3) {
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  Future<bool> voidOrder(OrderHeader order, int employeeId, String reason, bool waste) async {
    Database? database = await SqliteRepository().db;
    String sql = "Update Order_headers Set status = 4, update_time = ? Where id = ? and status <> 4;";

    await database!.rawUpdate(sql, [DateTime.now().toUtc().millisecondsSinceEpoch, order.id]);

    sql = """Insert Into Order_voids(order_id,employee_id,reasons,date_time,amount) Values(?,?,?,?,
                                (select grand_price from Order_headers where id = ?))""";

    await database.rawUpdate(sql, [
      order.id,
      employeeId,
      reason,
      DateTime.now().toUtc().millisecondsSinceEpoch,
      order.id,
    ]);

    return true;
  }

  @override
  Future<List<PendingStatus>> getPendingStatus() async {
    Database? database = await SqliteRepository().db;
    var list = await database!.rawQuery("""Select * From Pending_Status where server_sent = 0 """);

    List<PendingStatus> pendingStatusList = List<PendingStatus>.empty(growable: true);
    for (var item in list) {
      pendingStatusList.add(PendingStatus.fromMap(item));
    }
    return pendingStatusList;
  }

  @override
  Future<void> updatePendingStatus(List<PendingStatus> pendingStatus) async {
    //Update Pending_Status Set server_sent = 1 where id In @ids
    Database? database = await SqliteRepository().db;
    if (pendingStatus.length > 0) {
      List<int> ids = [];
      for (var item in pendingStatus) {
        ids.add(int.parse(item.id.toString()));
      }
      String ids_ = ids.join(',');
      await database!.rawUpdate("Update Pending_Status set server_sent = 1 where id in ($ids_)");
    }
  }

  @override
  Future<bool> payOrder(OrderHeader order, bool complete) async {
    Database? database = await SqliteRepository().db;
    Batch batch = database!.batch();
    try {
      if (order.id > 0) {
        for (var item in order.payments.where((f) => f.amount_paid > 0).toList()) {
          item.order_id = order.id;
          if (item.id == 0 || item.id == null) {
            item.order_id = order.id;
            batch.insert("order_payments", item.toMap());
          } else {
            batch.update("order_payments", item.toMap(), where: "id = ?", whereArgs: [item.id]);
          }
        }
      }

      if (complete) {
        Map<String, dynamic> updateOrderStatus = <String, dynamic>{"status": 3};
        batch.update("Order_headers", updateOrderStatus, where: "id = ?", whereArgs: [order.id]);
      }

      //insert in peniding status
      if (/*order.status == 3 &&*/ complete && order.server_id != null) {
        DepartureStatus statusSetteld = DepartureStatus();
        statusSetteld.id = order.id;
        statusSetteld.server_id = order.server_id;
        statusSetteld.date_time = DateTime.now();
        PendingStatus pendingStatus =
            PendingStatus(type: 3, server_sent: false, is_sent: false, status: jsonEncode(statusSetteld.toMap()).toString());
        batch.insert("Pending_Status", pendingStatus.toMap());
      }

      await batch.commit();
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
