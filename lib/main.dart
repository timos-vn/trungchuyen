import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:trungchuyen/page/login/login_page.dart';
import 'package:trungchuyen/page/splash/splash_page.dart';
import 'package:trungchuyen/service/app_binding.dart';
import 'package:trungchuyen/themes/colors.dart';
import 'package:trungchuyen/utils/translations.dart';
import 'package:wakelock/wakelock.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runZoned(() {
    initializeDateFormatting().then((_) => runApp(MyApp()));
  });
}

class MyApp extends StatefulWidget  {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final key = ValueKey('my overlay');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Wakelock.enable();
    // if(!Utils.isEmpty(MyTranslations().getCurrentLang())){
    //   //MyTranslations().changeLocale(MyTranslations.newLocale);
    //   print('${MyTranslations.newLocale}');
    // }
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark, statusBarColor: Colors.white));

    return OverlaySupport.global(
      key: key,
      child: GetMaterialApp(
        title: 'Trung Chuyển',
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
        initialBinding: AppBinding(),
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
