class PushLocationRequestBody {

  String location;

  PushLocationRequestBody({this.location,});

  PushLocationRequestBody.fromJson(Map<String, dynamic> json) {

    location = json['Location'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.location != null){
      data['Location'] = this.location;
    }
    return data;
  }
}
