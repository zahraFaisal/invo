class CloudRequest {
  String from;
  String to;
  String request;
  String data;
  dynamic param;

  CloudRequest({
    this.from = "",
    this.to = "",
    this.request = "",
    this.data = "",
    this.param,
  });

  factory CloudRequest.fromMap(Map<String, dynamic> map) {
    CloudRequest cloudRequest = CloudRequest();
    cloudRequest.from = map['from'] ?? "";
    cloudRequest.to = map['to'] ?? "";
    cloudRequest.request = map['request'] ?? "";
    cloudRequest.data = map['data'] ?? "";
    cloudRequest.param = map['param'];
    return cloudRequest;
  }

  factory CloudRequest.fromJson(Map<String, dynamic> json) {
    return CloudRequest(
      from: json['from'] ?? "",
      to: json['to'] ?? "",
      request: json['request'] ?? "",
      data: json['data'] ?? "",
      param: json['param'],
    );
  }
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'from': from,
      'to': to,
      'request': request,
      'data': data,
      'param': param,
    };
    return map;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{
      'from': from,
      'to': to,
      'request': request,
      'data': data == null ? "[]" : data,
      'param': param,
    };
    return map;
  }
}
