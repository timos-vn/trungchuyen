import 'package:equatable/equatable.dart';

abstract class  WaitingState extends Equatable {
  @override
  List<Object> get props => [];
}

class GetPrefsSuccess extends WaitingState{

  @override
  String toString() {
    return 'GetPrefsSuccess{}';
  }
}

class WaitingInitial extends WaitingState {

  @override
  String toString() => 'WaitingInitial';
}
class WaitingFailure extends WaitingState {
  final String error;

  WaitingFailure(this.error);

  @override
  String toString() => 'WaitingFailure { error: $error }';
}

class WaitingLoading extends WaitingState {
  @override
  String toString() => 'WaitingLoading';
}

class GetListOfWaitingCustomerSuccess extends WaitingState {
  @override
  String toString() => 'GetListOfWaitingCustomerSuccess }';
}

class GetListOfWaitingCustomerEmpty extends WaitingState {

  @override
  String toString() {
    return 'GetListOfWaitingCustomerEmpty{}';
  }
}
class LoadMoreListOfWaitingCustomer extends WaitingState {
  @override
  String toString() {
    // TODO: implement toString
    return 'LoadMoreListOfWaitingCustomer{}';
  }
}
class GetListOfDetailTripsOfWaitingPageSuccess extends WaitingState {
  @override
  String toString() => 'GetListOfDetailTripsOfWaitingPageSuccess }';
}