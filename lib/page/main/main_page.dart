import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:trungchuyen/page/account/account_bloc.dart';
import 'package:trungchuyen/page/account/account_page.dart';
import 'package:trungchuyen/page/list_customer_limo/list_customer_limo_bloc.dart';
import 'package:trungchuyen/page/list_customer_limo/list_customer_limo_page.dart';
import 'package:trungchuyen/page/map/map_bloc.dart';
import 'package:trungchuyen/page/map/map_event.dart';
import 'package:trungchuyen/page/map/map_page.dart';
import 'package:trungchuyen/page/map_limo/map_limo_bloc.dart';
import 'package:trungchuyen/page/map_limo/map_limo_page.dart';
import 'package:trungchuyen/page/report/report_bloc.dart';
import 'package:trungchuyen/page/report/report_page.dart';
import 'package:trungchuyen/page/report_limo/report_limo_bloc.dart';
import 'package:trungchuyen/page/report_limo/report_limo_page.dart';
import 'package:trungchuyen/page/waiting/waiting_bloc.dart';
import 'package:trungchuyen/page/waiting/waiting_event.dart';
import 'package:trungchuyen/page/waiting/waiting_page.dart';
import 'package:trungchuyen/themes/colors.dart';
import 'package:trungchuyen/utils/const.dart';
import 'package:trungchuyen/utils/utils.dart';
import 'package:trungchuyen/widget/custom_tab_bar.dart';
import 'package:trungchuyen/widget/custom_tab_scaffold.dart';
import 'package:trungchuyen/widget/custom_tab_view.dart';
import 'package:trungchuyen/widget/pending_action.dart';
import 'main_bloc.dart';
import 'main_event.dart';
import 'main_state.dart';

class MainPage extends StatefulWidget {
  final int roleAccount;
  const MainPage({Key key,this.roleAccount}) : super(key: key);


  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  MainBloc _mainBloc;
  MapBloc _mapBloc;
  WaitingBloc _waitingBloc;
  ReportBloc _reportBloc;
  AccountBloc _accountBloc;
  ListCustomerLimoBloc _listCustomerLimoBloc;
  MapLimoBloc _mapLimoBloc;
  ReportLimoBloc _reportLimoBloc;

  int testcase = 0;
  int _lastIndexToShop = 0;
  int _currentIndex = 0;


  //DatabaseHelper db;
  GlobalKey<NavigatorState> _currentTabKey;
  List<BottomNavigationBarItem> listBottomItems = List();
  final GlobalKey<NavigatorState> firstTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> secondTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> thirdTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> fourthTabNavKey = GlobalKey<NavigatorState>();

  final GlobalKey<MapPageState> _mapPageKey = GlobalKey();
  final GlobalKey<WaitingPageState> _waitingPageKey = GlobalKey();
  final GlobalKey<ListCustomerLimoPageState> _listCustomerLimoKey = GlobalKey();

  @override
  void initState() {
    _mainBloc = MainBloc();
    _mapBloc = MapBloc(context);
    _waitingBloc = WaitingBloc(context);
    _reportBloc = ReportBloc(context);
    _accountBloc = AccountBloc(context);
    _listCustomerLimoBloc = ListCustomerLimoBloc(context);
    _mapLimoBloc = MapLimoBloc(context);
    _reportLimoBloc = ReportLimoBloc(context);
    _currentTabKey = firstTabNavKey;
    // _mainBloc.add(GetCountApprovalEvent());
    // DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
    // _mainBloc.add(GetListGroupCustomer(parseDate));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
          bool isSuccess = await _currentTabKey.currentState.maybePop();
          if (!isSuccess && _currentIndex != Const.WAITING) {
            _lastIndexToShop = Const.MAP;
            _mainBloc.add(NavigateBottomNavigation(Const.WAITING));
            _currentIndex = _lastIndexToShop;
            _currentTabKey = firstTabNavKey;
          }
          if (!isSuccess) _exitApp(context);
          return false;
      },
      child: Scaffold(
        body: MultiBlocProvider(
            providers: [
              BlocProvider<MainBloc>(
                create: (context) {
                  if (_mainBloc == null) _mainBloc = MainBloc();
                  return _mainBloc;
                },
              ),
              BlocProvider<WaitingBloc>(
                create: (context) {
                  if (_waitingBloc == null) _waitingBloc = WaitingBloc(context);
                  return _waitingBloc;
                },
              ),
              BlocProvider<MapBloc>(
                create: (context) {
                  if (_mapBloc == null) _mapBloc = MapBloc(context);
                  return _mapBloc;
                },
              ),
              BlocProvider<ReportBloc>(
                create: (context) {
                  if (_reportBloc == null) _reportBloc = ReportBloc(context);
                  return _reportBloc;
                },
              ),
              BlocProvider<AccountBloc>(
                create: (context) {
                  if (_accountBloc == null) _accountBloc = AccountBloc(context);
                  return _accountBloc;
                },
              ),
              BlocProvider<ListCustomerLimoBloc>(
                create: (context) {
                  if (_listCustomerLimoBloc == null) _listCustomerLimoBloc = ListCustomerLimoBloc(context);
                  return _listCustomerLimoBloc;
                },
              ),
              BlocProvider<MapLimoBloc>(
                create: (context) {
                  if (_mapLimoBloc == null) _mapLimoBloc = MapLimoBloc(context);
                  return _mapLimoBloc;
                },
              ),
            ],
            child: BlocListener<MainBloc, MainState>(
              cubit: _mainBloc,
              // bloc: _mainBloc,
              listener: (context, state) {
                if (state is LogoutFailure) {
                  Utils.showToast(state.error.toString());
                }else if(state is  UpdateStatusCustomerSuccess){
                  DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
                  _waitingBloc.add(GetListGroupAwaitingCustomer(parseDate));
                }

                if (state is LogoutSuccess) {
                  _lastIndexToShop = Const.WAITING;
                  _currentIndex = _lastIndexToShop;
                  _currentTabKey = firstTabNavKey;
                  _mainBloc.add(GetCountNoti());
                  //_mainBloc.countSMS = null;

                }
                if (state is NavigateToNotificationState) {
                }
              },
              child: BlocBuilder<MainBloc, MainState>(
                cubit: _mainBloc,
                builder: (context, state) {
                  if (state is MainPageState) {
                    _currentIndex = state.position;
                    if (_currentIndex == Const.MAP) {
                      if(widget.roleAccount == 3){ /// LX TC
                        _mapBloc.add(GetListCustomer(_mainBloc.listOfDetailTrips));
                      }
                    }
                    if (_currentIndex == Const.WAITING) {
                      if(widget.roleAccount == 3){
                        DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
                        _waitingBloc.add(GetListGroupAwaitingCustomer(parseDate));
                      }
                    }
                    if (_currentIndex == Const.REPORT) {

                    }
                    if (_currentIndex == Const.ACCOUNT) {

                    }
                  }
                  if (state is MainProfile) {
                    _currentIndex = Const.ACCOUNT;
                    _currentTabKey = fourthTabNavKey;
                  }
                  _mainBloc.init(context);
                  return Stack(children: <Widget>[
                    /*_mainBloc.countNotiUnRead == null
                        ? Container()
                        : */
                    CustomTabScaffold(
                        tabBar: CustomTabBar(
                          activeColor: Colors.redAccent,
                          inactiveColor: Colors.black,
                          onTap: (pos) {
                            switch (pos) {
                              case 0:
                                _currentTabKey = firstTabNavKey;
                                if(widget.roleAccount == 3){
                                  _waitingPageKey?.currentState?.setState(() {
                                    _mainBloc.testing = "B ${testcase++}";
                                    _mainBloc.listOfGroupAwaitingCustomer = _waitingBloc.listOfGroupAwaitingCustomer;

                                  });
                                }else{
                                  _listCustomerLimoKey?.currentState?.setState(() {
                                    _mainBloc.testing = "B ${testcase++}";
                                    _mainBloc.listCustomerLimo = _listCustomerLimoBloc.listCustomerLimo;
                                  });
                                }
                                break;
                              case 1:
                                _currentTabKey = secondTabNavKey;
                                if(widget.roleAccount == 3){
                                  _mapPageKey?.currentState?.setState(() {
                                    _mainBloc.testing = "B";
                                    _mainBloc.listOfDetailTrips = _mainBloc.listOfDetailTrips;
                                    print(_mainBloc.listOfDetailTrips.length);
                                  });
                                }
                                break;
                              case 2:
                                _lastIndexToShop = _currentIndex;
                                _currentTabKey = thirdTabNavKey;
                                break;
                              case 3:
                                _currentTabKey = fourthTabNavKey;
                                break;
                            }
                            if (_currentIndex == pos) {
                              setState(() {
                                _currentTabKey.currentState.popUntil((r) => r.isFirst);
                              });
                            } else
                              _mainBloc.add(NavigateBottomNavigation(pos));
                          },
                          currentIndex: _currentIndex,
                          items: listBottomBar(),
                        ),
                        tabBuilder: (BuildContext context, int index) {
                          Widget newWidget;
                          GlobalKey key;
                          switch (index) {
                            case 0:
                              key = firstTabNavKey;
                              newWidget = widget.roleAccount == 3 ? WaitingPage(key: _waitingPageKey,) : ListCustomerLimoPage(key: _listCustomerLimoKey,);
                              break;
                            case 1:
                              key = secondTabNavKey;
                              newWidget =widget.roleAccount == 3 ? MapPage(key:_mapPageKey) : MapLimoPage();
                              break;
                            case 2:
                              key = thirdTabNavKey;
                              newWidget =widget.roleAccount == 3 ? ReportPage() : ReportLimoPage();
                              break;
                            case 3:
                              key = fourthTabNavKey;
                              newWidget = AccountPage();
                              break;
                          }
                          return CustomTabView(
                            navigatorKey: key,
                            builder: (BuildContext context) {
                              return newWidget;
                            },
//                              defaultTitle: title,
                          );
                        }),
                    Visibility(
                      visible: state is MainLoading,
                      child: PendingAction(),
                    )
                  ]);
                },
              ),
            )),
      ),
    );
  }

  List<BottomNavigationBarItem> listBottomBar() {
    return [
      BottomNavigationBarItem(
        icon: Icon(
          Icons.person_add_alt_1_outlined,
          color: _currentIndex == Const.WAITING ? orange : grey,
        ),
        title: Text(
          'Khách'.tr,
          style: TextStyle(color: _currentIndex == Const.WAITING ? orange : grey, fontSize: 10),
        ),
      ),
      BottomNavigationBarItem(
        icon: Icon(
          MdiIcons.map,
          color: _currentIndex == Const.MAP ? orange : grey,
        ),
        title: Text(
          "Map".tr,
          style: TextStyle(color: _currentIndex == Const.MAP ? orange : grey, fontSize: 10),
        ),
      ),
      BottomNavigationBarItem(
        icon: Icon(
          MdiIcons.chartArc,
          color: _currentIndex == Const.REPORT ? orange : grey,
        ),
        title: Text(
          'Report'.tr,
          style: TextStyle(color: _currentIndex == Const.REPORT ? orange : grey, fontSize: 10),
        ),
      ),
      BottomNavigationBarItem(
        icon: Icon(
          MdiIcons.orderBoolDescendingVariant,
          color: _currentIndex == Const.ACCOUNT ? orange : grey,
        ),
        title: Text(
          "Account".tr,
          style: TextStyle(color: _currentIndex == Const.ACCOUNT ? orange : grey, fontSize: 10),
        ),
      ),

    ];
  }

  void _exitApp(BuildContext context) {
    List<Widget> actions = [
      FlatButton(
        onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        child: Text('No'.tr,
            style: TextStyle(
              color: Colors.orange,
              fontSize: 14,
            )),
      ),
      FlatButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        },
        child: Text(
          'Yes'.tr,
          style: TextStyle(
            color: Colors.orange,
            fontSize: 14,
          ),
        ),
      )
    ];

    Utils.showDialogTwoButton(
        context: context,
        title: 'Notice'.tr,
        contentWidget: Text(
          'ExitApp'.tr,
          style: TextStyle(fontSize: 16.0),
        ),
        actions: actions);
  }
}