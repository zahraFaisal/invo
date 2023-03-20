import 'dart:async';
import 'dart:ui';
import 'package:invo_mobile/blocs/blockBase.dart';
import 'package:invo_mobile/blocs/home_page/home_page_events.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/blocs/navigator/navigator_event.dart';
import 'package:invo_mobile/blocs/property.dart';
import 'package:invo_mobile/helpers/priviligers.dart';
import 'package:invo_mobile/models/Service.dart';
import 'package:invo_mobile/models/service_order.dart';
import 'package:invo_mobile/models/terminal.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/services/Print/PrintService.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../service_locator.dart';
import 'package:invo_mobile/models/custom/messages.dart';
import 'package:invo_mobile/models/custom/mini_order.dart';
import 'package:flutter_sound/flutter_sound.dart' as sound;
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
// import 'package:flutter_text_to_speech/flutter_text_to_speech.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:invo_mobile/models/preference.dart';
import 'package:invo_mobile/blocs/main/main_bloc.dart';
import 'package:collection/collection.dart';

import '../blockBase.dart';
import 'dart:convert';
import 'package:flutter/rendering.dart';

class HomePageBloc implements BlocBase {
  NavigatorBloc? _navigationBloc;
  Timer? serviceOrderTimer;
  Property<bool> isINVOConnection = Property<bool>();
  // sound.FlutterSoundPlayer? audioPlayer = sound.FlutterSoundPlayer();
  // VoiceController? _voiceController;
  String text = 'new pending order';

  //event
  final _eventController = StreamController<HomePageEvent>.broadcast();
  Sink<HomePageEvent> get serviceEventSink => _eventController.sink;

  final _dineInOrderQtyController = StreamController<int>.broadcast();
  Sink<int> get dineInOrderQtySink => _dineInOrderQtyController.sink;
  Stream<int> get dineInOrderQtyStream => _dineInOrderQtyController.stream;

  final _deliveryOrderQtyController = StreamController<int>.broadcast();
  Sink<int> get deliveryOrderQtySink => _deliveryOrderQtyController.sink;
  Stream<int> get deliveryOrderQtyStream => _deliveryOrderQtyController.stream;

  final _takeAwayOrderQtyController = StreamController<int>.broadcast();
  Sink<int> get takeAwayOrderQtySink => _takeAwayOrderQtyController.sink;
  Stream<int> get takeAwayOrderQtyStream => _takeAwayOrderQtyController.stream;

  final _carServiceOrderQtyController = StreamController<int>.broadcast();
  Sink<int> get carServiceOrderQtySink => _carServiceOrderQtyController.sink;
  Stream<int> get carServiceOrderQtyStream => _carServiceOrderQtyController.stream;

  final _pendingOrderQtyController = StreamController<int>.broadcast();
  Sink<int> get pendingOrderQtySink => _pendingOrderQtyController.sink;
  Stream<int> get pendingOrderQtyStream => _pendingOrderQtyController.stream;

  Service? dineIn;
  Service? takeAway;
  Service? carHop;
  Service? delivery;
  Service? pendingOrder;
  bool hasNewPending = false;
  int lastPendingCount = 0;

  Property<String> dineInName = Property<String>();
  Property<String> takeAwayName = Property<String>();
  Property<String> carServiceName = Property<String>();
  Property<String> deliveryName = Property<String>();
  Property<int> notificationCount = Property<int>();
  Property<String> pendingOrderName = Property<String>();

  StreamSubscription<String>? _navigationListener;

  ConnectionRepository? locatorConnction;

  bool get isDatabaseConnection {
    return locatorConnction!.repoName == "Database Connection";
  }

  HomePageBloc(NavigatorBloc navigationBloc) {
    locatorConnction = locator.get<ConnectionRepository>();
    _navigationBloc = navigationBloc;
    // _voiceController = FlutterTextToSpeech.instance.voiceController();

    _eventController.stream.listen(_mapEventToServiceState);
    dineIn = locator.get<ConnectionRepository>().services!.firstWhereOrNull((f) => f.id == 1);
    dineInName.sinkValue(dineIn!.display_name!);

    takeAway = locator.get<ConnectionRepository>().services!.firstWhereOrNull((f) => f.id == 2);
    takeAwayName.sinkValue(takeAway!.display_name!);

    carHop = locator.get<ConnectionRepository>().services!.firstWhereOrNull((f) => f.id == 3);
    carServiceName.sinkValue(carHop!.display_name!);

    delivery = locator.get<ConnectionRepository>().services!.firstWhereOrNull((f) => f.id == 4);
    deliveryName.sinkValue(delivery!.display_name!);

    loadServiceOrders(null);
    loadTimer();
    // playAudio();

    //load selected langauge
    loadSelectedLang();

    _navigationListener = navigationBloc.displayedPage.stream.listen((event) {
      if (event == "HomePage") {
        loadServiceOrders(null);
      }
    });
  }

  loadSelectedLang() async {
    String? lang = locator.get<ConnectionRepository>().terminal!.getLangauge();
    if (lang != null) {
      AppLocalizations appLocalizations = await AppLocalizations.load(Locale(lang));
      pendingOrderName.sinkValue(appLocalizations.translate("Pending Orders"));
    }
  }

  // playAudio() async {
  //   await _voiceController!.init();
  //   await audioPlayer.openAudioSession();
  // }

  play() async {
    var path = p.join("./assets/sound/service_bell_daniel_simion.mp3");

    Uint8List buffer = await getAssetData(path);
    // await audioPlayer!.startPlayer(fromDataBuffer: buffer, codec: sound.Codec.mp3, whenFinished: () {});
  }

  Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  Future<Uint8List> getAssetData(String path) async {
    var asset = await rootBundle.load(path);
    return asset.buffer.asUint8List();
  }

  updateServices() {
    dineIn = locator.get<ConnectionRepository>().services!.firstWhereOrNull((f) => f.id == 1);
    dineInName.sinkValue(dineIn!.display_name!);

    takeAway = locator.get<ConnectionRepository>().services!.firstWhereOrNull((f) => f.id == 2);
    takeAwayName.sinkValue(takeAway!.display_name!);

    carHop = locator.get<ConnectionRepository>().services!.firstWhereOrNull((f) => f.id == 3);
    carServiceName.sinkValue(carHop!.display_name!);

    delivery = locator.get<ConnectionRepository>().services!.firstWhereOrNull((f) => f.id == 4);
    deliveryName.sinkValue(delivery!.display_name!);
  }

  // _playVoice() async {
  //   await play();
  //   _voiceController!.speak(
  //     text,
  //     VoiceControllerOptions(volume: 1),
  //   );
  // }

  loadTimer() {
    serviceOrderTimer = new Timer.periodic(const Duration(seconds: 10), loadServiceOrders);
  }

  loadServiceOrders(Timer? timer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lang = locator.get<ConnectionRepository>().terminal!.getLangauge();
    AppLocalizations appLocalizations = await AppLocalizations.load(Locale(lang!));
    //print(_navigationBloc.currentPage);
    if (_navigationBloc!.currentPage != "HomePage") return;
    List<ServiceOrder> orders = await locator.get<ConnectionRepository>().fetchServicesOrders();

    List<MiniOrder> pendingOrders = await locator.get<ConnectionRepository>().fetchPendingOrders() ?? List<MiniOrder>.empty(growable: true);

    dineInOrderQtySink.add(0);
    takeAwayOrderQtySink.add(0);
    carServiceOrderQtySink.add(0);
    deliveryOrderQtySink.add(0);
    pendingOrderQtySink.add(0);

    dineInName.sinkValue(dineIn!.display_name!);
    takeAwayName.sinkValue(takeAway!.display_name!);
    carServiceName.sinkValue(carHop!.display_name!);
    deliveryName.sinkValue(delivery!.display_name!);

    if (orders != null)
      // ignore: curly_braces_in_flow_control_structures
      for (var item in orders) {
        switch (item.service_id) {
          case 1:
            dineInOrderQtySink.add(item.order_count);
            break;
          case 2:
            takeAwayOrderQtySink.add(item.order_count);
            break;
          case 3:
            carServiceOrderQtySink.add(item.order_count);
            break;
          case 4:
            deliveryOrderQtySink.add(item.order_count);
            break;
        }
      }

    if (pendingOrders != null) {
      // Future.delayed(const Duration(seconds: 10), () {
      //   pendingOrderQtyStream.listen((value) {
      //     if (value > 0) {
      //       _playVoice();
      //     }
      //   });
      // });

      hasNewPending = true;
      pendingOrderQtySink.add(pendingOrders.length);
    } else {
      hasNewPending = false;
    }
    notificationCount.value = 0;
    notificationCount.sinkValue(notificationCount.value ?? 0);
    if (isINVOConnection.value == true) {
      List<NotificationMessage>? notificationList = await locator.get<ConnectionRepository>().preferenceService!.getAllNotifications();
      if (notificationList != null) {
        notificationCount.sinkValue(notificationList.length);
      }
    }
  }

  // function that map events to states in service
  void _mapEventToServiceState(HomePageEvent event) async {
    ConnectionRepository repository = locator.get<ConnectionRepository>();
    if (event is DineInClick) {
      Privilege privilage = new Privilege();
      if (!await privilage.checkLogin(Privilages.DineIn)) return;
      if (repository.services!.firstWhereOrNull((f) => f.id == 1)!.showTableSelection) {
        _navigationBloc!.navigatorSink.add(NavigateToDineInPage());
      } else {
        _navigationBloc!.navigatorSink.add(NavigateToRecallPage(service: repository.services!.firstWhereOrNull((f) => f.id == 1)));
      }
    } else if (event is DeliveryClick) {
      // final PrinterNetworkManager printerManager = PrinterNetworkManager();
      // printerManager.selectPrinter('10.1.1.123', port: 9100);
      // final PosPrintResult res = await printerManager.printTicket(testTicket());

      // print('Print result: ${res.msg}');

      // return;
      Privilege privilage = Privilege();
      if (!await privilage.checkLogin(Privilages.Delivery)) return;
      _navigationBloc!.navigatorSink.add(NavigateToRecallPage(service: repository.services!.firstWhereOrNull((f) => f.id == 4)));
    } else if (event is CarServiceClick) {
      Privilege privilage = Privilege();
      if (!await privilage.checkLogin(Privilages.DriveThru)) return;
      _navigationBloc!.navigatorSink.add(NavigateToRecallPage(service: repository.services!.firstWhereOrNull((f) => f.id == 3)));
    } else if (event is TakeAwayClick) {
      Privilege privilage = Privilege();
      if (!await privilage.checkLogin(Privilages.TakeAway)) return;
      _navigationBloc!.navigatorSink.add(NavigateToRecallPage(service: repository.services!.firstWhereOrNull((f) => f.id == 2)));
    } else if (event is SearchClick) {
      Privilege privilage = Privilege();
      if (!await privilage.checkLogin(Privilages.Search_Security)) return;
      _navigationBloc!.navigatorSink.add(NavigateToRecallPage(service: Service(id: 0, name: "Search")));
    } else if (event is PendingClick) {
      Privilege privilage = Privilege();
      if (!await privilage.checkLogin(Privilages.Search_Security)) return;
      _navigationBloc!.navigatorSink.add(NavigateToPendingPage());
    }
  }

  openDrawer() async {
    Privilege privilage = new Privilege();
    if (!await privilage.checkLogin(Privilages.Open_Drawer)) return;

    Terminal? terminal = locator.get<ConnectionRepository>().terminal;
    PrintService printService = new PrintService(terminal!);
    printService.openDrawer();
  }

  @override
  void dispose() {
    serviceOrderTimer!.cancel();
    _eventController.close();
    _dineInOrderQtyController.close();
    _deliveryOrderQtyController.close();
    _takeAwayOrderQtyController.close();
    _carServiceOrderQtyController.close();
    _pendingOrderQtyController.close();
    if (_navigationListener != null) _navigationListener!.cancel();
    dineInName.dispose();
    takeAwayName.dispose();
    carServiceName.dispose();
    deliveryName.dispose();
    pendingOrderName.dispose();
    notificationCount.dispose();
    // audioPlayer.closeAudioSession();
    // audioPlayer = null;
    // _voiceController!.stop();
    // _voiceController = null;
    isINVOConnection.dispose();
  }
}
