class TranferCustomerRequestBody {

  String title;
  String body; String data;
  List<String> idTaiKhoans;


  TranferCustomerRequestBody({this.title, this.body,this.data, this.idTaiKhoans,});

  TranferCustomerRequestBody.fromJson(Map<String, dynamic> json) {

    title = json['Title'];
    body = json['Body'];data = json['Data'];
    idTaiKhoans = json['IdTaiKhoans'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.title != null){
      data['Title'] = this.title;
    }
    if(this.body != null){
      data['Body'] = this.body;
    } if(this.data != null){
      data['Data'] = this.data;
    }
    if(this.idTaiKhoans != null){
      data['IdTaiKhoans'] = this.idTaiKhoans;
    }
    return data;
  }
}
