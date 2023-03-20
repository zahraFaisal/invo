import 'dart:async';
import 'dart:convert';

import 'package:android_plugin/android_plugin_method_channel.dart';
import 'package:invo_mobile/blocs/property.dart';
import 'package:invo_mobile/blocs/settle_page/settle_page_event.dart';
import 'package:invo_mobile/helpers/dialog_service.dart';
import 'package:invo_mobile/models/Number.dart';
import 'package:invo_mobile/models/global.dart';
import 'package:invo_mobile/models/order/order_header.dart';
import 'package:invo_mobile/models/order/order_payment.dart';
import 'package:invo_mobile/models/payment_method.dart';
import 'package:invo_mobile/models/terminal.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/services/Print/PrintService.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../service_locator.dart';
import '../blockBase.dart';
import 'package:flutter/material.dart';

import 'package:invo_mobile/widgets/translation/app_localizations.dart';

class CrediMaxResponse {
  String respCode;
  String respMsg;
  String amount;
  String messNo;
  String pan;
  String approval;

  CrediMaxResponse({
    required this.respCode,
    required this.respMsg,
    required this.amount,
    required this.messNo,
    required this.pan,
    required this.approval,
  });

  factory CrediMaxResponse.fromJson(Map<String, dynamic> json) {
    return CrediMaxResponse(
      respCode: json['RespCode'],
      respMsg: json['RespMsg'],
      amount: json['Amount'],
      messNo: json['MessNo'],
      pan: json['Pan'],
      approval: json['Approval'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'RespCode': respCode,
      'RespMsg': respMsg,
      'Amount': amount,
      'MessNo': messNo,
      'Pan': pan,
      'Approval': approval,
    };
  }
}

class SettlePageBloc implements BlocBase {
  Property<List<double>> priceSuggestion = new Property<List<double>>();
  Property<List<PaymentMethod>> methods = new Property<List<PaymentMethod>>();
  Property<List<OrderPayment>> payments = new Property<List<OrderPayment>>();

  Property<bool> finish = new Property<bool>();
  final _eventController = StreamController<SettlePageEvent>.broadcast();
  Sink<SettlePageEvent> get eventSink => _eventController.sink;

  OrderHeader? orderHeader;
  ConnectionRepository? connection;

  SettlePageBloc(this.orderHeader) {
    connection = locator.get<ConnectionRepository>();
    setSuggestionPrices();
    loadPaymentMethods();
    payments.sinkValue(orderHeader!.payments);
    _eventController.stream.listen(_mapEventToState);
  }

  setSuggestionPrices() {
    orderHeader!.calculateAmountTendered();
    double balance = this.orderHeader!.amountBalance; //change with balance
    List<double> _suggestion = List<double>.empty(growable: true);
    var temp = balance.toStringAsFixed(3);
    _suggestion.add(double.parse(temp));
    double price = balance;
    for (var i = 0; i < 5; i++) {
      price = calculatePrice(price);
      _suggestion.add(price);
    }

    priceSuggestion.sinkValue(_suggestion);
  }

  calculatePrice(double price) {
    try {
      if (price % 0.5 > 0) //if number has decimal point more than 0 and not equal 0.5
        return (price / 0.5).ceil().toDouble() * 0.5;
      else if ((price / 0.5) % 2 == 1) //if number had decimal point 0.5
        return price + 0.5;
      else if (price % 5 > 0) //if number is not multiple of 5
        return (price / 5).ceil().toDouble() * 5;
      else //if (Price % 5 == 0)  //if number is multiple of 5
        return price + 5;
    } catch (e) {
      return 0;
    }
  }

  void loadPaymentMethods() async {
    List<PaymentMethod> _methods = await connection!.paymentMethodService!.getAll() ?? [];
    methods.sinkValue(_methods);
  }

  void _mapEventToState(SettlePageEvent event) async {
    String? lang = locator.get<ConnectionRepository>().terminal!.getLangauge();
    AppLocalizations appLocalizations = await AppLocalizations.load(Locale(lang!));

    if (event is MethodClicked) {
      bool isSettled = await connection!.orderService!.isSettled(orderHeader!.GUID);
      String resault;

      if (orderHeader!.status != 6 && isSettled) //isSettled() Select status from Order_headers where GUID ='" + guid + "'" 3 => true else => false
      {
        //already paid
        locator.get<DialogService>().showDialog(appLocalizations.translate("Order"), appLocalizations.translate("Already Paid"), cancelButton: appLocalizations.translate("Cancel"));
        return;
      }

      if (event.method.type == 0) {
        event.method.type = 1;
      }

      if (event.method.settings != null && event.method.name == "CrediMax ECR") {
        if (Number.getDouble(orderHeader!.grand_price) > Number.getDouble(orderHeader!.amountTendered)) {
          if (event.paymentAmount * event.method.rate > Number.getDouble(orderHeader!.amountBalance)) {
            await locator.get<DialogService>().showDialog(appLocalizations.translate("Order"), appLocalizations.translate("Over Tendered"), cancelButton: appLocalizations.translate("Cancel"));
            return;
          }
        }

        MethodChannelAndroidPlugin methodChannelCrediMaxEcr = MethodChannelAndroidPlugin();
        try {
          methodChannelCrediMaxEcr.messageStream.listen((ecrEvent) async {
            if (ecrEvent.isEmpty) {
              debugPrint("event is empty");
            } else {
              CrediMaxResponse res = CrediMaxResponse.fromJson(json.decode(ecrEvent));

              if (res.respCode == "00") {
                //success
                resault = orderHeader!.addPayment(
                  event.paymentAmount,
                  event.method,
                  locator.get<Global>().authCashier!.id,
                  locator.get<Global>().authEmployee!.id,
                  reference: json.encode(res.toJson()),
                );
                completePayment(true);
              } else {
                debugPrint("request code: " + res.amount);
                await locator.get<DialogService>().showDialog("Response error", res.respMsg);
              }
            }
          });

          //get CrediMax termianlID
          final prefs = await SharedPreferences.getInstance();
          String? crediMaxTerminalId = prefs.getString("crediMaxTerminalId");
          if (crediMaxTerminalId == null || crediMaxTerminalId == "") {
            //show warning msg
            showToast("Terminal id has not been set", duration: const Duration(seconds: 2), backgroundColor: Colors.red, radius: 5, textStyle: TextStyle(color: Colors.white, fontSize: 22), position: ToastPosition(align: Alignment.topCenter, offset: -10));

            return;
          }
          //Change price format
          String price = (event.paymentAmount).toStringAsFixed(3);
          double amount = double.parse(price) * 1000;
          price = amount.toStringAsFixed(0);

          debugPrint("transType: 01");
          debugPrint("amount: " + price);
          debugPrint("ecrRefNo: " + orderHeader!.id.toString());
          debugPrint("tid: " + crediMaxTerminalId!);
          String? res = await methodChannelCrediMaxEcr.getAuthRequest("01", price, orderHeader!.id.toString(), crediMaxTerminalId!);

          if (res != null) {
            debugPrint("result is " + res);

            //showToast("status: " + res, duration: Duration(seconds: 10), backgroundColor: Colors.red, radius: 5, textStyle: TextStyle(color: Colors.white, fontSize: 22), position: ToastPosition(align: Alignment.topCenter, offset: -10));

            //change isrufund to refund status
            for (var item in orderHeader!.payments.where((element) => element.status == 2)) {
              item.status = 1;
            }
          } else {
            debugPrint("result: is null");
          }
        } catch (e) {
          showToast("status: " + e.toString(), duration: const Duration(seconds: 2), backgroundColor: Colors.red, radius: 5, textStyle: TextStyle(color: Colors.white, fontSize: 22), position: ToastPosition(align: Alignment.topCenter, offset: -10));

          debugPrint("error " + e.toString());
        }
        return;
      }

      //check for verfication code and save the resault

      if (event.method.type == 2 && (event.method.verification_required != null && event.method.verification_required == true)) {
        String verificationCode;
        if (event.method.verification_only_numerical) {
          verificationCode = await locator<DialogService>().showNumberDialog(NumberDialogRequest(title: "Enter Code"));
        } else {
          verificationCode = await locator<DialogService>().noteDialog(appLocalizations.translate("Enter Code"));
        }

        if (verificationCode == null || verificationCode == "") return;

        //check if verfication not exists

        resault = orderHeader!.addPayment(event.paymentAmount, event.method, locator.get<Global>().authCashier!.id, locator.get<Global>().authEmployee!.id, reference: verificationCode);
      } else {
        resault = orderHeader!.addPayment(
          event.paymentAmount,
          event.method,
          locator.get<Global>().authCashier!.id,
          locator.get<Global>().authEmployee!.id,
        );
      }

      if (resault == "complete") {
        completePayment(true);
      } else if (resault == "over_tendered") {
        //msg Over Tendered
        locator.get<DialogService>().showDialog(appLocalizations.translate("Order"), appLocalizations.translate("Over Tendered"), cancelButton: appLocalizations.translate("Cancel"));
        return;
      } else {
        setSuggestionPrices();
        payments.sinkValue(orderHeader!.payments);
        orderHeader!.footerUpdate.sinkValue(true);
      }
    } else if (event is CancelPayment) {
      if (event.payment.id == 0) {
        orderHeader!.payments.remove(event.payment);
        setSuggestionPrices();
        payments.sinkValue(orderHeader!.payments);
        orderHeader!.footerUpdate.sinkValue(true);
      }
    } else if (event is ConfirmPayment) {
      bool complete = (Number.getDouble(orderHeader!.amountChange) >= 0 && Number.getDouble(orderHeader!.amountBalance) <= 0);
      completePayment(complete);
    }
  }

  void completePayment(bool complete) async {
    print("complete payment");

    Terminal? terminal = locator.get<ConnectionRepository>().terminal;
    PrintService printService = new PrintService(terminal!);
    printService.openDrawer();

    if (complete) {
      orderHeader?.status = 3;
    }

    await finish.sinkValue(complete);
  }

  var payment_method_validation = null;
  var payment_amount_validation = null;

  Future<bool> asyncValidateForm(amount, method) async {
    payment_method_validation = null;
    payment_amount_validation = null;

    if (method == null) {
      payment_method_validation = "Value must be Entered";
      return false;
    }

    if (amount == null) {
      payment_amount_validation = "Value must be Entered";
      return false;
    }

    return true;
  }

  @override
  void dispose() {
    _eventController.close();
    finish.dispose();
    priceSuggestion.dispose();
    methods.dispose();
    payments.dispose();
  }
}
