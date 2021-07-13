import 'package:equatable/equatable.dart';

class Customer extends Equatable {
  String idTrungChuyen;
  final String idTaiXeLimousine;
  final String hoTenTaiXeLimousine;
  final String dienThoaiTaiXeLimousine;
  final String tenXeLimousine;
  final String bienSoXeLimousine;
  final String tenKhachHang;
  final String soDienThoaiKhach;
  final String diaChiKhachDi;
  final String toaDoDiaChiKhachDi;
  final String diaChiKhachDen;
  final String toaDoDiaChiKhachDen;
  final String diaChiLimoDi;
  final String toaDoLimoDi;
  final String diaChiLimoDen;
  final String toaDoLimoDen;
  final int loaiKhach;
  int trangThaiTC;
  int soKhach;
  int statusCustomer;
  String chuyen;
  int totalCustomer;
  int idKhungGio;
  int idVanPhong;


  Customer(
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
    this.soKhach,
    this.statusCustomer,this.chuyen,this.totalCustomer,this.idKhungGio,this.idVanPhong}
      );

  Customer.fromDb(Map<String, dynamic> map)
      :
        idTrungChuyen = map['idTrungChuyen'],
        idTaiXeLimousine = map['idTaiXeLimousine'],
        hoTenTaiXeLimousine = map['hoTenTaiXeLimousine'],
        dienThoaiTaiXeLimousine = map['dienThoaiTaiXeLimousine'],
        tenXeLimousine = map['tenXeLimousine'],
        bienSoXeLimousine = map['bienSoXeLimousine'],
        tenKhachHang = map['tenKhachHang'],
        soDienThoaiKhach = map['soDienThoaiKhach'],
        diaChiKhachDi = map['diaChiKhachDi'],
        toaDoDiaChiKhachDi = map['toaDoDiaChiKhachDi'],
        diaChiKhachDen = map['diaChiKhachDen'],
        toaDoDiaChiKhachDen = map['toaDoDiaChiKhachDen'],
        diaChiLimoDi = map['diaChiLimoDi'],
        toaDoLimoDi = map['toaDoLimoDi'],
        diaChiLimoDen = map['diaChiLimoDen'],
        toaDoLimoDen = map['toaDoLimoDen'],
        loaiKhach = map['loaiKhach'],
        trangThaiTC = map['trangThaiTC'],
        soKhach = map['soKhach'],
        statusCustomer = map['statusCustomer'],chuyen = map['chuyen'],totalCustomer = map['totalCustomer'],
        idKhungGio = map['idKhungGio'],
        idVanPhong = map['idVanPhong'];

  Map<String, dynamic> toMapForDb() {
    var map = Map<String, dynamic>();
    map['idTrungChuyen'] = idTrungChuyen;
    map['idTaiXeLimousine'] = idTaiXeLimousine;
    map['hoTenTaiXeLimousine'] = hoTenTaiXeLimousine;
    map['dienThoaiTaiXeLimousine'] = dienThoaiTaiXeLimousine;
    map['tenXeLimousine'] = tenXeLimousine;
    map['bienSoXeLimousine'] = bienSoXeLimousine;
    map['tenKhachHang'] = tenKhachHang;
    map['soDienThoaiKhach'] = soDienThoaiKhach;
    map['diaChiKhachDi'] = diaChiKhachDi;
    map['toaDoDiaChiKhachDi'] = toaDoDiaChiKhachDi;
    map['diaChiKhachDen'] = diaChiKhachDen;
    map['toaDoDiaChiKhachDen'] = toaDoDiaChiKhachDen;
    map['diaChiLimoDi'] = diaChiLimoDi;
    map['toaDoLimoDi'] = toaDoLimoDi;
    map['diaChiLimoDen'] = diaChiLimoDen;
    map['toaDoLimoDen'] = toaDoLimoDen;
    map['loaiKhach'] = loaiKhach;
    map['trangThaiTC'] = trangThaiTC;
    map['soKhach'] = soKhach;
    map['statusCustomer'] = statusCustomer;
    map['chuyen'] = chuyen;
    map['totalCustomer'] = totalCustomer;
    map['idKhungGio'] = idKhungGio;map['idVanPhong'] = idVanPhong;
    return map;
  }

  @override
  List<Object> get props => [
    idTrungChuyen,
    idTaiXeLimousine,
    hoTenTaiXeLimousine,
    dienThoaiTaiXeLimousine,
    tenXeLimousine,
    bienSoXeLimousine,
    tenKhachHang,
    soDienThoaiKhach,
    diaChiKhachDi,
    toaDoDiaChiKhachDi,
    diaChiKhachDen,
    toaDoDiaChiKhachDen,
    diaChiLimoDi,
    toaDoLimoDi,
    diaChiLimoDen,
    toaDoLimoDen,
    loaiKhach,
    trangThaiTC,
    soKhach,
    chuyen,
    idKhungGio,
    idVanPhong
  ];
}
