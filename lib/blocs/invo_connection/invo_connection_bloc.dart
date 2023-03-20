import 'dart:async';

import 'package:invo_mobile/blocs/blockBase.dart';
import 'package:invo_mobile/blocs/invo_connection/invo_connection_events.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/blocs/navigator/navigator_event.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/repositories/invo_connection_repository.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'invo_connection_state.dart';

class InvoConnectionBloc extends BlocBase {
  NavigatorBloc? _navigationBloc;

  final _currentStateStateController = StreamController<InvoConnectionState>.broadcast();
  StreamSink<InvoConnectionState> get _currentStateSink => _currentStateStateController.sink;
  Stream<InvoConnectionState> get currentStateStream => _currentStateStateController.stream;

  //event
  final _eventController = StreamController<InvoConnectionEvent>.broadcast();
  Sink<InvoConnectionEvent> get invoConnectionEventSink => _eventController.sink;

  InvoConnectionBloc(NavigatorBloc navigationBloc) {
    _navigationBloc = navigationBloc;
    _eventController.stream.listen(_mapEventToState);

    if (locator.isRegistered<ConnectionRepository>()) locator.unregister<ConnectionRepository>();

    locator.registerSingleton<ConnectionRepository>(new InvoConnectionRepository());

    locator.get<ConnectionRepository>().progress = (progress) {
      _currentStateSink.add(IsLoading(progress: progress));
    };
  }

  void _mapEventToState(InvoConnectionEvent event) async {
    print("event is :" + event.toString());

    if (event is ConnectButtonPressed) {
      try {
        _currentStateSink.add(IsLoading());

        String ip = event.part1! + "." + event.part2! + "." + event.part3! + "." + event.part4!;
        bool resault = await locator.get<ConnectionRepository>().connect(ip: ip);

        if (resault) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          print(await prefs.setString("Invo_IP", ip));
          prefs.setString("connectionType", "INVO");

          _navigationBloc?.navigatorSink.add(NavigateToHomePage());
        } else {
          if (locator.get<ConnectionRepository>().httpRequestError != null && locator.get<ConnectionRepository>().httpRequestError != "")
            // ignore: curly_braces_in_flow_control_structures
            _currentStateSink.add(ConnectionError(locator.get<ConnectionRepository>().httpRequestError!));
          else {
            _currentStateSink.add(InitState());
          }
        }
      } catch (e) {
        print(e.toString());
        // _currentStateSink.add(ConnectionError(e.toString()));
        _currentStateSink.add(ConnectionError("Cannot Connect , Please check your connection"));
      }
    } else if (event is ConnectionGoBack) {
      _navigationBloc?.navigatorSink.add(NavigateToConnectionPage());
    } else {
      _currentStateSink.add(InitState());
    }
  }

  @override
  void dispose() {
    _currentStateStateController.close();
    _eventController.close();
    locator.get<ConnectionRepository>().progress = null;
  }
}
