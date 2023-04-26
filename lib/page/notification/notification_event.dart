import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetListNotification extends NotificationEvent {
  final bool? isScroll;
  final bool? isRefresh;
  final bool? isLoadMore;
  final bool? isReLoad;

  GetListNotification({this.isScroll,this.isRefresh = false, this.isLoadMore = false,this.isReLoad});

  @override
  String toString() => 'isScroll: $isScroll,GetListAds {isRefresh: $isRefresh, isLoadMore: $isLoadMore,isReLoad: $isReLoad}';
}

class GetPrefs extends NotificationEvent {

  @override
  String toString() => 'GetPrefs';
}

class UpdateNotificationEvent extends NotificationEvent {
  final String notificationID;

  UpdateNotificationEvent(this.notificationID);

  @override
  String toString() => 'notificationID: $notificationID';
}

class DeleteNotificationEvent extends NotificationEvent {
  final String notificationID;

  DeleteNotificationEvent(this.notificationID);

  @override
  String toString() => 'notificationID: $notificationID';
}

class UpdateAllNotificationEvent extends NotificationEvent {

  @override
  String toString() => '';
}

class DeleteAllNotificationEvent extends NotificationEvent {

  @override
  String toString() => '';
}