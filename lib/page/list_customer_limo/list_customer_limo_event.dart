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

class TranferCustomerLimo extends ListCustomerLimoEvent {

  final String title;
  final String body;
  final  List<DetailTripsLimoReponseBody> listTaiXeTC;

  TranferCustomerLimo(this.title, this.body, this.listTaiXeTC);

  @override
  String toString() => 'GetListCustomerLimo {title: $title,body:$body, idsTaiKhoan:$listTaiXeTC }';
}

class GetListDetailTripLimo extends ListCustomerLimoEvent {

  final DateTime date;
  final int idTrips;
  final int idTime;

  GetListDetailTripLimo(this.date,this.idTrips,this.idTime);

  @override
  String toString() => 'GetListDetailTripLimo {date: $date }';
}