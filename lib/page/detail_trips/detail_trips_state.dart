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
class UpdateStatusCustomerSuccess extends DetailTripsState {
  final int status;

  UpdateStatusCustomerSuccess(this.status);
  @override
  String toString() => 'UpdateStatusCustomerSuccess }';
}

class TCTransferCustomerToLimoSuccess extends DetailTripsState {
  final String listIDTC;

  TCTransferCustomerToLimoSuccess(this.listIDTC);
  @override
  String toString() => 'TCTransferCustomerToLimoSuccess {listIDTC: $listIDTC}';
}
