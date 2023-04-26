import 'package:equatable/equatable.dart';

abstract class LimoConfirmEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetListCustomerConfirmEvent extends LimoConfirmEvent {

  @override
  String toString() => 'GetListCustomerConfirmEvent {}';
}

class GetPrefs extends LimoConfirmEvent {

  @override
  String toString() => 'GetPrefs';
}

class UpdateStatusCustomerConfirmMapEvent extends LimoConfirmEvent{
  final int? status;
  final String? idTrungChuyen;
  final String? note;
  final String? idLaiXeTC;
  UpdateStatusCustomerConfirmMapEvent({this.status,this.idTrungChuyen,this.note,this.idLaiXeTC});

  @override
  String toString() {
    return 'UpdateStatusCustomerConfirmMapEvent{status: $status, idTrungChuyen:$idTrungChuyen}';
  }
}
class LimoConfirm extends LimoConfirmEvent {

  final String title;
  final String body;
  final String listTaiXeTC;

  LimoConfirm(this.title, this.body, this.listTaiXeTC);

  @override
  String toString() => 'LimoConfirm {title: $title,body:$body, listTaiXeTC:$listTaiXeTC}';
}