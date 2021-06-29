import 'package:equatable/equatable.dart';

abstract class DetailTripsEvent extends Equatable {
  @override
  List<Object> get props => [];
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