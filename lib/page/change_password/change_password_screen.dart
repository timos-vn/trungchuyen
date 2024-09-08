import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trungchuyen/utils/utils.dart';
import 'package:trungchuyen/widget/pending_action.dart';

import 'change_password_bloc.dart';
import 'change_password_event.dart';
import 'change_password_state.dart';



class ChangePassWordScreen extends StatefulWidget {
  ChangePassWordScreen({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _ChangePassWordScreenState createState() => _ChangePassWordScreenState();
}

class _ChangePassWordScreenState extends State<ChangePassWordScreen> with SingleTickerProviderStateMixin{
  final passwordOldController = TextEditingController();
  final passwordNewController = TextEditingController();
  final againPasswordController = TextEditingController();

  final passwordOldFocus = FocusNode();
  final passwordNewFocus = FocusNode();
  final againPasswordFocus = FocusNode();
  String? verificationCode;

  String? errorPass, errorUsername, errorAgainPass;

  late ChangePasswordBloc _bloc;

  bool showLoading = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _bloc = ChangePasswordBloc(context);
    _bloc.add(GetPrefs());
  }

  Widget _entryField(String title, TextEditingController textEditingController, String textHint,
      { bool isPassword = false, bool isPhone = false,
        FocusNode? currentFocus, FocusNode? nextFocus,
        TextInputAction? textInputAction,
        int? checkErr,
        String? err,
      }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style:  TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            onChanged:(text){
              if(checkErr == 0){
                _bloc.checkPasswordOldBloc(text);
              }else if(checkErr == 1){
                _bloc.checkPasswordNewBloc(text);
              }else{
                _bloc.checkAgainPassBloc(passwordNewController.text,text);
              }
            },
            keyboardType: TextInputType.phone,
            textInputAction: textInputAction,
            focusNode:currentFocus,
            controller: textEditingController,
            obscureText: isPassword,
            decoration: InputDecoration(
                errorText: err,
                contentPadding: EdgeInsets.only(top: 20,left: 10),
                border: new OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: new BorderSide(color: Colors.white)),
                fillColor: Colors.white,
                filled: true,
                hintText: textHint),
            onSubmitted: (text) => Utils.navigateNextFocusChange(context,  currentFocus!,  nextFocus!),
          )
        ],
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () async{
        if(!Utils.isEmpty(passwordOldController.text) && !Utils.isEmpty(passwordNewController.text) && !Utils.isEmpty(againPasswordController.text) && errorAgainPass == null){
          _bloc.add(ChangePassword(passwordOldController.text,passwordNewController.text));
        }else{
          Utils.showToast('Vui lòng nhập đầy đủ thông tin');
        }
      },
      child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.shade200,
                    offset: Offset(2, 4),
                    blurRadius: 5,
                    spreadRadius: 2)
              ],
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xfffbb448), Color(0xfff7892b)])),
          child: Text(
            'Đổi mật khẩu',
            style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
    );
  }


  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Timo',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10),
          ),children: [
        TextSpan(
          text: 's',
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
      ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Mật khẩu hiện tại", passwordOldController, "",isPhone : true,currentFocus: passwordOldFocus,nextFocus: passwordNewFocus,textInputAction: TextInputAction.next,err: errorUsername,checkErr: 0),
        _entryField("Mật khẩu mới", passwordNewController, "", isPassword: true,currentFocus: passwordNewFocus,nextFocus: againPasswordFocus,textInputAction: TextInputAction.next,err: errorPass,checkErr: 1),
        _entryField("Nhập lại mật khẩu mới", againPasswordController, "",isPassword: true,textInputAction: TextInputAction.done,err: errorAgainPass,checkErr: 2,currentFocus:  againPasswordFocus),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: BlocProvider(
          create: (context) => _bloc,
          child: BlocListener<ChangePasswordBloc, ChangePasswordState>(
            listener: (context, state) {
              if(state is ChangePasswordFailure){
                Utils.showToast(state.error);
              }else if(state is ChangePasswordSuccess){
                Utils.showToast('Cập nhật thôgn tin thành công');
              }
            },
            child: BlocBuilder<ChangePasswordBloc, ChangePasswordState>(builder: (BuildContext context, ChangePasswordState state,) {
              if (state is ValidateErrorPasswordOld) errorUsername = state.error;
              if (state is ValidateErrorPasswordNew) errorPass = state.error;
              if (state is ValidateErrorAgainPasswordNew) errorAgainPass = state.error;
              return buildScreen(context, state);
            }),
          ),
        )
    );
  }

  Widget buildScreen(BuildContext context,ChangePasswordState state){
    final height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
          child: Container(
            height: height,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 40),
                        _title(),
                        SizedBox(
                          height: 50,
                        ),
                        _emailPasswordWidget(),
                        SizedBox(
                          height: 30,
                        ),
                        _submitButton(),
                      ],
                    ),
                  ),
                ),
                Positioned(top: 40, left: 0, child:InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
                      child: Icon(Icons.arrow_back, color: Colors.black),
                    ),
                  ),
                ) ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: state is ChangePasswordLoading,
          child: PendingAction(),
        ),
      ],
    );
  }

  @override
  void onChangePasswordError() {
    // TODO: implement onChangePasswordError
  }

  @override
  void onChangePasswordSuccess() {
    // TODO: implement onChangePasswordSuccess
  }

  @override
  void onLoginError() {
    // TODO: implement onLoginError
  }

  @override
  void onLoginSuccess() {
    // TODO: implement onLoginSuccess
  }

  @override
  void onForgotPasswordError() {
    // TODO: implement onForgotPasswordError
  }

  @override
  void onForgotPasswordSuccess() {
    // TODO: implement onForgotPasswordSuccess
  }
}
