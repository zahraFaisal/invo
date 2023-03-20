import 'dart:async';

import 'package:invo_mobile/blocs/daily_report/daily_report_page_event.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/blocs/navigator/navigator_event.dart';
import 'package:invo_mobile/models/preference.dart';
import 'package:invo_mobile/models/reports/DailyClosingModel.dart';
import 'package:invo_mobile/models/terminal.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:invo_mobile/services/Print/PrintService.dart';

import '../blockBase.dart';
import '../property.dart';

class DailyReportPageBloc extends BlocBase {
  final NavigatorBloc _navigationBloc;
  final _eventController = StreamController<DailyReportPageEvent>.broadcast();
  Sink<DailyReportPageEvent> get eventSink => _eventController.sink;
  Preference? preference;

  DailyReportPageBloc(this._navigationBloc) {
    _eventController.stream.listen(_mapEventToState);
    _eventController.sink.add(DailyReportLoadReport(DateTime.now()));
    preference = locator.get<ConnectionRepository>().preference!;
  }

  Property<DailyClosingModel> model = new Property<DailyClosingModel>();

  @override
  void dispose() {
    _eventController.close();
    model.dispose();
    // TODO: implement dispose
  }

  void _mapEventToState(DailyReportPageEvent event) async {
    if (event is DailyReportPageGoBack) {
      _navigationBloc.navigatorSink.add(PopUp());
    } else if (event is DailyReportLoadReport) {
      DailyClosingModel? temp = await locator.get<ConnectionRepository>().reportService!.closingSalesReport(event.date);
      model.sinkValue(temp!);
    } else if (event is PrintDailyClosingReport) {
      Terminal? terminal = locator.get<ConnectionRepository>().terminal;

      PrintService printService = new PrintService(terminal!);

      printService.printDailyClosingReport(model.value!, preference!, event.date_time);
      /* if (terminal.bluetoothPrinter == "") {
            //await locator.get<ConnectionRepository>().printDailyClosingReport();
          } else {
            
          } */

    }
  }
}
