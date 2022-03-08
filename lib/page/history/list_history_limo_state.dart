import 'package:equatable/equatable.dart';

abstract class  ListHistoryLimoState extends Equatable {
  @override
  List<Object> get props => [];
}

class ListHistoryLimoInitial extends ListHistoryLimoState {

  @override
  String toString() => 'ListHistoryLimoInitial';
}
class ListHistoryLimoFailure extends ListHistoryLimoState {
  final String error;

  ListHistoryLimoFailure(this.error);

  @override
  String toString() => 'ListHistoryLimoFailure { error: $error }';
}

class ListHistoryLimoLoading extends ListHistoryLimoState {
  @override
  String toString() => 'ListHistoryLimoLoading';
}

class GetListHistoryLimoSuccess extends ListHistoryLimoState {
  @override
  String toString() => 'GetListHistoryLimoSuccess }';
}

class GetListHistoryDetailLimoSuccess extends ListHistoryLimoState {
  @override
  String toString() => 'GetListHistoryDetailLimoSuccess }';
}

class GetListHistoryLimoEmpty extends ListHistoryLimoState {

  @override
  String toString() {
    return 'GetListHistoryLimoEmpty{}';
  }
}
class LoadMoreListHistoryLimo extends ListHistoryLimoState {
  @override
  String toString() {
    // TODO: implement toString
    return 'LoadMoreListHistoryLimo{}';
  }
}
class GetListHistoryOfDetailTripLimoSuccess extends ListHistoryLimoState {
  @override
  String toString() => 'GetListHistoryOfDetailTripLimoSuccess }';
}

