import 'package:equatable/equatable.dart';
import 'package:trungchuyen/models/network/response/detail_trips_repose.dart';

abstract class  MapState extends Equatable {
  @override
  List<Object> get props => [];
}
class GetListCustomerSuccess extends MapState {

  final List<DetailTripsReponseBody> listOfCustomerTrips;

  GetListCustomerSuccess(this.listOfCustomerTrips);

  @override
  String toString() => 'GetListCustomerSuccess }';
}

class MapInitial extends MapState {

  @override
  String toString() => 'MapInitial';
}

class MapFailure extends MapState {
  final String error;

  MapFailure(this.error);

  @override
  String toString() => 'MapFailure { error: $error }';
}

class MapLoading extends MapState {
  @override
  String toString() => 'MapLoading';
}
class UpdateStatusDriverState extends MapState {

  @override
  String toString() => 'UpdateStatusDriverState {}';
}