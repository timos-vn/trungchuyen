class LanguageRequest {
  String? lang;

  LanguageRequest({this.lang});

  LanguageRequest.fromJson(Map<String, dynamic> json) {
    lang = json['lang'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.lang != null){
      data['lang'] = this.lang;
    }
    return data;
  }
}