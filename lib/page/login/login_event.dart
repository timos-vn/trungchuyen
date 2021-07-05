import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Login extends LoginEvent {

  final String username;
  final String password;
  final bool savePassword;

  Login(this.username, this.password,this.savePassword);

  @override
  String toString() => 'Login {username: $username, password: $password,savePassword: $savePassword }';
}


class ValidateHostId extends LoginEvent {
  final String hostId;

  ValidateHostId(this.hostId);

  @override
  String toString() => 'ValidateHostId { hostId: $hostId }';
}

class ValidateUsername extends LoginEvent {
  final String username;

  ValidateUsername(this.username);

  @override
  String toString() => 'ValidateUsername { username: $username }';
}

class ValidatePass extends LoginEvent {
  final String pass;

  ValidatePass(this.pass);

  @override
  String toString() =>
      'ValidatePass { pass: $pass }';
}

class CheckDB extends LoginEvent {
  @override
  String toString() => 'CheckDB { }';
}

class UpdateStatusDriverEvent extends LoginEvent {

  final int statusDriver;

  UpdateStatusDriverEvent(this.statusDriver);

  @override
  String toString() => 'UpdateStatusDriverEvent {statusDriver: $statusDriver}';
}

class SaveLanguageEvent extends LoginEvent {

  final String codeLanguage;
  final String nameLanguage;

  SaveLanguageEvent(this.codeLanguage,this.nameLanguage);

  @override
  String toString() {
    return 'SaveLanguageEvent{codeLanguage: $codeLanguage,nameLanguage: $nameLanguage }';
  }
}

class SaveUserNamePassWordEvent extends LoginEvent {

  @override
  String toString() {
    return 'SaveUserNamePassWordEvent{}';
  }
}