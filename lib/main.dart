import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:trungchuyen/page/login/login_page.dart';
import 'package:trungchuyen/page/splash/splash_page.dart';
import 'package:trungchuyen/themes/colors.dart';
import 'package:trungchuyen/utils/const.dart';
import 'package:trungchuyen/utils/translations.dart';
import 'package:trungchuyen/utils/utils.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runZoned(() {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget  {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(!Utils.isEmpty(MyTranslations().getCurrentLang())){
      print('calllllllllllllllllllalalalalallalaa');
      MyTranslations().changeLocale(MyTranslations.newLocale);
      print('${MyTranslations.newLocale}');
    }
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark, statusBarColor: Colors.white));

    return OverlaySupport(
      child: GetMaterialApp(
        title: 'SSE Cloud ERP',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: white,
          //primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        locale: MyTranslations.locale,
        fallbackLocale: MyTranslations.fallbackLocale,
        translations: MyTranslations(),
        initialRoute: '/SplashPageRouter',
        getPages: [
          GetPage(
            name: '/SplashPageRouter',
            page: () => SplashPage(),
          ),
          GetPage(
            name: '/LoginPageRouter',
            page: () => LoginPage(),
            //binding: HomeBinding()
          ),
        ],
      ),
    );
  }
}
