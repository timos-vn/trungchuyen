class UpdateInfoRequestBody {

  String? phone;
  String? email;
  String? fullName;
  String? companyId;
  String? role;


  UpdateInfoRequestBody({this.phone, this.email,this.fullName, this.companyId, this.role,});

  UpdateInfoRequestBody.fromJson(Map<String, dynamic> json) {

    phone = json['Phone'];
    email = json['Email']; fullName = json['FullName'];
    companyId = json['CompanyId']; role = json['Role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.phone != null){
      data['Phone'] = this.phone;
    }
    if(this.email != null){
      data['Email'] = this.email;
    } if(this.fullName != null){
      data['FullName'] = this.fullName;
    }
    if(this.companyId != null){
      data['CompanyId'] = this.companyId;
    } if(this.role != null){
      data['Role'] = this.role;
    }
    return data;
  }
}
