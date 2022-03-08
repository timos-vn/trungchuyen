import 'package:equatable/equatable.dart';

abstract class  ListHistoryTCState extends Equatable {
  @override
  List<Object> get props => [];
}

class ListHistoryTCInitial extends ListHistoryTCState {

  @override
  String toString() => 'ListHistoryTCInitial';
}
class ListHistoryTCFailure extends ListHistoryTCState {
  final String error;

  ListHistoryTCFailure(this.error);

  @override
  String toString() => 'ListHistoryTCFailure { error: $error }';
}

class ListHistoryTCLoading extends ListHistoryTCState {
  @override
  String toString() => 'ListHistoryTCLoading';
}

class GetListHistoryTCSuccess extends ListHistoryTCState {
  @override
  String toString() => 'GetListHistoryTCSuccess }';
}

class GetListHistoryDetailTCSuccess extends ListHistoryTCState {
  @override
  String toString() => 'GetListHistoryDetailTCSuccess }';
}

class GetListHistoryTCEmpty extends ListHistoryTCState {

  @override
  String toString() {
    return 'GetListHistoryTCEmpty{}';
  }
}
class LoadMoreListHistoryTC extends ListHistoryTCState {
  @override
  String toString() {
    // TODO: implement toString
    return 'LoadMoreListHistoryTC{}';
  }
}
class GetListHistoryOfDetailTripTCSuccess extends ListHistoryTCState {
  @override
  String toString() => 'GetListHistoryOfDetailTripTCSuccess }';
}

