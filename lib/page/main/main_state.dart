import 'package:equatable/equatable.dart';


abstract class MainState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialMainState extends MainState {

  @override
  String toString() {
    return 'InitialMainState{}';
  }
}

class SetMainState extends MainState {

  @override
  String toString() {
    return 'SetMainState{}';
  }
}

class MainPageState extends MainState {
  final int position;

  MainPageState(this.position);

  @override
  String toString() => 'MainPageState';
}

class MainFailure extends MainState {
  final String error;

  MainFailure(this.error);

  @override
  String toString() {
    return 'MainFail{error: $error}';
  }
}
class GetPrefsSuccess extends MainState{

  @override
  String toString() {
    return 'GetPrefsSuccess{}';
  }
}
class MainSearchState extends MainState {

  @override
  String toString() => 'MainSearchState';
}

class MainProfile extends MainState {

  @override
  String toString() => 'MainProfile';
}

class MainLoading extends MainState {
  @override
  String toString() => "MainLoading";
}

class LogoutSuccess extends MainState {
  @override
  String toString() => 'LogoutSuccess';
}

class LogoutFailure extends MainState {
  final String error;

  LogoutFailure(this.error);

  @override
  String toString() => 'LogoutFailure: $error}';
}

class ChangeTitleAppbarSuccess extends MainState {
  final String? title;

  ChangeTitleAppbarSuccess({this.title});

  @override
  String toString() {
    return 'ChangeTitleAppbarSuccess{title: $title}';
  }
}

class GetCountNotiSuccess extends MainState {

  @override
  String toString() {
    return 'GetCountNotiSuccess{}';
  }
}

class InitializeDb extends MainState{

  @override
  String toString() {
    return 'InitializeDb{}';
  }
}

class RefreshMainState extends MainState{

  @override
  String toString() {
    return 'RefreshMainState{}';
  }
}

class NavigateToPayState extends MainState{

  @override
  String toString() {
    return 'NavigateToPayState{}';
  }
}

class NavigateToNotificationState extends MainState{

  @override
  String toString() {
    return 'NavigateToNotificationState{}';
  }
}

class GetCountApprovalSuccess extends MainState{

  @override
  String toString() {
    return 'GetCountApprovalSuccess{}';
  }
}

class GetListOfGroupCustomerSuccess extends MainState {
  @override
  String toString() => 'GetListOfGroupCustomerSuccess }';
}
class UpdateStatusCustomerSuccess extends MainState {

  @override
  String toString() => 'UpdateStatusCustomerSuccess }';
}

class TXLimoConfirmWithTXTCSuccess extends MainState {

  @override
  String toString() => 'TXLimoConfirmWithTXTCSuccess {}';
}
class GetLocationSuccess extends MainState {


  final String makerID;
  final double lat;
  final double lng;

  GetLocationSuccess(this.makerID, this.lat, this.lng);

  @override
  String toString() => 'GetLocationSuccess {}';
}

class GetCustomerListSuccess extends MainState {

  @override
  String toString() => 'GetCustomerListSuccess {}';
}
class GetListNotificationOfLimoSuccess extends MainState {

  @override
  String toString() => 'GetListNotificationOfLimoSuccess {}';
}

class GetListNotificationCustomerSuccess extends MainState {

  @override
  String toString() => 'GetListNotificationCustomerSuccess {}';
}
class GetListNotificationOfTC extends MainState {

  @override
  String toString() => 'GetListNotificationOfTC {}';
}
class GetListTaiXeLimoSuccess extends MainState {

  @override
  String toString() => 'GetListTaiXeLimoSuccess {}';
}
class GetListCustomerConfirmLimo extends MainState {
  @override
  String toString() => 'GetListCustomerConfirmLimo }';
}
class GetListCustomerLimoSuccess extends MainState {
  @override
  String toString() => 'GetListCustomerLimoSuccess }';
}
class GetListOfDetailTripsTCSuccess extends MainState {

  final DateTime ngayChay;
  final int idRoom;
  final int idTime;
  final int typeCustomer;

  GetListOfDetailTripsTCSuccess(this.ngayChay, this.idRoom, this.idTime, this.typeCustomer);

  @override
  String toString() => 'GetListOfDetailTripsTCSuccess }';
}
class CountNotificationSuccess extends MainState {
  @override
  String toString() => 'CountNotificationSuccess }';
}

class GetListOfDetailLimoTripsSuccess extends MainState {
  @override
  String toString() => 'GetListOfDetailLimoTripsSuccess }';
}