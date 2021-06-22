class ReportReponse {
  ReportReponseDetail data;
  int statusCode;
  String message;

  ReportReponse({this.data, this.statusCode, this.message});

  ReportReponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new ReportReponseDetail.fromJson(json['data']) : null;
    statusCode = json['statusCode'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}

class ReportReponseDetail {
  int tongKhach;
  double tongTien;
  List<DsKhachs> dsKhachs;

  ReportReponseDetail({this.tongKhach, this.tongTien, this.dsKhachs});

  ReportReponseDetail.fromJson(Map<String, dynamic> json) {
    tongKhach = json['tongKhach'];
    tongTien = json['tongTien'];
    if (json['dsKhachs'] != null) {
      dsKhachs = new List<DsKhachs>();
      json['dsKhachs'].forEach((v) {
        dsKhachs.add(new DsKhachs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tongKhach'] = this.tongKhach;
    data['tongTien'] = this.tongTien;
    if (this.dsKhachs != null) {
      data['dsKhachs'] = this.dsKhachs.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DsKhachs {
  String ngayChay;
  String tenTuyenDuong;
  String gioBatDau;
  String gioKetThuc;
  String tenKhachHang;
  String soDienThoaiKhach;
  String hoTenTaiXeLimousine;
  String dienThoaiTaiXeLimousine;
  String tenXeLimousine;
  String bienSoXeLimousine;
  int loaiKhach;

  DsKhachs(
      {this.ngayChay,
        this.tenTuyenDuong,
        this.gioBatDau,
        this.gioKetThuc,
        this.tenKhachHang,
        this.soDienThoaiKhach,
        this.hoTenTaiXeLimousine,
        this.dienThoaiTaiXeLimousine,
        this.tenXeLimousine,
        this.bienSoXeLimousine,
        this.loaiKhach});

  DsKhachs.fromJson(Map<String, dynamic> json) {
    ngayChay = json['ngayChay'];
    tenTuyenDuong = json['tenTuyenDuong'];
    gioBatDau = json['gioBatDau'];
    gioKetThuc = json['gioKetThuc'];
    tenKhachHang = json['tenKhachHang'];
    soDienThoaiKhach = json['soDienThoaiKhach'];
    hoTenTaiXeLimousine = json['hoTenTaiXeLimousine'];
    dienThoaiTaiXeLimousine = json['dienThoaiTaiXeLimousine'];
    tenXeLimousine = json['tenXeLimousine'];
    bienSoXeLimousine = json['bienSoXeLimousine'];
    loaiKhach = json['loaiKhach'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ngayChay'] = this.ngayChay;
    data['tenTuyenDuong'] = this.tenTuyenDuong;
    data['gioBatDau'] = this.gioBatDau;
    data['gioKetThuc'] = this.gioKetThuc;
    data['tenKhachHang'] = this.tenKhachHang;
    data['soDienThoaiKhach'] = this.soDienThoaiKhach;
    data['hoTenTaiXeLimousine'] = this.hoTenTaiXeLimousine;
    data['dienThoaiTaiXeLimousine'] = this.dienThoaiTaiXeLimousine;
    data['tenXeLimousine'] = this.tenXeLimousine;
    data['bienSoXeLimousine'] = this.bienSoXeLimousine;
    data['loaiKhach'] = this.loaiKhach;
    return data;
  }
}

