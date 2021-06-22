import 'package:equatable/equatable.dart';

abstract class  ListCustomerLimoState extends Equatable {
  @override
  List<Object> get props => [];
}

class ListCustomerLimoInitial extends ListCustomerLimoState {

  @override
  String toString() => 'ListCustomerLimoInitial';
}
class ListCustomerLimoFailure extends ListCustomerLimoState {
  final String error;

  ListCustomerLimoFailure(this.error);

  @override
  String toString() => 'ListCustomerLimoFailure { error: $error }';
}

class ListCustomerLimoLoading extends ListCustomerLimoState {
  @override
  String toString() => 'ListCustomerLimoLoading';
}

class GetListCustomerLimoSuccess extends ListCustomerLimoState {
  @override
  String toString() => 'GetListCustomerLimoSuccess }';
}

class GetListCustomerLimoEmpty extends ListCustomerLimoState {

  @override
  String toString() {
    return 'GetListCustomerLimoEmpty{}';
  }
}
class LoadMoreListCustomerLimo extends ListCustomerLimoState {
  @override
  String toString() {
    // TODO: implement toString
    return 'LoadMoreListCustomerLimo{}';
  }
}
class GetListOfDetailTripLimoSuccess extends ListCustomerLimoState {
  @override
  String toString() => 'GetListOfDetailTripLimoSuccess }';
}
class TransferLimoSuccess extends ListCustomerLimoState {
  @override
  String toString() => 'TransferLimoSuccess }';
}
