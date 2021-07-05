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