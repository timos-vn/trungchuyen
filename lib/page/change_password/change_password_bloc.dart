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


  NetWorkFactory? _networkFactory;
  BuildContext context;
  String? _accessToken;
  String? get accessToken => _accessToken;
  String? _refreshToken;
  String? get refreshToken => _refreshToken;
  SharedPreferences? _prefs;
  String? _username;
  String? get username => _username;
  String? _errorUsername, _errorPass, _errorAgainPass;


  ChangePasswordBloc(this.context) : super(ChangePasswordInitial()){
    _networkFactory = NetWorkFactory(context);
    on<GetPrefs>(_getPrefs,);
    on<ChangePassword>(_changePassword);
    on<ValidatePasswordOldEvent>(_validatePasswordOldEvent);
    on<ValidatePasswordNewEvent>(_validatePasswordNewEvent);
    on<ValidateAgainPasswordNewEvent>(_validateAgainPasswordNewEvent);
  }

  void _getPrefs(GetPrefs event, Emitter<ChangePasswordState> emitter)async{
    emitter(ChangePasswordLoading());
    _prefs = await SharedPreferences.getInstance();
    _accessToken = _prefs!.getString(Const.ACCESS_TOKEN) ?? "";
    _refreshToken = _prefs!.getString(Const.REFRESH_TOKEN) ?? "";
    emitter(GetPrefsSuccess());
  }

  void _changePassword(ChangePassword event, Emitter<ChangePasswordState> emitter)async{
    emitter(ChangePasswordLoading());
    ChangePasswordRequest request = ChangePasswordRequest(
        matKhauHienTai: event.passOld,
        matKhau: event.passNew
    );
    ChangePasswordState state = _handleChangePassword(await _networkFactory!.changePassword(request,_accessToken!));
    emitter(state);
  }

  void _validatePasswordOldEvent(ValidatePasswordOldEvent event, Emitter<ChangePasswordState> emitter)async{
    emitter(ChangePasswordLoading());
    String? error = checkPass(context, event.pass) ?? '';
    emitter(ValidateErrorPasswordOld(error));
  }

  void _validatePasswordNewEvent(ValidatePasswordNewEvent event, Emitter<ChangePasswordState> emitter)async{
    emitter(ChangePasswordLoading());
    String? error = checkPass(context, event.pass) ?? '';
    emitter(ValidateErrorPasswordNew(error));
  }

  void _validateAgainPasswordNewEvent(ValidateAgainPasswordNewEvent event, Emitter<ChangePasswordState> emitter)async{
    emitter(ChangePasswordLoading());
    String error = checkPassAgain(context, event.currentPassword, event.newPassword) ?? '';
    emitter(ValidateErrorAgainPasswordNew(error));
  }

  ChangePasswordState _handleChangePassword(Object data){
    if (data is String) return ChangePasswordFailure(data.toString());
    try{
      return ChangePasswordSuccess();
    } catch (e) {
      print(e.toString());
      return ChangePasswordFailure(e.toString());
    }
  }

  void checkPasswordOldBloc(String username) {
    String? _tempErrUsername = checkPass(context, username);
    if (_errorUsername != _tempErrUsername) {
      _errorUsername = _tempErrUsername;
      add(ValidatePasswordOldEvent(username));
    }
  }

  void checkPasswordNewBloc(String pass) {
    String? _tempErrPass = checkPass(context, pass);
    if (_errorPass != _tempErrPass) {
      _errorPass = _tempErrPass;
      add(ValidatePasswordNewEvent(pass));
    }
  }

  void checkAgainPassBloc( String currentPassword, String newPassword) {
    String? _tempErrPass = checkPassAgain(context, currentPassword,newPassword);
    if (_errorAgainPass != _tempErrPass) {
      _errorAgainPass = _tempErrPass;
      add(ValidateAgainPasswordNewEvent(currentPassword,newPassword));
    }
  }
}