import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trungchuyen/models/network/service/network_factory.dart';
import 'package:trungchuyen/page/account/account_event.dart';
import 'package:trungchuyen/utils/const.dart';
import 'package:trungchuyen/utils/utils.dart';

import 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent,AccountState> {

  BuildContext context;
  NetWorkFactory _networkFactory;
  SharedPreferences _prefs;
  SharedPreferences get prefs => _prefs;
  String _accessToken;
  String get accessToken => _accessToken;
  String _refreshToken;
  String get refreshToken => _refreshToken;
  String role;
  String userName;
  String phone;

  AccountBloc(this.context){
    _networkFactory = NetWorkFactory(context);
  }

  @override
  Stream<AccountState> mapEventToState(AccountEvent event) async*{
    // TODO: implement mapEventToState
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
      _accessToken = _prefs.getString(Const.ACCESS_TOKEN) ?? "";
      _refreshToken = _prefs.getString(Const.REFRESH_TOKEN) ?? "";
      role = _prefs.getString(Const.CHUC_VU) ?? "";
      userName = _prefs.getString(Const.FULL_NAME) ?? "";
      phone = _prefs.getString(Const.PHONE_NUMBER) ?? "";
    }
    if(event is GetInfoAccount){
      yield AccountLoading();
      yield GetInfoAccountSuccess();
    }
    else if(event is LogOut){
      yield AccountLoading();
      AccountState state = _handleLogOut(await _networkFactory.logOut(_accessToken));
      yield state;
    }
  }

  @override
  // TODO: implement initialState
  AccountState get initialState => AccountInitial();

  AccountState _handleLogOut(Object data) {
    if (data is String) return AccountFailure(data);
    try {
      Utils.removeData(_prefs);
      return LogOutSuccess();
    } catch (e) {
      print(e.toString());
      return AccountFailure(e.toString());
    }
  }

}