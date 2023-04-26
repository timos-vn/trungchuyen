class UpdateTokenRequestBody {

  String? deviceToken;

  UpdateTokenRequestBody({this.deviceToken});

  UpdateTokenRequestBody.fromJson(Map<String, dynamic> json) {

    deviceToken = json['DeviceToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.deviceToken != null){
      data['DeviceToken'] = this.deviceToken;
    }
    return data;
  }
}
