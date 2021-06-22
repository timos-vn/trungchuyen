import 'package:equatable/equatable.dart';

abstract class DetailTripsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetListDetailTrips extends DetailTripsEvent {

  final DateTime date;
  final String idTrips;
  final String idTime;

  GetListDetailTrips(this.date,this.idTrips,this.idTime);

  @override
  String toString() => 'GetListDetailTrips {date: $date }';
}