import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oktoast/oktoast.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:trungchuyen/page/login/login_page.dart';
// import 'package:wakelock/wakelock.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main()async {
  HttpOverrides.global = new MyHttpOverrides();
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark, statusBarColor: Colors.white));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
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
    // Wakelock.enable();
    // if(!Utils.isEmpty(MyTranslations().getCurrentLang())){
    //   //MyTranslations().changeLocale(MyTranslations.newLocale);
    //   print('${MyTranslations.newLocale}');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      key: key,
      child: OKToast(
        child: MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales:const [
            Locale('vi', 'VN'),
            // arabic, no country code
          ],
          title: 'Timos Trung chuyển',
          theme: ThemeData(
            visualDensity:  VisualDensity.adaptivePlatformDensity,
            primarySwatch: Colors.blue,
          ),
          debugShowCheckedModeBanner: false,
          // initialRoute: RouterGenerator.routeIntro,
          home: LoginPage(),//InfoCPNScreen
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: child!,
            );
          },
        ),
      ),

      // GetMaterialApp(
      //   title: 'Trung Chuyển',
      //   debugShowCheckedModeBanner: false,
      //   theme: ThemeData(
      //     primaryColor: white,
      //     //primarySwatch: Colors.blue,
      //     visualDensity: VisualDensity.adaptivePlatformDensity,
      //   ),
      //   locale: MyTranslations.locale,
      //   fallbackLocale: MyTranslations.fallbackLocale,
      //   translations: MyTranslations(),
      //   initialRoute: '/SplashPageRouter',
      //   initialBinding: AppBinding(),
      //   getPages: [
      //     GetPage(
      //       name: '/SplashPageRouter',
      //       page: () => SplashPage(),
      //     ),
      //     GetPage(
      //       name: '/LoginPageRouter',
      //       page: () => LoginScreen(),
      //       //binding: HomeBinding()
      //     ),
      //   ],
      // ),
    );
  }
}
