import 'dart:async';

import 'package:invo_mobile/blocs/blockBase.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/blocs/property.dart';
import 'package:invo_mobile/models/preference.dart';
import 'package:invo_mobile/models/reports/DashBoardReportModel.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/service_locator.dart';

import 'dash_board_page_event.dart';

class DashboardPageBloc implements BlocBase {
  final NavigatorBloc _navigationBloc;
  final _eventController = StreamController<DashBoardPageEvent>.broadcast();
  Sink<DashBoardPageEvent> get eventSink => _eventController.sink;
  Preference? preference;
  Property<DashBoardModel> model = new Property<DashBoardModel>();
  DashboardPageBloc(this._navigationBloc) {
    _eventController.stream.listen(_mapEventToState);
    _eventController.sink.add(DashBoardLoadReport(DateTime.now()));
    preference = locator.get<ConnectionRepository>().preference;
  }

  void _mapEventToState(DashBoardPageEvent event) async {
    if (event is DashBoardLoadReport) {
      DashBoardModel temp = await locator.get<ConnectionRepository>().reportService!.dashBoardReport(event.date);
      model.sinkValue(temp);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _eventController.close();
  }
}
