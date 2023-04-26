import 'package:flutter/material.dart';
import 'package:open_store/open_store.dart';
import 'dart:io' show Platform;
import 'package:url_launcher/url_launcher.dart';

class ConfirmSuccessPage extends StatefulWidget {
  final String? title;
  final String? content;
  final int? type;

  const ConfirmSuccessPage({ Key? key, this.title, this.content, this.type}) : super(key: key);
  @override
  _ConfirmSuccessPageState createState() => _ConfirmSuccessPageState();
}

class _ConfirmSuccessPageState extends State<ConfirmSuccessPage> {
  TextEditingController contentController = TextEditingController();
  int groupValue = 0;
  FocusNode focusNodeContent = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        backgroundColor: Colors.transparent,
        body: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 30, right: 30,),
            child: Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(16)),),
              height:  380,
              width: double.infinity,
              child: Material(
                  animationDuration: Duration(seconds: 3),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  child: Container(
                    height: double.infinity,width: double.infinity,
                    decoration: BoxDecoration(
                      // border: Border.all(color: Colors.orange,width: 0.7,),
                      color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(16)
                    ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: Image.asset(
                              'assets/images/background.png',
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        SizedBox(height: 30,),
                        Text(widget.title.toString(),style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                        SizedBox(height: 12,),
                        Padding(
                          padding: const EdgeInsets.only(left: 10,right: 10),
                          child: Text(widget.content.toString(),style:  TextStyle(color: Colors.grey,fontSize: 11),textAlign: TextAlign.center,),
                        ),
                        SizedBox(height: 35,),
                       _submitButton(context),
                      ],
                    ),
                  )),
            ),
          ),
        ));
  }
  Widget _submitButton(BuildContext context) {
    return InkWell(
      onTap: () {
        if (Platform.isAndroid) {
          print('android');
         launch('https://play.google.com/store/apps/details?id=takecare.hn.trungchuyen');
        } else{
          print('ios');
          OpenStore.instance.open(
            appStoreId: '1573580926', // AppStore id of your app for iOS
            appStoreIdMacOS: '1573580926', // AppStore id of your app for MacOS (appStoreId used as default)
            androidAppBundleId: 'takecare.hn.trungchuyen', // Android app bundle package name
            //windowsProductId: '9NZTWSQNTD0S' // Microsoft store id for Widnows apps
          );
        }
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 40,right: 40),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
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
            'Cập nhật ngay',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}



