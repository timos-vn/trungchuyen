import 'package:equatable/equatable.dart';
import 'package:trungchuyen/models/entity/customer.dart';
import 'package:trungchuyen/models/network/response/detail_trips_repose.dart';

abstract class MapEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetListCustomer extends MapEvent {

  final List<DetailTripsResponseBody> listOfDetailTrips;

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

class CheckPermissionEvent extends MapEvent {

  @override
  String toString() => 'CheckPermissionEvent {}';
}

class OnlineEvent extends MapEvent {

  @override
  String toString() => 'OnlineEvent {}';
}

class OfflineEvent extends MapEvent {

  @override
  String toString() => 'OnlineEvent {}';
}

class PushLocationToLimoEvent extends MapEvent {

  final String location;

  PushLocationToLimoEvent(this.location);

  @override
  String toString() => 'PushLocationToLimoEvent {location:$location}';
}
class GetCurrentLocationEvent extends MapEvent {

  final String location;

  GetCurrentLocationEvent(this.location);

  @override
  String toString() => 'GetCurrentLocationEvent {}';
}

class GetListLocationPolylineEvent extends MapEvent {

  final String customerLocation;

  GetListLocationPolylineEvent(this.customerLocation);

  @override
  String toString() => 'GetListLocationPolylineEvent {customerLocation: $customerLocation}';
}
class CustomerTransferToLimo extends MapEvent {

  final String title;
  final String body;
  final List<Customer> listTaiXeTC;

  CustomerTransferToLimo(this.title, this.body, this.listTaiXeTC);

  @override
  String toString() => 'CustomerTransferToLimo {title: $title,body:$body, listTaiXeTC:$listTaiXeTC}';
}

class GetCustomerList extends MapEvent{

  @override
  String toString() {
    // TODO: implement toString
    return 'GetCustomerList{}';
  }
}

class UpdateCustomerList extends MapEvent{

  final DetailTripsResponseBody customer;

  UpdateCustomerList(this.customer);

  @override
  String toString() {
    // TODO: implement toString
    return 'GetCustomerList{}';
  }
}

class GetPrefs extends MapEvent {

  @override
  String toString() => 'GetPrefs';
}

class UpdateStatusCustomerMapEvent extends MapEvent{
  final int? status;
  final List<String>? idTrungChuyen;
  final String? note;
  UpdateStatusCustomerMapEvent({this.status,this.idTrungChuyen,this.note});

  @override
  String toString() {
    return 'UpdateStatusCustomerMapEvent{status: $status, idTrungChuyen:$idTrungChuyen}';
  }
}

class UpdateTaiXeLimos extends MapEvent{

  final DetailTripsResponseBody customer;

  UpdateTaiXeLimos(this.customer);

  @override
  String toString() {
    // TODO: implement toString
    return 'UpdateTaiXeLimos{}';
  }
}

class GetListTaiXeLimos extends MapEvent{

  @override
  String toString() {
    // TODO: implement toString
    return 'GetListTaiXeLimos{}';
  }
}

class DeleteCustomer extends MapEvent{
  final String idTC;
  final int index;
  DeleteCustomer(this.idTC, this.index);
  @override
  String toString() {
    // TODO: implement toString
    return 'DeleteCustomer{}';
  }
}

class GetListDetailTripsCustomer extends MapEvent {

  final DateTime date;
  final int idRoom;
  final int idTime;
  final int typeCustomer;

  GetListDetailTripsCustomer(this.date,this.idRoom,this.idTime,this.typeCustomer);

  @override
  String toString() => 'GetListDetailTripsOfPageWaiting {date: $date }';
}

class AddOldCustomer extends MapEvent{

  final DetailTripsResponseBody customer;

  AddOldCustomer(this.customer);

  @override
  String toString() {
    // TODO: implement toString
    return 'AddOldCustomer{}';
  }
}