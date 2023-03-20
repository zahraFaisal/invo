class DatabaseList {
  String id;
  String name;
  String createdTime;

  DatabaseList({
    this.id = "",
    this.name = "",
    this.createdTime = "",
  });

  factory DatabaseList.fromMap(Map<String, dynamic> map) {
    DatabaseList databaseList = DatabaseList();
    databaseList.id = map['id'] ?? "";
    databaseList.name = map['name'] ?? "";
    databaseList.createdTime = map['createdTime'] ?? "";
    return databaseList;
  }

  factory DatabaseList.fromJson(Map<String, dynamic> json) {
    return DatabaseList(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      createdTime: json['createdTime'] ?? "",
    );
  }
}
