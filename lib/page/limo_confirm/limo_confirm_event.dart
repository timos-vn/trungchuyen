import 'package:equatable/equatable.dart';

abstract class LimoConfirmEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetListCustomerConfirmEvent extends LimoConfirmEvent {

  @override
  String toString() => 'GetListCustomerConfirmEvent {}';
}

class UpdateStatusCustomerConfirmMapEvent extends LimoConfirmEvent{
  final int status;
  final String idTrungChuyen;
  final String note;
  UpdateStatusCustomerConfirmMapEvent({this.status,this.idTrungChuyen,this.note});

  @override
  String toString() {
    return 'UpdateStatusCustomerConfirmMapEvent{status: $status, idTrungChuyen:$idTrungChuyen}';
  }
}