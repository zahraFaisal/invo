import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:invo_mobile/blocs/home_page/home_page_bloc.dart';
import 'package:invo_mobile/blocs/home_page/home_page_events.dart';
import 'package:invo_mobile/views/blocProvider.dart';
import 'package:invo_mobile/views/home/widgets/service.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';
// import 'package:flutter_text_to_speech/flutter_text_to_speech.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info/device_info.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart' as sound;
import 'dart:typed_data';
import 'package:path/path.dart' as p;
import 'package:invo_mobile/blocs/main/main_bloc.dart';
import '../../service_locator.dart';

class HomePagePortrait extends StatefulWidget {
  const HomePagePortrait({
    Key? key,
  }) : super(key: key);

  // final _homePageBloc = HomePageBloc(employee) ;

  @override
  State<StatefulWidget> createState() {
    return _HomePagePortraitState();
  }
}

class _HomePagePortraitState extends State<HomePagePortrait> {
  late HomePageBloc homePageBloc;
  // late VoiceController _voiceController;
  int length = 0;
  String text = 'new pending order';
  late MainBloc mainBloc;

  // sound.FlutterSoundPlayer audioPlayer = sound.FlutterSoundPlayer();

  @override
  void initState() {
    super.initState();
    playAudio();
    homePageBloc = BlocProvider.of<HomePageBloc>(context);
    // _voiceController = FlutterTextToSpeech.instance.voiceController();
    homePageBloc = BlocProvider.of<HomePageBloc>(context);
    mainBloc = locator.get<MainBloc>();
    setState(() {
      mainBloc.updateConnection();
      homePageBloc.updateServices();
    });
  }

  @override
  void dispose() {
    super.dispose();
    // _voiceController.stop();
  }

  // _playVoice() async {
  //   await play();
  //   _voiceController.init().then((_) {
  //     _voiceController.speak(
  //       text,
  //       VoiceControllerOptions(volume: 1),
  //     );
  //   });
  // }

  // _stopVoice() {
  //   _voiceController.stop();
  // }

  playAudio() async {
    // await audioPlayer.openAudioSession();
  }

  play() async {
    var path = p.join("./assets/sound/service_bell_daniel_simion.mp3");
    Uint8List buffer = await getAssetData(path);
    // await audioPlayer.startPlayer(fromDataBuffer: buffer, codec: sound.Codec.mp3, whenFinished: () {});
  }

  Future<Uint8List> getAssetData(String path) async {
    var asset = await rootBundle.load(path);
    return asset.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    // Future.delayed(const Duration(seconds: 10), () {
    //   homePageBloc.pendingOrderQtyStream.listen((value) {
    //     if (value > 0) {
    //       _playVoice();
    //     }
    //   });
    // });
    return StreamBuilder(
        stream: mainBloc.isINVOConnection.stream,
        builder: (context, snapshot) {
          return Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              (homePageBloc.dineIn!.in_active! && homePageBloc.delivery!.in_active!)
                  ? SizedBox()
                  : Expanded(
                      child: Row(
                        mainAxisAlignment: (homePageBloc.dineIn!.in_active! || homePageBloc.delivery!.in_active!)
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          (homePageBloc.dineIn!.in_active!)
                              ? SizedBox()
                              : ServiceBtn(
                                  streamInt: homePageBloc.dineInOrderQtyStream,
                                  initName: 'Dine In',
                                  streamName: homePageBloc.dineInName.stream,
                                  image: "assets/icons/dinein.png",
                                  tab: () async {
                                    homePageBloc.serviceEventSink.add(DineInClick());
                                  }),
                          (homePageBloc.delivery!.in_active!)
                              ? SizedBox()
                              : ServiceBtn(
                                  streamInt: homePageBloc.deliveryOrderQtyStream,
                                  initName: 'Delivery',
                                  streamName: homePageBloc.deliveryName.stream,
                                  image: "assets/icons/delivery.png",
                                  tab: () async {
                                    homePageBloc.serviceEventSink.add(DeliveryClick());
                                  }),
                        ],
                      ),
                    ),
              // SizedBox(
              //   height: 10,
              // ),

              (homePageBloc.takeAway!.in_active! && homePageBloc.carHop!.in_active!)
                  ? SizedBox()
                  : Expanded(
                      child: Row(
                        mainAxisAlignment: (homePageBloc.takeAway!.in_active! || homePageBloc.carHop!.in_active!)
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          (homePageBloc.takeAway!.in_active!)
                              ? SizedBox()
                              : ServiceBtn(
                                  streamInt: homePageBloc.takeAwayOrderQtyStream,
                                  initName: 'Pick Up',
                                  streamName: homePageBloc.takeAwayName.stream,
                                  image: "assets/icons/pickup.png",
                                  tab: () async {
                                    homePageBloc.serviceEventSink.add(TakeAwayClick());
                                  },
                                ),
                          (homePageBloc.carHop!.in_active!)
                              ? SizedBox()
                              : ServiceBtn(
                                  streamInt: homePageBloc.carServiceOrderQtyStream,
                                  initName: 'Car Hop',
                                  streamName: homePageBloc.carServiceName.stream,
                                  image: "assets/icons/carhop.png",
                                  tab: () async {
                                    homePageBloc.serviceEventSink.add(CarServiceClick());
                                  },
                                ),
                        ],
                      ),
                    ),
              (mainBloc.isINVOConnection.value == false)
                  ? Expanded(
                      child: ServiceBtn(
                        streamInt: homePageBloc.pendingOrderQtyStream,
                        initName: 'Pending',
                        streamName: homePageBloc.pendingOrderName.stream,
                        image: "assets/icons/Pending_Order.png",
                        tab: () async {
                          homePageBloc.serviceEventSink.add(PendingClick());
                        },
                      ),
                    )
                  : SizedBox(),

              // Expanded(
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceAround,
              //     children: <Widget>[
              //       ServiceBtn(
              //         streamInt: homePageBloc.takeAwayOrderQtyStream,
              //         name: AppLocalizations.of(context).translate('Pick Up'),
              //         image: "assets/icons/pickup.png",
              //         tab: () async {
              //           homePageBloc.serviceEventSink.add(TakeAwayClick());
              //         },
              //       ),
              //       ServiceBtn(
              //         streamInt: homePageBloc.carServiceOrderQtyStream,
              //         name: AppLocalizations.of(context).translate('Car Hop'),
              //         image: "assets/icons/carhop.png",
              //         tab: () async {
              //           homePageBloc.serviceEventSink.add(CarServiceClick());
              //         },
              //       ),
              //     ],
              //   ),
              // )
            ],
          ));
        });
  }
}
