class ListOfGroupAwaitingCustomer {
  List<ListOfGroupAwaitingCustomerBody> data;
  int statusCode;
  Null message;

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
  int idTuyenDuong;
  String tenTuyenDuong;
  int idKhungGio;
  String thoiGianDi;
  String thoiGianDen;
  int loaiKhach;
  int soKhach;

  ListOfGroupAwaitingCustomerBody(
      {this.ngayChay,
        this.idTuyenDuong,
        this.tenTuyenDuong,
        this.idKhungGio,
        this.thoiGianDi,
        this.thoiGianDen,
        this.loaiKhach,
        this.soKhach});

  ListOfGroupAwaitingCustomerBody.fromJson(Map<String, dynamic> json) {
    ngayChay = json['ngayChay'];
    idTuyenDuong = json['idTuyenDuong'];
    tenTuyenDuong = json['tenTuyenDuong'];
    idKhungGio = json['idKhungGio'];
    thoiGianDi = json['thoiGianDi'];
    thoiGianDen = json['thoiGianDen'];
    loaiKhach = json['loaiKhach'];
    soKhach = json['soKhach'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ngayChay'] = this.ngayChay;
    data['idTuyenDuong'] = this.idTuyenDuong;
    data['tenTuyenDuong'] = this.tenTuyenDuong;
    data['idKhungGio'] = this.idKhungGio;
    data['thoiGianDi'] = this.thoiGianDi;
    data['thoiGianDen'] = this.thoiGianDen;
    data['loaiKhach'] = this.loaiKhach;
    data['soKhach'] = this.soKhach;
    return data;
  }
}

