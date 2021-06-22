import 'package:equatable/equatable.dart';

abstract class DetailTripsLimoEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetListDetailTripsLimo extends DetailTripsLimoEvent {

  final String date;
  final String idTrips;
  final String idTime;

  GetListDetailTripsLimo(this.date,this.idTrips,this.idTime);

  @override
  String toString() => 'GetListDetailTripsLimo {date: $date }';
}