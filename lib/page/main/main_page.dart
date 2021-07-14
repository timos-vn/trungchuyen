import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animarker/flutter_map_marker_animation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:trungchuyen/models/database/dbhelper.dart';
import 'package:trungchuyen/models/entity/customer.dart';
import 'package:trungchuyen/models/entity/notification_trung_chuyen.dart';
import 'package:trungchuyen/models/network/response/detail_trips_repose.dart';
import 'package:trungchuyen/page/account/account_bloc.dart';
import 'package:trungchuyen/page/account/account_page.dart';
import 'package:trungchuyen/page/limo_confirm/limo_confirm_bloc.dart';
import 'package:trungchuyen/page/limo_confirm/limo_confirm_event.dart';
import 'package:trungchuyen/page/limo_confirm/limo_confirm_page.dart';
import 'package:trungchuyen/page/list_customer_limo/list_customer_limo_bloc.dart';
import 'package:trungchuyen/page/list_customer_limo/list_customer_limo_page.dart';
import 'package:trungchuyen/page/map/map_bloc.dart';
import 'package:trungchuyen/page/map/map_event.dart';
import 'package:trungchuyen/page/map/map_page.dart';
import 'package:trungchuyen/page/map_limo/map_limo_bloc.dart';
import 'package:trungchuyen/page/map_limo/map_limo_event.dart';
import 'package:trungchuyen/page/map_limo/map_limo_page.dart';
import 'package:trungchuyen/page/report/report_bloc.dart';
import 'package:trungchuyen/page/report/report_page.dart';
import 'package:trungchuyen/page/report_limo/report_limo_bloc.dart';
import 'package:trungchuyen/page/report_limo/report_limo_page.dart';
import 'package:trungchuyen/page/waiting/waiting_bloc.dart';
import 'package:trungchuyen/page/waiting/waiting_event.dart';
import 'package:trungchuyen/page/waiting/waiting_page.dart';
import 'package:trungchuyen/service/lifecycle_event_handler.dart';
import 'package:trungchuyen/service/soket_io_service.dart';
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
  final String tokenFCM;
  const MainPage({Key key,this.roleAccount,this.tokenFCM}) : super(key: key);


  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver{
  MainBloc _mainBloc;
  MapBloc _mapBloc;
  WaitingBloc _waitingBloc;
  // ReportBloc _reportBloc;
  AccountBloc _accountBloc;
  ListCustomerLimoBloc _listCustomerLimoBloc;
  MapLimoBloc _mapLimoBloc;
  // ReportLimoBloc _reportLimoBloc;
   LimoConfirmBloc _limoConfirmBloc;

  int testcase = 0;
  int _lastIndexToShop = 0;
  int _currentIndex = 0;

  List<Customer> customerAwaiting = new List<Customer>();

  DatabaseHelper db = DatabaseHelper();
  GlobalKey<NavigatorState> _currentTabKey;
  List<BottomNavigationBarItem> listBottomItems = List();
  final GlobalKey<NavigatorState> firstTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> secondTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> thirdTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> fourthTabNavKey = GlobalKey<NavigatorState>();


  final GlobalKey<MapPageState> _mapPageKey = GlobalKey();
  final GlobalKey<MapLimoPageState> _mapLimoPageKey = GlobalKey();
  final GlobalKey<WaitingPageState> _waitingPageKey = GlobalKey();
  final GlobalKey<ListCustomerLimoPageState> _listCustomerLimoKey = GlobalKey();
  final GlobalKey<LimoConfirmPageState> _limoConfirmKey = GlobalKey();

  Future<List<NotificationCustomerOfTC>> getListFromDbNotificationCustomer() {
    return _mainBloc.db.fetchAllNotificationCustomer();
  }

  Future<List<Customer>> getListFromDbCustomer() {
    return _mainBloc.db.fetchAll();
  }

  Future<List<NotificationCustomerOfTC>> getCurrentNotificationCustomer() async {
    _mainBloc.listNotificationCustomer = await getListFromDbNotificationCustomer();
    if (!Utils.isEmpty(_mainBloc.listNotificationCustomer)) {
      print(_mainBloc.listNotificationCustomer.length);
      return _mainBloc.listNotificationCustomer;
    }else{
      print('NuisNull1');
      return null;
    }
  }

  Future<List<Customer>> getListCustomer() async {
    _mainBloc.listCustomer = await getListFromDb();
    if (!Utils.isEmpty(_mainBloc.listCustomer)) {
      _mainBloc.idKhungGio = _mainBloc.listCustomer[0].idKhungGio;
      _mainBloc.idVanPhong = _mainBloc.listCustomer[0].idVanPhong;
      _mainBloc.loaiKhach = _mainBloc.listCustomer[0].loaiKhach;
      _mainBloc.blocked = true;
      _mainBloc.listCustomer.forEach((element) {
        if(element.statusCustomer == 4 || element.statusCustomer == 8){
          _mainBloc.soKhachDaDonDuoc =  _mainBloc.soKhachDaDonDuoc + 1;
        }
      //  _mainBloc.add(KhachHuyOrDoiTaiXe(element.idTrungChuyen));
      });
      print('LENGHT: ${_mainBloc.soKhachDaDonDuoc}');
      return _mainBloc.listCustomer ;
    }else{
      print('nullll');
      // _mainBloc.db.deleteAll();
      // _mainBloc.add(GetListTaiXeLimo());
      return null;
    }
  }

  Future<List<Customer>> getListTaiXeLimo() async {
    _mainBloc.listTaiXeLimo = await getListDriverLimoFromDb();
    if (!Utils.isEmpty(_mainBloc.listTaiXeLimo)) {
      return _mainBloc.listTaiXeLimo ;
    }else{
      print('nullll listTaiXeLimo');
      return null;
    }
  }
  Future<List<Customer>> getListDriverLimoFromDb() {
    return db.fetchAllDriverLimo();
  }
  Future<List<Customer>> getListFromDb() {
    return db.fetchAll();
  }

  @override
  void initState() {
    // Get.put(SocketIOService());
    WidgetsBinding.instance.addObserver(this);

    _mainBloc = MainBloc();
    _mapBloc = MapBloc(context);
    _waitingBloc = WaitingBloc(context);
    _accountBloc = AccountBloc(context);
    _listCustomerLimoBloc = ListCustomerLimoBloc(context);
    _mapLimoBloc = MapLimoBloc(context);
    _limoConfirmBloc = LimoConfirmBloc(context);
    _currentTabKey = firstTabNavKey;
    if(widget.roleAccount == 3){
      getListCustomer();
      getListTaiXeLimo();
    }
    else if(widget.roleAccount == 7){
      _mainBloc.add(GetListNotificationOfLimo());
    }
    WidgetsBinding.instance.addObserver(
        LifecycleEventHandler(resumeCallBack: (){

        }),
    );
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.resumed){
      // Utils.showToast('Bạn đã Online');
      if(_mainBloc.socketIOService.socket.disconnected)
      {
        _mainBloc.socketIOService.socket.connect();
        if(widget.roleAccount == 3){
          // getListCustomer();
          // getListTaiXeLimo();
          //_mainBloc.add(GetListNotificationCustomerTC());
        }else if(widget.roleAccount == 7){
          _mainBloc.add(GetListNotificationOfLimo());
        }
      }
      // _mapBloc.add(UpdateStatusDriverEvent(1));
    }else if(state == AppLifecycleState.inactive || state == AppLifecycleState.paused){
      Utils.showToast('Bạn đã offline. Vui lòng quay lại app.');
      if(_mainBloc.socketIOService.socket.connected)
      {
        _mainBloc.socketIOService.socket.disconnect();
      }
      // _mapBloc.add(UpdateStatusDriverEvent(0));///viet ntn dung k :))))
    }
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
              // BlocProvider<ReportBloc>(
              //   create: (context) {
              //     if (_reportBloc == null) _reportBloc = ReportBloc(context);
              //     return _reportBloc;
              //   },
              // ),
              BlocProvider<LimoConfirmBloc>(
                create: (context) {
                  if (_limoConfirmBloc == null) _limoConfirmBloc = LimoConfirmBloc(context);
                  return _limoConfirmBloc;
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
              bloc: _mainBloc,
              // bloc: _mainBloc,
              listener: (context, state) {
                if (state is LogoutFailure) {
                  Utils.showToast(state.error.toString());
                }else if(state is  UpdateStatusCustomerSuccess){
                  DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
                  _waitingBloc.add(GetListGroupAwaitingCustomer(parseDate));
                }
                else if (state is LogoutSuccess) {
                  _lastIndexToShop = Const.WAITING;
                  _currentIndex = _lastIndexToShop;
                  _currentTabKey = firstTabNavKey;
                }
                else if(state is GetListOfGroupCustomerSuccess){
                  _waitingPageKey?.currentState?.setState(() {
                    _mainBloc.listOfGroupAwaitingCustomer = _mainBloc.listOfGroupAwaitingCustomer;

                  });
                }
                else if(state is GetListCustomerConfirmLimo){
                  _limoConfirmKey?.currentState?.setState(() {
                    _mainBloc.listCustomerConfirmLimo = _mainBloc.listCustomerConfirmLimo;
                  });
                }
                else if(state is GetListCustomerLimoSuccess){
                  _listCustomerLimoKey?.currentState?.setState(() {
                    _mainBloc.listCustomerLimo = _mainBloc.listCustomerLimo;
                  });
                }else if(state is GetListOfDetailTripsTCSuccess){
                  _mapPageKey?.currentState?.setState(() {
                    _mainBloc.listCustomer = _mainBloc.listCustomer;
                  });
                }else if(state is GetCustomerListSuccess){

                }
                else if (state is NavigateToNotificationState) {}
                else if(state is GetLocationSuccess){
                  // _mapLimoPageKey?.currentState?.setState(() {
                  //   if(_mapLimoBloc.lsMarkerId.where((id) => id==state.makerID).length==0)
                  //   {
                  //     print('ALALALA');
                  //     _mapLimoBloc.lsMarkerId.add(state.makerID);
                  //     _mapLimoBloc.add(GetEvent(state.makerID));
                  //   }
                  //   _mapLimoBloc.latLngStream.addLatLng(new LatLngInfo(state.lat,state.lng,state.makerID));
                  // });
                  // print('ALALALA');
                  // print(state.makerID +' - '+ state.lat.toString() +' - '+ state.lng.toString());
                }
              },
              child: BlocBuilder<MainBloc, MainState>(
                bloc: _mainBloc,
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
                        _mainBloc.add(GetListGroupCustomer(parseDate));
                      }else if(widget.roleAccount == 7){
                        DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
                        _mainBloc.add(GetListTripsLimo(parseDate));
                      }
                    }
                    if (_currentIndex == Const.CONFIRM) {
                      _mainBloc.add(GetListCustomerConfirm());
                    }
                    if (_currentIndex == Const.ACCOUNT) {
                    }
                  }
                  if (state is MainProfile) {
                    _mapPageKey?.currentState?.setState(() {
                      _mainBloc.listCustomer = _mainBloc.listCustomer;
                    });
                    _currentIndex = Const.MAP;
                    _currentTabKey = secondTabNavKey;
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
                                break;
                              case 1:
                                _currentTabKey = secondTabNavKey;
                                if(widget.roleAccount == 3){
                                  _mapPageKey?.currentState?.setState(() {
                                    _mainBloc.listCustomer = _mainBloc.listCustomer;
                                  });
                                }
                                break;
                              case 2:
                                // _lastIndexToShop = _currentIndex;
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
                              newWidget = LimoConfirmPage(key: _limoConfirmKey,);//widget.roleAccount == 3 ? ReportPage() : ReportLimoPage();
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
          MdiIcons.carWash,
          color: _currentIndex == Const.WAITING ? orange : grey,
        ),
        title: Text(
          'Chuyến'.tr,
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
      // BottomNavigationBarItem(
      //   icon: Icon(
      //     MdiIcons.chartArc,
      //     color: _currentIndex == Const.REPORT ? orange : grey,
      //   ),
      //   title: Text(
      //     'Report'.tr,
      //     style: TextStyle(color: _currentIndex == Const.REPORT ? orange : grey, fontSize: 10),
      //   ),
      // ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.stream,
          color: _currentIndex == Const.CONFIRM ? orange : grey,
        ),
        title: Text(
          'Xác nhận khách'.tr,
          style: TextStyle(color: _currentIndex == Const.CONFIRM ? orange : grey, fontSize: 10),
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
