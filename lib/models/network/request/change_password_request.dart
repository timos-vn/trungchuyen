class ChangePasswordRequest {

  String matKhauHienTai;
  String matKhau;


  ChangePasswordRequest({this.matKhauHienTai,this.matKhau});

  ChangePasswordRequest.fromJson(Map<String, dynamic> json) {
    matKhauHienTai = json['MatKhauHienTai'];
    matKhau = json['MatKhau'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.matKhauHienTai != null){
      data['MatKhauHienTai'] = this.matKhauHienTai;
    }
    if(this.matKhau != null){
      data['MatKhau'] = this.matKhau;
    }

    return data;
  }
}
