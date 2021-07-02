import 'package:equatable/equatable.dart';

class NotificationCustomerOfTC extends Equatable {
  final String idTrungChuyen;
  final String chuyen;
  final String thoiGian;
  final String loaiKhach;


  NotificationCustomerOfTC(
      {this.idTrungChuyen,
        this.chuyen,
        this.thoiGian,
        this.loaiKhach,
      });

  NotificationCustomerOfTC.fromDb(Map<String, dynamic> map)
      :
        idTrungChuyen = map['idTrungChuyen'],
        thoiGian = map['ThoiGian'],
        chuyen = map['Chuyen'],
        loaiKhach = map['LoaiKhach'];

  Map<String, dynamic> toMapForDb() {
    var map = Map<String, dynamic>();
    map['idTrungChuyen'] = idTrungChuyen;
    map['ThoiGian'] = thoiGian;
    map['Chuyen'] = chuyen;
    map['LoaiKhach'] = loaiKhach;
    return map;
  }

  @override
  List<Object> get props => [
    idTrungChuyen,
    thoiGian,
    chuyen,
    loaiKhach,
  ];
}
