class UnreadCountResponse {
  int? unreadTotal;
  int? statusCode;
  String? message;


  UnreadCountResponse({ this.unreadTotal, this.message, this.statusCode});

  UnreadCountResponse.fromJson(Map<String, dynamic> json) {
    unreadTotal = json['data'];
    message = json['message'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.unreadTotal;
    data['message'] = this.message;
    data['statusCode'] = this.statusCode;
    return data;
  }
}
