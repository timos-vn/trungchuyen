import 'package:equatable/equatable.dart';
import 'package:trungchuyen/models/network/response/detail_trips_repose.dart';

abstract class MapLimoEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetListCustomerLimo extends MapLimoEvent {

  final List<DetailTripsResponseBody> listOfDetailTrips;

  GetListCustomerLimo(this.listOfDetailTrips);

  @override
  String toString() => 'GetListCustomer {listOfDetailTrips: ${listOfDetailTrips.length}';
}

class UpdateStatusDriverLimoEvent extends MapLimoEvent {

  final int statusDriver;

  UpdateStatusDriverLimoEvent(this.statusDriver);

  @override
  String toString() => 'UpdateStatusDriverLimoEvent {statusDriver: $statusDriver}';
}
class GetEvent extends MapLimoEvent {

  final String markerId;

  GetEvent(this.markerId);

  @override
  String toString() => 'GetEvent {}';
}
class CheckPermissionLimoEvent extends MapLimoEvent {

  @override
  String toString() => 'CheckPermissionLimoEvent {}';
}

class PushLocationOfLimoEvent extends MapLimoEvent {

  final String location;

  PushLocationOfLimoEvent(this.location);

  @override
  String toString() => 'PushLocationOfLimoEvent {location:$location}';
}

class OnlineEvent extends MapLimoEvent {

  @override
  String toString() => 'OnlineEvent {}';
}

class OfflineEvent extends MapLimoEvent {

  @override
  String toString() => 'OnlineEvent {}';
}