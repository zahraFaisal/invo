import 'dart:convert';

import 'package:invo_mobile/models/custom/cloud_request.dart';
import 'package:invo_mobile/models/custom/discount_list.dart';
import 'package:invo_mobile/models/discount.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:socket_io_client/socket_io_client.dart';

class DiscountCloud {
  processRequest(request, websocket) {
    List<String> list = request.request.split(':');
    switch (list[1]) {
      case "list":
        this.getDiscounts(request, websocket);
        break;
      case "get":
        this.getDiscount(request, websocket);
        break;
      case "save":
        this.saveDiscount(request, websocket);
        break;
      default:
        break;
    }
  }

  Future<bool> getDiscounts(CloudRequest request, Socket websocket) async {
    List<DiscountList>? list = await locator.get<ConnectionRepository>().discountService!.getActiveList();
    if (list!.length > 0) {
      List<Map<String, dynamic>> result = List<Map<String, dynamic>>.empty(growable: true);
      list.forEach((element) {
        result.add(element.toMap());
      });

      print(jsonEncode(result).toString());
      request.data = jsonEncode(result).toString();
      websocket.emit("response", jsonEncode(request.toJson()));
      return true;
    } else {
      request.data = '[]';
      websocket.emit("response", jsonEncode(request.toJson()));
      return false;
    }
  }

  Future<bool> getDiscount(CloudRequest request, Socket websocket) async {
    int id = int.parse(request.param);
    Discount? list = await locator.get<ConnectionRepository>().discountService!.get(id);
    if (list != null) {
      Map<String, dynamic> result = new Map<String, dynamic>();
      result = list.toMapRequest();

      print(jsonEncode(result).toString());

      request.data = jsonEncode(result).toString();
      websocket.emit("response", jsonEncode(request.toJson()));
      return true;
    } else {
      request.data = '[]';
      websocket.emit("response", jsonEncode(request.toJson()));
      return false;
    }
  }

  Future<bool> saveDiscount(CloudRequest request, Socket websocket) async {
    print("discount");
    print(request.param);
    Map<String, dynamic> temp = json.decode(request.param);
    Discount discount = Discount.fromJson(temp);
    locator.get<ConnectionRepository>().discountService?.save(discount);
    request.data = '{"status":"Success","msg":"Successfully saved"}';
    websocket.emit("response", jsonEncode(request.toJson()));
    return true;
  }
}
