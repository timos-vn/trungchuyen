import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class OptionsInputState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialOptionsInputState extends OptionsInputState {
  @override
  String toString() {
    // TODO: implement toString
    return 'InitialOptionsInputState{}';
  }
}

class PickDateSuccess extends OptionsInputState {
  @override
  String toString() {
    // TODO: implement toString
    return 'PickDateSuccess{}';
  }
}

class WrongDate extends OptionsInputState {
  @override
  String toString() {
    // TODO: implement toString
    return 'WrongDate{}';
  }
}
class PickGenderStatusSuccess extends OptionsInputState {
  @override
  String toString() => 'PickGenderStatusSuccess';
}
class GetListTimeSuccess extends OptionsInputState {
  @override
  String toString() => 'GetListTimeSuccess';
}