import 'package:equatable/equatable.dart';
import 'package:trungchuyen/models/network/response/detail_trips_limo_reponse.dart';

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


class GetListDetailTripLimo extends HistoryLimoEvent {

  final DateTime date;
  final int idRoom;
  final int idTime;
  final int typeCustomer;

  GetListDetailTripLimo(this.date,this.idRoom,this.idTime,this.typeCustomer);

  @override
  String toString() => 'GetListDetailTripLimo {date: $date }';
}