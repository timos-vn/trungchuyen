import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {

  @override
  String toString() => 'LoginInitial';
}
class ChangeLanguageSuccess extends LoginState {
  final String nameLng;

  ChangeLanguageSuccess(this.nameLng);
  @override
  String toString() {
    return 'ChangeLanguageSuccess{nameLng: $nameLng}';
  }
}

class LoginLoading extends LoginState {
  @override
  String toString() => 'LoginLoading';
}

class LoginSuccess extends LoginState {

  @override
  String toString() {
    return 'LoginSuccess{}';
  }
}
class LoginFailure extends LoginState {
  final String error;

  LoginFailure(this.error);

  @override
  String toString() => 'LoginFailure { error: $error }';
}

class ValidateErrorHostId extends LoginState {
  final String error;

  ValidateErrorHostId(this.error);

  @override
  String toString() => 'ValidateErrorHostId { error: $error }';
}

class ValidateErrorUsername extends LoginState {
  final String error;

  ValidateErrorUsername(this.error);

  @override
  String toString() => 'ValidateErrorUsername { error: $error }';
}

class ValidateErrorPassword extends LoginState {
  final String error;

  ValidateErrorPassword(this.error);

  @override
  String toString() => 'ValidateErrorPassword { error: $error }';
}

class UpdateStatusDriverState extends LoginState {

  @override
  String toString() => 'UpdateStatusDriverState {}';
}