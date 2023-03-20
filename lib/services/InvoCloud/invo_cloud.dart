import 'package:invo_mobile/models/custom/cloud_request.dart';
import 'package:invo_mobile/services/InvoCloud/Employee/EmployeeCloud.dart';
import 'package:invo_mobile/services/InvoCloud/Employee/RoleCloud.dart';
import 'package:invo_mobile/services/InvoCloud/Menu/DiscountCloud.dart';
import 'package:invo_mobile/services/InvoCloud/Menu/MenuCategoryCloud.dart';
import 'package:invo_mobile/services/InvoCloud/Menu/MenuItemCloud.dart';
import 'package:invo_mobile/services/InvoCloud/Menu/MenuBuilderCloud.dart';
import 'package:invo_mobile/services/InvoCloud/Menu/MenuModifierCloud.dart';
import 'package:invo_mobile/services/InvoCloud/Menu/PriceLabelCloud.dart';
import 'package:invo_mobile/services/InvoCloud/Menu/PriceManagementCloud.dart';
import 'package:invo_mobile/services/InvoCloud/Menu/SurchargeCloud.dart';
import 'package:invo_mobile/services/InvoCloud/Report/ReportCloud.dart';

class InvoCloud {
  late CloudRequest request;
  sendRequest(req, websocket) {
    DateTime date = DateTime.now();
    CloudRequest request = new CloudRequest.fromJson(req);
    String temp = request.from;
    request.from = request.to;
    request.to = temp;
    //Future<List<OrderDetails>> details;
    //Invo.Lib.Data.ReportData ReportData = new Invo.Lib.Data.ReportData();
    //report reportTemp;
    //dateParam x;

    if (request.request.startsWith("menuItems")) {
      new MenuItemCloud().processRequest(request, websocket);
      return;
    } else if (request.request.startsWith("menuBuilder")) {
      new MenuBilderCloud().processRequest(request, websocket);
      return;
    } else if (request.request.startsWith("priceLabels")) {
      new PriceLabelCloud().processRequest(request, websocket);
      return;
    } else if (request.request.startsWith("discounts")) {
      new DiscountCloud().processRequest(request, websocket);
      return;
    } else if (request.request.startsWith("surcharges")) {
      new SurchargeCloud().processRequest(request, websocket);
      return;
    } else if (request.request.startsWith("employees")) {
      new EmployeeCloud().processRequest(request, websocket);
      return;
    } else if (request.request.startsWith("roles")) {
      new RoleCloud().processRequest(request, websocket);
      return;
    } else if (request.request.startsWith("menuCategories")) {
      new MenuCategoryCloud().processRequest(request, websocket);
      return;
    } else if (request.request.startsWith("menuModifiers")) {
      new MenuModifierCloud().processRequest(request, websocket);
      return;
    } else if (request.request.startsWith("priceManagments")) {
      new PriceManagementCloud().processRequest(request, websocket);
      return;
    } else if (request.request.startsWith("dailySalesReport")) {
      new ReportCloud().dailyClosingReportRequest(request, websocket);
    } else if (request.request.startsWith("cashierReport")) {
      new ReportCloud().cashierReportRequest(request, websocket);
    } else if (request.request.startsWith("getCashiers")) {
      new ReportCloud().getCashiers(request, websocket);
    } else if (request.request.startsWith("salesSummary")) {
      new ReportCloud().salesSummary(request, websocket);
    } else if (request.request.startsWith("dailySales")) {
      new ReportCloud().dailySaleReport(request, websocket);
    } else if (request.request.startsWith("hourlySales")) {
      new ReportCloud().hourlySaleReport(request, websocket);
    } else if (request.request.startsWith("salesByService")) {
      new ReportCloud().salesByServiceReport(request, websocket);
    } else if (request.request.startsWith("salesByTable")) {
      new ReportCloud().salesByTableReport(request, websocket);
    } else if (request.request.startsWith("salesByTableGroups")) {
      new ReportCloud().salesByTableGroupReport(request, websocket);
    } else if (request.request.startsWith("salesByItem")) {
      new ReportCloud().salesByItemsReport(request, websocket);
    } else if (request.request.startsWith("salesByCategory")) {
      new ReportCloud().salesByCategoryReport(request, websocket);
    } else if (request.request.startsWith("TaxReport")) {
      new ReportCloud().taxReport(request, websocket);
    } else if (request.request.startsWith("salesByEmployee")) {
      new ReportCloud().salesByEmployeeReport(request, websocket);
    } else if (request.request.startsWith("voidReport")) {
      new ReportCloud().voidReport(request, websocket);
    } else if (request.request.startsWith("driverReportSummary")) {
      new ReportCloud().driverReportSummaryReport(request, websocket);
    } else if (request.request.startsWith("hourlyOrderList")) {
      new ReportCloud().hourlyOrderListReport(request, websocket);
    } else if (request.request.startsWith("dailyOrderList")) {
      new ReportCloud().dailyOrderListReport(request, websocket);
    } else if (request.request.startsWith("order")) {
      new ReportCloud().fetchFullOrderRequest(request, websocket);
    }
  }
}
