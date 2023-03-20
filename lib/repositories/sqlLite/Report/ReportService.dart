import 'package:invo_mobile/blocs/back_office/reports/report_page_event.dart';
import 'package:invo_mobile/models/Number.dart';
import 'package:invo_mobile/models/reports/CashierReportModel.dart';
import 'package:invo_mobile/models/reports/DailyClosingModel.dart';
import 'package:invo_mobile/models/reports/DailySalesModel.dart';
import 'package:invo_mobile/models/reports/DashBoardReportModel.dart';
import 'package:invo_mobile/models/reports/DriverSummaryModel.dart';
import 'package:invo_mobile/models/reports/OrderTotalDetailModel.dart';
import 'package:invo_mobile/models/reports/SalesByCategoryModel.dart';

import 'package:invo_mobile/models/reports/SalesByEmployeeModel.dart';
import 'package:invo_mobile/models/reports/SalesByHoursModel.dart';
import 'package:invo_mobile/models/reports/SalesByItemModel.dart';
import 'package:invo_mobile/models/reports/SalesBySectionTableModel.dart';
import 'package:invo_mobile/models/reports/SalesByServiceModel.dart';
import 'package:invo_mobile/models/reports/SalesByTableModel.dart';
import 'package:invo_mobile/models/reports/SalesSummaryModels.dart';
import 'package:invo_mobile/models/reports/TaxReportModel.dart';
import 'package:invo_mobile/models/reports/VoidReportModel.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/repositories/interface/Report/IReportService.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:sqflite/sqflite.dart';
import 'package:collection/collection.dart';

import '../sqlite_repository.dart';

class ReportService implements IReportService {
  @override
  Future<List<SalesByServiceModel>> salesByService(DateTime from, DateTime to) async {
    int fromDate = addOpeningHours(from).toUtc().millisecondsSinceEpoch;
    int toDate = addOpeningHours(to).toUtc().millisecondsSinceEpoch;

    List<SalesByServiceModel> report = List<SalesByServiceModel>.empty(growable: true);

    Database? database = await SqliteRepository().db;
    String sql =
        """SELECT Services.id AS serviceId, Services.alternative AS alternative, Services.name AS service, SUM(OH.grand_price) AS orderSum, COUNT(*) AS totalOrder
                                     FROM Order_headers AS OH INNER JOIN 
                                     Services ON OH.service_id = Services.id 
                                     where OH.status <> 4 and OH.status <> 7 and [date_time] >= ? and [date_time] <= ?
                                     group by Services.id,Services.alternative,Services.name""";

    List<Map<String, dynamic>> result = await database!.rawQuery(sql, [fromDate, toDate]);
    for (var item in result) {
      report.add(SalesByServiceModel.fromMap(item));
    }

    return report;
  }

  Future<List<SalesByTableModel>> salesByTable(DateTime from, DateTime to) async {
    int fromDate = addOpeningHours(from).toUtc().millisecondsSinceEpoch;
    int toDate = addOpeningHours(to).toUtc().millisecondsSinceEpoch;
    List<SalesByTableModel> report = List<SalesByTableModel>.empty(growable: true);
    Database? database = await SqliteRepository().db;
    String sql =
        """SELECT DineIn_tables.id As tableId,DineIn_tables.name As tableName, Sum(OH.no_of_guests) As guest ,SUM(OH.grand_price) / Sum(OH.no_of_guests) As avgarageGuest, SUM(OH.grand_price) AS orderSum, COUNT(*) AS totalOrder, AVG(OH.grand_price) AS average
                                        FROM Order_headers AS OH INNER JOIN 
                                        DineIn_tables ON OH.dinein_table_id = DineIn_tables.id 
                                        where OH.status <> 4 and OH.status <> 7 and [date_time] >= ? and [date_time] <= ?
                                        group by DineIn_tables.id,DineIn_tables.name """;
    List<Map<String, dynamic>> result = await database!.rawQuery(sql, [fromDate, toDate]);
    for (var item in result) {
      report.add(new SalesByTableModel.fromMap(item));
    }
    return report;
  }

  Future<List<SalesBySectionTableModel>> salesBySectionTable(DateTime from, DateTime to) async {
    int fromDate = addOpeningHours(from).toUtc().millisecondsSinceEpoch;
    int toDate = addOpeningHours(to).toUtc().millisecondsSinceEpoch;
    List<SalesBySectionTableModel> report = List<SalesBySectionTableModel>.empty(growable: true);
    Database? database = await SqliteRepository().db;
    String sql =
        """SELECT DineIn_table_groups.id as groupId, DineIn_table_groups.name as groupName, SUM(OH.grand_price) AS orderSum, COUNT(*) AS totalOrder, AVG(OH.grand_price) AS average
                                    FROM DineIn_table_groups INNER JOIN 
                                   DineIn_tables ON DineIn_table_groups.id = DineIn_tables.table_group_id INNER JOIN 
                                   Order_headers As OH ON DineIn_tables.id = OH.dinein_table_id 
                                  where OH.status <> 4 and OH.status <> 7 and [date_time] >= ? and [date_time] <= ?
                                  group by DineIn_table_groups.id,DineIn_table_groups.name """;
    List<Map<String, dynamic>> result = await database!.rawQuery(sql, [fromDate, toDate]);
    for (var item in result) {
      report.add(SalesBySectionTableModel.fromMap(item));
    }
    return report;
  }

  Future<List<SalesByItemModel>> salesByItem(DateTime from, DateTime to) async {
    int fromDate = addOpeningHours(from).toUtc().millisecondsSinceEpoch;
    int toDate = addOpeningHours(to).toUtc().millisecondsSinceEpoch;
    List<SalesByItemModel> report = List<SalesByItemModel>.empty(growable: true);
    Database? database = await SqliteRepository().db;
    String sql =
        """SELECT Menu_items.name as name, SUM(Order_transactions.qty) AS totalQty, Menu_items.barcode as barcode, Menu_categories.name AS category,
                             SUM(Order_transactions.grand_price) as totalSale
                                    FROM Menu_items LEFT OUTER JOIN 
                                    Menu_categories ON Menu_items.menu_category_id = Menu_categories.id INNER JOIN 
                                    Order_transactions ON Menu_items.id = Order_transactions.menu_item_id INNER JOIN 
                                    Order_headers ON Order_transactions.order_id = Order_headers.id 
                                    where Order_headers.status <> 4 and Order_headers.status <> 7 and Order_transactions.status = 1 
                                    and Order_transactions.[date_time] >= ?
                                    and Order_transactions.[date_time] <= ?
                                    GROUP BY Menu_items.name, Menu_items.barcode, Menu_categories.name """;
    List<Map<String, dynamic>> result = await database!.rawQuery(sql, [fromDate, toDate]);
    for (var item in result) {
      report.add(new SalesByItemModel.fromMap(item));
    }
    return report;
  }

  Future<List<SalesByCategoryModel>> salesByCategory(DateTime from, DateTime to) async {
    int fromDate = addOpeningHours(from).toUtc().millisecondsSinceEpoch;
    int toDate = addOpeningHours(to).toUtc().millisecondsSinceEpoch;
    List<SalesByCategoryModel> report = List<SalesByCategoryModel>.empty(growable: true);
    Database? database = await SqliteRepository().db;
    String sql =
        """SELECT IFNULL(Menu_categories.name,'other') AS category, Menu_categories.[index] AS categoryIndex, SUM(Order_transactions.grand_price) AS orderSum,
                                         (Sum(Order_transactions.grand_price)/ (Select Sum(Order_transactions.grand_price) from  Order_transactions INNER JOIN
                                         Order_headers ON Order_transactions.order_id = Order_headers.id
                                         where (Order_headers.status <> 4 and Order_headers.status <> 7) AND Order_transactions.status = 1 and Order_transactions.[date_time] >= ? and Order_transactions.[date_time] <= ?) * 100)  [percentage]   
                                         FROM Menu_items LEFT OUTER JOIN
                                         Menu_categories ON Menu_items.menu_category_id = Menu_categories.id INNER JOIN
                                         Order_transactions ON Menu_items.id = Order_transactions.menu_item_id INNER JOIN
                                         Order_headers ON Order_transactions.order_id = Order_headers.id
                                         where (Order_headers.status <> 4 and Order_headers.status <> 7) AND Order_transactions.status = 1 and Order_transactions.[date_time] >= ? and Order_transactions.[date_time] <= ?
                                         GROUP BY Menu_categories.name, Menu_categories.[index] """;
    List<Map<String, dynamic>> result = await database!.rawQuery(sql, [fromDate, toDate, fromDate, toDate]);
    for (var item in result) {
      report.add(SalesByCategoryModel.fromMap(item));
    }
    return report;
  }

  Future<List<SalesByEmployeeModel>> salesByEmployee(DateTime from, DateTime to) async {
    int fromDate = addOpeningHours(from).toUtc().millisecondsSinceEpoch;
    int toDate = addOpeningHours(to).toUtc().millisecondsSinceEpoch;
    Database? database = await SqliteRepository().db;
    String sql = """ 
     SELECT Order_transactions.employee_id As employeeId, SUM(qty) AS itemsQty, SUM(Order_transactions.grand_price) As sumOrder 
                                                 FROM Order_transactions Inner Join Order_headers As OH ON OH.id = Order_transactions.order_id
                                                WHERE OH.status <> 4 and OH.status <> 7 and (Order_transactions.status = 1) and (order_id IS NOT NULL)
                                                 and Order_transactions.[date_time] >= ? and Order_transactions.[date_time] <= ?
                                                 GROUP BY Order_transactions.employee_id;""";

    List<SalesByEmployeeModel> report1 = List<SalesByEmployeeModel>.empty(growable: true);
    List<SalesByEmployeeModel> report2 = List<SalesByEmployeeModel>.empty(growable: true);

    List<Map<String, dynamic>> result = await database!.rawQuery(sql, [fromDate, toDate]);
    for (var item in result) {
      report1.add(SalesByEmployeeModel.fromMap(item));
    }

    sql = """SELECT Employees.id as employeeId,Employees.name as employee,Count(*) As totalOrder, sum(grand_price) as grandTotal
                                                 FROM Order_headers AS OH INNER JOIN 
                                                 Employees ON OH.employee_id = Employees.id
                                                 where OH.status <> 4 and OH.status <> 7 and OH.[date_time] >= ? and OH.[date_time] <= ?
                                                 Group By  Employees.id,Employees.name;""";

    result = await database.rawQuery(sql, [fromDate, toDate]);
    for (var item in result) {
      report2.add(SalesByEmployeeModel.fromMap(item));
    }

    SalesByEmployeeModel? temp;
    for (var item in report2) {
      temp = report1.firstWhereOrNull((f) => f.employeeId == item.employeeId);
      if (temp != null) {
        temp.totalOrder = item.totalOrder;
        temp.employee = item.employee;
        temp.grandTotal = item.grandTotal;
      }
    }

    return report1;
  }

  Future<List<VoidReportModel>> voidReport(DateTime from, DateTime to) async {
    int fromDate = addOpeningHours(from).toUtc().millisecondsSinceEpoch;
    int toDate = addOpeningHours(to).toUtc().millisecondsSinceEpoch;
    List<VoidReportModel> report = List<VoidReportModel>.empty(growable: true);
    Database? database = await SqliteRepository().db;
    String sql =
        """SELECT Employees.name as employeeName, Order_voids.reasons As reasons, Menu_items.name AS itemName , Order_voids.date_time As date, Order_voids.amount As amount, Order_voids.transacion_id as transaction_id , Order_voids.order_id As orderId
                                    FROM Order_voids LEFT OUTER JOIN 
                                    Order_transactions ON Order_voids.transacion_id = Order_transactions.id LEFT OUTER JOIN 
                                    Menu_items On Menu_items.id = Order_transactions.menu_item_id  LEFT OUTER JOIN 
                                    Order_headers ON Order_voids.order_id = Order_headers.id  LEFT OUTER JOIN
                                    Employees On Employees.id = Order_voids.employee_id
                                    Where Order_voids.date_time >= ? and Order_voids.date_time <= ? """;
    List<Map<String, dynamic>> result = await database!.rawQuery(sql, [fromDate, toDate]);
    for (var item in result) {
      report.add(VoidReportModel.fromMap(item));
    }
    return report;
  }

  Future<List<DriverSummaryModel>> driverSummary(DateTime from, DateTime to) async {
    int fromDate = addOpeningHours(from).toUtc().millisecondsSinceEpoch;
    int toDate = addOpeningHours(to).toUtc().millisecondsSinceEpoch;
    List<DriverSummaryModel> report = List<DriverSummaryModel>.empty(growable: true);
    Database? database = await SqliteRepository().db;
    String sql = """Select Emp.name As name,Sum(OH.grand_price) As orderTotal,COUNT(OH.id) As orderQty,
                                Avg(strftime('%s',(julianday('OH.depature_time') - julianday('OH.arrival_time') ))) AS avgDeliveryTime
                                From Order_headers As OH Left Join Employees As Emp On OH.driver_id = Emp.id
                                Where OH.date_time >= ? and OH.date_time <= ? and OH.driver_id IS NOT NULL
                                group by Emp.name """;
    List<Map<String, dynamic>> result = await database!.rawQuery(sql, [fromDate, toDate]);
    for (var item in result) {
      report.add(DriverSummaryModel.fromMap(item));
    }
    return report;
  }

  Future<List<SalesByHoursModel>> salesByHours(DateTime from, DateTime to) async {
    int fromDate = addOpeningHours(from).toUtc().millisecondsSinceEpoch;
    int toDate = addOpeningHours(to).toUtc().millisecondsSinceEpoch;
    List<SalesByHoursModel> report = List<SalesByHoursModel>.empty(growable: true);
    Database? database = await SqliteRepository().db;
    String sql = """SELECT OH.date_time,sum(OH.grand_price) as orderSum,COUNT(*) as totalOrder
                                       FROM [Order_headers] as OH 
                                       where OH.status <> 4 and OH.status <> 7 and [date_time] >= ? and [date_time] <= ?
                                       group by strftime('%H', datetime(OH.date_time/1000, 'unixepoch')) """;
    List<Map<String, dynamic>> result = await database!.rawQuery(sql, [fromDate, toDate]);
    for (var item in result) {
      report.add(SalesByHoursModel.fromMap(item));
    }

    SalesByHoursModel temp;
    for (var i = 0; i <= 23; i++) {
      if (report.firstWhereOrNull((f) => f.hour == i) == null) {
        temp = SalesByHoursModel();
        temp.hour = i;
        report.add(temp);
      }
    }
    report.sort((a, b) {
      if (b.hour < a.hour) {
        return 1;
      } else if (b.hour > a.hour) {
        return -1;
      }
      return 0;
    });

    return report;
  }

  Future<List<TaxReportModel>> taxReport(DateTime from, DateTime to) async {
    int fromDate = addOpeningHours(from).toUtc().millisecondsSinceEpoch;
    int toDate = addOpeningHours(to).toUtc().millisecondsSinceEpoch;
    List<TaxReportModel> report = List<TaxReportModel>.empty(growable: true);
    Database? database = await SqliteRepository().db;
    String sql =
        """Select tax1 as tax1,Sum(sub_total_price) as transaction_total,Sum(taxable1_amount) as taxable_amount,Sum(total_tax)  as total_tax_amount , (Select tax1_name from preferences where id = 1) as tax1_name
                                from Order_headers  
                                where Order_headers.status <> 4 and status <> 7 and Order_headers.date_time  >= ? and Order_headers.[date_time] <= ? and tax1 > 0
                                Group by tax1""";
    List<Map<String, dynamic>> result = await database!.rawQuery(sql, [fromDate, toDate]);

    TaxReportModel temp;
    for (var item in result) {
      temp = TaxReportModel.fromMap(item);
      // temp.tax1_name =
      report.add(temp);
    }

    sql =
        """Select tax2 as tax1,Sum(sub_total_price) as transaction_total,Sum(taxable2_amount) as taxable_amount,Sum(total_tax2) as total_tax_amount ,(Select tax2_name from preferences where id = 1) as tax1_name
                                    from Order_headers 
                                    where Order_headers.status <> 4 and status <> 7 and Order_headers.date_time  >= ? and Order_headers.date_time <= ? and tax2 > 0
                                    Group by tax2""";
    List<Map<String, dynamic>> result2 = await database.rawQuery(sql, [fromDate, toDate]);
    for (var item in result2) {
      report.add(TaxReportModel.fromMap(item));
    }

    sql =
        """Select tax3 as tax1,Sum(sub_total_price) as transaction_total,Sum(taxable3_amount) as taxable_amount,Sum(total_tax3) as total_tax_amount,(Select tax3_name from preferences where id = 1) as tax1_name
                                    from Order_headers 
                                    where Order_headers.status <> 4 and status <> 7 and Order_headers.date_time  >= ? and Order_headers.date_time <= ? and tax3 > 0
                                    Group by tax3""";
    List<Map<String, dynamic>> result3 = await database.rawQuery(sql, [fromDate, toDate]);
    for (var item in result3) {
      report.add(new TaxReportModel.fromMap(item));
    }

    return report;
  }

  Future<List<CashierReportDetails>> shortOverReport(DateTime from, DateTime to) async {
    int fromDate = addOpeningHours(from).toUtc().millisecondsSinceEpoch;
    int toDate = addOpeningHours(to).toUtc().millisecondsSinceEpoch;
    List<CashierReportDetails> report = List<CashierReportDetails>.empty(growable: true);
    Database? database = await SqliteRepository().db;
    String sql = """Select OP.payment_method_id,CAST(
                         CASE 
                              WHEN OP.payment_method_id Is NULL
                                 THEN 'Account' 
                              ELSE PM.name
                         END AS nvarchar) as Payment_method,
                        (SELECT Sum([Cashier_details].start_amount) FROM [Cashier_details] Inner Join Cashiers  ON Cashiers.id = [Cashier_details].cashier_id where payment_method_id = OP.payment_method_id and Cashiers.cashier_out >= ? and Cashiers.cashier_out <= ?) 
                        as start_amount,
                        (SELECT Sum([Cashier_details].[end_amount]) FROM [Cashier_details] Inner Join Cashiers  ON Cashiers.id = [Cashier_details].cashier_id where payment_method_id = OP.payment_method_id and Cashiers.cashier_out >= ? and Cashiers.cashier_out <= ?) 
                        as end_amount,
                         Sum(OP.amount_paid) As Amount_paid,Sum(OP.amount_paid * OP.rate) As actual_amount_paid 
                         From Order_payments As OP Left Join Payment_methods As PM On PM.id = OP.payment_method_id 
                         Left Join Order_headers As OH ON OH.id = OP.order_id
                         Left Join Cashiers  ON Cashiers.id = OP.cashier_id
                          Left Join Employees  ON Employees.id = Cashiers.employee_id
                         Left Join Cashier_details As details ON OP.cashier_id = details.cashier_id  and OP.payment_method_id = details.payment_method_id
                         Where  OP.payment_method_id Is Not NULL and Cashiers.cashier_out >= ? and Cashiers.cashier_out <= ? and (OP.status Is null Or (OP.status = 0)) and OH.status <> 4
                         Group By OP.payment_method_id,PM.name;""";
    List<Map<String, dynamic>> result = await database!.rawQuery(sql, [fromDate, toDate, fromDate, toDate, fromDate, toDate]);

    for (var item in result) {
      report.add(CashierReportDetails.fromMap(item));
    }
// Credit

    return report;
  }

  Future<List<DailySalesModel>> dailySales(DateTime from, DateTime to) async {
    int fromDate = addOpeningHours(from).toUtc().millisecondsSinceEpoch;
    int toDate = addOpeningHours(to).toUtc().millisecondsSinceEpoch;
    List<DailySalesModel> report = List<DailySalesModel>.empty(growable: true);
    Database? database = await SqliteRepository().db;
    String sql =
        """Select strftime('%Y',START_TIME) as [year], strftime('%m',START_TIME) as [month], strftime('%d',START_TIME) as [day],[order_sum] As orderSum,[total_order] As totalOrder
                                From (Select 
                                CASE 
                                  when  strftime('%H', datetime(OH.date_time/1000, 'unixepoch'))  >= 5 then  datetime(date(datetime(OH.date_time/1000, 'unixepoch')), '+5 hours')
                                  else  datetime(datetime(date(datetime(date_time, 'unixepoch')), '+5 hours'),'-1 day')
                                END START_TIME,
                                CASE 
                                  when  strftime('%H', datetime(OH.date_time/1000, 'unixepoch'))  >= 5 then datetime(datetime(date(datetime(OH.date_time/1000, 'unixepoch')), '+5 hours'),'+1 day')
                                  else datetime(date(datetime(date_time, 'unixepoch')), '+5 hours')
                                END END_TIME
                                ,sum(OH.grand_price) as [order_sum],COUNT(*) as [total_order]
                                FROM [Order_headers] as OH 
                                where OH.status <> 4 and OH.status <> 7 and [date_time] >= ? and [date_time] <= ?
                                group by 
                                CASE 
                                  when  strftime('%H', datetime(OH.date_time/1000, 'unixepoch')) >= 5 then datetime(date(datetime(OH.date_time/1000, 'unixepoch')), '+5 hours')
                                  else datetime(datetime(date(datetime(date_time, 'unixepoch')), '+5 hours'),'-1 day')
                                END,
                                CASE 
                                  when strftime('%H', datetime(OH.date_time/1000, 'unixepoch')) >= 5 then datetime(datetime(date(datetime(OH.date_time/1000, 'unixepoch')), '+5 hours'),'+1 day')
                                  else datetime(date(datetime(date_time, 'unixepoch')), '+5 hours')
                                END) t Order By t.START_TIME""";
    List<Map<String, dynamic>> result = await database!.rawQuery(sql, [fromDate, toDate]);
    for (var item in result) {
      report.add(DailySalesModel.fromMap(item));
    }
    print(result);
    return report;
  }

  Future<List<Orderly>> hourlyOrderList(DateTime from, DateTime to, hour) async {
    int fromDate = addOpeningHours(from).toUtc().millisecondsSinceEpoch;
    int toDate = addOpeningHours(to).toUtc().millisecondsSinceEpoch;
    print(hour);
    List<Orderly> report = List<Orderly>.empty(growable: true);
    Database? database = await SqliteRepository().db;
    String sql = """SELECT id, OH.grand_price 
                                FROM Order_headers AS OH   
                                Where  OH.status <> 4 and OH.status <> 7
                                and strftime('%H', datetime(OH.date_time/1000,'unixepoch', 'localtime')) = ?
                                and [date_time] >= ? and [date_time] <= ?""";
    List<Map<String, dynamic>> result = await database!.rawQuery(sql, [hour, fromDate, toDate]);
    for (var item in result) {
      report.add(Orderly.fromMap(item));
    }
    print(result);
    return report;
  }

  Future<List<Orderly>> dailyOrderList(DateTime from, DateTime to) async {
    int fromDate = addOpeningHours(from).toUtc().millisecondsSinceEpoch;
    int toDate = addOpeningHours(to).toUtc().millisecondsSinceEpoch;
    List<Orderly> report = List<Orderly>.empty(growable: true);
    Database? database = await SqliteRepository().db;
    String sql = """SELECT OH.id, OH.grand_price
                                FROM Order_headers As OH 
                                where OH.status <> 4 and OH.status <> 7 and [date_time] >= ? and [date_time] <= ?""";
    List<Map<String, dynamic>> result = await database!.rawQuery(sql, [fromDate, toDate]);
    for (var item in result) {
      report.add(Orderly.fromMap(item));
    }
    print(result);
    return report;
  }

//orderTotalSales
  Future<List<OrderTotalDetailsModel>> orderTotalDetail(DateTime from, DateTime to) async {
    int fromDate = addOpeningHours(from).toUtc().millisecondsSinceEpoch;
    int toDate = addOpeningHours(to).toUtc().millisecondsSinceEpoch;
    List<OrderTotalDetailsModel> report = List<OrderTotalDetailsModel>.empty(growable: true);
    Database? database = await SqliteRepository().db;
    String sql = """Select Sum(t.Discount) As discount, Sum(t.Surcharge) As surcharge,
                                Sum(t.Sub_Total) As subTotal,
                                Sum(t.minimum_charge) As minimumCharge,
                                Sum(t.delivery_charge) As deliveryCharge,
                                Sum(t.total_charge_per_hour) As chargePerHour,
                                SUM(t.total) As grandTotal,
                                SUM(t.TotalTax + t.TotalTax2) As totalTax,
                                SUM(t.rounding) As totalRounding
                                From (Select OH.discount_actual_amount As Discount,
                                OH.sub_total_price As Sub_Total,
                                OH.min_charge As minimum_charge,
                                OH.surcharge_actual_amount As Surcharge,
                                OH.total_charge_per_hour,
                                OH.delivery_charge,
                                OH.grand_price as total,
                                OH.Rounding * -1 as rounding,
                                OH.total_tax as TotalTax,
                                OH.total_tax2 as TotalTax2
                                From Order_headers As OH  Where OH.status <> 4 and OH.status <> 7 and [date_time] >= ? and 
                                [date_time] < ?) t """;
    List<Map<String, dynamic>> result = await database!.rawQuery(sql, [fromDate, toDate]);
    for (var item in result) {
      report.add(OrderTotalDetailsModel.fromMap(item));
    }
    return report;
  }

//Sales Summary
//category
  Future<List<CategorySalesModel>> categorysales(DateTime from, DateTime to) async {
    int fromDate = addOpeningHours(from).toUtc().millisecondsSinceEpoch;
    int toDate = addOpeningHours(to).toUtc().millisecondsSinceEpoch;
    List<CategorySalesModel> report = List<CategorySalesModel>.empty(growable: true);
    Database? database = await SqliteRepository().db;
    String sql =
        """SELECT IFNULL(Menu_categories.name,'other') AS category,Sum(Order_transactions.qty) as itemQty, Menu_categories.[index] AS Category_index, SUM(Order_transactions.grand_price - tax3_amount) AS orderSum,
                                         (Sum(Order_transactions.grand_price)/ (Select Sum(Order_transactions.grand_price) from  Order_transactions INNER JOIN
                                         Order_headers ON Order_transactions.order_id = Order_headers.id
                                         where (Order_headers.status <> 4 and Order_headers.status <> 7) AND Order_transactions.status = 1 and Order_transactions.[date_time] >= ? and Order_transactions.[date_time] <= ?) * 100)[percentage]   
                                         FROM Menu_items LEFT OUTER JOIN
                                         Menu_categories ON Menu_items.menu_category_id = Menu_categories.id INNER JOIN
                                         Order_transactions ON Menu_items.id = Order_transactions.menu_item_id INNER JOIN
                                         Order_headers ON Order_transactions.order_id = Order_headers.id
                                         where (Order_headers.status <> 4 and Order_headers.status <> 7) AND Order_transactions.status = 1 and Order_transactions.[date_time] >= ? and Order_transactions.[date_time] <= ?
                                         GROUP BY Menu_categories.name, Menu_categories.[index] """;
    List<Map<String, dynamic>> result = await database!.rawQuery(sql, [fromDate, toDate, fromDate, toDate]);
    for (var item in result) {
      report.add(new CategorySalesModel.fromMap(item));
    }
    return report;
  }

  Future<List<PaymentMethodSalesModel>> paymentMethodsales(DateTime from, DateTime to) async {
    int fromDate = addOpeningHours(from).toUtc().millisecondsSinceEpoch;
    int toDate = addOpeningHours(to).toUtc().millisecondsSinceEpoch;
    List<PaymentMethodSalesModel> report = List<PaymentMethodSalesModel>.empty(growable: true);
    Database? database = await SqliteRepository().db;
    String sql = """SELECT Payment_methods.id,case when Payment_methods.name IS NULL Then 'Account'
                                       ELSE Payment_methods.name  End
                                       As name,Count(*) As totalTransaction, 
                                       SUM(Order_payments.amount_paid) AS amountPaid, 
                                       SUM(Order_payments.amount_paid * Order_payments.rate) AS percentage
                                       FROM Order_payments Left JOIN 
                                       Payment_methods ON Order_payments.payment_method_id = Payment_methods.id 
                                       Left Join Order_headers On Order_headers.id = Order_payments.order_id
                                       WHERE (Order_payments.status = 0) and Order_headers.status <> 4 and Order_headers.status <> 7
                                       and Order_payments.date_time >= ? and Order_payments.date_time <= ?
                                       GROUP BY Payment_methods.id,Payment_methods.name """;
    List<Map<String, dynamic>> result = await database!.rawQuery(sql, [fromDate, toDate]);
    for (var item in result) {
      report.add(PaymentMethodSalesModel.fromMap(item));
    }

    return report;
  }

  Future<SummaryModel> summarySales(DateTime from, DateTime to) async {
    int fromDate = addOpeningHours(from).toUtc().millisecondsSinceEpoch;
    int toDate = addOpeningHours(to).toUtc().millisecondsSinceEpoch;
    SummaryModel report = SummaryModel(0, 0, 0, 0, 0, 0, 0, 0);
    Database? database = await SqliteRepository().db;
    String sql = """Select (Select SUM(OT.grand_price) 
		                                                From Order_transactions As OT Inner Join Order_headers As OH ON OH.id = OT.order_id
		                                                Where OH.date_time >= ? and OH.date_time < ? 
		                                                and OT.status = 1 and OH.status <> 4 and OH.status <> 7) As netsale,
                                                    (Select Sum(no_of_guests) from Order_headers Where date_time >=  ? and date_time < ? and status <> 4 and status <> 7) as total_guests,
                                                        (Select SUM(OT.qty) 
		                                                From Order_transactions As OT Inner Join Order_headers As OH ON OH.id = OT.order_id
		                                                Where OH.date_time >= ? and OH.date_time < ? 
		                                                and OT.status = 1 and OH.status <> 4 and OH.status <> 7) As total_qty,
                                                    (select Count(Order_headers.id) From Order_headers  Where date_time >= ? and date_time < ? and status <> 4 and status <> 7) As total_order,
                                                        (Select Sum(discount_actual_price)
                                                        From Order_transactions As OT Inner Join Order_headers As OH ON OH.id = OT.order_id
                                                        Where OH.date_time >= ? and OH.date_time < ? 
                                                        and OT.status = 1 and OH.status <> 4 and OH.status <> 7 and OT.discount_amount > 0) As _item_discount,
                                                        (Select Sum(OT.grand_price)
                                                        From Order_transactions As OT Inner Join Order_headers As OH ON OH.id = OT.order_id
                                                        Where OH.date_time >=? and OH.date_time < ? 
                                                        and OT.status = 1 and OH.status <> 4 and OH.status <> 7) As items_total,
                                                        (select Count(Order_headers.id) From Order_headers  Where date_time >= ? and date_time < ? and status <> 4 and status <> 7) As total_order,
		                                                (Select Sum(amount) from Order_voids Where date_time >= ? and date_time < ?) totalVoids,
		                                                SUM(sub_total_price) As _sub_total_price,SUM(grand_price) As _total,SUM(total_charge_per_hour - (total_charge_per_hour * tax3 / (100+tax3))) As _total_charge_per_hour,Sum(min_charge - (min_charge * tax3 / (100+tax3))) minimumCharge,
	                                                    SUM(delivery_charge - (delivery_charge * tax3 / (100+tax3)))  As totalDeliveryCharge, SUM(discount_actual_amount - (discount_actual_amount * tax3 / (100+tax3)))  As totalDiscount,Sum(Case When surcharge_apply_tax3 = 1 Then surcharge_actual_amount - (surcharge_actual_amount * tax3 / (100+tax3)) Else surcharge_actual_amount End)  As _total_surcharge_amount
                                                        ,SUM(total_tax)  As _total_tax,SUM(total_tax2)  As _total_tax2,SUM(total_tax3)  As totalTax3, Sum(Rounding) As totalRounding
                                                        From Order_headers 
                                                        Where date_time >= ? and date_time < ?  and status <> 4 and status <> 7; """;
    List<Map<String, dynamic>> result = await database!.rawQuery(sql, [
      fromDate,
      toDate,
      fromDate,
      toDate,
      fromDate,
      toDate,
      fromDate,
      toDate,
      fromDate,
      toDate,
      fromDate,
      toDate,
      fromDate,
      toDate,
      fromDate,
      toDate,
      fromDate,
      toDate
    ]);
    for (var item in result) {
      report = new SummaryModel.fromMap(item);
    }
    return report;
  }

  Future<List<DiscountModel>> discountSales(DateTime from, DateTime to) async {
    int fromDate = addOpeningHours(from).toUtc().millisecondsSinceEpoch;
    int toDate = addOpeningHours(to).toUtc().millisecondsSinceEpoch;
    List<DiscountModel> report = List<DiscountModel>.empty(growable: true);
    Database? database = await SqliteRepository().db;
    String sql =
        """SELECT OH.discount_id, IFNULL(Discounts.name,'Other') As name,COUNT(OH.id) as noOfOrders,Sum(discount_actual_amount - (discount_actual_amount * tax3 / (100+tax3))) as discountAmount
                                                                     FROM Order_headers AS OH Left JOIN
                                                                      Discounts ON OH.discount_id = Discounts.id 
                                                                     WHERE OH.discount_amount > 0 and (OH.status <> 4 and OH.status <> 7) and OH.date_time >= ? and OH.date_time <= ?
                                                                     Group by OH.discount_id, Discounts.name """;
    List<Map<String, dynamic>> result = await database!.rawQuery(sql, [fromDate, toDate]);
    for (var item in result) {
      report.add(new DiscountModel.fromMap(item));
    }
    return report;
  }

  Future<List<SalesByItemDetails>> salesByItemDetails(DateTime from, DateTime to) async {
    int fromDate = addOpeningHours(from).toUtc().millisecondsSinceEpoch;
    int toDate = addOpeningHours(to).toUtc().millisecondsSinceEpoch;
    List<SalesByItemDetails> report = List<SalesByItemDetails>.empty(growable: true);
    Database? database = await SqliteRepository().db;
    String sql = """Select Sum(t.Discount) As Discount, Sum(t.Surcharge) As Surcharge,
                                Sum(t.Sub_Total) As SubTotal,
                                Sum(t.minimum_charge) As Minimum_charge,
                                Sum(t.delivery_charge) As Delivery_Charge,
                                Sum(t.total_charge_per_hour) As ChargePerHour,
                                SUM(t.total) As GrandTotal,
                                SUM(t.TotalTax + t.TotalTax2) As TotalTax,
                                SUM(t.rounding) As TotalRounding
                                From (Select OH.discount_actual_amount As Discount,
                                OH.sub_total_price As Sub_Total,
                                OH.min_charge As minimum_charge,
                                OH.surcharge_actual_amount As Surcharge,
                                OH.total_charge_per_hour,
                                OH.delivery_charge,
                                OH.grand_price as total,
                                OH.Rounding * -1 as rounding,
                                OH.total_tax as TotalTax,
                                OH.total_tax2 as TotalTax2
                                From Order_headers As OH  Where OH.status <> 4 and OH.status <> 7 and [date_time] >= ? and 
                                [date_time] < ?) t """;
    List<Map<String, dynamic>> result = await database!.rawQuery(sql, [fromDate, toDate]);
    for (var item in result) {
      report.add(new SalesByItemDetails.fromMap(item));
    }
    return report;
  }

  DateTime addOpeningHours(DateTime dateTime) {
    DateTime? dayStart = locator.get<ConnectionRepository>().preference?.day_start;
    int hour = 5;
    int minute = 0;
    int second = 0;
    if (dayStart != null) {
      hour = dayStart.hour;
      minute = dayStart.minute;
      second = dayStart.second;
    }
    DateTime _date = dateTime;
    _date = _date.add(Duration(hours: -_date.hour + hour));
    _date = _date.add(Duration(minutes: -_date.minute + minute));
    _date = _date.add(Duration(seconds: -_date.second + second));
    return _date;
  }

  Future<DailyClosingModel?> closingSalesReport(DateTime dateTime) async {
    DateTime _date = addOpeningHours(dateTime);

    int fromDate = _date.toUtc().millisecondsSinceEpoch;
    int toDate = _date.add(Duration(days: 1)).toUtc().millisecondsSinceEpoch;

    DailyClosingModel report;
    Database? database = await SqliteRepository().db;
    String sql = """Select (Select SUM(OT.grand_price) 
		                                                From Order_transactions As OT Inner Join Order_headers As OH ON OH.id = OT.order_id
		                                                Where OH.date_time >= ? and OH.date_time < ? 
		                                                and OT.status = 1 and OH.status <> 4 and OH.status <> 7) As Total_Sale,
                                                        (Select Sum(discount_actual_price)
                                                        From Order_transactions As OT Inner Join Order_headers As OH ON OH.id = OT.order_id
                                                        Where OH.date_time >= ? and OH.date_time < ? 
                                                        and OT.status = 1 and OH.status <> 4 and OH.status <> 7 and OT.discount_amount > 0) As item_discount,
                                                        (select Count(Order_headers.id) From Order_headers  Where date_time >= ? and date_time < ? and status <> 4 and status <> 7) As total_order,
		                                                (Select Sum(amount) from Order_voids Where date_time >= ? and date_time < ?) As Total_Void,
		                                                SUM(grand_price) As Total,SUM(total_charge_per_hour) As Total_charge_per_hour,Sum(min_charge) As Total_minimum_charge,
	                                                    SUM(delivery_charge)  As Total_delivery_charge,SUM(discount_actual_amount)  As Total_discount_amount,Sum(surcharge_actual_amount)  As Total_surcharge_amount
                                                        ,SUM(total_tax)  As Total_tax,SUM(total_tax2)  As Total_tax2,SUM(total_tax3)  As Total_tax3, Sum(Rounding) As total_rounding
                                                        From Order_headers 
                                                        Where date_time >= ? and date_time < ?  and status <> 4 and status <> 7;""";
    List<Map<String, dynamic>> result =
        await database!.rawQuery(sql, [fromDate, toDate, fromDate, toDate, fromDate, toDate, fromDate, toDate, fromDate, toDate]);
    report = DailyClosingModel.fromMap(result[0]);

    sql = """Select Count(OH.id) As total_transaction From Cashiers 
                                                          Left Join Order_payments As OP ON Cashiers.id = OP.cashier_id
                                                          Left Join Order_headers As OH ON OH.id = OP.order_id
                                                          where (OP.status Is null Or (OP.status = 0)) and OH.status <> 4
                                                          and OP.date_time > ? and OP.date_time < ?;""";
    List<Map<String, dynamic>> resultCashier = await database.rawQuery(sql, [fromDate, toDate]);
    report.total_transaction = resultCashier[0].values.first;

    sql = """Select Services.alternative As service_name,SUM(grand_price) As total
                                                                                 From Order_headers  Inner Join Services On Order_headers.service_id = Services.id
                                                                                 Where date_time >= ? and date_time < ? and status <> 4 and status <> 7
                                                                                 Group by Services.alternative;""";
    List<Map<String, dynamic>> resultServices = await database.rawQuery(sql, [fromDate, toDate]);
    resultServices.forEach((element) {
      report.serviceReports.add(SalesService.fromMap(element));
    });

    sql =
        """Select Payment_methods.name As Payment_method, Payment_methods.id As Payment_method_id,SUM(OP.amount_paid * OP.rate) As total From Order_payments As OP
                                                                            Inner Join Order_headers on Order_headers.id = OP.order_id
                                                                            Left Join Payment_methods On Payment_methods.id = OP.payment_method_id
                                                                            Where Order_headers.status != 4 and OP.status = 0 and OP.date_time >= ? and OP.date_time < ?
                                                                            Group By Payment_methods.name,Payment_methods.id;""";
    List<Map<String, dynamic>> resultTenders = await database.rawQuery(sql, [fromDate, toDate]);

    resultTenders.forEach((element) {
      report.tenderReports.add(SalesByTender.fromMap(element));
    });

    sql = """Select Cashiers.id,name, Terminals.id As computer_id From Cashiers Inner Join Employees On Cashiers.employee_id = Employees.id
                                                                            Inner Join Terminals On Cashiers.terminal_id = Terminals.id
                                                                            Where cashier_out IS NULL;""";
    List<Map<String, dynamic>> resultTerminal = await database.rawQuery(sql);

    resultTerminal.forEach((element) {
      report.openCashiers.add(OpenCashier.fromMap(element));
    });
    sql = """ Select MC.name As category_name,SUM(OT.grand_price) As total 
		                                                                    From Order_transactions As OT Inner Join Order_headers As OH ON OH.id = OT.order_id
		                                                                    Inner Join Menu_items As MI ON MI.id = OT.menu_item_id Left Join Menu_categories As MC
		                                                                    On MC.id = MI.menu_category_id
		                                                                    Where  OH.date_time >= ? and OH.date_time < ?
		                                                                    and OT.status = 1 and OH.status <> 4 and OH.status <> 7
		                                                                    Group By MC.name;""";
    List<Map<String, dynamic>> resultCategory = await database.rawQuery(sql, [fromDate, toDate]);

    resultCategory.forEach((element) {
      report.categoryReports.add(CategoryReport.fromMap(element));
    });

    sql =
        """Select Order_headers.id, Services.name,Services.alternative,date_time,grand_price from Order_headers Inner Join Services On Order_headers.service_id = Services.id where status = 1 Or status = 2  Or status = 6;""";

    List<Map<String, dynamic>> resultOpenOrder = await database.rawQuery(sql);

    resultOpenOrder.forEach((element) {
      report.openOrders.add(OpenOrder.fromMap(element));
    });

    sql = """Select Sum(no_of_guests) from Order_headers Where date_time >=  ? and date_time < ? and status <> 4 and status <> 7;""";
    List<Map<String, dynamic>> resultGuests = await database.rawQuery(sql, [fromDate, toDate]);

    report.totalGuests = resultGuests[0].values.first != null ? resultGuests[0].values.first : 0;

    report.cashierReports = await cashierReports(fromDate, toDate);

    return report;
  }

  Future<DashBoardModel> dashBoardReport(DateTime dateTime) async {
    DateTime _date = addOpeningHours(dateTime);

    int fromDate = _date.toUtc().millisecondsSinceEpoch;
    int toDate = _date.add(Duration(days: 1)).toUtc().millisecondsSinceEpoch;

    DashBoardModel report = new DashBoardModel();
    Database? database = await SqliteRepository().db;
    String sql = """Select SUM(grand_price) As Total,COUNT(*) AS qty From Order_headers
                                                Where status <> 4 and status <> 7 and 
                                                date_time >= ? and 
                                                date_time < ?""";
    List<Map<String, dynamic>> result = await database!.rawQuery(sql, [
      fromDate,
      toDate,
    ]);
    report = new DashBoardModel.fromMap(result[0]);

    report.employee_report = await salesByEmployee(_date, _date.add(Duration(days: 1)));
    report.service_report = await salesByService(_date, _date.add(Duration(days: 1)));

    DateTime from = _date.add(Duration(days: -5));
    report.daily_report = await dailySales(from, _date.add(Duration(days: 1)));
    return report;
  }

  Future<List<CashierModel>?> getCashiers(DateTime dateTime) async {
    DateTime _date = addOpeningHours(dateTime);

    int fromDate = _date.toUtc().millisecondsSinceEpoch;
    int toDate = _date.add(Duration(days: 1)).toUtc().millisecondsSinceEpoch;

    List<CashierModel> report = List<CashierModel>.empty(growable: true);
    Database? database = await SqliteRepository().db;
    String sql = """SELECT [Cashiers].[id],[employee_id],[cashier_in],[cashier_out],Employees.name,terminal_id
                               FROM [Cashiers] Inner Join Employees On Cashiers.employee_id = Employees.id
                               Where [cashier_out] >= ? and [cashier_out] <= ? ;""";
    List<Map<String, dynamic>> result = await database!.rawQuery(sql, [fromDate, toDate]);
    if (result.length > 0)
      for (var item in result) {
        report.add(CashierModel.fromMap(item));
      }

    //cashierDetailReport(report.first.id);
    return report;
  }

  @override
  Future<CashierReportModel?> cashierDetailReport(id) async {
    CashierReportModel report =
        CashierReportModel(categoryReports: [], credit_payments: [], details: [], forignCurrency: [], local_currency: [], other_tenders: []);
    Database? database = await SqliteRepository().db;

    String sql =
        """Select Cashiers.id,Emp.name, ApproveEmp.name As approvedBy,cashier_in,cashier_out, Cashiers.start_amount ,Count(OH.id) As Total_Transactions,
                                              Sum(OP.amount_paid * OP.rate) As Total_Sale From Cashiers 
                                              Left Join Order_payments As OP ON Cashiers.id = OP.cashier_id
                                              Left Join Order_headers As OH ON OH.id = OP.order_id
                                              Inner Join Employees As Emp ON Emp.id = Cashiers.employee_id
                                              Left Join Employees As ApproveEmp ON ApproveEmp.id = Cashiers.approved_employee_id
                                              where Cashiers.id = ?  and  (OP.status Is null Or (OP.status = 0)) and OH.status <> 4 and OH.status <> 7
                                              Group By Cashiers.id,Emp.name, ApproveEmp.name,cashier_in,cashier_out, Cashiers.start_amount ;""";

    List<Map<String, dynamic>> resultReport = await database!.rawQuery(sql, [id]);

    if (resultReport.isEmpty) {
      sql =
          """Select Cashiers.id,Emp.name, ApproveEmp.name As approvedBy,cashier_in,cashier_out, Cashiers.start_amount ,Count(Cashiers.id) As Total_Transactions,
                                              Sum(OP.amount_paid * OP.rate) As Total_Sale From Cashiers 
                                              Left Join Order_payments As OP ON Cashiers.id = OP.cashier_id
                                              Inner Join Employees As Emp ON Emp.id = Cashiers.employee_id
                                              Left Join Employees As ApproveEmp ON ApproveEmp.id = Cashiers.approved_employee_id
                                              where Cashiers.id = ? and  (OP.status Is null Or (OP.status = 0))
                                              Group By Cashiers.id,Emp.name, ApproveEmp.name,cashier_in,cashier_out, Cashiers.start_amount;""";

      resultReport = await database.rawQuery(sql, [id]);
    }
    if (resultReport.isNotEmpty) {
      report = CashierReportModel.fromMap(resultReport[0]);
    } else {
      return null;
    }

    sql = """Select MC.name As category_name, SUM(OT.grand_price) As total 
                                                                            From Order_transactions As OT Inner Join Order_headers As OH ON OH.id = OT.order_id 
                                                                            Inner Join Menu_items As MI ON MI.id = OT.menu_item_id
                                                                            Left Join Menu_categories As MC On MC.id = MI.menu_category_id
                                                                            Where OT.status = 1 and OH.id IN (Select order_id from Order_payments Where cashier_id = ? and (status Is null Or (status = 0)))  and OH.status = 3
                                                                            Group By MC.name;""";

    List<Map<String, dynamic>> resultCategory = await database.rawQuery(sql, [id]);
    resultCategory.forEach((element) {
      report.categoryReports.add(CategoryCashier.fromMap(element));
    });

    sql = """Select  SUM(total_charge_per_hour) As Total_charge_per_hour,Sum(min_charge) As Total_minimum_charge,
                       SUM(delivery_charge)  As Total_delivery_charge,SUM(discount_actual_amount)  As Total_discount_amount,Sum(surcharge_actual_amount)  As Total_surcharge_amount
                       ,SUM(total_tax)  As Total_tax,SUM(total_tax2)  As Total_tax2, Sum(Rounding) As total_rounding
                        From Order_headers 
                        Where id IN (Select order_id from Order_payments Where cashier_id = ? and (status Is null Or (status = 0))) and status <> 4 and status <> 7;""";

    List<Map<String, dynamic>> resultOrder = await database.rawQuery(sql, [id]);

    report.ordersDetails = new OrdersDetails.fromMap(resultOrder[0]);

    sql = """Select OP.payment_method_id,CAST(
                         CASE 
                              WHEN OP.payment_method_id Is NULL
                                 THEN 'Account' 
                              ELSE PM.name
                         END AS nvarchar) as Payment_method,details.start_amount,details.end_amount,COUNT(OP.id) As count,Sum(OP.amount_paid) As Amount_paid,Sum(OP.amount_paid * OP.rate) As actual_amount_paid 
                         From Order_payments As OP Left Join Payment_methods As PM On PM.id = OP.payment_method_id 
                         Left Join Order_headers As OH ON OH.id = OP.order_id
                         Left Join Cashier_details As details ON OP.cashier_id = details.cashier_id  and OP.payment_method_id = details.payment_method_id
                         Where OP.cashier_id = ? and  (OP.status Is null Or (OP.status = 0)) and OH.status <> 4 and OH.status <> 7
                         Group By OP.payment_method_id,PM.name,details.start_amount,details.end_amount;""";

    List<Map<String, dynamic>> resultCashierDetails = await database.rawQuery(sql, [id]);

    resultCashierDetails.forEach((element) {
      report.details.add(CashierReportDetails.fromMap(element));
    });

    print(resultCashierDetails);
    return report;
  }

  Future<List<CashierReportModel>> cashierReports(int fromDate, int toDate) async {
    List<CashierReportModel> report = List<CashierReportModel>.empty(growable: true);
    CashierReportModel cashierReport =
        CashierReportModel(categoryReports: [], credit_payments: [], details: [], forignCurrency: [], local_currency: [], other_tenders: []);
    Database? database = await SqliteRepository().db;
    String ids = "";
    String sql = """Select Cashiers.id,Emp.name,cashier_in,cashier_out, Cashiers.start_amount ,Count(OH.id) As Total_Transactions,
                                              Sum(OP.amount_paid * OP.rate) As Total_Sale From Cashiers 
                                              Left Join Order_payments As OP ON Cashiers.id = OP.cashier_id   
                                              Left Join Order_headers As OH ON OH.id = OP.order_id and OH.status <> 4 and OH.status <> 7
                                              Inner Join Employees As Emp ON Emp.id = Cashiers.employee_id
                                              where Cashiers.cashier_out >= ? and Cashiers.cashier_out < ? and  (OP.status Is null Or (OP.status = 0)) and OH.status <> 4
                                              Group By Cashiers.id,Emp.name,cashier_in,cashier_out, Cashiers.start_amount;""";
    List<Map<String, dynamic>> result = await database!.rawQuery(sql, [fromDate, toDate]);
    if (result.isEmpty) {
      sql = """Select Cashiers.id,Emp.name,cashier_in,cashier_out, Cashiers.start_amount ,Count(OP.id) As Total_Transactions,
                                              Sum(OP.amount_paid * OP.rate) As Total_Sale From Cashiers 
                                              Left Join Order_payments As OP ON Cashiers.id = OP.cashier_id   
                                              Inner Join Employees As Emp ON Emp.id = Cashiers.employee_id
                                              where Cashiers.cashier_out >= ? and Cashiers.cashier_out < ? and  (OP.status Is null Or (OP.status = 0)) 
                                              Group By Cashiers.id,Emp.name,cashier_in,cashier_out, Cashiers.start_amount""";

      result = await database.rawQuery(sql, [fromDate, toDate]);
    }

    result.forEach((element) {
      report.add(CashierReportModel.fromMap(element));
      ids += element['id'].toString() + ",";
    });
    if (ids != "") ids = ids.substring(0, ids.length - 1);
    print(ids);
    // sql = """Select MC.name As category_name, SUM(OT.grand_price) As total
    //                                                                         From Order_transactions As OT Inner Join Order_headers As OH ON OH.id = OT.order_id
    //                                                                         Inner Join Menu_items As MI ON MI.id = OT.menu_item_id
    //                                                                         Left Join Menu_categories As MC On MC.id = MI.menu_category_id
    //                                                                         Where OT.status = 1 and OH.id IN (Select order_id from Order_payments Where cashier_id IN (?)  and (status Is null Or (status = 0)))  and OH.status = 3
    //                                                                         Group By MC.name;""";

    // List<Map<String, dynamic>> resultCategory =
    //     await database.rawQuery(sql, [ids]);
    // for (var item in resultCategory) {
    //   cashierReport = report.where((f) => f.id == item[0].cashier_id).first;
    //   if (cashierReport != null)
    //     cashierReport.categoryReports.add(CategoryCashier.fromMap(item));
    // }

    if (ids != "") {
      sql = """Select  OP.cashier_id,OP.payment_method_id,CAST(
                         CASE 
                              WHEN OP.payment_method_id Is NULL
                                 THEN 'Account' 
                              ELSE PM.name
                         END AS nvarchar) as Payment_method,details.start_amount,details.end_amount,COUNT(OP.id) As count,Sum(OP.amount_paid) As Amount_paid,Sum(OP.amount_paid * OP.rate) As actual_amount_paid 
                         From Order_payments As OP Left Join Payment_methods As PM On PM.id = OP.payment_method_id 
                         Left Join Order_headers As OH ON OH.id = OP.order_id
                         Left Join Cashier_details As details ON OP.cashier_id = details.cashier_id and OP.payment_method_id = details.payment_method_id
                         Where OP.cashier_id IN (?) and (OP.status Is null Or (OP.status = 0)) and OH.status <> 4 and OH.status <> 7
                         Group By OP.cashier_id,OP.payment_method_id,PM.name,details.start_amount,details.end_amount""";

      List<Map<String, dynamic>> resultCashierDetails = await database.rawQuery(sql, [ids]);

      List<CashierReportDetails> listTemp = List<CashierReportDetails>.empty(growable: true);
      for (var item in resultCashierDetails) {
        listTemp.add(CashierReportDetails.fromMap(item));
      }

      for (var item in listTemp) {
        cashierReport = report.where((f) => f.id == item.cashier_id).first;
        if (cashierReport != null) cashierReport.details.add(item);
      }
    }

    return report;
  }
}
