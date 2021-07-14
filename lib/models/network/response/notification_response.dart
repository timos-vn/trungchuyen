class NotificationResponse {
  List<NotificationDataResponse> data;
  int statusCode;
  String message;

  NotificationResponse({this.data, this.statusCode, this.message});

  NotificationResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<NotificationDataResponse>();
      json['data'].forEach((v) {
        data.add(new NotificationDataResponse.fromJson(v));
      });
    }
    statusCode = json['statusCode'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}

class NotificationDataResponse {
  int type;
  String id;
  String title;
  String body;
  String userIds;
  String tokens;
  String data;
  int status;
  String time;

  NotificationDataResponse(
      {this.type,
        this.id,
        this.title,
        this.body,
        this.userIds,
        this.tokens,
        this.data,
      this.status,
      this.time});

  NotificationDataResponse.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id =json['id'];
    title = json['title'];
    body = json['body'];
    userIds = json['userIds'];
    tokens = json['tokens'];
    data = json['data'];status = json['status'];time = json['time'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['id'] = this.id;
    data['title'] = this.title;
    data['body'] = this.body;
    data['userIds'] = this.userIds;
    data['tokens'] = this.tokens;
    data['data'] = this.data;
    data['status'] = this.status;data['time'] = this.time;
    return data;
  }
}

