import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
// import 'package:in_app_update/in_app_update.dart';
// import 'package:new_version/new_version.dart';
import 'package:trungchuyen/themes/colors.dart';
import 'package:trungchuyen/themes/font.dart';
import 'package:trungchuyen/themes/images.dart';
import 'package:trungchuyen/utils/utils.dart';
import 'package:trungchuyen/widget/confirm_update_version.dart';
import 'package:trungchuyen/widget/pending_action.dart';
import 'package:trungchuyen/widget/text_field_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main/main_page.dart';
import 'login_bloc.dart';
import 'login_event.dart';
import 'login_sate.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late FocusNode usernameFocus;
  late FocusNode passwordFocus;
  bool isChecked = false;
  late LoginBloc _loginBloc;
  bool showLoading = false;
  String? errorPass, errorUsername, errorHotId;
  String? _selectedLang;
  // AppUpdateInfo? _updateInfo;
  bool _flexibleUpdateAvailable = false;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  Future<void> checkForUpdate() async {
    // InAppUpdate.checkForUpdate().then((info) {
    //   setState(() {
    //     _updateInfo = info;
    //   });
    // }).catchError((e) {
    //   showSnack(e.toString());
    // });
  }

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(text)));
    }
  }


  void _checkVersion() async {
    // final newVersion = NewVersion(
    //     androidId: 'takecare.hn.trungchuyen',
    //     iOSId: 'takecare.hn.trungchuyen',
    // );
    // final status = await newVersion.getVersionStatus();
    // setState(() {
    //   showLoading = false;
    // });
    // print(status!.localVersion);
    // print(status.storeVersion);
    // List<String> localVersion = status.localVersion.split('.');
    // List<String> storeVersion = status.storeVersion.split('.');
    // if(int.parse(localVersion[0]) < int.parse(storeVersion[0])){
    //   showUpdate();
    // }else if((int.parse(localVersion[0]) == int.parse(storeVersion[0])) && (int.parse(localVersion[1]) < int.parse(storeVersion[1]))){
    //   showUpdate();
    // }else if((int.parse(localVersion[0]) == int.parse(storeVersion[0])) && (int.parse(localVersion[1]) == int.parse(storeVersion[1])) && (int.parse(localVersion[2]) < int.parse(storeVersion[2]))){
    //   showUpdate();
    // }
  }

  void showUpdate(){
    showDialog(
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => true,
            child: ConfirmSuccessPage(
              title: 'Đã có phiên bản mới',
              content: 'Cập nhật ứng dụng của bạn để có trải nghiệm tốt nhất',
              type: 0,
            ),
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showLoading = true;
    _checkVersion();
    _loginBloc = LoginBloc(context);
    _loginBloc.add(GetPrefs());


    usernameFocus = FocusNode();
    passwordFocus = FocusNode();

    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        return false;
      },
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: white,
          body: BlocProvider(
            create: (context) => _loginBloc,
            child: BlocListener<LoginBloc, LoginState>(
              listener: (context, state) {
                if(state is GetPrefsSuccess){
                  _loginBloc.add(SaveUserNamePassWordEvent());
                }
                if(state is LoginFailure){
                  Utils.showToast(state.error.toString());
                }
                if (state is LoginSuccess) {
                  // Get.put(SocketIOService());
                  ///0 : Offline
                  ///1 : Online
                  _loginBloc.add(UpdateTokenDiveEvent(state.tokenFCM));
                  print('Login OK');

                }
                else if (state is UpdateTokenSuccessState) {
                  pushNewScreen(context, screen: MainPage(roleTC: _loginBloc.roleTC,roleAccount: _loginBloc.roleAccount,tokenFCM: state.tokenFCM,));
                }
                else if(state is ChangeLanguageSuccess){
                  _selectedLang = state.nameLng;
                }
                else if (state is SaveUserNamePasswordSuccessful){
                  usernameController.text = state.userName;
                  passwordController.text = state.passWord;
                }
              },
              child: BlocBuilder<LoginBloc, LoginState>(builder: (BuildContext context, LoginState state,) {
                if (state is ValidateErrorUsername) {
                  errorUsername = state.error;
                } else if (state is ValidateErrorPassword) {
                  errorPass = state.error;
                }
                return buildPage(context, state);
              }),
            ),
          )),
    );
  }


  Stack buildPage(BuildContext context, LoginState state){
    return Stack(
      children: [
        Scaffold(
          backgroundColor: white,//grey_100.withOpacity(0.9),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 55),
                            child: Container(
                              width: 250.0,
                              child: Image.asset(icLogo,),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        buildInputUserName(context),
                        SizedBox(height: 10,),
                        buildInputPassword(context),
                        SizedBox(height: 10,),
                        buildForgotPassword(),
                        SizedBox(height: 20,),
                        buildButtonLogin(),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40,right: 40,bottom:30,top: 0),
                  child: GestureDetector(
                    onTap: ()async{
                      final Uri launchUri = Uri(
                        scheme: 'tel',
                        path: '0979910019',
                      );
                      await launchUrl(launchUri);
                      // launch("https://www.facebook.com/timos.vn");
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Cần trợ giúp?',style: TextStyle(color: Colors.grey,),),
                        SizedBox(width: 3,),
                        Text(
                          'Liên hệ với chúng tôi',style: TextStyle(color: Colors.blue,),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Visibility(
          visible: state is LoginLoading,
          child: PendingAction(),
        ),
      ],
    );
  }

  Widget buildForgotPassword(){
    return InkWell(
      onTap: (){
        setState(() {
          print(isChecked);
          if(isChecked == true ){
            isChecked = false;
          }else{
            isChecked = true;
          }
        });
      } ,
      child: Container(
        padding: const EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Checkbox(
              value: isChecked,
              onChanged: (bool? newValue) {
                setState(() {
                  print(isChecked);
                  isChecked = newValue!;
                });
              },
            ),
            Text(
              'Ghi nhớ mật khẩu'.toUpperCase(),
              style: TextStyle(fontFamily: fontSub, fontSize: 12, color: grey,decoration:TextDecoration.underline ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButtonLogin(){
    return  GestureDetector(
      onTap: (){
        _loginBloc.add(Login(usernameController.text,passwordController.text,isChecked));
      },
      child: Container(
        width: 148.0,
        height: 40.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.0),
            color: Colors.orange
        ),
        child: Center(
          child: Text(
            'Đăng nhập',
            style: TextStyle(fontFamily: fontSub, fontSize: 16, color: Colors.black,),
            textAlign: TextAlign.left,
          ),
        ),
      ),
    );
  }

  Padding buildInputUserName(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 0.0),
      child: TextFieldWidget(
        focusNode:  usernameFocus,
        controller: usernameController,
        textInputAction: TextInputAction.next,
        errorText: errorUsername,
        hintText: 'Tên tài khoản',
        onChanged: (text) => _loginBloc.checkUsernameBloc(text!),
        //labelText: S.of(context).phone_number,
        keyboardType: TextInputType.phone,
        prefixIcon: Icons.account_circle,
        suffixIcon: Icons.cancel,
        onSubmitted: (text) => Utils.navigateNextFocusChange(context,  usernameFocus,  passwordFocus), readOnly: false,
      ),
    );
  }

  Padding buildInputPassword(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 0.0),
      child: TextFieldWidget(
        controller: passwordController,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.phone,
        isPassword: true,
        errorText: errorPass,
        hintText: 'Mật khẩu',
        prefixIcon: Icons.vpn_key,
        onChanged: (text) => _loginBloc.checkPassBloc(text!),
        focusNode: passwordFocus,
        onSubmitted: (_)=>_loginBloc.add(Login(usernameController.text,passwordController.text,false)), readOnly: false,
      ),
    );
  }
}