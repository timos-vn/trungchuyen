class ListOfGroupLimoCustomerResponse {
  List<ListOfGroupLimoCustomerResponseBody>? data;
  int? statusCode;
  String? message;

  ListOfGroupLimoCustomerResponse({this.data, this.statusCode, this.message});

  ListOfGroupLimoCustomerResponse.fromJson(Map<String?, dynamic> json) {
    if (json['data'] != null) {
      data = <ListOfGroupLimoCustomerResponseBody>[];
      json['data'].forEach((v) {
        data?.add(new ListOfGroupLimoCustomerResponseBody.fromJson(v));
      });
    }
    statusCode = json['statusCode'];
    message = json['message'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    if (this.data != null) {
      data['data'] = this.data?.map((v) => v.toJson()).toList();
    }
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}

class ListOfGroupLimoCustomerResponseBody {
  String? ngayChay;
  int? idTuyenDuong;
  String? tenTuyenDuong;
  int? idKhungGio;
  String? thoiGianDi;
  String? thoiGianDen;
  int? loaiKhach;
  int? khachCanXuLy;
  int? tongSoGhe;

  ListOfGroupLimoCustomerResponseBody(
      {this.ngayChay,
        this.idTuyenDuong,
        this.tenTuyenDuong,
        this.idKhungGio,
        this.thoiGianDi,
        this.thoiGianDen,
        this.loaiKhach,
        this.khachCanXuLy,
        this.tongSoGhe});

  ListOfGroupLimoCustomerResponseBody.fromJson(Map<String?, dynamic> json) {
    ngayChay = json['ngayChay'];
    idTuyenDuong = json['idTuyenDuong'];
    tenTuyenDuong = json['tenTuyenDuong'];
    idKhungGio = json['idKhungGio'];
    thoiGianDi = json['thoiGianDi'];
    thoiGianDen = json['thoiGianDen'];
    loaiKhach = json['loaiKhach'];
    khachCanXuLy = json['khachCanXuLy'];
    tongSoGhe = json['tongSoGhe'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['ngayChay'] = this.ngayChay;
    data['idTuyenDuong'] = this.idTuyenDuong;
    data['tenTuyenDuong'] = this.tenTuyenDuong;
    data['idKhungGio'] = this.idKhungGio;
    data['thoiGianDi'] = this.thoiGianDi;
    data['thoiGianDen'] = this.thoiGianDen;
    data['loaiKhach'] = this.loaiKhach;
    data['khachCanXuLy'] = this.khachCanXuLy;
    data['tongSoGhe'] = this.tongSoGhe;
    return data;
  }
}

