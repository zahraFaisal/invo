import 'dart:async';
import 'package:invo_mobile/blocs/cashier_function/cashier_function_event.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/blocs/navigator/navigator_event.dart';
import 'package:invo_mobile/blocs/property.dart';
import 'package:invo_mobile/helpers/dialog_service.dart';
import 'package:invo_mobile/models/cashier.dart';
import 'package:invo_mobile/models/cashier_detail.dart';
import 'package:invo_mobile/models/global.dart';
import 'package:invo_mobile/models/payment_method.dart';
import 'package:invo_mobile/models/preference.dart';
import 'package:invo_mobile/models/reports/CashierReportModel.dart';
import 'package:invo_mobile/models/reports/SalesSummaryModels.dart';
import 'package:invo_mobile/models/terminal.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:invo_mobile/services/Print/PrintService.dart';
import '../blockBase.dart';
import 'package:collection/collection.dart';
import 'package:invo_mobile/blocs/main/main_bloc.dart';

class CashierFunctionBloc implements BlocBase {
  final NavigatorBloc? _navigationBloc;
  MainBloc mainBloc = locator.get<MainBloc>();

  Property<List<LocalCurrency>> localcurrencies = Property<List<LocalCurrency>>();
  Property<List<ForigenCurrency>> forigenCurrencies = Property<List<ForigenCurrency>>();
  Property<List<OtherTender>> otherTenders = Property<List<OtherTender>>();
  Property<bool> otherCurrency = Property<bool>();
  double extraCash = 0;
  Property<CashierReportModel> model = Property<CashierReportModel>();
  final _eventController = StreamController<CashierFunctionPageEvent>.broadcast();
  Sink<CashierFunctionPageEvent> get eventSink => _eventController.sink;
  Preference? preference;
  Cashier? cashier;
  ConnectionRepository? connectionRepository;
  CashierFunctionBloc(this._navigationBloc) {
    connectionRepository = locator.get<ConnectionRepository>();
    _eventController.stream.listen(_mapEventToState);
    localcurrencies.sinkValue(List<LocalCurrency>.empty(growable: true));
    forigenCurrencies.sinkValue(List<ForigenCurrency>.empty(growable: true));
    otherTenders.sinkValue(List<OtherTender>.empty(growable: true));
    preference = locator.get<ConnectionRepository>().preference;
    var _localcurrencies = List<LocalCurrency>.empty(growable: true);
    if (preference!.money_count != "" && preference!.money_count != null) {
      var list = preference!.money_count.split(",");
      list.forEach((element) {
        if (element != "") _localcurrencies.add(LocalCurrency(double.parse(element)));
      });
    } else {
      _localcurrencies.add(LocalCurrency(1000));
      _localcurrencies.add(LocalCurrency(500));
      _localcurrencies.add(LocalCurrency(200));
      _localcurrencies.add(LocalCurrency(100));
      _localcurrencies.add(LocalCurrency(50));
      _localcurrencies.add(LocalCurrency(25));
      _localcurrencies.add(LocalCurrency(20));
      _localcurrencies.add(LocalCurrency(10));
      _localcurrencies.add(LocalCurrency(5));
      _localcurrencies.add(LocalCurrency(1));
      _localcurrencies.add(LocalCurrency(0.5));
      _localcurrencies.add(LocalCurrency(0.1));
      _localcurrencies.add(LocalCurrency(0.05));
      _localcurrencies.add(LocalCurrency(0.025));
      _localcurrencies.add(LocalCurrency(0.01));
    }
    localcurrencies.sinkValue(_localcurrencies);

    loadForigenCurruncies();
    loadCashier();
  }

  loadCashier() async {
    if (locator.get<Global>().authCashier != null) if (locator.get<Global>().authCashier!.id > 0) {
      cashier = await connectionRepository!.cashierService!.get(locator.get<Global>().authCashier!.id);
    }
    loadCashierReport();
  }

  Future<void> loadCashierReport() async {
    int id = locator.get<Global>().authCashier == null ? 0 : locator.get<Global>().authCashier!.id;
    CashierReportModel? temp = await locator.get<ConnectionRepository>().reportService!.cashierDetailReport(id);
    model.sinkValue(temp);
  }

  loadForigenCurruncies() async {
    ConnectionRepository connectionRepository = locator.get<ConnectionRepository>();
    var _forigenCurrencies = List<ForigenCurrency>.empty(growable: true);
    var _otherTenders = List<OtherTender>.empty(growable: true);
    List<PaymentMethod>? paymentMethods = await connectionRepository.paymentMethodService!.getAll();
    if (paymentMethods != null)
      for (var item in paymentMethods) {
        if (item.id == 1) continue;
        if (item.type == 1)
          _forigenCurrencies.add(ForigenCurrency(item));
        else
          _otherTenders.add(OtherTender(item));
      }

    forigenCurrencies.sinkValue(_forigenCurrencies);
    otherTenders.sinkValue(_otherTenders);

    otherCurrency.sinkValue(_forigenCurrencies.length > 0 || _otherTenders.length > 0);
  }

  double get total {
    double _total = extraCash;
    for (var item in localcurrencies.value!) {
      _total += item.amount;
    }

    for (var item in forigenCurrencies.value!) {
      _total += item.equivalant;
    }

    for (var item in otherTenders.value!) {
      _total += item.amount;
    }
    return _total;
  }

  double localCurrencyTotal = 0.0;

  double otherTenderTotal = 0.0;

  double forignCurrencyTotal = 0.0;

  void _mapEventToState(CashierFunctionPageEvent event) async {
    if (event is CancelCashierFunction) {
      _navigationBloc!.navigatorSink.add(PopUp());
    } else if (event is SaveCashier) {
      locator.get<DialogService>().showLoadingProgressDialog();
      double total = 0;
      for (var item in event.details) {
        total += item.total;
      }

      Terminal terminal = locator.get<ConnectionRepository>().terminal!;

      PrintService printService = new PrintService(terminal);

      if (cashier == null) {
        // cashier in
        cashier = Cashier(
          id: 0,
          terminal_id: locator.get<ConnectionRepository>().terminal!.id,
          employee_id: locator.get<Global>().authEmployee!.id,
          cashier_in: DateTime.now(),
          start_amount: total,
          end_amount: 0,
          variance_amount: 0,
        );

        CashierReportModel temp = CashierReportModel(
          name: locator.get<Global>().authEmployee!.name != null || locator.get<Global>().authEmployee!.name != ""
              ? locator.get<Global>().authEmployee!.name
              : "",
          terminal_id: locator.get<ConnectionRepository>().terminal!.id,
          employee_id: locator.get<Global>().authEmployee!.id,
          extra_cash: extraCash,
          cashier_in: DateTime.now(),
          categoryReports: [],
          credit_payments: [],
          details: [],
          forignCurrency: [],
          local_currency: [],
          other_tenders: [],
        );
        if (otherTenders.value != null) {
          for (var element in otherTenders.value!) {
            temp.other_tenders.add(OtherTenders.fromMap(element.toMap()));
            otherTenderTotal += element.amount;
          }
        }

        if (forigenCurrencies.value != null) {
          for (var element in forigenCurrencies.value!) {
            temp.forignCurrency.add(ForigenCurrencys.fromMap(element.toMap()));
            forignCurrencyTotal += (element.amount * element.method.rate);
          }
        }

        if (localcurrencies.value != null) {
          for (var element in localcurrencies.value!) {
            temp.local_currency.add(LocalCurrencys.fromMap(element.toMap()));
            localCurrencyTotal += (element.qty * element.type);
          }
        }
        temp.count = total == null ? 0 : total;

        if (terminal.bluetoothPrinter == "") {
          printService.printCashierReport(temp, isCashIn: true);
        } else {
          printService.printCashierReport(temp, isCashIn: true);
        }

        cashier!.details = List<CashierDetail>.empty(growable: true);
        for (var item in event.details) {
          cashier!.details!.add(
            CashierDetail(
              payment_method_id: item.method!.id,
              rate: item.method!.rate,
              start_amount: item.total,
            ),
          );
        }
      } else {
        // cashier out
        cashier!.end_amount = total;
        cashier!.cashier_out = DateTime.now();
        otherTenders.value?.forEach((element) {
          otherTenderTotal += element.amount;
        });

        forigenCurrencies.value?.forEach((element) {
          forignCurrencyTotal += (element.amount * element.method.rate);
        });

        localcurrencies.value?.forEach((element) {
          localCurrencyTotal += (element.qty * element.type);
        });
        CashierDetail? tempDetail;
        if (cashier!.details == null) {
          cashier!.details = List<CashierDetail>.empty(growable: true);
        }
        for (var item in event.details) {
          tempDetail = cashier!.details!.firstWhereOrNull((f) => f.payment_method_id == item.method!.id);

          if (tempDetail == null) {
            cashier!.details!.add(
              CashierDetail(
                payment_method_id: item.method!.id,
                rate: item.method!.rate,
                start_amount: cashier!.start_amount!,
                end_amount: item.total,
              ),
            );
          } else {
            tempDetail.end_amount = item.total;
          }
        }
        CashierDetail? tempModel;
        if (model.value != null)
          for (var item in model.value!.combine) {
            tempModel = cashier!.details!.firstWhereOrNull((element) => element.payment_method_id == item.payment_method_id);
            if (tempModel != null) {
              item.end_amount = tempModel.end_amount;
            }
          }
      }
      bool cashier_in = false;
      if (cashier!.cashier_out == null) {
        cashier_in = true;
      }

      cashier = await connectionRepository!.cashierService!.save(cashier!);
      locator.get<DialogService>().closeDialog();
      if (cashier == null) {
        //show error msg
        print("Cashier is NULL");
        return;
      }

      if (cashier_in) {
        locator.get<Global>().setCashier(cashier!);
        mainBloc.authCashier.sinkValue(cashier);
      } else {
        _eventController.sink.add(PrintCashier());
        locator.get<Global>().setCashier(null);
        cashier!.cashier_out = null;
        mainBloc.authCashier.sinkValue(cashier);
      }
    } else if (event is PrintCashier) {
      Terminal? terminal = locator.get<ConnectionRepository>().terminal;

      PrintService printService = new PrintService(terminal!);
      CashierReportModel? temp = await locator.get<ConnectionRepository>().reportService!.cashierDetailReport(cashier!.id);

      otherTenders.value?.forEach((element) {
        temp!.other_tenders.add(OtherTenders.fromMap(element.toMap()));
      });

      forigenCurrencies.value?.forEach((element) {
        temp!.forignCurrency.add(ForigenCurrencys.fromMap(element.toMap()));
      });

      localcurrencies.value?.forEach((element) {
        temp!.local_currency.add(LocalCurrencys.fromMap(element.toMap()));
      });

      temp!.extra_cash = extraCash == null ? 0 : extraCash;
      temp.count = total == null ? 0 : total;

      if (terminal.bluetoothPrinter == "") {
        printService.printCashierReport(temp, isCashIn: true);
      } else {
        printService.printCashierReport(temp, isCashIn: true);
      }
    }
  }

  @override
  void dispose() {
    _eventController.close();
    localcurrencies.dispose();
    forigenCurrencies.dispose();
    otherTenders.dispose();
    otherCurrency.dispose();
    // TODO: implement dispose
  }
}

class LocalCurrency {
  int qty = 0;
  double type = 0;
  double get amount {
    return qty * type;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'qty': qty, 'type': type};
    return map;
  }

  LocalCurrency(this.type);
}

class ForigenCurrency {
  double amount = 0;
  PaymentMethod method;
  double get equivalant {
    return amount * method.rate;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'amount': amount, 'payment_method': method, 'rate': method.rate};
    return map;
  }

  ForigenCurrency(this.method);
}

class OtherTender {
  double amount = 0;
  PaymentMethod? method;
  OtherTender.fromMap(Map<String, dynamic> map) {
    amount = map['amount'];
    method = map['payment_method'];
  }
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'amount': amount,
      'payment_method': method,
    };
    return map;
  }

  OtherTender(this.method);
}
