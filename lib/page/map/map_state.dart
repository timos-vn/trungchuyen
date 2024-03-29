import 'package:equatable/equatable.dart';

abstract class  MapState extends Equatable {
  @override
  List<Object> get props => [];
}
class GetListCustomerSuccess extends MapState {

  @override
  String toString() => 'GetListCustomerSuccess }';
}
class GetPrefsSuccess extends MapState{

  @override
  String toString() {
    return 'GetPrefsSuccess{}';
  }
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
// class GetListLocationPolylineSuccess extends MapState {
//   final List<LatLng> lsPoints;
//
//   GetListLocationPolylineSuccess(this.lsPoints);
//   @override
//   String toString() => 'GetListLocationPolylineSuccess {}';
// }


class TransferCustomerToLimoSuccess extends MapState {
  final String listIDTC;

  TransferCustomerToLimoSuccess(this.listIDTC);
  @override
  String toString() => 'TransferCustomerToLimoSuccess {listIDTC: $listIDTC}';
}
class PushLocationToLimoSuccess extends MapState {

  @override
  String toString() => 'PushLocationToLimoSuccess {}';
}class UpdateStatusCustomerMapSuccess extends MapState {

  final int status;

  UpdateStatusCustomerMapSuccess(this.status);

  @override
  String toString() => 'UpdateStatusCustomerMapSuccess {}';
}

class GetListTaiXeLimosSuccess extends MapState {

  @override
  String toString() => 'GetListTaiXeLimosSuccess {}';
}
class GetListOfDetailTripsSuccess extends MapState {
  @override
  String toString() => 'GetListOfDetailTripsSuccess }';
}