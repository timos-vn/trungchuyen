import 'package:equatable/equatable.dart';

abstract class ReportState extends Equatable {
  @override
  List<Object> get props => [];
}

class GetReportEventSuccess extends ReportState {

  @override
  String toString() => 'GetListCustomer2Success }';
}

class ReportInitial extends ReportState {

  @override
  String toString() => 'ReportInitial';
}
class GetPrefsSuccess extends ReportState{

  @override
  String toString() {
    return 'GetPrefsSuccess{}';
  }
}
class ReportFailure extends ReportState {
  final String error;

  ReportFailure(this.error);

  @override
  String toString() => 'ReportFailure { error: $error }';
}

class ReportLoading extends ReportState {
  @override
  String toString() => 'ReportLoading';
}
