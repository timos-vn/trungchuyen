import 'package:equatable/equatable.dart';
import 'package:trungchuyen/models/network/response/detail_trips_repose.dart';

abstract class  MapLimoState extends Equatable {
  @override
  List<Object> get props => [];
}
class GetListCustomerLimoSuccess extends MapLimoState {

  final List<DetailTripsReponseBody> listOfCustomerTrips;

  GetListCustomerLimoSuccess(this.listOfCustomerTrips);

  @override
  String toString() => 'GetListCustomerSuccess }';
}

class MapLimoInitial extends MapLimoState {

  @override
  String toString() => 'MapLimoInitial';
}

class MapLimoFailure extends MapLimoState {
  final String error;

  MapLimoFailure(this.error);

  @override
  String toString() => 'MapLimoFailure { error: $error }';
}

class MapLimoLoading extends MapLimoState {
  @override
  String toString() => 'MapLimoLoading';
}
class UpdateStatusDriverLimoState extends MapLimoState {

  @override
  String toString() => 'UpdateStatusDriverLimoState {}';
}