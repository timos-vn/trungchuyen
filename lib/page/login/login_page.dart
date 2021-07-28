import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get.dart' as libGetX;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:new_version/new_version.dart';
import 'package:trungchuyen/page/main/main_page.dart';
import 'package:trungchuyen/service/soket_io_service.dart';
import 'package:trungchuyen/themes/colors.dart';
import 'package:trungchuyen/themes/font.dart';
import 'package:trungchuyen/themes/images.dart';
import 'package:trungchuyen/utils/utils.dart';
import 'package:trungchuyen/widget/pending_action.dart';
import 'package:trungchuyen/widget/text_field_widget.dart';
import 'login_bloc.dart';
import 'login_event.dart';
import 'login_sate.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController usernameController;
  TextEditingController passwordController;
  FocusNode usernameFocus;
  FocusNode passwordFocus;
  bool isChecked = false;
  LoginBloc _loginBloc;

  String errorPass, errorUsername, errorHotId;
  String _selectedLang;

  void _checkVersion() async {
    final newVersion = NewVersion(
        context: context,
        androidId: 'takecare.hn.trungchuyen',
        iOSId: 'takecare.hn.trungchuyen',
        dialogTitle: 'Thông báo cập nhật',
        dialogText: 'Đã có phiên bản mới xin vui lòng cập nhật để có thể sử dụng những tính năng mới nhất.',
        dismissText: 'Để sau',
        updateText:'Cập nhật'
    );
    final status = await newVersion.getVersionStatus();
    print(status.appStoreLink);
    print(status.localVersion);
    print(status.storeVersion);
    List<String> localVersion = status.localVersion.split('.');
    List<String> storeVersion = status.storeVersion.split('.');
    if(int.parse(localVersion[0]) < int.parse(storeVersion[0])){
      newVersion.showUpdateDialog(status);
    }else if((int.parse(localVersion[0]) == int.parse(storeVersion[0])) && (int.parse(localVersion[1]) < int.parse(storeVersion[1]))){
      newVersion.showUpdateDialog(status);
    }else if((int.parse(localVersion[0]) == int.parse(storeVersion[0])) && (int.parse(localVersion[1]) == int.parse(storeVersion[1])) && (int.parse(localVersion[0]) < int.parse(storeVersion[0]))){
      newVersion.showUpdateDialog(status);
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkVersion();
    _loginBloc = LoginBloc(context);
    _loginBloc.add(SaveUserNamePassWordEvent());

    usernameFocus = FocusNode();
    passwordFocus = FocusNode();

    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: white,
        body: BlocProvider(
          create: (context) => _loginBloc,
          child: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccess) {
                Get.put(SocketIOService());
                ///0 : Offline
                ///1 : Online
                _loginBloc.add(UpdateTokenDiveEvent(state.tokenFCM));
                Navigator.push(context, (MaterialPageRoute(builder: (context)=>MainPage(roleTC: _loginBloc.roleTC,roleAccount: _loginBloc.roleAccount,tokenFCM: state.tokenFCM,))));
              }
              else if (state is UpdateTokenSuccessState) {

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
              if (state is ValidateErrorHostId) errorHotId = state.error;
              if (state is ValidateErrorUsername) errorUsername = state.error;
              if (state is ValidateErrorPassword) errorPass = state.error;

              return buildPage(context, state);
            }),
          ),
        ));
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
              onChanged: (bool newValue) {
                setState(() {
                  print(isChecked);
                  isChecked = newValue;
                });
              },
            ),
            Text(
              'SavePassword'.tr.toUpperCase(),
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
        //page.login(hostIdController.text,usernameController.text,passwordController.text,isChecked);
        _loginBloc.add(Login(usernameController.text,passwordController.text,isChecked));
      },
      child: Container(
        width: 148.0,
        height: 40.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.0),
            color: Colors.blue
        ),
        child: Center(
          child: Text(
            'Đăng nhập',
            style: TextStyle(fontFamily: fontSub, fontSize: 16, color: white,),
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
        hintText: 'Tên tài khoản'.tr,
        onChanged: (text) => _loginBloc.checkUsernameBloc(text),
        //labelText: S.of(context).phone_number,
        keyboardType: TextInputType.phone,
        prefixIcon: Icons.account_circle,
        onSubmitted: (text) => Utils.navigateNextFocusChange(context,  usernameFocus,  passwordFocus),
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
        hintText: 'Mật khẩu'.tr,
        prefixIcon: Icons.vpn_key,
        onChanged: (text) => _loginBloc.checkPassBloc(text),
        focusNode: passwordFocus,
        onSubmitted: (_)=>_loginBloc.add(Login(usernameController.text,passwordController.text,false)),
      ),
    );
  }
}