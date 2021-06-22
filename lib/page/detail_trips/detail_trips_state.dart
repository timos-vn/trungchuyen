import 'package:equatable/equatable.dart';

abstract class DetailTripsState extends Equatable {
  @override
  List<Object> get props => [];
}

class DetailTripsInitial extends DetailTripsState {

  @override
  String toString() => 'DetailTripsInitial';
}
class DetailTripsFailure extends DetailTripsState {
  final String error;

  DetailTripsFailure(this.error);

  @override
  String toString() => 'DetailTripsFailure { error: $error }';
}

class DetailTripsLoading extends DetailTripsState {
  @override
  String toString() => 'DetailTripsLoading';
}

class GetListOfDetailTripsSuccess extends DetailTripsState {
  @override
  String toString() => 'GetListOfWaitingCustomerSuccess }';
}
