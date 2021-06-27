import 'package:equatable/equatable.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_controller/google_maps_controller.dart';
import 'package:trungchuyen/models/network/response/detail_trips_repose.dart';

abstract class  MapState extends Equatable {
  @override
  List<Object> get props => [];
}
class GetListCustomerSuccess extends MapState {

  final List<DetailTripsResponseBody> listOfCustomerTrips;

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
class CheckPermissionSuccess extends MapState {

  @override
  String toString() => 'CheckPermissionSuccess {}';
}
class OnlineSuccess extends MapState {

  @override
  String toString() => 'OnlineSuccess {}';
}
class OfflineSuccess extends MapState {

  @override
  String toString() => 'OfflineSuccess {}';
}
class OfflineSuccess2 extends MapState {

  @override
  String toString() => 'OfflineSuccess {}';
}
class GetListLocationPolylineSuccess extends MapState {
  final List<LatLng> lsPoints;

  GetListLocationPolylineSuccess(this.lsPoints);
  @override
  String toString() => 'GetListLocationPolylineSuccess {}';
}
class TransferCustomerToLimoSuccess extends MapState {

  @override
  String toString() => 'TransferCustomerToLimoSuccess {}';
}
class PushLocationToLimoSuccess extends MapState {

  @override
  String toString() => 'PushLocationToLimoSuccess {}';
}