import 'dart:async';

import 'package:invo_mobile/blocs/cashier_report/cashier_report_page_event.dart';

import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/blocs/navigator/navigator_event.dart';
import 'package:invo_mobile/models/preference.dart';
import 'package:invo_mobile/models/reports/CashierReportModel.dart';
import 'package:invo_mobile/models/terminal.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:invo_mobile/services/Print/PrintService.dart';

import '../blockBase.dart';
import '../property.dart';

class CashierReportPageBloc extends BlocBase {
  final NavigatorBloc _navigationBloc;
  final _eventController = StreamController<CashierReportPageEvent>.broadcast();
  Sink<CashierReportPageEvent> get eventSink => _eventController.sink;
  Preference? preference;

  CashierReportPageBloc(this._navigationBloc) {
    _eventController.stream.listen(_mapEventToState);
    _eventController.sink.add(CashierReportLoadReport(DateTime.now()));

    preference = locator.get<ConnectionRepository>().preference;
  }

  Property<CashierReportModel> model = new Property<CashierReportModel>();
  Property<List<CashierModel>> modelList = new Property<List<CashierModel>>();

  @override
  void dispose() {
    _eventController.close();
    model.dispose();
    modelList.dispose();
    // TODO: implement dispose
  }

  void _mapEventToState(CashierReportPageEvent event) async {
    if (event is CashierReportPageGoBack) {
      _navigationBloc.navigatorSink.add(PopUp());
    } else if (event is CashierReportLoadReport) {
      List<CashierModel>? temp = await locator.get<ConnectionRepository>().reportService!.getCashiers(event.date);
      modelList.sinkValue(temp!);
    } else if (event is CashierReportDetailsLoadReport) {
      CashierReportModel? temp = await locator.get<ConnectionRepository>().reportService?.cashierDetailReport(event.id);
      model.sinkValue(temp!);
    } else if (event is PrintCashierReport) {
      Terminal? terminal = locator.get<ConnectionRepository>().terminal;

      PrintService printService = PrintService(terminal!);

      if (terminal.bluetoothPrinter == "") {
        printService.printCashierReport(model.value!);
      } else {
        printService.printCashierReport(model.value!);
      }
    }
  }
}
