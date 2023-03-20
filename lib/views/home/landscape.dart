import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/home_page/home_page_bloc.dart';
import 'package:invo_mobile/blocs/home_page/home_page_events.dart';
import 'package:invo_mobile/views/blocProvider.dart';
import 'package:invo_mobile/views/home/widgets/service.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';
import 'package:flutter_sound/flutter_sound.dart' as sound;
import 'package:invo_mobile/blocs/main/main_bloc.dart';
import '../../service_locator.dart';

class HomePageLandscape extends StatefulWidget {
  const HomePageLandscape({
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePageLandscapeState();
  }
}

class _HomePageLandscapeState extends State<HomePageLandscape> {
  late HomePageBloc homePageBloc;
  late MainBloc mainBloc;

  int length = 0;
  // sound.FlutterSoundPlayer audioPlayer = sound.FlutterSoundPlayer();

  @override
  void initState() {
    super.initState();
    homePageBloc = BlocProvider.of<HomePageBloc>(context);
    mainBloc = locator.get<MainBloc>();
    mainBloc.updateConnection();

    setState(() {
      homePageBloc.updateServices();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: mainBloc.isINVOConnection.stream,
        builder: (context, snapshot) {
          return Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 40,
                ),
                (homePageBloc.dineIn!.in_active!)
                    ? SizedBox()
                    : Container(
                        height: 350,
                        child: ServiceBtn(
                            streamInt: homePageBloc.dineInOrderQtyStream,
                            initName: 'Dine In',
                            streamName: homePageBloc.dineInName.stream,
                            image: "assets/icons/dinein.png",
                            tab: () {
                              homePageBloc.serviceEventSink.add(DineInClick());
                            }),
                      ),
                SizedBox(
                  width: 10,
                ),
                (homePageBloc.delivery!.in_active!)
                    ? SizedBox()
                    : Container(
                        height: 350,
                        child: ServiceBtn(
                            streamInt: homePageBloc.deliveryOrderQtyStream,
                            initName: 'Delivery',
                            streamName: homePageBloc.deliveryName.stream,
                            image: "assets/icons/delivery.png",
                            tab: () {
                              homePageBloc.serviceEventSink.add(DeliveryClick());
                            }),
                      ),
                SizedBox(
                  width: 10,
                ),
                (homePageBloc.takeAway!.in_active!)
                    ? SizedBox()
                    : Container(
                        height: 350,
                        child: ServiceBtn(
                          streamInt: homePageBloc.takeAwayOrderQtyStream,
                          initName: 'Pick Up',
                          streamName: homePageBloc.takeAwayName.stream,
                          image: "assets/icons/pickup.png",
                          tab: () {
                            homePageBloc.serviceEventSink.add(TakeAwayClick());
                          },
                        ),
                      ),
                SizedBox(
                  width: 10,
                ),
                (homePageBloc.carHop!.in_active!)
                    ? SizedBox()
                    : Container(
                        height: 350,
                        child: ServiceBtn(
                          streamInt: homePageBloc.carServiceOrderQtyStream,
                          initName: 'Car Hop',
                          streamName: homePageBloc.carServiceName.stream,
                          image: "assets/icons/carhop.png",
                          tab: () {
                            homePageBloc.serviceEventSink.add(CarServiceClick());
                          },
                        ),
                      ),
                SizedBox(
                  width: 10,
                ),
                mainBloc.isINVOConnection.value == false
                    ? Container(
                        height: 350,
                        child: ServiceBtn(
                          streamInt: homePageBloc.pendingOrderQtyStream,
                          initName: "Pending",
                          streamName: homePageBloc.pendingOrderName.stream,
                          image: "assets/icons/Pending_Order.png",
                          tab: () async {
                            homePageBloc.serviceEventSink.add(PendingClick());
                          },
                        ),
                      )
                    : Container(),

                // SizedBox(
                //   width: 40,
                // ),
              ],
            ),
          );
        });
  }
}
