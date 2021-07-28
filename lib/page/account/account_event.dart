import 'package:equatable/equatable.dart';

abstract class AccountEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetInfoAccount extends AccountEvent {

  @override
  String toString() => 'GetInfoAccount {}';
}
class LogOut extends AccountEvent {

  @override
  String toString() => 'LogOut {}';
}

class UpdateInfo extends AccountEvent {

  final String phone;
  final String email;
  final String fullName;
  final String companyId;
  final String role;

  UpdateInfo(this.phone, this.email, this.fullName, this.companyId, this.role);

  @override
  String toString() => 'LogOut {}';
}