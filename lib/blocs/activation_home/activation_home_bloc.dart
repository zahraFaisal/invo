import 'dart:async';

import 'package:invo_mobile/blocs/connect_page/connect_event.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/blocs/navigator/navigator_event.dart';
import './activation_home_event.dart';

import '../blockBase.dart';

class ActivationHomeBloc implements BlocBase {
  final NavigatorBloc _navigationBloc;

  final _eventController = StreamController<ActivationHomeEvent>.broadcast();
  Sink<ActivationHomeEvent> get eventSink => _eventController.sink;

  ActivationHomeBloc(this._navigationBloc) {
    _eventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(ActivationHomeEvent event) {
    if (event is GoToActivationRegisterPage) {
      // _navigationBloc.navigateToActivationRegisterPage();
      _navigationBloc.navigatorSink.add(NavigateToActivationRegisterPage());
    } else if (event is GoToActivationFormPage) {
      // _navigationBloc.navigateToActivationForm();
      _navigationBloc.navigatorSink.add(NavigateToActivationFormPage());
    } else if (event is GoBack) {
      _navigationBloc.navigatorSink.add(NavigateToConnectionPage());
    }
  }

  @override
  void dispose() {
    _eventController.close();
    // TODO: implement dispose
  }
}
