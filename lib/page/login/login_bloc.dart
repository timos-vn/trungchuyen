import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trungchuyen/models/database/dbhelper.dart';
import 'package:trungchuyen/models/entity/account.dart';
import 'package:trungchuyen/models/network/request/login_request.dart';
import 'package:trungchuyen/models/network/request/update_token_request.dart';
import 'package:trungchuyen/models/network/response/login_response.dart';
import 'package:trungchuyen/models/network/service/network_factory.dart';
import 'package:trungchuyen/utils/const.dart';
import 'package:trungchuyen/utils/utils.dart';
import 'package:trungchuyen/utils/validator.dart';

import 'login_event.dart';
import 'login_sate.dart';

class LoginBloc extends Bloc<LoginEvent,LoginState> with Validators{

  NetWorkFactory _networkFactory;

  BuildContext context;
  String _accessToken;
  String _refreshToken;
  FirebaseMessaging _firebaseMessaging;
  String _deviceToken;
  SharedPreferences _prefs;
  String _username;
  String get username => _username;
  String  _errorHostId,_errorUsername, _errorPass;
  DatabaseHelper db = DatabaseHelper();
  String _hotURL;
  String get hotURL => _hotURL;
  int roleAccount;
  bool roleTC;
  String codeLang = "v";
  List<AccountInfo> listAccountInfo = new List<AccountInfo>();
  LoginBloc(this.context) {
    _networkFactory = NetWorkFactory(context);
    _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.getToken().then((token) {
      print("token");
      print(token);
      _deviceToken = token;
    });
  }
  @override
  // TODO: implement initialState
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async*  {
    // TODO: implement mapEventToState
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
      _username = _prefs.getString(Const.USER_NAME) ?? "";
      _accessToken = _prefs.getString(Const.ACCESS_TOKEN) ?? "";
      _refreshToken = _prefs.getString(Const.REFRESH_TOKEN) ?? "";
    }
    if(event is SaveUserNamePassWordEvent){
      yield LoginLoading();
      listAccountInfo = await getListAccountInfoFromDb();
      if(!Utils.isEmpty(listAccountInfo)){
        yield SaveUserNamePasswordSuccessful(listAccountInfo[0].userName,listAccountInfo[0].pass,);
      }
      yield LoginInitial();
    }
    else if(event is UpdateTokenDiveEvent){
      yield LoginLoading();
      UpdateTokenRequestBody request = UpdateTokenRequestBody(
          deviceToken: event.deviceToken
      );
      LoginState state = _handleUpdateToken(await _networkFactory.updateToken(request,_accessToken));
      yield state;
    }
    if (event is Login) {
      yield LoginLoading();
      LoginRequestBody request = LoginRequestBody(
        username:event.username, /// 0963004959
        password:event.password, /// 0976024216
      );
      LoginState state = _handleLogin(await _networkFactory.login(request),event.savePassword,event.username,event.password);
      yield state;
    }

    if (event is ValidateHostId) {
      yield LoginInitial();
      String error = checkHotId(context, event.hostId);
      yield ValidateErrorHostId(error);
    }
    if (event is ValidateUsername) {
      yield LoginInitial();
      String error = checkUsername(context, event.username);
      yield ValidateErrorUsername(error);
    }
    if (event is ValidatePass) {
      yield LoginInitial();
      String error = checkPass(context, event.pass);
      yield ValidateErrorPassword(error);
    }
  }

  LoginState _handleUpdateToken(Object data) {
    if (data is String) return LoginFailure(data);
    try {
      print('Update success FCM');
      return UpdateTokenSuccessState();
    } catch (e) {
      print(e.toString());
      return LoginFailure(e.toString());
    }
  }

  LoginState _handleLogin(Object data,bool savePassword,String username,String pass) {
    if (data is String) return LoginFailure(data);
    try {
      LoginResponse response = LoginResponse.fromJson(data);
      LoginResponseData loginResponseData = response.data;
      _accessToken = loginResponseData.accessToken;
      _refreshToken = loginResponseData.refreshToken;
      LoginResponseData dataUser = loginResponseData;
      roleAccount = dataUser.taiKhoan.chucVu;
      roleTC = dataUser.taiKhoan.lienKetTrungChuyen;
      _username = dataUser.taiKhoan.hoTen.toString().trim();
      Utils.saveDataLogin(_prefs, dataUser,_accessToken,_refreshToken,username,pass);
     pushService(savePassword,username,pass);
      return LoginSuccess(_deviceToken);
    } catch (e) {
      print(e.toString());
      return LoginFailure(e.toString());
    }
  }

  void checkUsernameBloc(String username) {
    String _tempErrUsername = checkUsername(context, username);
    if (_errorUsername != _tempErrUsername) {
      _errorUsername = _tempErrUsername;
      add(ValidateUsername(username));
    }
  }

  void checkPassBloc(String pass) {
    String _tempErrPass = checkPass(context, pass);
    if (_errorPass != _tempErrPass) {
      _errorPass = _tempErrPass;
      add(ValidatePass(pass));
    }
  }

  void pushService(bool savePassword,String username, String pass) async{
    // if(savePassword == false){
      AccountInfo _accountInfo = new AccountInfo(
          username,
          pass
      );
      await db.saveAccount(_accountInfo);
      listAccountInfo = await getListAccountInfoFromDb();
      if(!Utils.isEmpty(listAccountInfo)){
        db.updateAccountInfo(_accountInfo);
      }
    // }else{
    //   AccountInfo _accountInfo = new AccountInfo(
    //       '',
    //       ''
    //   );
    //   await db.saveAccount(_accountInfo);
    //   listAccountInfo = await getListAccountInfoFromDb();
    //   if(!Utils.isEmpty(listAccountInfo)){
    //     db.updateAccountInfo(_accountInfo);
    //   }
    // }
  }
  Future<List<AccountInfo>> getListAccountInfoFromDb() {
    return db.fetchAllAccountInfo();
  }

}