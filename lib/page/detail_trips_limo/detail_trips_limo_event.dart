import 'package:equatable/equatable.dart';

abstract class DetailTripsLimoEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetListDetailTripsLimo extends DetailTripsLimoEvent {

  final String date;
  final int idTrips;
  final int idTime;

  GetListDetailTripsLimo(this.date,this.idTrips,this.idTime);

  @override
  String toString() => 'GetListDetailTripsLimo {date: $date }';
}

class ConfirmCustomerLimoEvent extends DetailTripsLimoEvent {

  final String idDatVe;
  final int trangThai;
  final String note;

  ConfirmCustomerLimoEvent(this.idDatVe,this.trangThai,this.note);

  @override
  String toString() => 'ConfirmCustomerLimoEvent {date: $trangThai }';
}

class UpdateStatusCustomerConfirmMapEvent extends DetailTripsLimoEvent{
  final int status;
  final String idTrungChuyen;
  final String note;
  final String idLaiXeTC;
  UpdateStatusCustomerConfirmMapEvent({this.status,this.idTrungChuyen,this.note,this.idLaiXeTC});

  @override
  String toString() {
    return 'UpdateStatusCustomerConfirmMapEvent{status: $status, idTrungChuyen:$idTrungChuyen}';
  }
}
class LimoConfirm extends DetailTripsLimoEvent {

  final String title;
  final String body;
  final String listTaiXeTC;

  LimoConfirm(this.title, this.body, this.listTaiXeTC);

  @override
  String toString() => 'LimoConfirm {title: $title,body:$body, listTaiXeTC:$listTaiXeTC}';
}