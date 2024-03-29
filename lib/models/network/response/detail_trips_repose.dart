

class DetailTripsResponse {
  List<DetailTripsResponseBody>? data;
  int? statusCode;
  String? message;

  DetailTripsResponse({this.data, this.statusCode, this.message});

  DetailTripsResponse.fromJson(Map<String?, dynamic> json) {
    if (json['data'] != null) {
      data = <DetailTripsResponseBody>[];
      json['data'].forEach((v) {
        data?.add(new DetailTripsResponseBody.fromJson(v));
      });
    }
    statusCode = json['statusCode'];
    message = json['message'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}

class DetailTripsResponseBody {
  String? idTrungChuyen;
  String? idTaiXeLimousine;
  String? hoTenTaiXeLimousine;
  String? dienThoaiTaiXeLimousine;
  String? tenXeLimousine;
  String? bienSoXeLimousine;
  String? tenKhachHang;
  String? soDienThoaiKhach;
  String? diaChiKhachDi;
  String? toaDoDiaChiKhachDi;
  String? diaChiKhachDen;
  String? toaDoDiaChiKhachDen;
  String? diaChiLimoDi;
  String? toaDoLimoDi;
  String? diaChiLimoDen;
  String? toaDoLimoDen;
  int? loaiKhach;
  int? trangThaiTC;
  int? soKhach =1;
  String? chuyen;
  int? totalCustomer;
  int? idKhungGio;
  int? idVanPhong;
  String? ngayTC;
  int? maVe;
  String? vanPhongDen;
  String? vanPhongDi;
  String? tenNhaXe;
  String? hoTenKhachDatHo;
  String? soDienThoaiKhachDatHo;

  DetailTripsResponseBody(
      {
        this.idTrungChuyen,
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
        this.soKhach,
        this.chuyen,
        this.totalCustomer,
        this.idKhungGio,
        this.idVanPhong,this.ngayTC,this.maVe,this.vanPhongDen,this.vanPhongDi,this.tenNhaXe,
        this.hoTenKhachDatHo,this.soDienThoaiKhachDatHo
      });

  DetailTripsResponseBody.fromJson(Map<String?, dynamic> json) {
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
    maVe = json['maVe'];vanPhongDi = json['vanPhongDi'];
    vanPhongDen = json['vanPhongDen'];
    tenNhaXe = json['tenNhaXe'];
    hoTenKhachDatHo = json['hoTenKhachDatHo'];
    soDienThoaiKhachDatHo = json['soDienThoaiKhachDatHo'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
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
    data['trangThaiTC'] = this.trangThaiTC;data['maVe'] = this.maVe;
    data['vanPhongDi'] = this.vanPhongDi;
    data['vanPhongDen'] = this.vanPhongDen;
    data['tenNhaXe'] = this.tenNhaXe;
    data['hoTenKhachDatHo'] = this.hoTenKhachDatHo;
    data['soDienThoaiKhachDatHo'] = this.soDienThoaiKhachDatHo;
    return data;
  }
}

