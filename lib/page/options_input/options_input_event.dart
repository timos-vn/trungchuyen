import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class OptionsInputEvent extends Equatable {
  @override
  List<Object> get props => [];
}


class DateFrom extends OptionsInputEvent {
  final DateTime date;

  DateFrom(this.date);

  @override
  String toString() {
    // TODO: implement toString
    return 'DateFrom{}';
  }
}
class GetPrefs extends OptionsInputEvent {

  @override
  String toString() => 'GetPrefs';
}
class DateTo extends OptionsInputEvent {
  final DateTime date;

  DateTo(this.date);

  @override
  String toString() {
    // TODO: implement toString
    return 'DateTo{}';
  }
}

class PickGenderStatus extends OptionsInputEvent {

  final int status;

  PickGenderStatus(this.status);

  @override
  String toString() {
    return 'PickGenderStatus{status: $status}';
  }
}

class GetListTimeStatus extends OptionsInputEvent {


  @override
  String toString() {
    return 'GetListTimeStatus{}';
  }
}
