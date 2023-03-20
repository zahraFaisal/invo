import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'dart:typed_data';
import 'package:invo_mobile/blocs/property.dart';
import 'package:invo_mobile/models/customer/customer_contact.dart';
import 'package:invo_mobile/models/order/customer_reference.dart';
import 'package:invo_mobile/models/order/order_transaction.dart';
import 'package:invo_mobile/models/pending_status.dart';
import 'package:invo_mobile/models/preference.dart';
import 'package:invo_mobile/models/terminal.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:invo_mobile/services/InvoCloud/invo_cloud.dart';
import 'package:invo_mobile/services/InvoCloud/sync_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart' as http;
import 'package:invo_mobile/models/order/order_request.dart';
import 'package:invo_mobile/models/order/order_status.dart';
import 'package:invo_mobile/models/order/employee_reference.dart';
import 'package:invo_mobile/models/customer/customer.dart';
import 'package:invo_mobile/models/employee.dart';
import 'package:invo_mobile/models/order/order_header.dart';

import '../Print/PrintService.dart';

class WebSocketIO {
  late String ip;
  late String deviceId;
  late Map<String, String> headers;
  late SharedPreferences prefs;
  late String? slug, name, password;
  late String? server;
  late SyncData syncData = new SyncData();
  late Property<bool> online = new Property<bool>();
  late ConnectionRepository connectionRepository = locator.get<ConnectionRepository>();
  late String branchToken;
  Socket? socket;
  late Timer timer;

  WebSocketIO() {
    online.setValue(false);
  }

  loadPerf() async {
    headers = new Map<String, String>();
    headers["Content-Type"] = "application/json";
  }

  void load() async {
    if (!await authenticateBranch()) return;

    if (socket != null) {
      socket!.dispose();
      socket = null;
    }
    online.setValue(false);

    syncData.syncInvo(branchToken, server!);
    socket = io(
        server,
        OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .enableReconnection() // for Flutter or Dart VM
            .build());
    socket!.onConnect((_) {
      online.setValue(true);
      print('socket connect');
      socket!.emit("authenticate_mobile_branch", branchToken);
      socket!.emit("get_pending_orders", branchToken);
    });

    socket!.onDisconnect((data) {
      online.sinkValue(false);
    });

    timer = new Timer.periodic(const Duration(seconds: 15), check);

    socket!.on("request", (req) {
      InvoCloud invoCloud = new InvoCloud();
      invoCloud.sendRequest(req, socket);
    });

    socket!.on("requestUTF8", (req) {
      Utf8Codec outputAsUint8List = new Utf8Codec();
      String res = outputAsUint8List.decode(req);

      Map<String, dynamic> data = new Map<String, dynamic>();
      data = json.decode(res.replaceAll(r'', ''));

      InvoCloud invoCloud = new InvoCloud();
      invoCloud.sendRequest(data, socket);
    });

    socket!.on("void_orderUTF8", (req) async {
      try {
        Utf8Codec outputAsUint8List = new Utf8Codec();
        String res = outputAsUint8List.decode(req);

        Map<String, dynamic> data = new Map<String, dynamic>();
        data = json.decode(res.replaceAll(r'', ''));

        ConnectionRepository connectionRepository = locator.get<ConnectionRepository>();
        int employeeId = 1;
        if (data['void_employee'] != null) {
          // employeeId = data['void_employee']['_id'];

          Employee? employee = await connectionRepository.employeeService!.getEmployeeByName(data['void_employee']['name']);
          employeeId = employee!.id;
        }
        bool response = await connectionRepository.orderService!
            .voidOrder(await connectionRepository.orderService!.fetchFullOrder(data['id']), employeeId, data['void_reason'], true);
      } catch (e) {
        print(e.toString());
      }
    });

    socket!.on("save_orderUTF8", (req) async {
      Utf8Codec outputAsUint8List = new Utf8Codec();
      String x = outputAsUint8List.decode(req);
      x = x.replaceAll(r'', '');
      Map<String, dynamic> temp = json.decode(x);
      ConnectionRepository connectionRepository = locator.get<ConnectionRepository>();
      OrderRequest request = OrderRequest.fromMap(temp);
      Customer? customerByphone = await connectionRepository.customerService!.getByPhone(request.order!.customer_contact!);
      if (customerByphone == null) {
        customerByphone = Customer(addresses: [], contacts: [], id_number: 0, name: '');
      }

      request.order!.customer_id_number = customerByphone.id_number_;
      request.order!.customer!.id_number = customerByphone.id_number_;
      if (request.order!.customer != null) {
        if (request.order!.customer_id_number != null && request.order!.customer_id_number! > 0) {
          //update customer
          await connectionRepository.customerService!.save(customerByphone);
        } else {
          List<dynamic> contact = List<dynamic>.empty(growable: true);
          Map<String, dynamic> contactTemp = {"contact": request.order!.customer_contact, "id": 0, "type": 1, "customer_id_number": 0};
          contact.add(contactTemp);
          Map<String, dynamic> customer = {
            'name': request.order!.customer!.name,
            'contacts': contact,
          };
          Customer newCustomer = new Customer.fromMap(customer);
          await connectionRepository.customerService!.save(newCustomer);
          request.order!.customer_id_number = newCustomer.id_number;
          request.order!.customer!.id_number = newCustomer.id_number;
        }
      }

      int employeeId = 0;
      if (request.order!.employee != null) {
        Employee? employee = await connectionRepository.employeeService!.getEmployeeByName(request.order!.employee!.name);
        employeeId = employee!.id;
        request.order!.employee_id = employeeId;
        request.order!.employee!.id = employeeId;
      } else {
        request.order!.employee_id = 1;
        request.order!.employee!.id = 1;
      }

      for (var item in request.order!.transaction.where((f) => f.Just_Voided)) {
        if (item.EmployeeVoid_id != null) {
          Employee? employeeByName = await connectionRepository.employeeService!.getEmployeeByName(item.void_employee!.name);
        } else {
          employeeId = 1;
        }
        item.EmployeeVoid_id = employeeId;
        item.Is_Changed = true;
      }

      request.order!.note = "Order From Call Center \r\n ${request.order!.note}";
      request.order!.calculateItemTotal();
      OrderHeader? _order = await locator.get<ConnectionRepository>().saveOrder(request.order!);

      OrderStatus orderStatus = new OrderStatus();

      if (request.order!.id == 0) {
        OrderHeader? mini = await connectionRepository.orderService!.getByGUID(request.order!.GUID);
        orderStatus.id = mini!.id;
        orderStatus.ticket_number = mini.ticket_number!;
      } else {
        orderStatus.id = request.order!.id;
        orderStatus.ticket_number = request.order!.ticket_number!;
      }

      orderStatus.transactions = List<OrderTransaction>.empty(growable: true);
      for (var item in _order!.transaction) {
        orderStatus.transactions!.add(OrderTransaction.fromMap({'GUID': item.GUID, 'id': item.id, 'status': 2}));
      }

      orderStatus.branch_token = branchToken;
      orderStatus.status = request.order!.status!;
      orderStatus.GUID = request.order!.GUID;

      socket!.emit("updateOrderStatus", jsonEncode(orderStatus.toMap()).toString());
    });

    socket!.on("save_pending_order", (req) async {
      String s = new String.fromCharCodes(req);
      s = s.replaceAll(r'', '');
      await savePendingOrder(s);
    });

    socket!.on('connect', (_) {
      online.sinkValue(true);
      print("connect: " + _.toString());
    });

    socket!.on('connect_error', (_) => print("connect_error: " + _.toString()));
    socket!.on('exception', (_) => print('Exception: $_'));

    socket!.on('connect_timeout', (_) => print("connect_timeout: " + _.toString()));
    // socket.on('connecting', (_) => print("connecting: " + _.toString()));
    socket!.on('error', (_) => print("error: " + _.toString()));
    socket!.on('reconnect', (_) {
      online.setValue(true);
      print("reconnect: " + _.toString());
    });
    socket!.on('reconnect_attempt', (_) => print("reconnect_attempt: " + _.toString()));
    socket!.on('reconnect_failed', (_) => print("reconnect_failed: " + _.toString()));
    socket!.on('reconnecting', (_) => print("reconnecting: " + _.toString()));
    // socket.on('ping', (_) => print("ping: " + _.toString()));
    // socket.on('pong', (_) => print("pong: " + _.toString()));
    //
    // socket.on('event', (data) {
    //   print("event");
    //   print(data);
    // });
    //socket.onDisconnect((_) => socket.connect());
    // socket.on('fromServer', (_) => print(_));
  }

  void check(Timer timer) {
    checkChanges();
  }

  //every 15 second
  Future<void> checkChanges() async {
    if (socket == null) return;
    ConnectionRepository connectionRepository = locator.get<ConnectionRepository>();
    List<PendingStatus> pendingStatus = await connectionRepository.orderService!.getPendingStatus();

    //exit if empty
    if (pendingStatus != null && pendingStatus.length > 0) {
      for (var item in pendingStatus) {
        if (item.type == 4) //rejected order
        {
          OrderStatus orderStatusTemp = OrderStatus.fromJson(jsonDecode(item.status));
          OrderStatus orderStatus = new OrderStatus();
          orderStatus.id = 0;
          orderStatus.ticket_number = 0;
          orderStatus.branch_token = this.branchToken;
          orderStatus.status = 3; //rejected
          orderStatus.GUID = orderStatusTemp.GUID;
          socket!.emit("updateOnlineOrderStatus", jsonEncode(orderStatus.toMap()).toString());
        }
        if (item.type == 5) //accepted order
        {
          OrderStatus orderStatusTemp = OrderStatus.fromJson(jsonDecode(item.status));
          OrderStatus orderStatus = new OrderStatus();
          orderStatus.branch_token = this.branchToken;
          orderStatus.id = orderStatusTemp.id;
          orderStatus.ticket_number = orderStatusTemp.ticket_number;
          orderStatus.status = 2; //accepted
          orderStatus.GUID = orderStatusTemp.GUID;
          socket!.emit("updateOnlineOrderStatus", jsonEncode(orderStatus.toMap()).toString());
        } else {
          Map temp = jsonDecode(item.status);
          OrderStatus orderStatus = new OrderStatus();
          orderStatus.id_ = temp['server_id'] ?? "";
          if (item.type == 3) orderStatus.status = 3;
          orderStatus.depature_time = temp['depature_time'];
          orderStatus.arrival_time = temp['arrival_time'];
          orderStatus.driver = temp['driver'];
          orderStatus.branch_token = this.branchToken;
          socket!.emit("updateOrderStatusById", jsonEncode(orderStatus.toMap()).toString());
        }
      }

      //update the value
      connectionRepository.orderService!.updatePendingStatus(pendingStatus);
    }
  }

  Future<void> savePendingOrder(String req) async {
    Map<String, dynamic> temp = json.decode(req);
    ConnectionRepository connectionRepository = locator.get<ConnectionRepository>();
    OrderRequest request = new OrderRequest.fromMap(temp);
    Customer? customerByphone = await connectionRepository.customerService!.getByPhone(request.order!.customer_contact!);

    if (customerByphone != null) request.order?.customer_id_number = customerByphone.id_number_;
    if (request.order!.customer != null && customerByphone != null) request.order!.customer!.id_number = customerByphone.id_number_;
    if (request.order!.customer != null) {
      if (request.order!.customer_id_number != null && request.order!.customer_id_number! > 0 && customerByphone != null) {
        //update customer
        await connectionRepository.customerService!.save(customerByphone);
      } else {
        List<dynamic> contact = List<dynamic>.empty(growable: true);
        Map<String, dynamic> contactTemp = {"contact": request.order!.customer_contact, "id": null, "type": 1, "customer_id_number": 0};
        contact.add(contactTemp);
        Map<String, dynamic> customer = {
          'name': request.order!.customer!.name,
          'contacts': contact,
        };
        Customer newCustomer = Customer.fromMap(customer);
        await connectionRepository.customerService!.save(newCustomer);
        request.order!.customer_id_number = newCustomer.id_number_;
        request.order!.customer!.id_number = newCustomer.id_number_;
        request.order!.customer!.name = newCustomer.name;
      }
    }

    int employeeId;
    try {
      if (request.order!.employee != null) {
        Employee? employee = await connectionRepository.employeeService!.getEmployeeByName(request.order!.employee!.name);
        employeeId = employee!.id;
        request.order!.employee_id = employeeId;
        request.order!.employee!.id = employeeId;
      } else {
        request.order!.employee_id = 1;
      }
    } catch (Exception) {
      request.order!.employee_id = 1;
    }

    request.order!.date_time = DateTime.now();
    await connectionRepository.orderService!.savePendingOrder(request.order!);

    OrderStatus orderStatus =
        OrderStatus(id: 0, ticket_number: request.order!.ticket_number!, status: 1, GUID: request.order!.GUID, branch_token: this.branchToken);
    if (socket != null) {
      socket!.emit("updateOnlineOrderStatus", jsonEncode(orderStatus.toMap()).toString());
    }
  }

  Future authenticateBranch() async {
    await loadPerf();

    // server = connectionRepository.preference!.server;
    // slug = connectionRepository.preference!.restSlug;
    // name = connectionRepository.preference!.branch_name;
    // password = connectionRepository.preference!.password;

    Preference? preference = await connectionRepository.preferenceService!.get();
    server = preference!.server;
    password = preference.password;
    name = preference.branch_name;
    slug = preference.restSlug;
    var json = <String, dynamic>{
      "slug": slug == null ? "" : slug,
      "name": name == null ? "" : name,
      "password": password == null ? "" : password,
    };

    final response = await http.post(Uri.parse("$server/api/authenticate.branch"), body: jsonEncode(json), headers: this.headers).catchError((error) {
      print(error);
    });

    if (response == null) {
      return false;
    }
    if (response.statusCode == 200) {
      if (response.body == "") {
        return false;
      }
      print(jsonDecode(response.body));
      Map<String, dynamic> res = jsonDecode(response.body);
      branchToken = res['token'];

      return true;
      // If server returns an OK response, parse the JSON.
    } else {
      print("error");
      // If that response was not OK, throw an error.
      // throw Exception('Failed to load post');
      return false;
    }
  }

  // void acceptOnlineOrder(String orderGUID, int id, int ticket_number) {
  //   OrderStatus orderStatus = new OrderStatus(
  //       id: id,
  //       ticket_number: ticket_number,
  //       status: 2,
  //       GUID: orderGUID,
  //       branch_token: this.branchToken);

  //   if (socket != null) {
  //     print("test");
  //     socket.emit("updateOnlineOrderStatus",
  //         jsonEncode(orderStatus.toMap()).toString());
  //   }
  // }
}
