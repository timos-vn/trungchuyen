import 'package:get/get.dart' as libGet;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trungchuyen/models/network/request/change_password_request.dart';
import 'package:trungchuyen/models/network/service/network_factory.dart';
import 'package:trungchuyen/utils/const.dart';
import 'package:trungchuyen/utils/validator.dart';

import 'change_password_event.dart';
import 'change_password_state.dart';


class ChangePasswordBloc extends Bloc<ChangePasswordEvent,ChangePasswordState>with Validators{


  NetWorkFactory _networkFactory;
  BuildContext context;
  String _accessToken;
  String get accessToken => _accessToken;
  String _refreshToken;
  String get refreshToken => _refreshToken;
  SharedPreferences _prefs;
  String _username;
  String get username => _username;
  String _errorUsername, _errorPass, _errorAgainPass;


  ChangePasswordBloc(this.context) {
    _networkFactory = NetWorkFactory(context);
  }

  @override
  // TODO: implement initialState
  ChangePasswordState get initialState => ChangePasswordInitial();

  @override
  Stream<ChangePasswordState> mapEventToState(ChangePasswordEvent event) async* {
    // TODO: implement mapEventToState
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
      _accessToken = _prefs.getString(Const.ACCESS_TOKEN) ?? "";
      _refreshToken = _prefs.getString(Const.REFRESH_TOKEN) ?? "";
    }
    if(event is ChangePassword){
      yield ChangePasswordLoading();
      ChangePasswordRequest request = ChangePasswordRequest(
        matKhauHienTai: event.passOld,
        matKhau: event.passNew
      );
      ChangePasswordState state = _handleChangePassword(await _networkFactory.changePassword(request,_accessToken));
      yield state;
    }
    if (event is ValidatePasswordOldEvent) {
      yield ChangePasswordInitial();
      String error = checkPass(context, event.pass);
      yield ValidateErrorPasswordOld(error);
    }
    if (event is ValidatePasswordNewEvent) {
      yield ChangePasswordInitial();
      String error = checkPass(context, event.pass);
      yield ValidateErrorPasswordNew(error);
    }
    if (event is ValidateAgainPasswordNewEvent) {
      yield ChangePasswordInitial();
      String error = checkPassAgain(context, event.currentPassword, event.newPassword);
      yield ValidateErrorAgainPasswordNew(error);
    }
  }

  ChangePasswordState _handleChangePassword(Object data){
    if (data is String) return ChangePasswordFailure(data ?? 'Error'.tr);
    try{
      return ChangePasswordSuccess();
    } catch (e) {
      print(e.toString());
      return ChangePasswordFailure(e);
    }
  }

  void checkPasswordOldBloc(String username) {
    String _tempErrUsername = checkPass(context, username);
    if (_errorUsername != _tempErrUsername) {
      _errorUsername = _tempErrUsername;
      add(ValidatePasswordOldEvent(username));
    }
  }

  void checkPasswordNewBloc(String pass) {
    String _tempErrPass = checkPass(context, pass);
    if (_errorPass != _tempErrPass) {
      _errorPass = _tempErrPass;
      add(ValidatePasswordNewEvent(pass));
    }
  }

  void checkAgainPassBloc( String currentPassword, String newPassword) {
    String _tempErrPass = checkPassAgain(context, currentPassword,newPassword);
    if (_errorAgainPass != _tempErrPass) {
      _errorAgainPass = _tempErrPass;
      add(ValidateAgainPasswordNewEvent(currentPassword,newPassword));
    }
  }
}