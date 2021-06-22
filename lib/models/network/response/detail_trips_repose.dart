class DetailTripsReponse {
  List<DetailTripsReponseBody> data;
  int statusCode;
  String message;

  DetailTripsReponse({this.data, this.statusCode, this.message});

  DetailTripsReponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<DetailTripsReponseBody>();
      json['data'].forEach((v) {
        data.add(new DetailTripsReponseBody.fromJson(v));
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

class DetailTripsReponseBody {
  String idTrungChuyen;
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
  int soKhach;

  DetailTripsReponseBody(
      {this.idTrungChuyen,
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
        this.soKhach});

  DetailTripsReponseBody.fromJson(Map<String, dynamic> json) {
    idTrungChuyen = json['idTrungChuyen'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idTrungChuyen'] = this.idTrungChuyen;
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
    return data;
  }
}

