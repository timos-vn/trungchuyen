import 'package:equatable/equatable.dart';

abstract class NotificationState extends Equatable {
  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {
  @override
  String toString() => 'OrderInitial';
}
class NotificationLoading extends NotificationState {
  @override
  String toString() => 'NotificationLoading';
}

class GetListNotificationSuccess extends NotificationState {

  @override
  String toString() {
    return 'GetListNotificationSuccess{}';
  }
}
class GetListNotificationFailure extends NotificationState {
  final String error;

  GetListNotificationFailure(this.error);

  @override
  String toString() => 'GetListNotificationFailure { error: $error }';
}
class EmptyDataState extends NotificationState {
  @override
  String toString() {
    // TODO: implement toString
    return 'EmptyDataState{}';
  }
}
class UpdateNotificationFailure extends NotificationState {
  final String error;

  UpdateNotificationFailure(this.error);

  @override
  String toString() => 'UpdateNotificationFailure { error: $error }';
}

class UpdateNotificationSuccess extends NotificationState {

  @override
  String toString() {
    return 'UpdateNotificationSuccess{}';
  }
}