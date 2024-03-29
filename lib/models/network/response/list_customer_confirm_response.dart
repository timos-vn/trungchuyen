class CustomerLimoConfirm {
  List<CustomerLimoConfirmBody>? data;
  int? statusCode;
  String? message;

  CustomerLimoConfirm({this.data, this.statusCode, this.message});

  CustomerLimoConfirm.fromJson(Map<String?, dynamic> json) {
    if (json['data'] != null) {
      data = <CustomerLimoConfirmBody>[];
      json['data'].forEach((v) {
        data?.add(new CustomerLimoConfirmBody.fromJson(v));
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

class CustomerLimoConfirmBody {
  String? idTrungChuyen;
  String? hoTenTaiXe;
  String? dienThoaiTaiXe;
  String? tenKhachHang;
  String? soDienThoaiKhach;
  String? tenTuyenDuong;
  String? ghiChuDatVe;
  String? ghiChuTrungChuyen;
  int? loaiKhach;
  String? ngayChay;
  String? thoiGianDi;
  String? idTaiXe;
  int? soKhach = 1;

  CustomerLimoConfirmBody(
      {this.idTrungChuyen,
        this.hoTenTaiXe,
        this.dienThoaiTaiXe,
        this.tenKhachHang,
        this.soDienThoaiKhach,
        this.tenTuyenDuong,
        this.ghiChuDatVe,
        this.ghiChuTrungChuyen,
        this.loaiKhach,
        this.ngayChay,
        this.thoiGianDi,
        this.idTaiXe,
        this.soKhach});

  CustomerLimoConfirmBody.fromJson(Map<String?, dynamic> json) {
    idTrungChuyen = json['idTrungChuyen'];
    hoTenTaiXe = json['hoTenTaiXe'];
    dienThoaiTaiXe = json['dienThoaiTaiXe'];
    tenKhachHang = json['tenKhachHang'];
    soDienThoaiKhach = json['soDienThoaiKhach'];
    tenTuyenDuong = json['tenTuyenDuong'];
    ghiChuDatVe = json['ghiChuDatVe'];
    ghiChuTrungChuyen = json['ghiChuTrungChuyen'];
    loaiKhach = json['loaiKhach'];
    ngayChay = json['ngayChay'];
    thoiGianDi = json['thoiGianDi'];
    idTaiXe = json['idTaiXe'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['idTrungChuyen'] = this.idTrungChuyen;
    data['hoTenTaiXe'] = this.hoTenTaiXe;
    data['dienThoaiTaiXe'] = this.dienThoaiTaiXe;
    data['tenKhachHang'] = this.tenKhachHang;
    data['soDienThoaiKhach'] = this.soDienThoaiKhach;
    data['tenTuyenDuong'] = this.tenTuyenDuong;
    data['ghiChuDatVe'] = this.ghiChuDatVe;
    data['ghiChuTrungChuyen'] = this.ghiChuTrungChuyen;
    data['loaiKhach'] = this.loaiKhach;
    data['ngayChay'] = this.ngayChay;
    data['thoiGianDi'] = this.thoiGianDi;
    data['idTaiXe'] = this.idTaiXe;
    return data;
  }
}

