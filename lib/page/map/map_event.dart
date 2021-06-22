import 'package:equatable/equatable.dart';
import 'package:trungchuyen/models/network/response/detail_trips_repose.dart';

abstract class MapEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetListCustomer extends MapEvent {

  final List<DetailTripsReponseBody> listOfDetailTrips;

  GetListCustomer(this.listOfDetailTrips);

  @override
  String toString() => 'GetListCustomer {listOfDetailTrips: ${listOfDetailTrips.length}';
}

class UpdateStatusDriverEvent extends MapEvent {

  final int statusDriver;

  UpdateStatusDriverEvent(this.statusDriver);

  @override
  String toString() => 'UpdateStatusDriverEvent {statusDriver: $statusDriver}';
}