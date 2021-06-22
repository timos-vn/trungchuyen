class DetailTripsLimo {
  List<DetailTripsLimoReponseBody> data;
  int statusCode;
  Null message;

  DetailTripsLimo({this.data, this.statusCode, this.message});

  DetailTripsLimo.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<DetailTripsLimoReponseBody>();
      json['data'].forEach((v) {
        data.add(new DetailTripsLimoReponseBody.fromJson(v));
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

class DetailTripsLimoReponseBody {
  String idDatVe;
  String idTaiXeTC;
  String hoTenTaiXeTrungChuyen;
  String dienThoaiTaiXeTrungChuyen;
  String tenXeTrungChuyen;
  String bienSoXeTrungChuyen;
  String tenKhachHang;
  String soDienThoaiKhach;
  String diaChiKhachDi;
  String toaDoDiaChiKhachDi;
  String diaChiKhachDen;
  String toaDoDiaChiKhachDen;
  Null diaChiLimoDi;
  Null toaDoLimoDi;
  String diaChiLimoDen;
  String toaDoLimoDen;
  int loaiKhach;
  int khachTrungChuyen;
  int soKhach;

  DetailTripsLimoReponseBody(
      {this.idDatVe,
        this.idTaiXeTC,
        this.hoTenTaiXeTrungChuyen,
        this.dienThoaiTaiXeTrungChuyen,
        this.tenXeTrungChuyen,
        this.bienSoXeTrungChuyen,
        this.tenKhachHang,
        this.soDienThoaiKhach,
        this.diaChiKhachDi,
        this.toaDoDiaChiKhachDi,
        this.diaChiKhachDen,
        this.toaDoDiaChiKhachDen,
        this.diaChiLimoDi,
        this.toaDoLimoDi,
        this.diaChiLimoDen,
        this.toaDoLimoDen,
        this.loaiKhach,
        this.khachTrungChuyen,
        this.soKhach});

  DetailTripsLimoReponseBody.fromJson(Map<String, dynamic> json) {
    idDatVe = json['idDatVe'];
    idTaiXeTC = json['idTaiXeTC'];
    hoTenTaiXeTrungChuyen = json['hoTenTaiXeTrungChuyen'];
    dienThoaiTaiXeTrungChuyen = json['dienThoaiTaiXeTrungChuyen'];
    tenXeTrungChuyen = json['tenXeTrungChuyen'];
    bienSoXeTrungChuyen = json['bienSoXeTrungChuyen'];
    tenKhachHang = json['tenKhachHang'];
    soDienThoaiKhach = json['soDienThoaiKhach'];
    diaChiKhachDi = json['diaChiKhachDi'];
    toaDoDiaChiKhachDi = json['toaDoDiaChiKhachDi'];
    diaChiKhachDen = json['diaChiKhachDen'];
    toaDoDiaChiKhachDen = json['toaDoDiaChiKhachDen'];
    diaChiLimoDi = json['diaChiLimoDi'];
    toaDoLimoDi = json['toaDoLimoDi'];
    diaChiLimoDen = json['diaChiLimoDen'];
    toaDoLimoDen = json['toaDoLimoDen'];
    loaiKhach = json['loaiKhach'];
    khachTrungChuyen = json['khachTrungChuyen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idDatVe'] = this.idDatVe;
    data['idTaiXeTC'] = this.idTaiXeTC;
    data['hoTenTaiXeTrungChuyen'] = this.hoTenTaiXeTrungChuyen;
    data['dienThoaiTaiXeTrungChuyen'] = this.dienThoaiTaiXeTrungChuyen;
    data['tenXeTrungChuyen'] = this.tenXeTrungChuyen;
    data['bienSoXeTrungChuyen'] = this.bienSoXeTrungChuyen;
    data['tenKhachHang'] = this.tenKhachHang;
    data['soDienThoaiKhach'] = this.soDienThoaiKhach;
    data['diaChiKhachDi'] = this.diaChiKhachDi;
    data['toaDoDiaChiKhachDi'] = this.toaDoDiaChiKhachDi;
    data['diaChiKhachDen'] = this.diaChiKhachDen;
    data['toaDoDiaChiKhachDen'] = this.toaDoDiaChiKhachDen;
    data['diaChiLimoDi'] = this.diaChiLimoDi;
    data['toaDoLimoDi'] = this.toaDoLimoDi;
    data['diaChiLimoDen'] = this.diaChiLimoDen;
    data['toaDoLimoDen'] = this.toaDoLimoDen;
    data['loaiKhach'] = this.loaiKhach;
    data['khachTrungChuyen'] = this.khachTrungChuyen;
    return data;
  }
}





