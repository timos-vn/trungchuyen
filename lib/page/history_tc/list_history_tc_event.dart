import 'package:equatable/equatable.dart';
import 'package:trungchuyen/models/network/response/detail_trips_limo_reponse.dart';

abstract class HistoryTCEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetListHistoryTC extends HistoryTCEvent {
  final String dateTime;

  GetListHistoryTC(this.dateTime);

  @override
  String toString() => 'GetListHistoryTC {dateTime:$dateTime}';
}


class GetListDetailTripTC extends HistoryTCEvent {

  final DateTime date;
  final int idRoom;
  final int idTime;
  final int typeCustomer;

  GetListDetailTripTC(this.date,this.idRoom,this.idTime,this.typeCustomer);

  @override
  String toString() => 'GetListDetailTripTC {date: $date }';
}