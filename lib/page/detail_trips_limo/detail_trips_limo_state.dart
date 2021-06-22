import 'package:equatable/equatable.dart';

abstract class DetailTripsLimoState extends Equatable {
  @override
  List<Object> get props => [];
}

class DetailTripsLimoInitial extends DetailTripsLimoState {

  @override
  String toString() => 'DetailTripsLimoInitial';
}
class DetailTripsLimoFailure extends DetailTripsLimoState {
  final String error;

  DetailTripsLimoFailure(this.error);

  @override
  String toString() => 'DetailTripsLimoFailure { error: $error }';
}

class DetailTripsLimoLoading extends DetailTripsLimoState {
  @override
  String toString() => 'DetailTripsLimoLoading';
}

class GetListOfDetailTripsLimoSuccess extends DetailTripsLimoState {
  @override
  String toString() => 'GetListOfDetailTripsLimoSuccess }';
}
