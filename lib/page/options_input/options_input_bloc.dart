import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trungchuyen/utils/const.dart';
import 'package:trungchuyen/utils/utils.dart';

import 'options_input_event.dart';
import 'options_input_state.dart';

class OptionsInputBloc extends Bloc<OptionsInputEvent, OptionsInputState> {

  SharedPreferences? _prefs;

  BuildContext context;
  int? _status = 0;
  int? get status => _status;
  DateTime _dateFrom = DateTime.now();
  DateTime? _dateTo  = DateTime.now();
  List<String> _listTimeId = [];
  List<String> _listTimeName = [];

  List<String> get listTimeId => _listTimeId;
  List<String> get listTimeName => _listTimeName;
  DateTime? get dateFrom => _dateFrom;
  DateTime? get dateTo => _dateTo;

  OptionsInputBloc(this.context) : super(InitialOptionsInputState()){

    on<GetPrefs>(_getPrefs,);
    on<GetListTimeStatus>(_getListTimeStatus);
    on<DateFrom>(_dateFromEvent);
    on<DateFrom>(_dateToEvent);
    on<PickGenderStatus>(_pickGenderStatus);
  }

  void _getPrefs(GetPrefs event, Emitter<OptionsInputState> emitter)async{
    emitter(InitialOptionsInputState());
    _prefs = await SharedPreferences.getInstance();
    emitter(GetPrefsSuccess());
  }

  void _getListTimeStatus(GetListTimeStatus event, Emitter<OptionsInputState> emitter)async{
    emitter(InitialOptionsInputState());
    emitter(GetListTimeSuccess());
  }

  void _dateFromEvent(DateFrom event, Emitter<OptionsInputState> emitter)async{
    emitter(InitialOptionsInputState());
    _dateFrom = event.date;
    if (_dateTo == null) {
      emitter(PickDateSuccess());
      return;
    }
    if (_dateFrom.add(Duration(hours: -23)).isAfter(_dateTo!)) {
      _dateTo = null;
      emitter(WrongDate());
      return;
    }
  }

  void _dateToEvent(DateFrom event, Emitter<OptionsInputState> emitter)async{
    emitter(InitialOptionsInputState());
    _dateTo = event.date;
    if (_dateFrom == null) {
      emitter(PickDateSuccess());
      return;
    }
    if (_dateFrom.add(Duration(hours: -23)).isAfter(_dateTo!)) {
      _dateTo = null;
      emitter(WrongDate());
      return;
    }
  }

  void _pickGenderStatus(PickGenderStatus event, Emitter<OptionsInputState> emitter)async{
    emitter(InitialOptionsInputState());
    _status = event.status;
    emitter(PickGenderStatusSuccess());
  }

  init(BuildContext context) {
    this.context = context;
    _dateFrom = DateTime.now().subtract(Duration(days: 7));
    _dateTo = DateTime.now();
  }

  bool checkDate() {
    if (dateFrom!.isBefore(dateTo!)) {
      return true;
    } else {
      return false;
    }
  }

   DateTime stringToDate(String date) {
     return DateTime.parse(date);
   }

  String getStringFromDate(DateTime date) {
    return Utils.parseDateToString(date, Const.DATE_FORMAT);
  }

  String getStringFromDateYMD(DateTime date) {
    return Utils.parseDateToString(date, Const.DATE_SV_FORMAT_2);
  }
}