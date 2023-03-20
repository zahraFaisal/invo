import 'package:flutter/material.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/models/custom/messages.dart';
import 'package:invo_mobile/widgets/order_notification.dart';
import 'package:invo_mobile/blocs/property.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatefulWidget {
  NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late Property<List<NotificationMessage>> notifications;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifications = new Property<List<NotificationMessage>>();
    notifications.value = List<NotificationMessage>.empty(growable: true);
    getAllNotification();
  }

  getAllNotification() async {
    notifications.sinkValue(await locator.get<ConnectionRepository>().preferenceService!.getAllNotifications() ?? List<NotificationMessage>.empty(growable: true));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    notifications.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width / 1.8;
    var height = MediaQuery.of(context).size.height / 1.5;
    return Container(
      decoration: BoxDecoration(color: Color.fromARGB(255, 208, 218, 230), borderRadius: BorderRadius.all(Radius.circular(15.0)), border: Border.all(color: Color.fromARGB(255, 246, 252, 248), width: 1)),
      width: width,
      height: height,
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 8),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      backgroundColor: Color.fromARGB(255, 80, 129, 169),
                    ),
                    onPressed: () async {
                      bool? isDeleted = await locator.get<ConnectionRepository>().preferenceService!.deleteAllNotification();
                      if (isDeleted == true) {
                        notifications.value = List<NotificationMessage>.empty(growable: true);
                        notifications.sinkValue(notifications.value ?? List<NotificationMessage>.empty(growable: true));
                      }
                    },
                    child: Text("Dismiss All", style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 4),
                  child: TextButton(
                    style: TextButton.styleFrom(backgroundColor: const Color.fromARGB(255, 208, 218, 230), minimumSize: Size.fromWidth(12)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },

                    //minWidth: 12,
                    child: Text("X", style: TextStyle(color: Color.fromARGB(255, 80, 129, 169), fontSize: 30)),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 9,
            child: StreamBuilder(
                stream: notifications.stream,
                initialData: notifications.value,
                builder: (context, snapshot) {
                  return ListView.builder(
                    padding: EdgeInsets.all(0),
                    itemCount: notifications.value!.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (notifications.value![index].type == "pager")
                        // ignore: curly_braces_in_flow_control_structures
                        return OrderNotification(
                          title: "Waiter Notification",
                          message: notifications.value![index].msg,
                          status: 1,
                          time: DateFormat('hh:mm a').format(notifications.value![index].date_time!),
                          ticket: true,
                          onDelete: () async {
                            bool? isDeleted = await locator.get<ConnectionRepository>().preferenceService!.deleteNotification(notifications.value![index].id);
                            if (isDeleted == true) {
                              notifications.value!.remove(notifications.value![index]);
                              notifications.sinkValue(notifications.value ?? List<NotificationMessage>.empty(growable: true));
                            }
                          },
                        );

                      if (notifications.value![index].type == "warn")
                        // ignore: curly_braces_in_flow_control_structures
                        return OrderNotification(
                          title: "Warning",
                          message: notifications.value![index].msg,
                          status: 2,
                          time: DateFormat('hh:mm a').format(notifications.value![index].date_time!),
                          ticket: true,
                          onDelete: () async {
                            bool? isDeleted = await locator.get<ConnectionRepository>().preferenceService!.deleteNotification(notifications.value![index].id);
                            if (isDeleted == true) {
                              notifications.value!.remove(notifications.value![index]);
                              notifications.sinkValue(notifications.value ?? List<NotificationMessage>.empty(growable: true));
                            }
                          },
                        );

                      return Center();
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
