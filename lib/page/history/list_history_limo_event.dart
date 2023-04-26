import 'package:equatable/equatable.dart';

abstract class HistoryLimoEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetListHistoryLimo extends HistoryLimoEvent {
  final String dateTime;

  GetListHistoryLimo(this.dateTime);
  @override
  String toString() => 'GetListHistoryLimo {dateTime:$dateTime}';
}
class GetPrefs extends HistoryLimoEvent {

  @override
  String toString() => 'GetPrefs';
}

class GetListDetailTripLimo extends HistoryLimoEvent {

  final DateTime date;
  final int idRoom;
  final int idTime;
  final int typeCustomer;

  GetListDetailTripLimo(this.date,this.idRoom,this.idTime,this.typeCustomer);

  @override
  String toString() => 'GetListDetailTripLimo {date: $date }';
}