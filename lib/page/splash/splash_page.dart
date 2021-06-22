import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trungchuyen/page/splash/splash_controller.dart';
import 'package:trungchuyen/themes/colors.dart';
import 'package:trungchuyen/themes/font.dart';
import 'package:trungchuyen/themes/images.dart';

class SplashPage extends StatelessWidget {
  SplashPage({Key key,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      dispose: (_)=> print('Dispose Splash Page'),
      init: SplashController(),
      builder: (_)=> Scaffold(
        backgroundColor: white,
        body: Center(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 250.0,
                //height: 200.0,
                child: Image.asset(
                  icLogo,
                ),
              ),
              Text(
                'Dịch vụ tận tình - giải pháp thông minh',
                style: TextStyle(
                  fontFamily: fontApp,
                  fontSize: 16,
                  color: blue,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 100,)
            ],
          ),
        ),
      ),
    );
  }
}

