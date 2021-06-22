import 'package:equatable/equatable.dart';
import 'package:trungchuyen/models/network/response/detail_trips_repose.dart';

abstract class ReportEvent extends Equatable {
  @override
  List<Object> get props => [];
}


class GetReportEvent extends ReportEvent {

  final DateTime dateFrom;
  final DateTime dateTo;

  GetReportEvent( this.dateFrom, this.dateTo);

  @override
  String toString() => 'UpdateStatusDriverEvent {dateFrom: $dateFrom, dateTo:$dateTo}';
}