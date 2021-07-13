
class ListOfGroupAwaitingCustomer {
  List<ListOfGroupAwaitingCustomerBody> data;
  int statusCode;
  String message;

  ListOfGroupAwaitingCustomer({this.data, this.statusCode, this.message});

  ListOfGroupAwaitingCustomer.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<ListOfGroupAwaitingCustomerBody>();
      json['data'].forEach((v) {
        data.add(new ListOfGroupAwaitingCustomerBody.fromJson(v));
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

class ListOfGroupAwaitingCustomerBody {
  String ngayChay;
  int idVanPhong;
  String diaChi;
  int idKhungGio;
  String thoiGianDi;
  String thoiGianDen;
  int loaiKhach;
  int soKhach;
  String tenVanPhong;

  ListOfGroupAwaitingCustomerBody(
      {this.ngayChay,
        this.idVanPhong,
        this.diaChi,
        this.idKhungGio,
        this.thoiGianDi,
        this.thoiGianDen,
        this.loaiKhach,
        this.soKhach,
      this.tenVanPhong});

  ListOfGroupAwaitingCustomerBody.fromJson(Map<String, dynamic> json) {
    ngayChay = json['ngayChay'];
    idVanPhong = json['idVanPhong'];
    diaChi = json['diaChi'];
    idKhungGio = json['idKhungGio'];
    thoiGianDi = json['thoiGianDi'];
    thoiGianDen = json['thoiGianDen'];
    loaiKhach = json['loaiKhach'];
    soKhach = json['soKhach'];
    tenVanPhong = json['tenVanPhong'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ngayChay'] = this.ngayChay;
    data['idVanPhong'] = this.idVanPhong;
    data['diaChi'] = this.diaChi;
    data['idKhungGio'] = this.idKhungGio;
    data['thoiGianDi'] = this.thoiGianDi;
    data['thoiGianDen'] = this.thoiGianDen;
    data['loaiKhach'] = this.loaiKhach;
    data['soKhach'] = this.soKhach;data['tenVanPhong'] = this.tenVanPhong;
    return data;
  }
}



