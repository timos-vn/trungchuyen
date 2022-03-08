// class DetailTripsLimo {
//   List<DsKhachs> data;
//   int statusCode;
//   String message;
//
//   DetailTripsLimo({this.data, this.statusCode, this.message});
//
//   DetailTripsLimo.fromJson(Map<String, dynamic> json) {
//     if (json['data'] != null) {
//       data = new List<DsKhachs>();
//       json['data'].forEach((v) {
//         data.add(new DsKhachs.fromJson(v));
//       });
//     }
//     statusCode = json['statusCode'];
//     message = json['message'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.data != null) {
//       data['data'] = this.data.map((v) => v.toJson()).toList();
//     }
//     data['statusCode'] = this.statusCode;
//     data['message'] = this.message;
//     return data;
//   }
// }
//
// class DetailTripsLimoReponseBody {
//   String idDatVe;
//   String idTaiXeTC;
//   String hoTenTaiXeTrungChuyen;
//   String dienThoaiTaiXeTrungChuyen;
//   String tenXeTrungChuyen;
//   String bienSoXeTrungChuyen;
//   String tenKhachHang;
//   String soDienThoaiKhach;
//   String diaChiKhachDi;
//   String toaDoDiaChiKhachDi;
//   String diaChiKhachDen;
//   String toaDoDiaChiKhachDen;
//   String diaChiLimoDi;
//   String toaDoLimoDi;
//   String diaChiLimoDen;
//   String toaDoLimoDen;
//   String ghiChu;
//   int loaiKhach;
//   int khachTrungChuyen;
//   int trangThaiVe;
//   int trangThaiTC;
//   int soKhach;
//
//   DetailTripsLimoReponseBody(
//       {this.idDatVe,
//         this.idTaiXeTC,
//         this.hoTenTaiXeTrungChuyen,
//         this.dienThoaiTaiXeTrungChuyen,
//         this.tenXeTrungChuyen,
//         this.bienSoXeTrungChuyen,
//         this.tenKhachHang,
//         this.soDienThoaiKhach,
//         this.diaChiKhachDi,
//         this.toaDoDiaChiKhachDi,
//         this.diaChiKhachDen,
//         this.toaDoDiaChiKhachDen,
//         this.diaChiLimoDi,
//         this.toaDoLimoDi,
//         this.diaChiLimoDen,
//         this.toaDoLimoDen,
//         this.ghiChu,
//         this.loaiKhach,
//         this.khachTrungChuyen,
//         this.trangThaiVe,
//         this.trangThaiTC,
//         this.soKhach});
//
//   DetailTripsLimoReponseBody.fromJson(Map<String, dynamic> json) {
//     idDatVe = json['idDatVe'];
//     idTaiXeTC = json['idTaiXeTC'];
//     hoTenTaiXeTrungChuyen = json['hoTenTaiXeTrungChuyen'];
//     dienThoaiTaiXeTrungChuyen = json['dienThoaiTaiXeTrungChuyen'];
//     tenXeTrungChuyen = json['tenXeTrungChuyen'];
//     bienSoXeTrungChuyen = json['bienSoXeTrungChuyen'];
//     tenKhachHang = json['tenKhachHang'];
//     soDienThoaiKhach = json['soDienThoaiKhach'];
//     diaChiKhachDi = json['diaChiKhachDi'];
//     toaDoDiaChiKhachDi = json['toaDoDiaChiKhachDi'];
//     diaChiKhachDen = json['diaChiKhachDen'];
//     toaDoDiaChiKhachDen = json['toaDoDiaChiKhachDen'];
//     diaChiLimoDi = json['diaChiLimoDi'];
//     toaDoLimoDi = json['toaDoLimoDi'];
//     diaChiLimoDen = json['diaChiLimoDen'];
//     toaDoLimoDen = json['toaDoLimoDen'];
//     ghiChu = json['ghiChu'];
//     loaiKhach = json['loaiKhach'];
//     khachTrungChuyen = json['khachTrungChuyen'];
//     trangThaiVe = json['trangThaiVe'];
//     trangThaiTC = json['trangThaiTC'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['idDatVe'] = this.idDatVe;
//     data['idTaiXeTC'] = this.idTaiXeTC;
//     data['hoTenTaiXeTrungChuyen'] = this.hoTenTaiXeTrungChuyen;
//     data['dienThoaiTaiXeTrungChuyen'] = this.dienThoaiTaiXeTrungChuyen;
//     data['tenXeTrungChuyen'] = this.tenXeTrungChuyen;
//     data['bienSoXeTrungChuyen'] = this.bienSoXeTrungChuyen;
//     data['tenKhachHang'] = this.tenKhachHang;
//     data['soDienThoaiKhach'] = this.soDienThoaiKhach;
//     data['diaChiKhachDi'] = this.diaChiKhachDi;
//     data['toaDoDiaChiKhachDi'] = this.toaDoDiaChiKhachDi;
//     data['diaChiKhachDen'] = this.diaChiKhachDen;
//     data['toaDoDiaChiKhachDen'] = this.toaDoDiaChiKhachDen;
//     data['diaChiLimoDi'] = this.diaChiLimoDi;
//     data['toaDoLimoDi'] = this.toaDoLimoDi;
//     data['diaChiLimoDen'] = this.diaChiLimoDen;
//     data['toaDoLimoDen'] = this.toaDoLimoDen;
//     data['ghiChu'] = this.ghiChu;
//     data['loaiKhach'] = this.loaiKhach;
//     data['khachTrungChuyen'] = this.khachTrungChuyen;
//     data['trangThaiVe'] = this.trangThaiVe;
//     data['trangThaiTC'] = this.trangThaiTC;
//     return data;
//   }
// }

class DetailTripsLimo {
  DetailTripsLimoReponseBody data;
  int statusCode;
  String message;

  DetailTripsLimo({this.data, this.statusCode, this.message});

  DetailTripsLimo.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new DetailTripsLimoReponseBody.fromJson(json['data']) : null;
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

class DetailTripsLimoReponseBody {
  int tongKhach;
  int khachHuy;
  List<DsKhachs> dsKhachs;

  DetailTripsLimoReponseBody({this.tongKhach, this.khachHuy, this.dsKhachs});

  DetailTripsLimoReponseBody.fromJson(Map<String, dynamic> json) {
    tongKhach = json['tongKhach'];
    khachHuy = json['khachHuy'];
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
    data['khachHuy'] = this.khachHuy;
    if (this.dsKhachs != null) {
      data['dsKhachs'] = this.dsKhachs.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DsKhachs {
  String idDatVe;
  String idTaiXeTC;
  int maVe;
  int soGhe;
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
  String diaChiLimoDi;
  String toaDoLimoDi;
  String diaChiLimoDen;
  String toaDoLimoDen;
  String ghiChu;
  int loaiKhach;
  int khachTrungChuyen;
  int trangThaiVe;
  int trangThaiTC;
  int soKhach=1;
  int daThanhToan;
  num tienVe;
  num soTienCoc;
  String hoTenKhachDatHo;
  String soDienThoaiKhachDatHo;

  DsKhachs(
      {this.idDatVe,
        this.idTaiXeTC,
        this.maVe,
        this.soGhe,
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
        this.ghiChu,
        this.loaiKhach,
        this.khachTrungChuyen,
        this.trangThaiVe,
        this.trangThaiTC,
        this.soKhach,
        this.daThanhToan,
        this.tienVe,
        this.soTienCoc,this.hoTenKhachDatHo,this.soDienThoaiKhachDatHo});

  DsKhachs.fromJson(Map<String, dynamic> json) {
    idDatVe = json['idDatVe'];
    idTaiXeTC = json['idTaiXeTC'];
    maVe = json['maVe'];
    soGhe = json['soGhe'];
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
    ghiChu = json['ghiChu'];
    loaiKhach = json['loaiKhach'];
    khachTrungChuyen = json['khachTrungChuyen'];
    trangThaiVe = json['trangThaiVe'];
    trangThaiTC = json['trangThaiTC'];daThanhToan = json['daThanhToan'];
    tienVe = json['tienVe'];
    soTienCoc = json['soTienCoc'];
    hoTenKhachDatHo = json['hoTenKhachDatHo'];
    soDienThoaiKhachDatHo = json['soDienThoaiKhachDatHo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idDatVe'] = this.idDatVe;
    data['idTaiXeTC'] = this.idTaiXeTC;
    data['maVe'] = this.maVe;
    data['soGhe'] = this.soGhe;
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
    data['ghiChu'] = this.ghiChu;
    data['loaiKhach'] = this.loaiKhach;
    data['khachTrungChuyen'] = this.khachTrungChuyen;
    data['trangThaiVe'] = this.trangThaiVe;
    data['trangThaiTC'] = this.trangThaiTC;
    data['daThanhToan'] = this.daThanhToan;
    data['tienVe'] = this.tienVe;
    data['soTienCoc'] = this.soTienCoc;
    data['hoTenKhachDatHo'] = this.hoTenKhachDatHo;
    data['soDienThoaiKhachDatHo'] = this.soDienThoaiKhachDatHo;
    return data;
  }
}