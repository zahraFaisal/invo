import 'package:invo_mobile/blocs/property.dart';

class SearchModel {
  int status;
  DateTime? end_date;
  DateTime? start_date;
  String searchText;
  int service;

  SearchModel({
    this.searchText = "",
    this.service = 0,
    this.status = 0,
    this.end_date,
    this.start_date,
  }) {
    this.end_date = new DateTime.now();
    this.start_date = new DateTime.now();
  }

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    DateTime? _endTime = (json.containsKey('end_date') && json['end_date'] != null)
        ? DateTime.fromMillisecondsSinceEpoch(int.parse(json['end_date'].substring(6, json['end_date'].length - 7)))
        : null;

    DateTime? _startTime = (json.containsKey('start_date') && json['start_date'] != null)
        ? DateTime.fromMillisecondsSinceEpoch(int.parse(json['start_date'].substring(6, json['start_date'].length - 7)))
        : null;

    return SearchModel(
      searchText: json['searchText'] ?? "",
      service: json['service'] ?? 0,
      status: json['status'] ?? 0,
      end_date: _endTime,
      start_date: _startTime,
    );
  }

  factory SearchModel.fromMap(Map<String, dynamic> map) {
    SearchModel searchModel = SearchModel();
    searchModel.searchText = map['searchText'] ?? "";
    searchModel.service = map['service'] ?? 0;
    searchModel.status = map['status'] ?? 0;
    searchModel.end_date = map['departure_time'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['departure_time']);
    searchModel.start_date = map['start_date'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['start_date']);
    return searchModel;
  }

  dispose() {}
}
