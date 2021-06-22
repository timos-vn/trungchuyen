import 'package:equatable/equatable.dart';

abstract class ReportLimoState extends Equatable {
  @override
  List<Object> get props => [];
}

class GetReportLimoEventSuccess extends ReportLimoState {

  @override
  String toString() => 'GetReportLimoEventSuccess }';
}

class ReportLimoInitial extends ReportLimoState {

  @override
  String toString() => 'ReportLimoInitial';
}

class ReportLimoFailure extends ReportLimoState {
  final String error;

  ReportLimoFailure(this.error);

  @override
  String toString() => 'ReportLimoFailure { error: $error }';
}

class ReportLimoLoading extends ReportLimoState {
  @override
  String toString() => 'ReportLimoLoading';
}
