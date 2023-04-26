import 'package:equatable/equatable.dart';

abstract class ChangePasswordState extends Equatable {
  @override
  List<Object> get props => [];
}

class ChangePasswordInitial extends ChangePasswordState {

  @override
  String toString() => 'ChangePasswordInitial';
}

class ChangePasswordLoading extends ChangePasswordState {

  @override
  String toString() => 'ChangePasswordLoading';
}

class GetPrefsSuccess extends ChangePasswordState{

  @override
  String toString() {
    return 'GetPrefsSuccess{}';
  }
}
class ChangePasswordFailure extends ChangePasswordState {
  final String error;

  ChangePasswordFailure(this.error);

  @override
  String toString() => 'ChangePasswordFailure { error: $error }';
}

class ChangePasswordSuccess extends ChangePasswordState {

  @override
  String toString() {
    return 'ChangePasswordSuccess{}';
  }
}

class ValidateErrorAgainPasswordNew extends ChangePasswordState {
  final String error;

  ValidateErrorAgainPasswordNew(this.error);

  @override
  String toString() => 'ValidateErrorAgainPasswordNew { error: $error }';
}

class ValidateErrorPasswordOld extends ChangePasswordState {
  final String error;

  ValidateErrorPasswordOld(this.error);

  @override
  String toString() => 'ValidateErrorPasswordOld { error: $error }';
}

class ValidateErrorPasswordNew extends ChangePasswordState {
  final String error;

  ValidateErrorPasswordNew(this.error);

  @override
  String toString() => 'ValidateErrorPasswordNew { error: $error }';
}