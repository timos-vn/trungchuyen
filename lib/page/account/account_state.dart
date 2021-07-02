import 'package:equatable/equatable.dart';

abstract class AccountState extends Equatable {
  @override
  List<Object> get props => [];
}
class AccountInitial extends AccountState {

  @override
  String toString() => 'AccountInitial';
}