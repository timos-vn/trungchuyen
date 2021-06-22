import 'package:get/get.dart';
import 'package:trungchuyen/page/login/login_page.dart';

class SplashController extends GetxController{
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    Future.delayed(Duration(seconds: 2),()=> Get.off(LoginPage(),transition: Transition.zoom));
  }
}