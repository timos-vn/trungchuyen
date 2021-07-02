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