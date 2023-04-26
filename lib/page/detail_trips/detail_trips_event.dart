import 'package:equatable/equatable.dart';
import 'package:trungchuyen/models/network/response/detail_trips_repose.dart';

abstract class DetailTripsEvent extends Equatable {
  @override
  List<Object> get props => [];
}
class GetPrefs extends DetailTripsEvent {

  @override
  String toString() => 'GetPrefs';
}
class GetListDetailTrips extends DetailTripsEvent {

  final DateTime date;
  final int idRoom;
  final int idTime;
  final int typeCustomer;

  GetListDetailTrips(this.date,this.idRoom,this.idTime,this.typeCustomer);

  @override
  String toString() => 'GetListDetailTrips {date: $date }';
}
class GetListDetailTripsHistory extends DetailTripsEvent {
  final DateTime dateTime;
  final int idRoom;
  final int idTime;
  final int typeCustomer;

  GetListDetailTripsHistory(this.dateTime,this.idRoom,this.idTime,this.typeCustomer);

  @override
  String toString() => 'GetListDetailTripsHistory { }';
}
class TCTransferCustomerToLimoEvent extends DetailTripsEvent {

  final String title;
  final String body;
  final List<DetailTripsResponseBody> listCustomer;

  TCTransferCustomerToLimoEvent(this.title, this.body,this.listCustomer);

  @override
  String toString() => 'TCTransferCustomerToLimo {title: $title,body:$body,}';
}

class UpdateStatusCustomerDetailEvent extends DetailTripsEvent{
  final int? status;
  final List<String>? idTrungChuyen;
  final String? note;
  UpdateStatusCustomerDetailEvent({this.status,this.idTrungChuyen,this.note});

  @override
  String toString() {
    return 'UpdateStatusCustomerDetailEvent{status: $status, idTrungChuyen:$idTrungChuyen}';
  }
}