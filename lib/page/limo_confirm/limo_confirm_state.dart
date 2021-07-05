import 'package:equatable/equatable.dart';

abstract class LimoConfirmState extends Equatable {
  @override
  List<Object> get props => [];
}
class LimoConfirmInitial extends LimoConfirmState {

  @override
  String toString() => 'LimoConfirmInitial';
}

class LimoConfirmFailure extends LimoConfirmState {
  final String error;

  LimoConfirmFailure(this.error);

  @override
  String toString() => 'AccountFailure { error: $error }';
}
class LimoConfirmLoading extends LimoConfirmState {
  @override
  String toString() => 'AccountLoading';
}

class GetListCustomerConfirmLimoSuccess extends LimoConfirmState {
  @override
  String toString() => 'GetListCustomerConfirmLimoSuccess }';
}

class UpdateStatusCustomerConfirmSuccess extends LimoConfirmState {

  @override
  String toString() => 'UpdateStatusCustomerConfirmSuccess {}';
}