

class DetailTripsResponse {
  List<DetailTripsResponseBody> data;
  int statusCode;
  String message;

  DetailTripsResponse({this.data, this.statusCode, this.message});

  DetailTripsResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<DetailTripsResponseBody>();
      json['data'].forEach((v) {
        data.add(new DetailTripsResponseBody.fromJson(v));
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

class DetailTripsResponseBody {
  String idTrungChuyen;
  String idTaiXeLimousine;
  String hoTenTaiXeLimousine;
  String dienThoaiTaiXeLimousine;
  String tenXeLimousine;
  String bienSoXeLimousine;
  String tenKhachHang;
  String soDienThoaiKhach;
  String diaChiKhachDi;
  String toaDoDiaChiKhachDi;
  String diaChiKhachDen;
  String toaDoDiaChiKhachDen;
  String diaChiLimoDi;
  String toaDoLimoDi;
  String diaChiLimoDen;
  String toaDoLimoDen;
  int loaiKhach;
  String trangThaiTC;
  int soKhach;

  DetailTripsResponseBody(
      {this.idTrungChuyen,
        this.idTaiXeLimousine,
        this.hoTenTaiXeLimousine,
        this.dienThoaiTaiXeLimousine,
        this.tenXeLimousine,
        this.bienSoXeLimousine,
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
        this.trangThaiTC,
        this.soKhach});

  DetailTripsResponseBody.fromJson(Map<String, dynamic> json) {
    idTrungChuyen = json['idTrungChuyen'];
    idTaiXeLimousine = json['idTaiXeLimousine'];
    hoTenTaiXeLimousine = json['hoTenTaiXeLimousine'];
    dienThoaiTaiXeLimousine = json['dienThoaiTaiXeLimousine'];
    tenXeLimousine = json['tenXeLimousine'];
    bienSoXeLimousine = json['bienSoXeLimousine'];
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
    trangThaiTC = json['trangThaiTC'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idTrungChuyen'] = this.idTrungChuyen;
    data['idTaiXeLimousine'] = this.idTaiXeLimousine;
    data['hoTenTaiXeLimousine'] = this.hoTenTaiXeLimousine;
    data['dienThoaiTaiXeLimousine'] = this.dienThoaiTaiXeLimousine;
    data['tenXeLimousine'] = this.tenXeLimousine;
    data['bienSoXeLimousine'] = this.bienSoXeLimousine;
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
    data['trangThaiTC'] = this.trangThaiTC;
    return data;
  }
}

