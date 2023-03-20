class Messages {
  String Type;
  String Data;
  Messages({this.Type = "", this.Data = ""});
  factory Messages.fromJson(Map<String, dynamic> json) {
    String type_ = json['Type'] != null ? json['Type'].toString() : "";
    return Messages(Type: type_, Data: json['Data'] ?? "");
  }
}

class NotificationMessage {
  int id;
  String type;
  DateTime? date_time;
  String msg;
  String? time;
  String type_name;
  NotificationMessage({this.id = 0, this.type = "", this.date_time, this.msg = "", this.time, this.type_name = ""});

  factory NotificationMessage.fromJson(Map<String, dynamic> json) {
    DateTime? _date_time;
    if (json.containsKey('date_time') && json['date_time'] != null) {
      _date_time = DateTime.fromMillisecondsSinceEpoch(int.parse(json['date_time'].substring(6, json['date_time'].length - 7)));
    }
    return NotificationMessage(
      id: json['id'] ?? 0,
      type: json['type'] ?? "",
      date_time: _date_time,
      msg: json['msg'] ?? "",
      time: json['time'] ?? "",
      type_name: json['type_name'] ?? "",
    );
  }
}
