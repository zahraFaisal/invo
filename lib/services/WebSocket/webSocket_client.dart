import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:invo_mobile/models/custom/messages.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:invo_mobile/widgets/order_notification.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_sound/flutter_sound.dart' as sound;
import 'package:path/path.dart' as p;
import 'package:intl/intl.dart';

class WebStockClient {
  WebSocketChannel? channel;
  String ip = "";
  int attempts = 0;
  WebStockClient({this.channel}) {
    playAudio();
  }
  // sound.FlutterSoundPlayer audioPlayer = sound.FlutterSoundPlayer();

  playAudio() async {
    // await audioPlayer.openAudioSession();
  }

  play() async {
    var path = p.join("assets/sound/service_bell_daniel_simion.mp3");

    Uint8List buffer = await getAssetData(path);
    // await audioPlayer.startPlayer(fromDataBuffer: buffer, codec: sound.Codec.mp3, whenFinished: () {});
  }

  Future<Uint8List> getAssetData(String path) async {
    var asset = await rootBundle.load(path);
    return asset.buffer.asUint8List();
  }

  get baseUrl {
    return "ws://" + ip + ":8776";
  }

  loadMain() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("connectionType") != "INVO") return;
    if (ip == "") {
      ip = (await locator.get<ConnectionRepository>().preference!.main_terminal_ip);
      if (ip.isEmpty) {
        ip = (await locator.get<ConnectionRepository>().ip)!;
      }
    }
    if (baseUrl == "") {
      return;
    }
    // print(jsonEncode(settings.value));
    channel = IOWebSocketChannel.connect(baseUrl);

    print("connecting");
    channel!.stream.listen((event) {
      Messages messages = Messages.fromJson(jsonDecode(event));
      switch (messages.Type) {
        case "6": //Orders

          Ticket ticket = new Ticket();
          ticket = Ticket.fromJson(messages.Data as Map<String, dynamic>);

          play();
          String notificationMessage = 'Order#' + ticket.id.toString() + ' Ticket#' + ticket.ticket_number.toString() + " is Ready";
          showToastWidget(
            OrderNotification(
              title: "Waiter Notifications",
              message: notificationMessage,
              status: 1,
            ),
            handleTouch: true,
            duration: Duration(seconds: 5),
            position: ToastPosition(align: Alignment.topCenter, offset: -10),
          );

          break;
        case "10":
          play();
          NotificationMessage notification = new NotificationMessage();
          notification = NotificationMessage.fromJson(messages.Data as Map<String, dynamic>);
          if (notification.type == "pager") {
            showToastWidget(
              OrderNotification(
                title: notification.type_name,
                message: notification.msg,
                status: 1,
                time: DateFormat('hh:mm a').format(notification.date_time!),
              ),
              handleTouch: true,
              duration: Duration(seconds: 5),
              position: ToastPosition(align: Alignment.topCenter, offset: -10),
            );
          } else if (notification.type == "warn") {
            showToastWidget(
              OrderNotification(
                title: notification.type_name,
                message: notification.msg,
                status: 2,
                time: DateFormat('hh:mm a').format(notification.date_time!),
              ),
              handleTouch: true,
              duration: Duration(seconds: 5),
              position: ToastPosition(align: Alignment.topCenter, offset: -10),
            );
          }

          break;
        default:
          break;
      }
    }, onDone: () {
      print("disconnected");
      if (prefs.getString("connectionType") == "INVO") {
        if (attempts <= 5) {
          new Future.delayed(const Duration(seconds: 10), () => this.loadMain());
          attempts++;
        } else {
          new Future.delayed(const Duration(minutes: 1), () => this.loadMain());
        }
      }
    }, onError: (err) {
      print("error:");
      print(err);

      // if (prefs.getString("connectionType") == "INVO") {
      //   if (attempts <= 5) {
      //     new Future.delayed(const Duration(seconds: 10), () => loadMain());
      //     attempts++;
      //   } else {
      //     new Future.delayed(const Duration(minutes: 1), () => this.loadMain());
      //   }
      // }
    });
  }
}

class Ticket {
  int id;
  int ticket_number;
  Ticket({this.id = 0, this.ticket_number = 0});

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      ticket_number: json['ticket_number'],
    );
  }
}
