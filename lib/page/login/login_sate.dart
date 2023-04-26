import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {

  @override
  String toString() => 'LoginInitial';
}
class CheckVersionSuccess extends LoginState {

  @override
  String toString() => 'CheckVersionSuccess';
}
class ChangeLanguageSuccess extends LoginState {
  final String nameLng;

  ChangeLanguageSuccess(this.nameLng);
  @override
  String toString() {
    return 'ChangeLanguageSuccess{nameLng: $nameLng}';
  }
}

class GetPrefsSuccess extends LoginState{

  @override
  String toString() {
    return 'GetPrefsSuccess{}';
  }
}

class LoginLoading extends LoginState {
  @override
  String toString() => 'LoginLoading';
}

class LoginSuccess extends LoginState {

  final String tokenFCM;

  LoginSuccess(this.tokenFCM);

  @override
  String toString() {
    return 'LoginSuccess{tokenFCM: $tokenFCM}';
  }
}

class UpdateTokenSuccessState extends LoginState {

  final String tokenFCM;

  UpdateTokenSuccessState(this.tokenFCM);

  @override
  String toString() {
    return 'UpdateTokenSuccessState{}';
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
class SaveUserNamePasswordSuccessful extends LoginState {
  final String userName;
  final String passWord;

  SaveUserNamePasswordSuccessful(this.userName,this.passWord);

  @override
  String toString() => 'SaveUserNamePasswordSuccessful { userName: $userName }';
}
