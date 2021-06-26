import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:get/get.dart' as libGetX;
import 'package:trungchuyen/themes/colors.dart';
import 'package:trungchuyen/utils/utils.dart';
import 'dart:io' show Platform, exit;

import 'package:trungchuyen/widget/separator.dart';


class AccountPage extends StatefulWidget {
  final int point;

  const AccountPage({Key key, this.point}) : super(key: key);
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //     statusBarIconBrightness: Brightness.light,
    //     statusBarColor: mainColor
    // ));
    return Scaffold(
        body: buildPage(context));
  }

  Widget buildPage(BuildContext context){
    return Stack(
      children: <Widget>[
        Container(
          // color: mainColor,
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40,left: 16,right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Account'.tr,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
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
                            Row(
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
                            SizedBox(height: 10,),
                            Separator(color: Colors.grey),
                            SizedBox(height: 15,),
                            Row(
                              children: [
                                Icon(MdiIcons.recycle),
                                SizedBox(width: 10,),
                                Text('System'.tr),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Separator(color: Colors.grey),
                            SizedBox(height: 15,),
                            InkWell(
                              child: Row(
                                children: [
                                  Icon(Icons.person_add_alt_1_outlined),
                                  SizedBox(width: 10,),
                                  Text('InviteFriend'.tr),
                                ],
                              ),
                            ),
                            SizedBox(height: 10,),
                            Separator(color: Colors.grey),
                            SizedBox(height: 15,),
                            InkWell(
                              child: Row(
                                children: [
                                  Icon(MdiIcons.googleCirclesGroup),
                                  SizedBox(width: 10,),
                                  Text('Groups'),
                                ],
                              ),
                            ),
                            SizedBox(height: 10,),
                            Separator(color: Colors.grey),
                            SizedBox(height: 15,),
                            Row(
                              children: [
                                Icon(Icons.library_books),
                                SizedBox(width: 10,),
                                Text('MembershipPolicy'.tr),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Separator(color: Colors.grey),
                            SizedBox(height: 15,),
                            Row(
                              children: [
                                Icon(MdiIcons.informationOutline),
                                SizedBox(width: 10,),
                                Text('About SR'),
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
                                          Text('0963xxxx',style: TextStyle(color: Colors.black.withOpacity(0.8),fontWeight: FontWeight.bold),),
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
                                        Icon(MdiIcons.disqus,color: Colors.black,size: 18,),
                                        SizedBox(width: 3,),
                                        Text('400',style: TextStyle(fontSize: 12,color: Colors.black),),
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
        // Visibility(
        //   visible:true,
        //   child: PendingAction(),
        // ),
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
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else if (Platform.isIOS) {
            exit(0);
          }
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
