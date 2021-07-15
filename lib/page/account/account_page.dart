import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:get/get.dart' as libGetX;
import 'package:trungchuyen/page/account/account_bloc.dart';
import 'package:trungchuyen/page/account/account_state.dart';
import 'package:trungchuyen/page/login/login_page.dart';
import 'package:trungchuyen/page/main/main_bloc.dart';
import 'package:trungchuyen/page/map/map_bloc.dart';
import 'package:trungchuyen/page/notification/notification_page.dart';
import 'package:trungchuyen/page/profile/my_profile.dart';
import 'package:trungchuyen/page/profile/profile.dart';
import 'package:trungchuyen/page/report/report_page.dart';
import 'package:trungchuyen/page/report_limo/report_limo_page.dart';
import 'package:trungchuyen/themes/colors.dart';
import 'package:trungchuyen/utils/utils.dart';
import 'package:trungchuyen/widget/pending_action.dart';
import 'dart:io' show Platform, exit;

import 'package:trungchuyen/widget/separator.dart';

import 'account_event.dart';


class AccountPage extends StatefulWidget {

  const AccountPage({Key key}) : super(key: key);
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> with TickerProviderStateMixin {

  AccountBloc _accountBloc;
  MainBloc _mainBloc;

  @override
  void initState() {
    // TODO: implement initState
    _accountBloc = AccountBloc(context);
    _mainBloc = BlocProvider.of<MainBloc>(context);
    _accountBloc.add(GetInfoAccount());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener<AccountBloc,AccountState>(
            bloc: _accountBloc,
            listener: (context, state){
              if(state is LogOutSuccess){
                libGetX.Get.offAll(LoginPage());
              }
            },
            child: BlocBuilder<AccountBloc,AccountState>(
              bloc: _accountBloc,
              builder: (BuildContext context, AccountState state){
                return buildPage(context,state);
              },
            )
        ));
  }

  Widget buildPage(BuildContext context,AccountState state){
    return Stack(
      children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 55,left: 16,right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Account'.tr,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),),
                  ],
                ),
              ),
              SizedBox(height: 25,),
              Container(
                // color: mainColor,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Container(
                  padding: EdgeInsets.all(4),
                  height: 20,
                  width: double.infinity,
                ),
              ),
              Expanded(
                child: Stack(
                  overflow: Overflow.visible,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)
                          )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16,right: 16,top: 90),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile(userName: _accountBloc.userName,phone: _accountBloc.phone,))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(MdiIcons.accountOutline),
                                      SizedBox(width: 10,),
                                      Text('AccountInformation'.tr),
                                    ],
                                  ),
                                  Text('Code User: 66886868',style: TextStyle(color: Colors.grey,fontSize: 12),),
                                ],
                              ),
                            ),
                            SizedBox(height: 10,),
                            Separator(color: Colors.grey),
                            SizedBox(height: 15,),
                            InkWell(
                              onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>NotificationPage())),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                 Row(
                                   children: [
                                     Icon(MdiIcons.bellOutline),
                                     SizedBox(width: 10,),
                                     Text('Thông báo'.tr),
                                   ],
                                 ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: blue,
                                        borderRadius: BorderRadius.circular(9),
                                      ),
                                      constraints: BoxConstraints(
                                        minWidth: 17,
                                        minHeight: 17,
                                      ),
                                      child: Text(_mainBloc.countApproval > 0
                                          ? _mainBloc.countApproval.toString()
                                          : _mainBloc.countNotifyUnRead?.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10,),
                            Separator(color: Colors.grey),
                            SizedBox(height: 15,),
                            Visibility(
                              visible: _accountBloc.role == "3",
                              child: InkWell(
                                onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> ReportPage())),
                                child: Row(
                                  children: [
                                    Icon( MdiIcons.chartArc),
                                    SizedBox(width: 10,),
                                    Text('Report'.tr),
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: _accountBloc.role == "7",
                              child: InkWell(
                                onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> ReportLimoPage())),
                                child: Row(
                                  children: [
                                    Icon( MdiIcons.chartArc),
                                    SizedBox(width: 10,),
                                    Text('Report'.tr),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10,),
                            Separator(color: Colors.grey),
                            SizedBox(height: 15,),
                            Row(
                              children: [
                                Icon(Icons.library_books),
                                SizedBox(width: 10,),
                                Text('Membership Policy'.tr),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Separator(color: Colors.grey),
                            SizedBox(height: 15,),
                            Row(
                              children: [
                                Icon(MdiIcons.informationOutline),
                                SizedBox(width: 10,),
                                Text('Về Trung chuyển HN'),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Separator(color: Colors.grey),
                            SizedBox(height: 15,),
                            InkWell(
                              onTap: ()=> _showConfirm(context),
                              child: Row(
                                children: [
                                  Icon(Icons.exit_to_app,color: Colors.orange,),
                                  SizedBox(width: 10,),
                                  Text('LogOut'.tr,style: TextStyle(color: Colors.orange),),
                                ],
                              ),
                            ),
                            SizedBox(height: 10,),
                            Separator(color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: -40,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16,right: 16),
                        child: Container(
                          height: 90,
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.only(left: 10,right: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      ClipRRect(
                                          borderRadius: BorderRadius.circular(40),
                                          child: Icon(Icons.person)
                                      ),
                                      SizedBox(width: 10,),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(_accountBloc.userName??'',style: TextStyle(color: Colors.black.withOpacity(0.8),fontWeight: FontWeight.bold),),
                                          SizedBox(height: 5,),
                                          Text('Diamond',style: TextStyle(color: Colors.grey,fontSize: 12),),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 20,top: 7,bottom: 7,right: 20),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(24)),
                                        color: Colors.black.withOpacity(0.1)
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(MdiIcons.disqus,color: Colors.green,size: 18,),
                                        SizedBox(width: 3,),
                                        Text('000',style: TextStyle(fontSize: 12,color: Colors.green),),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: state is AccountLoading,
          child: PendingAction(),
        ),
      ],
    );
  }
  void _showConfirm(BuildContext context) {
    List<Widget> actions = [
      FlatButton(
        onPressed: () => Navigator.of(context, rootNavigator: true).pop(true),
        child: Text('No'.tr,
            style: TextStyle(
              color: Colors.orange,
              fontSize: 14,
            )),
      ),
      FlatButton(
        onPressed: () {
          _accountBloc.add(LogOut());
          // if (Platform.isAndroid) {
          //   SystemNavigator.pop();
          // } else if (Platform.isIOS) {
          //   exit(0);
          // }
        },
        child: Text('Yes'.tr,
            style: TextStyle(
              color: Colors.orange,
              fontSize: 14,
            )),
      ),
    ];

    Utils.showDialogTwoButton(
        context: context,
        title: 'Notice'.tr,
        contentWidget: Text(
          'ExitApp'.tr,
          style: TextStyle(fontSize: 14, color: black),
        ),
        actions: actions);
  }
}
