import 'package:equatable/equatable.dart';

abstract class WaitingEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetListGroupAwaitingCustomer extends WaitingEvent {

  final DateTime date;

  GetListGroupAwaitingCustomer(this.date,);

  @override
  String toString() => 'GetListGroupAwaitingCustomer {date: $date }';
}
class GetListDetailTripsOfPageWaiting extends WaitingEvent {

  final DateTime date;
  final int idTrips;
  final int idTime;

  GetListDetailTripsOfPageWaiting(this.date,this.idTrips,this.idTime);

  @override
  String toString() => 'GetListDetailTripsOfPageWaiting {date: $date }';
}