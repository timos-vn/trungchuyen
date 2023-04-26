import 'package:equatable/equatable.dart';
import 'package:trungchuyen/models/entity/notification_of_limo.dart';
import 'package:trungchuyen/models/network/response/detail_trips_repose.dart';


abstract class MainEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class NavigateBottomNavigation extends MainEvent {
  final int position;

  NavigateBottomNavigation(this.position);

  @override
  String toString() => 'NavigateBottomNavigation: $position';
}
class GetPrefsMain extends MainEvent {

  @override
  String toString() => 'GetPrefs';
}
class NavigateProfile extends MainEvent {

  @override
  String toString() => 'NavigateProfile';
}

class ImmediateLogOut extends MainEvent {
  ImmediateLogOut();

  @override
  String toString() => 'ImmediateLogOut';
}

// class ForegroundNotification extends MainEvent {
//   final NotificationData data;
//
//   ForegroundNotification(this.data);
//
//   @override
//   String toString() => 'ForegroundNotification';
// }

class GetListGroupCustomer extends MainEvent {

  final DateTime date;

  GetListGroupCustomer(this.date,);

  @override
  String toString() => 'GetListGroupAwaitingCustomer {date: $date }';
}

class ChangeTitleAppbarEvent extends MainEvent {
  final String? title;

  ChangeTitleAppbarEvent({this.title});

  @override
  String toString() {
    return 'ChangeTitleAppbarEvent{title: $title}';
  }
}

class GetCountProduct extends MainEvent{

  final int count ;

  GetCountProduct(this.count);

  @override
  String toString() {
    return 'GetCountProduct{count: $count}';
  }
}

class GetPermissionEvent extends MainEvent {

  @override
  String toString() {
    return 'GetPermissionEvent{}';
  }
}

class GetCountNotificationUnRead extends MainEvent{
  final bool isRefresh;

  GetCountNotificationUnRead({this.isRefresh = false});
  @override
  String toString() {
    return 'GetCountNotificationUnRead{isRefresh: $isRefresh}';
  }
}

class LogoutMainEvent extends MainEvent {

  @override
  String toString() {
    return 'LogoutMainEvent{}';
  }
}

class RefreshMain extends MainEvent{
  @override
  String toString() {
    return 'RefreshMain{}';
  }
}

class NavigateToPay extends MainEvent{
  @override
  String toString() {
    // TODO: implement toString
    return 'NavigateToPay{}';
  }
}

class NavigateToNotification extends MainEvent{
  @override
  String toString() {
    // TODO: implement toString
    return 'NavigateToNotification{}';
  }
}

class GetCountApprovalEvent extends MainEvent {
  @override
  String toString() => 'GetCountApprovalEvent {}';
}

class SetEvent extends MainEvent {
  final String unitName;
  final String storeName;
  final String userName;
  final List<String> listInfoUnitsID;
  final List<String> listInfoUnitsName;
  final String currentCompanyID;
  final String currentCompanyName;

  SetEvent(this.unitName,this.storeName,this.userName,this.listInfoUnitsID,this.listInfoUnitsName,this.currentCompanyID,this.currentCompanyName);
  @override
  String toString() => 'SetEvent {}';
}

class GetCountNotiSMS extends MainEvent{
  final bool isRefresh;

  GetCountNotiSMS({this.isRefresh = false});
  @override
  String toString() {
    return 'GetCountNotiSMS{isRefresh: $isRefresh}';
  }
}

class UpdateStatusCustomerEvent extends MainEvent{
  final int? status;
  final List<String>? idTrungChuyen;
  final String? note;
  UpdateStatusCustomerEvent({this.status,this.idTrungChuyen,this.note});

  @override
  String toString() {
    return 'UpdateStatusCustomerEvent{status: $status, idTrungChuyen:$idTrungChuyen}';
  }
}
class ConfirmWithTXTC extends MainEvent {

  final String title;
  final String body;
  final List<String> listId;

  ConfirmWithTXTC(this.title, this.body, this.listId);

  @override
  String toString() => 'ConfirmWithTXTC {title: $title,body:$body, listId:$listId}';
}

class GetLocationEvent extends MainEvent {

  final String makerID;
  final double lat;
  final double lng;

  GetLocationEvent(this.makerID, this.lat, this.lng);

  @override
  String toString() => 'GetLocationEvent {makerID:$makerID,lat:$lat,lng:$lng}';
}
//
class UpdateCustomerItemList extends MainEvent{

  final DetailTripsResponseBody customer;

  UpdateCustomerItemList(this.customer);

  @override
  String toString() {
    // TODO: implement toString
    return 'UpdateCustomerItemList{}';
  }
}class AddOldCustomerItemList extends MainEvent{

  final DetailTripsResponseBody customer;

  AddOldCustomerItemList(this.customer);

  @override
  String toString() {
    // TODO: implement toString
    return 'AddOldCustomerItemList{}';
  }
}

class UpdateTaiXeLimo extends MainEvent{

  final DetailTripsResponseBody customer;

  UpdateTaiXeLimo(this.customer);

  @override
  String toString() {
    // TODO: implement toString
    return 'UpdateTaiXeLimo{}';
  }
}

class AddNotificationOfLimo extends MainEvent{

  final NotificationOfLimo notificationOfLimo;

  AddNotificationOfLimo(this.notificationOfLimo);

  @override
  String toString() {
    // TODO: implement toString
    return 'AddNotificationOfLimo{}';
  }
}

class DeleteItem extends MainEvent{
  final String idTC;
  final int index;
  DeleteItem(this.idTC, this.index);
  @override
  String toString() {
    // TODO: implement toString
    return 'DeleteItem{}';
  }
}

class GetCustomerItemList extends MainEvent{

  @override
  String toString() {
    // TODO: implement toString
    return 'GetCustomerItemList{}';
  }
}


class GetListTaiXeLimo extends MainEvent{

  @override
  String toString() {
    // TODO: implement toString
    return 'GetListTaiXeLimo{}';
  }
}
class GetListNotificationOfLimo extends MainEvent{

  @override
  String toString() {
    // TODO: implement toString
    return 'GetListNotificationOfLimo{}';
  }
}

class DeleteCustomerFormDB extends MainEvent{
  final String idTC;
  DeleteCustomerFormDB(this.idTC);
  @override
  String toString() {
    // TODO: implement toString
    return 'DeleteCustomerFormDB{}';
  }
}
class DeleteCustomerHuyOrDoiTaiFormDB extends MainEvent{
  final String idTC;
  DeleteCustomerHuyOrDoiTaiFormDB(this.idTC);
  @override
  String toString() {
    // TODO: implement toString
    return 'DeleteCustomerHuyOrDoiTaiFormDB{}';
  }
}
class KhachHuyOrDoiTaiXe extends MainEvent{
  final String idTC;
  KhachHuyOrDoiTaiXe(this.idTC);
  @override
  String toString() {
    // TODO: implement toString
    return 'KhachHuyOrDoiTaiXe{}';
  }
}
class ThemKhachMoiKhiTrongChuyen extends MainEvent{
  final String idTC;
  final String idTime;
  final String idVanPhong;

  ThemKhachMoiKhiTrongChuyen(this.idTC, this.idTime, this.idVanPhong);

  @override
  String toString() {
    // TODO: implement toString
    return 'ThemKhachMoiKhiTrongChuyen{}';
  }
}

class GetListGroupCustomerTC extends MainEvent {

  final DateTime date;

  GetListGroupCustomerTC(this.date,);

  @override
  String toString() => 'GetListGroupCustomerTC {date: $date }';
}

class GetListCustomerConfirm extends MainEvent {

  @override
  String toString() => 'GetListCustomerConfirm {}';
}
class GetListTripsLimo extends MainEvent {

  final DateTime date;

  GetListTripsLimo(this.date,);

  @override
  String toString() => 'GetListTripsLimo {date: $date }';
}

class GetListDetailTripsTC extends MainEvent {

  final DateTime date;
  final int idRoom;
  final int idTime;
  final int typeCustomer;

  GetListDetailTripsTC(this.date,this.idRoom,this.idTime,this.typeCustomer);

  @override
  String toString() => 'GetListDetailTripsTC {date: $date }';
}
class GetListDetailTripsLimoMain extends MainEvent {

  final String? date;
  final int? idTrips;
  final int? idTime;

  GetListDetailTripsLimoMain({this.date,this.idTrips,this.idTime});

  @override
  String toString() => 'GetListDetailTripsLimoMain {date: $date }';
}