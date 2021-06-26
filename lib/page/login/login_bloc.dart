import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trungchuyen/models/network/request/login_request.dart';
import 'package:trungchuyen/models/network/response/login_response.dart';
import 'package:trungchuyen/models/network/service/host.dart';
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

  int roleAccount;
  // DatabaseHelper db = DatabaseHelper();

  // List<Lang> langSt = new List<Lang>();
  String codeLang = "v";

  // init(BuildContext context) {
  //   _networkFactory = NetWorkFactory(context);
  //   _firebaseMessaging.getToken().then((token) {
  //     print(token);
  //     _deviceToken = token;
  //   });
  // }
  LoginBloc(this.context) : super(null) {
    _networkFactory = NetWorkFactory(context);
    // _googleSignIn = GoogleSignIn();
    // _facebookSignIn = FacebookLogin();
    _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.getToken().then((token) => _deviceToken = token);
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

    if(event is UpdateStatusDriverEvent){
      yield LoginInitial();
      LoginState state = _handleUpdateStatusDriver(await _networkFactory.updateStatusDriver(_accessToken, event.statusDriver));//
      yield state;
    }

    if (event is Login) {
      yield LoginLoading();
      LoginRequestBody request = LoginRequestBody(
        username: event.username, /// 0989888668
        password: event.password, /// 0974629615
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

  LoginState _handleUpdateStatusDriver(Object data) {
    if (data is String) return LoginFailure(data);
    try {
      return UpdateStatusDriverState();
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
      _username = dataUser.taiKhoan.hoTen.toString().trim();
     Utils.saveDataLogin(_prefs, dataUser,_accessToken,_refreshToken,username,pass);
      return LoginSuccess();
    } catch (e) {
      print(e.toString());
      return LoginFailure(e.toString());
    }
  }

  void checkHostIdBloc(String hostId) {
    String _tempErrHostId = checkHotId(context, hostId);
    if (_errorHostId != _tempErrHostId) {
      _errorHostId = _tempErrHostId;
      add(ValidateHostId(hostId));
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
}