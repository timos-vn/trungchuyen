import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:new_version/new_version.dart';
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

  NetWorkFactory? _networkFactory;

  BuildContext context;
  String? _accessToken;
  String? _refreshToken;
  static final _firebaseMessaging = FirebaseMessaging.instance;
  String? _deviceToken;
  SharedPreferences? _prefs;
  SharedPreferences? get pref => _prefs;
  String? _username;
  String? get username => _username;
  String?  _errorUsername, _errorPass;
  DatabaseHelper db = DatabaseHelper();
  String? _hotURL;
  String? get hotURL => _hotURL;
  int roleAccount = 0;
  bool showLoading = false;
  bool roleTC = false;
  String codeLang = "v";
  List<AccountInfo> listAccountInfo = [];

  LoginBloc(this.context) : super(LoginInitial()){
    _networkFactory = NetWorkFactory(context);
    db = DatabaseHelper();
    db.init();
    _firebaseMessaging.getToken().then((token) {
      print("token");
      print(token);
      _deviceToken = token.toString();
    });
    on<GetPrefs>(_getPrefs);
    on<SaveUserNamePassWordEvent>(_saveUserNamePassWordEvent);
    on<UpdateTokenDiveEvent>(_updateTokenDiveEvent);
    on<Login>(_login);
    on<CheckVersion>(_checkVersion);
    on<ValidateHostId>(_validateHostId);
    on<ValidateUsername>(_validateUsername);
    on<ValidatePass>(_validatePass);
  }


  void _getPrefs(GetPrefs event, Emitter<LoginState> emitter)async{
    emitter(LoginLoading());
    _prefs = await SharedPreferences.getInstance();
    _accessToken = _prefs!.getString(Const.ACCESS_TOKEN) ?? "";
    _refreshToken = _prefs!.getString(Const.REFRESH_TOKEN) ?? "";
    _username = _prefs!.getString(Const.USER_NAME) ?? "";
    emitter(GetPrefsSuccess());
  }

  void _saveUserNamePassWordEvent(SaveUserNamePassWordEvent event, Emitter<LoginState> emitter)async{
    emitter(LoginLoading());
    listAccountInfo = await getListAccountInfoFromDb();
    if(listAccountInfo.isNotEmpty){
      emitter(SaveUserNamePasswordSuccessful(listAccountInfo[0].userName,listAccountInfo[0].pass,));
    }
    emitter(LoginInitial());
  }

  void _updateTokenDiveEvent(UpdateTokenDiveEvent event, Emitter<LoginState> emitter)async{
    emitter(LoginLoading());
    UpdateTokenRequestBody request = UpdateTokenRequestBody(
        deviceToken: event.deviceToken
    );
    LoginState state = _handleUpdateToken(await _networkFactory!.updateToken(request,_accessToken.toString()));
    emitter(state);
  }

  void _login(Login event, Emitter<LoginState> emitter)async{
    emitter(LoginLoading());
    LoginRequestBody request = LoginRequestBody(
      username:event.username, /// 0963004959
      password:event.password, /// 0976024216
    );
    LoginState state = _handleLogin(await _networkFactory!.login(request),event.savePassword,event.username,event.password);
    emitter(state);
  }

  void _checkVersion(CheckVersion event, Emitter<LoginState> emitter)async{
    emitter(LoginLoading());
    showLoading = event.showLoading;
    emitter(CheckVersionSuccess());
  }

  void _validateHostId(ValidateHostId event, Emitter<LoginState> emitter)async{
    emitter(LoginLoading());
    String? error = checkHotId(context, event.hostId);
    emitter(ValidateErrorHostId(error.toString()));
  }

  void _validateUsername(ValidateUsername event, Emitter<LoginState> emitter)async{
    emitter(LoginLoading());
    String? error = checkUsername(context, event.username) ?? '';
    emitter(ValidateErrorUsername(error.toString()));
  }

  void _validatePass(ValidatePass event, Emitter<LoginState> emitter)async{
    emitter(LoginLoading());
    String? error = checkPass(context, event.pass) ?? '';
    emitter(ValidateErrorPassword(error.toString()));
  }

  LoginState _handleUpdateToken(Object data) {
    if (data is String) return LoginFailure(data);
    try {
      print('Update success FCM');
      return UpdateTokenSuccessState(_deviceToken.toString());
    } catch (e) {
      print(e.toString());
      return LoginFailure(e.toString());
    }
  }

  LoginState _handleLogin(Object data,bool savePassword,String username,String pass) {
    if (data is String) return LoginFailure(data);
    try {
      LoginResponse response = LoginResponse.fromJson(data as Map<String,dynamic>);
      if(response.statusCode == 200){
        LoginResponseData? loginResponseData = response.data;
        _accessToken = loginResponseData!.accessToken!;
        _refreshToken = loginResponseData.refreshToken!;
        LoginResponseData dataUser = loginResponseData;
        roleAccount = dataUser.taiKhoan!.chucVu!;
        roleTC = dataUser.taiKhoan!.lienKetTrungChuyen!;
        _username = dataUser.taiKhoan!.hoTen.toString().trim();
        Utils.saveDataLogin(_prefs!, dataUser,_accessToken.toString(),_refreshToken.toString(),username,pass);
        pushService(savePassword,username,pass);
        return LoginSuccess(_deviceToken.toString());
      }else{
        return LoginFailure(response.message.toString());
      }
    } catch (e) {
      print(e.toString());
      return LoginFailure(e.toString());
    }
  }

  void checkUsernameBloc(String username) {
    String? _tempErrUsername = checkUsername(context, username);
    if (_errorUsername != _tempErrUsername) {
      _errorUsername = _tempErrUsername;
      add(ValidateUsername(username));
    }
  }

  void checkPassBloc(String pass) {
    String? _tempErrPass = checkPass(context, pass);
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