import 'package:equatable/equatable.dart';

abstract class AccountState extends Equatable {
  @override
  List<Object> get props => [];
}

class GetPrefsSuccess extends AccountState{

  @override
  String toString() {
    return 'GetPrefsSuccess{}';
  }
}
class AccountInitial extends AccountState {

  @override
  String toString() => 'AccountInitial';
}
class AccountFailure extends AccountState {
  final String error;

  AccountFailure(this.error);

  @override
  String toString() => 'AccountFailure { error: $error }';
}
class AccountLoading extends AccountState {
  @override
  String toString() => 'AccountLoading';
}

class GetInfoAccountSuccess extends AccountState {
  @override
  String toString() => 'GetInfoAccountSuccess }';
}

class LogOutSuccess extends AccountState {
  @override
  String toString() => 'LogOutSuccess }';
}

class UpdateInfoSuccess extends AccountState {
  @override
  String toString() => 'UpdateInfoSuccess }';
}
