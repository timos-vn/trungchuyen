import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trungchuyen/utils/const.dart';
import 'package:trungchuyen/utils/utils.dart';

import 'options_input_event.dart';
import 'options_input_state.dart';

class OptionsInputBloc extends Bloc<OptionsInputEvent, OptionsInputState> {

  SharedPreferences _prefs;

  BuildContext context;
  int _status = 0;
  int get status => _status;
  DateTime _dateFrom;
  DateTime _dateTo;
  List<String> _listTimeId;
  List<String> _listTimeName;

  List<String> get listTimeId => _listTimeId;
  List<String> get listTimeName => _listTimeName;
  DateTime get dateFrom => _dateFrom;
  DateTime get dateTo => _dateTo;



  init(BuildContext context) {
    this.context = context;
    _dateFrom = DateTime.now().subtract(Duration(days: 7));
    _dateTo = DateTime.now();
  }

  bool checkDate() {
    if (dateFrom.isBefore(dateTo)) {
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

  @override
  OptionsInputState get initialState => InitialOptionsInputState();

  @override
  Stream<OptionsInputState> mapEventToState(OptionsInputEvent event,) async* {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    if(event is GetListTimeStatus){
      yield InitialOptionsInputState();

      yield GetListTimeSuccess();
    }
    if (event is DateFrom || event is DateTo) {
      yield InitialOptionsInputState();
      if (event is DateFrom) {
        _dateFrom = event.date;
        if (_dateTo == null) {
          yield PickDateSuccess();
          return;
        }
      }
      if (event is DateTo) {
        _dateTo = event.date;
        if (_dateFrom == null) {
          yield PickDateSuccess();
          return;
        }
      }
      if (_dateFrom.add(Duration(hours: -23)).isAfter(_dateTo)) {
        _dateTo = null;
        yield WrongDate();
        return;
      }
    }

    if (event is PickGenderStatus) {
      yield InitialOptionsInputState();
      _status = event.status;
      yield PickGenderStatusSuccess();
    }
  }
}