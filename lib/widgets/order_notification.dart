import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';

typedef NotificationVoidFunc = void Function();

class OrderNotification extends StatelessWidget {
  final bool? ticket;
  final String? title;
  final String? message;
  final int? status;
  final String? time;
  final NotificationVoidFunc? onDelete;
  final DateTime? date_time;
  const OrderNotification({Key? key, this.ticket = false, this.message, this.status = 1, this.title, this.time, this.date_time, this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 110,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 246, 252, 248),
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          border: Border.all(color: const Color.fromARGB(255, 246, 252, 248), width: 1)),
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      child: Card(
        elevation: 0,
        color: const Color.fromARGB(255, 246, 252, 248),
        margin: const EdgeInsets.all(0),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  status != 4
                      ? Icon(
                          icons(status!),
                          size: 24,
                          color: iconsColor(status!),
                        )
                      : Image.asset(
                          "assets/icons/report.png",
                          height: 30,
                          width: 30,
                        ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: Text(
                        title!,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Color.fromARGB(255, 45, 79, 109), fontSize: 18),
                      ),
                    ),
                  ),
                  (time != null)
                      ? Text(
                          time!,
                          overflow: TextOverflow.fade,
                          style: const TextStyle(color: Color.fromARGB(255, 141, 141, 141), fontSize: 18),
                        )
                      : SizedBox(),
                  IconButton(
                    padding: EdgeInsets.all(0.0),
                    alignment: Alignment.topCenter,
                    iconSize: 30,
                    icon: const Icon(
                      Icons.cancel,
                      color: Color.fromARGB(255, 80, 129, 169),
                    ),
                    onPressed: () {
                      if (ticket == false) {
                        dismissAllToast();
                      } else if (ticket == true) {
                        // delete method
                        onDelete!();
                      }
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      message!,
                      textAlign: TextAlign.left,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Color.fromARGB(255, 97, 97, 97), fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  icons(int status) {
    if (status == 1) return Icons.notifications_active_outlined;
    if (status == 2) return Icons.warning_rounded;
    if (status == 3) return Icons.check_circle;
  }

  iconsColor(int status) {
    if (status == 1) return const Color.fromARGB(255, 45, 79, 109);
    if (status == 2) return const Color.fromARGB(255, 235, 180, 80);
    if (status == 3) return const Color.fromARGB(255, 59, 181, 74);
  }
}
