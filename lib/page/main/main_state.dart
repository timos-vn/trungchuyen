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

class UpdateTokenSuccessState extends MainState {

  @override
  String toString() {
    return 'UpdateTokenSuccessState{}';
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
  final String title;

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
