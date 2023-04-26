import 'package:equatable/equatable.dart';

abstract class ReportEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetPrefs extends ReportEvent {

  @override
  String toString() => 'GetPrefs';
}
class GetReportEvent extends ReportEvent {

  final String dateFrom;
  final String dateTo;

  GetReportEvent( this.dateFrom, this.dateTo);

  @override
  String toString() => 'UpdateStatusDriverEvent {dateFrom: $dateFrom, dateTo:$dateTo}';
}