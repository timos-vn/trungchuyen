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
  final int idRoom;
  final int idTime;
  final int typeCustomer;

  GetListDetailTripsOfPageWaiting(this.date,this.idRoom,this.idTime,this.typeCustomer);

  @override
  String toString() => 'GetListDetailTripsOfPageWaiting {date: $date }';
}
