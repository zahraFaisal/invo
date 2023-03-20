import 'package:invo_mobile/models/custom/mini_order.dart';
import 'package:invo_mobile/models/discount.dart';
import 'package:invo_mobile/models/order/order_header.dart';
import 'package:invo_mobile/models/pending_status.dart';
import 'package:invo_mobile/models/service_order.dart';
import 'package:invo_mobile/models/surcharge.dart';

abstract class IOrderService {
  Future<List<MiniOrder>> fetchServiceOrder(int serviceId);

  Future<List<MiniOrder>?>? fetchServicePaidOrders(int serviceId, DateTime _date);

  Future<List<MiniOrder>?>? fetchPendingOrders();

  Future<List<ServiceOrder>> fetchServicesOrders();

  Future<List<MiniOrder>?> fetchAllOrders(DateTime startDate, DateTime endDate, String searchText, int service, int status);

  Future<int>? fetchTodayOrdersCount(DateTime startDate, DateTime endDate);
  Future<OrderHeader> fetchFullOrder(int orderId);
  Future<OrderHeader?> fetchFullPendingOrder(int orderId);
  Future<List<OrderHeader>> loadOrders(int tableId);
  Future<OrderHeader?> saveOrder(OrderHeader order);
  Future<OrderHeader> savePendingOrder(OrderHeader order);
  Future<List<PendingStatus>> getPendingStatus();
  void updatePendingStatus(List<PendingStatus> pendingStatus);
  Future<OrderHeader>? getByGUID(String GUID);
  Future<List<OrderHeader>> saveOrders(List<OrderHeader> orders);
  void removePendingOrder(int id);
  void rejectPendingOrder(String order_GUID, int pendingId);
  void acceptPendingOrder(String orderGUID, int id, int ticket_number);
  Future<bool> voidOrder(OrderHeader order, int employeeId, String reason, bool waste);

  Future<bool> discountOrder(OrderHeader order, Discount discount, int employeeId);

  Future<bool> surchargeOrder(OrderHeader order, Surcharge surcharge);

  Future<bool> payOrder(OrderHeader order, bool complete);

  void updatePrintedItem(OrderHeader order) {}
  Future<bool> isSettled(guid);
}
