import 'package:equatable/equatable.dart';

abstract class ChangePasswordEvent extends Equatable {
  @override
  List<Object> get props => [];
}
class ChangePassword extends ChangePasswordEvent{
  final String passOld;
 final String passNew;

  ChangePassword(this.passOld, this.passNew);
  @override
  String toString() {
    return 'ChangePassword{passOld: $passOld, passNew: $passNew}';
  }
}
class ValidateAgainPasswordNewEvent extends ChangePasswordEvent {
  final String currentPassword;
  final String newPassword;
  ValidateAgainPasswordNewEvent(this.currentPassword,this.newPassword);

  @override
  String toString() => 'ValidateAgainPasswordNewEvent { currentPassword: $currentPassword, newPassword: $newPassword }';
}

class ValidatePasswordOldEvent extends ChangePasswordEvent {
  final String pass;

  ValidatePasswordOldEvent(this.pass);

  @override
  String toString() => 'ValidateUsername { username: $pass }';
}

class ValidatePasswordNewEvent extends ChangePasswordEvent {
  final String pass;

  ValidatePasswordNewEvent(this.pass);

  @override
  String toString() =>
      'ValidatePass { pass: $pass }';
}
