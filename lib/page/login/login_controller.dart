import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:trungchuyen/utils/validator.dart';
import 'login_bloc.dart';


class LoginController extends GetxController{
  var counter = 0.obs;
  BuildContext context;
  FocusNode hostIdFocus;
  FocusNode usernameFocus;
  FocusNode passwordFocus;

  final errorPass = ''.obs, errorUsername = ''.obs, errorHotId = ''.obs;

  Validators _validators;
  LoginBloc _loginBloc;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _loginBloc = LoginBloc(context);
    hostIdFocus = FocusNode();
    usernameFocus = FocusNode();
    passwordFocus = FocusNode();

    _validators = Validators();
    errorUsername.value = null;
    errorPass.value = null;
    errorHotId.value = null;
  }
  
  void login(String username, String password){

    //if(username == _user.uId && password == _user.pass){
    if(username == "" && password == ""){
      //Get.to(InfoCompanyPage(),transition: Transition.zoom);
      //Get.snackbar('Status','Login is successful',snackPosition: SnackPosition.BOTTOM);
    }else{
      Get.snackbar('Status'.tr,'LoginFailed'.tr,snackPosition: SnackPosition.BOTTOM, margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5));
    }
  }

  void checkHotId(BuildContext context,String hotId){
    errorHotId.value = _validators.checkHotId(context, hotId);
  }

  void checkUsername(BuildContext context,String username){
    errorUsername.value = _validators.checkUsername(context, username);
  }
  void checkPass(BuildContext context,String username){
    errorPass.value = _validators.checkPass(context, username);
  }
}