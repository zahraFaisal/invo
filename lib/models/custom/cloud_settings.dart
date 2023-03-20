class CloudSetting {
  String server;
  String restSlug;
  String branch_name;
  String password;

  CloudSetting({
    this.server = "",
    this.restSlug = "",
    this.branch_name = "",
    this.password = "",
  });

  factory CloudSetting.fromMap(Map<String, dynamic> map) {
    CloudSetting cloudSetting = CloudSetting();
    cloudSetting.server = map['customer_contact'] ?? "";
    cloudSetting.restSlug = map['customer_id'] ?? "";
    cloudSetting.branch_name = map['name'] ?? "";
    cloudSetting.password = map['name'] ?? "";
    return cloudSetting;
  }

  factory CloudSetting.fromJson(Map<String, dynamic> json) {
    return CloudSetting(
      server: json['customer_contact'] ?? "",
      restSlug: json['customer_id'] ?? "",
      branch_name: json['name'] ?? "",
      password: json['name'] ?? "",
    );
  }
}
