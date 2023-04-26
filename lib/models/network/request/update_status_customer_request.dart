class UpdateStatusCustomerRequestBody {

  List<String>? id;
  int? status;
  String? ghiChu;

  UpdateStatusCustomerRequestBody({this.id, this.status,this.ghiChu});

  UpdateStatusCustomerRequestBody.fromJson(Map<String, dynamic> json) {

    id = json['Ids'];
    status = json['TrangThai'];
    ghiChu = json['GhiChu'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.id != null){
      data['Ids'] = this.id;
    }
    if(this.status != null){
      data['TrangThai'] = this.status;
    } if(this.ghiChu != null){
      data['GhiChu'] = this.ghiChu;
    }
    return data;
  }
}
