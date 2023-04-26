import 'package:equatable/equatable.dart';

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

class GetPrefs extends ReportLimoEvent {

  @override
  String toString() => 'GetPrefs';
}