import 'package:equatable/equatable.dart';
import 'package:trungchuyen/models/network/response/detail_trips_repose.dart';

abstract class ReportLimoEvent extends Equatable {
  @override
  List<Object> get props => [];
}


class GetReportLimoEvent extends ReportLimoEvent {

  final String dateFrom;
  final String dateTo;

  GetReportLimoEvent( this.dateFrom, this.dateTo);

  @override
  String toString() => 'UpdateStatusDriverEvent {dateFrom: $dateFrom, dateTo:$dateTo}';
}