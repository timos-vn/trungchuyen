import 'package:equatable/equatable.dart';
import 'package:trungchuyen/models/network/response/detail_trips_limo_reponse.dart';

abstract class ListCustomerLimoEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetListCustomerLimo extends ListCustomerLimoEvent {

  final DateTime date;

  GetListCustomerLimo(this.date,);

  @override
  String toString() => 'GetListCustomerLimo {date: $date }';
}

class GetPrefs extends ListCustomerLimoEvent {

  @override
  String toString() => 'GetPrefs';
}

class CustomerTransferToTC extends ListCustomerLimoEvent {

  final String title;
  final String body;
  final  List<DsKhachs> listTaiXeTC;

  CustomerTransferToTC(this.title, this.body, this.listTaiXeTC);

  @override
  String toString() => 'GetListCustomerLimo {title: $title,body:$body, idsTaiKhoan:$listTaiXeTC}';
}

class GetListDetailTripLimo extends ListCustomerLimoEvent {

  final DateTime date;
  final int idRoom;
  final int idTime;
  final int typeCustomer;

  GetListDetailTripLimo(this.date,this.idRoom,this.idTime,this.typeCustomer);

  @override
  String toString() => 'GetListDetailTripLimo {date: $date }';
}